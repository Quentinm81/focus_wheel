import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: Center(
        child: Semantics(
          label: 'Paramètres',
          child: Text(
            'Paramètres ici',
            style: TextStyle(fontSize: size.width * 0.05),
          ),
        ),
      ), // À compléter
      backgroundColor: isDark ? Colors.black : Colors.white,
    );
  }
}
