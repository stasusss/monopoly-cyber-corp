import 'package:flutter/material.dart';

import 'cyber_theme.dart';

/// Compatibility façade — visual system is [CyberTheme].
class AppTheme {
  AppTheme._();

  static const Color boardGreen = CyberColors.voidBlack;
  static const Color boardFelt = CyberColors.deepIndigo;
  static const Color cream = CyberColors.panel;
  static const Color ink = CyberColors.textPrimary;
  static const Color gold = CyberColors.cyberYellow;

  static ThemeData get light => CyberTheme.dark;
  static ThemeData get dark => CyberTheme.dark;
}
