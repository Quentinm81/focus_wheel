import 'package:flutter/material.dart';
import 'package:focus_wheel/services/hive_service.dart';
import 'package:focus_wheel/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await HiveService.initSecure();
  await NotificationService().init();
  runApp(const ProviderScope(child: FocusWheelApp()));
}

class FocusWheelApp extends ConsumerWidget {
  const FocusWheelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Focus Wheel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color(0xFF6EC1E4), // Agenda Blue
          secondary: Color(0xFFBA68C8), // Tasks Violet
        ),
        fontFamily: 'Roboto',
        // useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF6EC1E4),
          secondary: Color(0xFFBA68C8),
        ),
      ),
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // Simulate some loading time for demonstration
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF6EC1E4)),
            const SizedBox(height: 24),
            Text(
              'Focus Wheel',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6EC1E4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
