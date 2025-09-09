## Lancer l'application sur Android (Samsung connecté via USB)

Prérequis:
- Android Platform-Tools (adb)
- Flutter SDK (ajoutez `flutter/bin` au PATH)
- Activez le débogage USB et autorisez l'empreinte ADB sur le téléphone

Commandes utiles:

1) Lancer l'application sur l'appareil (auto ou cible):

```bash
bash scripts/android_run.sh            # tente la sélection automatique
bash scripts/android_run.sh <device>   # cible un device précis (via adb devices)
```

2) Suivre les logs:

```bash
bash scripts/android_logs.sh --flutter                     # logs Flutter et erreurs
bash scripts/android_logs.sh --appId com.example.focus_wheel  # filtré sur l'ID app
```

Notes:
- Si `android/local.properties` est absent, le script essaiera de renseigner `flutter.sdk` automatiquement. Vous pouvez forcer avec `FLUTTER_SDK=/chemin/vers/flutter`.
- Le projet utilise compileSdk=35, targetSdk=35, minSdk=21. Assurez-vous d'avoir les SDK correspondants via Android Studio > SDK Manager.

