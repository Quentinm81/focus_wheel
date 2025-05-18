# Focus Wheel

Focus Wheel is a standalone, professional Android application designed to help adults with ADHD manage daily tasks and schedules. Built with Flutter/Dart, it emphasizes an offline-first approach, modular architecture, and a refined, minimalistic UI/UX.

## Sécurité

- **Chiffrement des données locales** : Toutes les données Hive sont chiffrées avec une clé AES stockée dans flutter_secure_storage.
- **Gestion des secrets** : Les clés Supabase, Sentry, etc. ne sont jamais dans le code source, mais dans un fichier `.env` non versionné.
- **Réseau sécurisé** : Les connexions Supabase sont obligatoirement en HTTPS (SSL pinning possible).
- **Suppression RGPD** : L'utilisateur peut supprimer toutes ses données locales et cloud.
- **Notifications** : Aucune donnée sensible n'est affichée dans les notifications.
- **CI/CD** : Audit automatique des dépendances dans la CI, secrets stockés dans GitHub Secrets.

Voir la documentation pour plus de détails sur chaque point.

## Features
- **Agenda Module:** Vertical timeline, rapid event creation, drag-and-drop, PDF/CSV export, optional cloud sync.
- **Timer Module:** Predefined durations, animated circular progress, motivational feedback, session statistics.
- **Reminders Module:** Text/voice input, predictive suggestions, recurring reminders, robust notifications.
- **Tasks Module:** Kanban board (To Do, In Progress, Done), drag-and-drop, animations, task limits.
- **Mood Journal & Analytics:** Daily mood tracking, weekly productivity statistics (fl_chart).
- **Smart Suggestions:** Context-aware recommendations based on inactivity and user behavior.
- **Motivational Feedback Engine:** 300 categorized phrases, adaptive, user-selectable styles.

## Technology Stack
- **Flutter/Dart** (UI, logic)
- **Riverpod** (state management)
- **Hive** (offline data storage)
- **Supabase** (optional cloud sync)
- **flutter_local_notifications** (notifications)
- **fl_chart** (statistics)
- **speech_to_text** (voice input)

## Directory Structure
```
lib/
  models/        # Data models (events, tasks, reminders, moods, etc.)
  screens/       # UI screens for each module
  services/      # Storage, sync, notifications, analytics
  widgets/       # Reusable UI components
  providers/     # Riverpod providers
assets/
  images/        # Professional images
  icons/         # Minimal, non-informal icons
  json/          # Motivational phrases, config
```

## Setup
1. Install Flutter SDK and dependencies.
2. Run `flutter pub get` to fetch packages.

---

## Build sécurisé Android (protection maximale du code)

Pour générer un APK ou un App Bundle (AAB) Android avec la protection maximale du code (obfuscation Dart + ProGuard/R8 + séparation des symboles) :

1. **Pré-requis** :
   - Flutter installé et accessible dans le terminal (`flutter --version` doit fonctionner)
   - Clé de signature release configurée (remplace la clé debug par une clé sécurisée dans `android/app/build.gradle.kts`)

2. **Commande de build sécurisée** :

   Pour un APK release :
   ```sh
   flutter build apk --release --obfuscate --split-debug-info=build/debug-info
   ```
   Pour un App Bundle (AAB) pour le Play Store :
   ```sh
   flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
   ```

   - Le dossier `build/debug-info` doit être conservé en lieu sûr (il permet de décoder les crashs, mais ne doit jamais être publié).

3. **Vérifications complémentaires** :
   - Le flag `android:debuggable="false"` doit être présent dans le manifeste pour la release.
   - L'obfuscation ProGuard/R8 est activée dans `android/app/build.gradle.kts` (`isMinifyEnabled = true`).
   - Le fichier `proguard-rules.pro` est présent et adapté à Flutter.

4. **Bonnes pratiques** :
   - Ne jamais publier la clé de signature ni le dossier `build/debug-info`.
   - Scanner l’APK/AAB avec un outil de sécurité (MobSF, VirusTotal) avant publication.

---

Pour toute question sur la sécurité ou l’automatisation du build, voir la documentation Flutter officielle ou contacter le mainteneur du projet.

## Developer Guidelines
- Modularize code for maintainability and expansion.
- Use Riverpod for state management.
- Document all modules and APIs.
- Write unit/integration tests for all features.
- Adhere to professional, minimalistic UI/UX standards.

## Future Enhancements
- Windsurf AI integration via modular APIs.
- Expanded analytics and adaptive feedback.

## License
[MIT](LICENSE)
