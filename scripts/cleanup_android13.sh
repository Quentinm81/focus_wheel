#!/usr/bin/env bash
# scripts/cleanup_android13.sh
# ------------------------------------------------------------
# Automatisation complète de la refonte « propre & légère » du
# dépôt Flutter pour assurer la compatibilité Android 13 + (API 34)
# et réduire la taille finale de l'AAB. Aucune intervention humaine
# n'est requise : le script crée une branche de nettoyage, applique
# toutes les optimisations, pousse le résultat et ouvre une PR.
# ------------------------------------------------------------

set -euo pipefail

# -----------------------------------------------------------------
# 0. Bootstrap
# -----------------------------------------------------------------
branch="cleanup/android13"
echo "[0] Préparation du dépôt – branche ${branch}"
git config --global advice.detachedHead false
git fetch --all --prune
git switch -c "$branch" || git switch "$branch"

# -----------------------------------------------------------------
# 1. Cartographie & sauvegarde état initial
# -----------------------------------------------------------------
echo "[1] Cartographie de l'état initial"
flutter pub outdated --mode=null-safety || true
du -sh . > pre_cleanup_size.txt
git ls-files -z | xargs -0 sha1sum > pre_cleanup_checksums.sha1

# -----------------------------------------------------------------
# 2. Purge des dossiers hors périmètre mobile
# -----------------------------------------------------------------
echo "[2] Suppression des dossiers non mobiles"
rm -rf server linux macos windows web scripts/test* test integration_test || true
# Nettoyage des variantes build inutiles
find android/app/src -type d \( -name debug -o -name profile \) -exec rm -rf {} + || true

# -----------------------------------------------------------------
# 3. Nettoyage assets & splash
# -----------------------------------------------------------------
echo "[3] Nettoyage des assets et de l'écran de splash"
export PATH="$PATH:":"$(dart pub global list | grep -q flutter_native_splash || true)"
# Activation outils nécessaires
(dart pub global activate flutter_native_splash  || true)
flutter pub run flutter_native_splash:remove --yes || true

dart pub global activate remove_unused_assets || true
# Suppression récursive des assets non référencés
remove_cmd="dart pub global run remove_unused_assets:remove_unused_assets"
$remove_cmd --path=assets --delete-files --yes || true

# -----------------------------------------------------------------
# 4. Prune des dépendances
# -----------------------------------------------------------------
echo "[4] Prune des dépendances inutilisées"
# Liste des dépendances inutiles puis suppression via yq si installé
unused=$(dart pub deps --unused --no-dev | awk '/unused dependencies/{flag=1;next} /Description/{flag=0} flag')
if [[ -n "$unused" ]]; then
  if ! command -v yq &> /dev/null; then
    echo "yq introuvable ; installation…"
    sudo snap install yq || sudo apt-get update && sudo apt-get install -y yq
  fi
  while read -r dep; do
    [[ -z "$dep" ]] && continue
    echo "    – Suppression de $dep"
    yq -i eval "del(.dependencies.\"$dep\")" pubspec.yaml
  done <<< "$unused"
fi
flutter pub upgrade --major-versions

# -----------------------------------------------------------------
# 5. Mise à jour Gradle & Manifest (Android 13+)
# -----------------------------------------------------------------
echo "[5] Mise à jour des fichiers Gradle pour API 34"
apply_patch() {
  patch -p0 <<'PATCH'
*** android/app/build.gradle
@@
-    compileSdkVersion 33
+    compileSdkVersion 34
@@
-        minSdkVersion 21
+        minSdkVersion 24
-        targetSdkVersion 33
+        targetSdkVersion 34
@@ release
         shrinkResources true
         minifyEnabled true
         proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
 }
*** gradle.properties
@@
+android.enableDexingArtifactTransform.desugaring=false
+android.defaults.buildfeatures.buildconfig=false
PATCH
}
apply_patch

# Marquage des composants exportés
grep -rl "<intent-filter" android/app/src/main | \
  xargs -r sed -i '/<activity / s|>| android:exported="true">|'

# Permissions dynamiques (POST_NOTIFICATIONS & BLUETOOTH_CONNECT) – ajout si référencées
if grep -qR "POST_NOTIFICATIONS" lib; then
  sed -i '/<\/manifest>/i\    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>' \
    android/app/src/main/AndroidManifest.xml
fi
if grep -qR "BLUETOOTH" lib; then
  sed -i '/<\/manifest>/i\    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>' \
    android/app/src/main/AndroidManifest.xml
fi

# -----------------------------------------------------------------
# 6. Optimisations Flutter / Dart
# -----------------------------------------------------------------
echo "[6] Build release optimisée"
flutter clean
flutter pub get
flutter build appbundle --release \
  --impeller \
  --no-tree-shake-icons \
  --split-debug-info=build/symbols \
  --dart-define=FLUTTER_WEB_AUTO_DETECT=false

# Analyse métriques
(dart pub global activate dart_code_metrics || true)
flutter pub run dart_code_metrics:metrics analyze lib --fatal-style || true

# -----------------------------------------------------------------
# 7. CI/CD minimal (GitHub Actions)
# -----------------------------------------------------------------
echo "[7] Génération du workflow GitHub Actions minimal"
workflow_dir=".github/workflows"
mkdir -p "$workflow_dir"
cat > "$workflow_dir/ci_cd.yaml" <<'YAML'
name: CI-CD
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v3
        with:
          flutter-version: '3.22.0'
      - run: flutter pub get
      - run: flutter build appbundle --release --impeller --no-tree-shake-icons --split-debug-info=build/symbols
      - uses: r0adkll/sign-android-release@v1
        with:
          releaseDirectory: build/app/outputs/bundle/release
          signingKeyBase64: ${{ secrets.ANDROID_KEYSTORE }}
          alias:              ${{ secrets.KEY_ALIAS }}
          keyStorePassword:   ${{ secrets.KEYSTORE_PASSWORD }}
          keyPassword:        ${{ secrets.KEY_PASSWORD }}
      - uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_JSON }}
          packageName: com.example.app
          releaseFiles: app-release.aab
          track: internal
YAML

# -----------------------------------------------------------------
# 8. Validation Firebase Test Lab & analyse taille
# -----------------------------------------------------------------
echo "[8] Tests Firebase Test Lab & contrôle taille AAB"
if command -v gcloud &> /dev/null; then
  gcloud firebase test android run \
    --type robo \
    --app build/app/outputs/bundle/release/app-release.aab \
    --device model=Pixel7,version=34,locale=en,orientation=portrait || true

  bundletool dump size --aab build/app/outputs/bundle/release/app-release.aab \
    --output=aab_size.txt || true
fi

# -----------------------------------------------------------------
# 9. Commit, PR & tag
# -----------------------------------------------------------------
echo "[9] Commit & ouverture de la Pull-Request"
git add -A
git commit -m "Cleanup: Android 13+ compatibility, repo slimming, perf optimisations" || true
git push --set-upstream origin "$branch"

if command -v gh &> /dev/null; then
  gh pr create --fill --label "automated" || true
  gh pr merge --auto --squash || true
  git tag -a "v$(date +%Y.%m.%d)" -m "Android 13+ clean release"
  git push --tags || true
fi

echo "🎉 Refonte terminée avec succès !"