import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF818CF8);
  
  static const Color secondaryLight = Color(0xFF10B981);
  static const Color secondaryDark = Color(0xFF34D399);
  
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFF87171);
  
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFFBBF24);
  
  static const Color successLight = Color(0xFF10B981);
  static const Color successDark = Color(0xFF34D399);
  
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF0F0F0F);
  
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  
  static const Color onBackgroundLight = Color(0xFF1F1F1F);
  static const Color onBackgroundDark = Color(0xFFFAFAFA);
  
  static const Color onSurfaceLight = Color(0xFF1F1F1F);
  static const Color onSurfaceDark = Color(0xFFFAFAFA);
  
  static const Color outlineLight = Color(0xFFE5E5E5);
  static const Color outlineDark = Color(0xFF404040);

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryLight,
    onPrimary: Colors.white,
    secondary: secondaryLight,
    onSecondary: Colors.white,
    tertiary: warningLight,
    onTertiary: Colors.white,
    error: errorLight,
    onError: Colors.white,
    background: backgroundLight,
    onBackground: onBackgroundLight,
    surface: surfaceLight,
    onSurface: onSurfaceLight,
    surfaceVariant: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF737373),
    outline: outlineLight,
    outlineVariant: Color(0xFFF3F4F6),
    shadow: Color(0x1A000000),
    scrim: Color(0x80000000),
    inverseSurface: Color(0xFF1A1A1A),
    onInverseSurface: Color(0xFFFAFAFA),
    inversePrimary: primaryDark,
    primaryContainer: Color(0xFFEEF2FF),
    onPrimaryContainer: Color(0xFF1E1B7E),
    secondaryContainer: Color(0xFFECFDF5),
    onSecondaryContainer: Color(0xFF064E3B),
    tertiaryContainer: Color(0xFFFEF3C7),
    onTertiaryContainer: Color(0xFF78350F),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDark,
    onPrimary: Color(0xFF1E1B7E),
    secondary: secondaryDark,
    onSecondary: Color(0xFF064E3B),
    tertiary: warningDark,
    onTertiary: Color(0xFF78350F),
    error: errorDark,
    onError: Color(0xFF7F1D1D),
    background: backgroundDark,
    onBackground: onBackgroundDark,
    surface: surfaceDark,
    onSurface: onSurfaceDark,
    surfaceVariant: Color(0xFF262626),
    onSurfaceVariant: Color(0xFFA3A3A3),
    outline: outlineDark,
    outlineVariant: Color(0xFF2D2D2D),
    shadow: Color(0x33000000),
    scrim: Color(0x99000000),
    inverseSurface: Color(0xFFFAFAFA),
    onInverseSurface: Color(0xFF1A1A1A),
    inversePrimary: primaryLight,
    primaryContainer: Color(0xFF2D2A8A),
    onPrimaryContainer: Color(0xFFEEF2FF),
    secondaryContainer: Color(0xFF065F46),
    onSecondaryContainer: Color(0xFFECFDF5),
    tertiaryContainer: Color(0xFF92400E),
    onTertiaryContainer: Color(0xFFFEF3C7),
    errorContainer: Color(0xFF991B1B),
    onErrorContainer: Color(0xFFFEE2E2),
  );

  static const Map<String, Color> securityColors = {
    'high': Color(0xFF10B981),
    'medium': Color(0xFFF59E0B),
    'low': Color(0xFFEF4444),
    'quantum': Color(0xFF8B5CF6),
    'biometric': Color(0xFF06B6D4),
  };

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryLight, Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient quantumGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}