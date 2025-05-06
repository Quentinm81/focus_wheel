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
3. Configure Hive and Supabase as needed (see `/lib/services`).
4. Build and run on Android device/emulator.

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
