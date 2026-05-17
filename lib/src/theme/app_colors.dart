import 'package:flutter/material.dart';

/// Primitive color palette for the application.
/// These should NOT be used directly in widgets.
/// Use [AppColors] or [ColorScheme] instead.
abstract final class AppPalette {
  AppPalette._();

  // --- Brand Colors ---
  static const Color green50 = Color(0xFFF0FDF4);
  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green400 = Color(0xFF4BE277);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green900 = Color(0xFF003915);

  // --- Dark Theme Primitives ---
  static const Color darkBlue950 = Color(0xFF0B1326); // Background
  static const Color darkBlue900 = Color(0xFF131B2E); // Surface/Card
  static const Color darkBlue800 = Color(0xFF171F33); // Surface/Card Alt
  static const Color darkBlue700 = Color(0xFF1D2942); // Elevated Surface
  static const Color darkBlue600 = Color(0xFF1F2937); // Border

  // --- Grays/Neutrals ---
  static const Color gray50 = Color(0xFFF8FAFC);
  static const Color gray100 = Color(0xFFF1F5F9);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray500 = Color(0xFF64748B);
  static const Color gray600 = Color(0xFF475569);
  static const Color gray700 = Color(0xFF334155);
  static const Color gray800 = Color(0xFF1E293B);
  static const Color gray900 = Color(0xFF0F172A);

  // --- Semantic Primitives ---
  static const Color red500 = Color(0xFFEF4444);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color emerald500 = Color(0xFF10B981);
}

/// Semantic color mappings.
/// Provides a consistent naming convention for colors across the app.
abstract final class AppColors {
  AppColors._();

  // --- Light Mode ---
  static const Color lightPrimary = AppPalette.green500;
  static const Color lightOnPrimary = Colors.white;
  static const Color lightBackground = AppPalette.gray50;
  static const Color lightSurface = Colors.white;
  static const Color lightOnSurface = AppPalette.gray900;
  static const Color lightOnSurfaceVariant = AppPalette.gray500;
  static const Color lightOutline = AppPalette.gray200;

  // --- Dark Mode ---
  static const Color darkPrimary = AppPalette.green400;
  static const Color darkOnPrimary = AppPalette.green900;
  static const Color darkBackground = AppPalette.darkBlue950;
  static const Color darkSurface = AppPalette.darkBlue900;
  static const Color darkOnSurface = Colors.white;
  static const Color darkOnSurfaceVariant = Color(
    0xFFBCC7DE,
  ); // subtitleColor from research
  static const Color darkOutline = AppPalette.darkBlue600;

  // --- Shared Semantic ---
  static const Color success = AppPalette.emerald500;
  static const Color error = AppPalette.red500;
  static const Color warning = AppPalette.amber500;
  static const Color info = AppPalette.blue500;
}
