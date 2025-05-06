// Centralisation des courbes, durées, répétitions pour les animations
import 'package:flutter/animation.dart';

class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 800);

  static const Curve cubic = Curves.easeInOutCubic;
}
