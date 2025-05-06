import 'package:flutter/material.dart';
import 'design_tokens.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: DesignTokens.agenda,
    secondary: DesignTokens.tasks,
  ),
  fontFamily: 'Inter',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
    bodyLarge: TextStyle(fontSize: 16, fontFamily: 'OpenSans'),
  ),
);
