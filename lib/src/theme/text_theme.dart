import 'package:flutter/material.dart';

/// Defines the full Material 3 typescale for the application.
///
/// Prefer accessing styles through [BuildContext] extensions:
/// ```dart
/// Text('Hello', style: context.textTheme.titleLarge);
/// ```
TextTheme buildTextTheme() {
  final baseTextTheme = TextTheme(
    // ── Display ──────────────────────────────────────────────────────────────
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      fontFamily: 'Chewy',
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Chewy',
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Chewy',
    ),

    // ── Headline ─────────────────────────────────────────────────────────────
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Chewy',
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Chewy',
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      fontFamily: 'Chewy',
    ),

    // ── Title ─────────────────────────────────────────────────────────────────
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      fontFamily: 'Chewy',
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      fontFamily: 'Chewy',
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontFamily: 'Chewy',
    ),

    // ── Body ──────────────────────────────────────────────────────────────────
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      fontFamily: 'Chewy',
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: 'Chewy',
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      fontFamily: 'Chewy',
    ),

    // ── Label ─────────────────────────────────────────────────────────────────
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontFamily: 'Chewy',
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      fontFamily: 'Chewy',
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      fontFamily: 'Chewy',
    ),
  );

  return baseTextTheme;
}
