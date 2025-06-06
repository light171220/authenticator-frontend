import 'package:flutter/material.dart';

class AppTypography {
  static const String fontFamily = 'Roboto';
  static const String monoFontFamily = 'RobotoMono';

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 57,
      height: 1.12,
      letterSpacing: -0.25,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 45,
      height: 1.16,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 36,
      height: 1.22,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 32,
      height: 1.25,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 28,
      height: 1.29,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      height: 1.33,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 22,
      height: 1.27,
      letterSpacing: 0,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      height: 1.50,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      height: 1.43,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      height: 1.50,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      height: 1.43,
      letterSpacing: 0.25,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      height: 1.33,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      height: 1.43,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      height: 1.33,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 11,
      height: 1.45,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
    ),
  );

  static const TextStyle monoLarge = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: 18,
    height: 1.33,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle monoMedium = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: 16,
    height: 1.25,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle monoSmall = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: 14,
    height: 1.14,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle otpCode = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: 24,
    height: 1.2,
    letterSpacing: 2.0,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle keyFingerprint = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: 12,
    height: 1.5,
    letterSpacing: 1.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle securityLevel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle timestamp = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    height: 1.45,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w400,
  );
}