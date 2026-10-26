import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cyber-Corp Takeover — Dark Neon / Cyberpunk 2077 design tokens.
abstract final class CyberColors {
  static const Color voidBlack = Color(0xFF0A0C10);
  static const Color deepIndigo = Color(0xFF111625);
  static const Color panel = Color(0xFF161B2E);
  static const Color panelElevated = Color(0xFF1C2340);

  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonMagenta = Color(0xFFFF0055);
  static const Color cyberYellow = Color(0xFFFFE600);
  static const Color terminalGreen = Color(0xFF00FF66);

  static const Color textPrimary = Color(0xFFE8F0FF);
  static const Color textMuted = Color(0xFF8B9BB8);
  static const Color gridLine = Color(0xFF2A3355);
}

/// Building tier labels (Data Racks → MegaCorp HQ).
abstract final class CyberLore {
  static const String currency = '₵';
  static const String appTitle = 'CYBER-CORP TAKEOVER';
  static const String appSubtitle = 'Night City Asset Protocol';

  static String buildingTier(int houses) => switch (houses) {
        0 => 'UNDEVELOPED',
        1 => 'DATA RACK ×1',
        2 => 'DATA RACK ×2',
        3 => 'DATA RACK ×3',
        4 => 'DATA RACK ×4',
        _ => 'MEGACORP HQ',
      };

  static String credits(int amount) => '$currency$amount';
}

/// Layout breakpoints shared by the shell and the board chrome.
abstract final class CyberLayout {
  static const double wideBreakpoint = 960;
  static const double shortLandscapeHeight = 500;
}

abstract final class CyberTheme {
  CyberTheme._();

  /// Single-layer glow. A second blurred shadow muddies small type and
  /// costs an extra saveLayer on CanvasKit.
  static List<BoxShadow> glow(Color color, {double blur = 12, double spread = 0}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.45),
          blurRadius: blur,
          spreadRadius: spread,
        ),
      ];

  static BoxDecoration neonBorder({
    Color color = CyberColors.neonCyan,
    double radius = 8,
    Color fill = CyberColors.panel,
    double opacity = 0.85,
  }) {
    return BoxDecoration(
      color: fill.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: color.withValues(alpha: 0.85), width: 1.4),
      boxShadow: glow(color, blur: 10),
    );
  }

  /// Glassmorphic panel for HUD cards / dialogs.
  static Widget glass({
    required Widget child,
    BorderRadius? borderRadius,
    Color glowColor = CyberColors.neonCyan,
    EdgeInsetsGeometry padding = const EdgeInsets.all(12),
  }) {
    final radius = borderRadius ?? BorderRadius.circular(10);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: CyberColors.deepIndigo.withValues(alpha: 0.55),
            border: Border.all(
              color: glowColor.withValues(alpha: 0.55),
              width: 1.2,
            ),
            boxShadow: glow(glowColor, blur: 14),
          ),
          child: child,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final orbitron = GoogleFonts.orbitronTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    );
    final rajdhani = GoogleFonts.rajdhaniTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    );
    final mono = GoogleFonts.shareTechMonoTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    );

    final baseText = rajdhani.apply(
      bodyColor: CyberColors.textPrimary,
      displayColor: CyberColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: CyberColors.voidBlack,
      colorScheme: const ColorScheme.dark(
        primary: CyberColors.neonCyan,
        secondary: CyberColors.cyberYellow,
        tertiary: CyberColors.neonMagenta,
        surface: CyberColors.deepIndigo,
        error: CyberColors.neonMagenta,
        onPrimary: CyberColors.voidBlack,
        onSecondary: CyberColors.voidBlack,
        onSurface: CyberColors.textPrimary,
        onError: CyberColors.textPrimary,
      ),
      textTheme: baseText.copyWith(
        displayLarge: orbitron.displayLarge?.copyWith(
          color: CyberColors.neonCyan,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        headlineMedium: orbitron.headlineMedium?.copyWith(
          color: CyberColors.neonCyan,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
        titleLarge: orbitron.titleLarge?.copyWith(
          color: CyberColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: rajdhani.titleMedium?.copyWith(
          color: CyberColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: rajdhani.bodyLarge,
        bodyMedium: rajdhani.bodyMedium,
        bodySmall: mono.bodySmall?.copyWith(color: CyberColors.textMuted),
        labelLarge: mono.labelLarge?.copyWith(
          color: CyberColors.cyberYellow,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: CyberColors.voidBlack,
        foregroundColor: CyberColors.neonCyan,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          color: CyberColors.neonCyan,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 3,
          shadows: [
            Shadow(
              color: CyberColors.neonCyan.withValues(alpha: 0.7),
              blurRadius: 12,
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: CyberColors.neonCyan),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          tapTargetSize: MaterialTapTargetSize.padded,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: GoogleFonts.shareTechMono(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ).copyWith(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return CyberColors.textMuted;
            }
            return CyberColors.neonCyan;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return CyberColors.panel;
            }
            return CyberColors.neonCyan.withValues(alpha: 0.15);
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(color: CyberColors.gridLine, width: 1.2);
            }
            return const BorderSide(color: CyberColors.neonCyan, width: 1.2);
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          tapTargetSize: MaterialTapTargetSize.padded,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: GoogleFonts.shareTechMono(letterSpacing: 1),
        ).copyWith(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return CyberColors.textMuted;
            }
            return CyberColors.cyberYellow;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return CyberColors.panel.withValues(alpha: 0.65);
            }
            return Colors.transparent;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(color: CyberColors.gridLine, width: 1.2);
            }
            return const BorderSide(color: CyberColors.cyberYellow, width: 1.2);
          }),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: CyberColors.panel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: CyberColors.neonCyan, width: 1.4),
        ),
        titleTextStyle: GoogleFonts.orbitron(
          color: CyberColors.neonCyan,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: GoogleFonts.rajdhani(
          color: CyberColors.textPrimary,
          fontSize: 16,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: CyberColors.deepIndigo,
      ),
      dividerColor: CyberColors.gridLine,
      chipTheme: ChipThemeData(
        backgroundColor: CyberColors.panelElevated,
        labelStyle: GoogleFonts.shareTechMono(
          color: CyberColors.terminalGreen,
          fontSize: 10,
        ),
        side: BorderSide(color: CyberColors.terminalGreen.withValues(alpha: 0.5)),
      ),
    );
  }
}
