# Focus Wheel - Optimized Version

## 🚀 Quick Start

### Prerequisites
- Flutter 3.32.4 or higher
- Dart 3.8.1 or higher
- Android Studio / VS Code with Flutter extensions

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd focus_wheel
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your Supabase credentials
   ```

4. **Generate code**
   ```bash
   # Generate Hive adapters
   dart run build_runner build --delete-conflicting-outputs
   
   # Generate localizations
   flutter gen-l10n
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Features

- **Agenda Management**: Schedule and track events
- **Task Management**: Kanban board with drag-and-drop
- **Focus Timer**: Pomodoro-style timer with session tracking
- **Mood Journal**: Track daily mood with notes
- **Reminders**: Local notifications for important tasks
- **Statistics**: Visual analytics of productivity
- **Multi-language**: English, Spanish, Italian, Portuguese

## 🏗️ Architecture

### State Management
- **Riverpod 2.4.9**: Modern reactive state management

### Data Persistence
- **Hive 2.2.3**: Local NoSQL database with encryption
- **Supabase 2.8.4**: Cloud sync and backup

### Key Directories
```
lib/
├── generated/      # Auto-generated localization files
├── l10n/          # ARB translation files
├── models/        # Data models with Hive adapters
├── providers/     # Riverpod state providers
├── screens/       # App screens
├── services/      # Business logic services
└── widgets/       # Reusable UI components
```

## 🌍 Internationalization

The app supports multiple languages:
- 🇬🇧 English (en)
- 🇪🇸 Spanish (es)
- 🇮🇹 Italian (it)
- 🇵🇹 Portuguese (pt)

To add a new language:
1. Create `lib/l10n/app_XX.arb` (where XX is the language code)
2. Add translations following the template in `app_en.arb`
3. Run `flutter gen-l10n`
4. Add the locale to `supportedLocales` in `main.dart`

## 🧪 Testing

Run all tests:
```bash
flutter test
```

Run specific test file:
```bash
flutter test test/widget/localization_test.dart
```

## 🔧 Development Commands

### Code Generation
```bash
# Generate Hive adapters
dart run build_runner build --delete-conflicting-outputs

# Watch for changes
dart run build_runner watch --delete-conflicting-outputs

# Generate localizations
flutter gen-l10n
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
dart format .
```

### Build
```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📦 Dependencies

### Core
- `flutter_riverpod`: State management
- `hive` & `hive_flutter`: Local database
- `supabase_flutter`: Backend services

### UI/UX
- `fl_chart`: Beautiful charts
- `flutter_slidable`: Swipe actions
- `flutter_local_notifications`: Notifications

### Utilities
- `intl`: Internationalization
- `flutter_secure_storage`: Secure data storage
- `permission_handler`: Runtime permissions

## 🔐 Security

- Sensitive data stored using `flutter_secure_storage`
- Environment variables for API keys
- Hive encryption for local database
- Secure Supabase authentication

## 🐛 Troubleshooting

### Build Issues
```bash
# Clean build
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Localization Issues
```bash
# Regenerate localizations
flutter gen-l10n
```

### iOS Issues
```bash
cd ios
pod install
cd ..
flutter run
```

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and ensure code quality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All contributors and package maintainers
- ADHD community for feedback and support