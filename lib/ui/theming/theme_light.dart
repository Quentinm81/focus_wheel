import 'package:flutter/material.dart';
import 'design_tokens.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: DesignTokens.background,
  colorScheme: ColorScheme.light(
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
