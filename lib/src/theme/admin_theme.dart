import 'package:flutter/material.dart';
import 'package:e7gz/src/theme/extensions/theme_context.dart';

/// Shared design tokens for admin features
class AdminColors {
  AdminColors._();

  static const bg = Color(0xFF0B0F1A);
  static const surface = Color(0xFF131929);
  static const surfaceHigh = Color(0xFF1C2539);
  static const border = Color(0xFF1E2D45);
  static const accent = Color(0xFF4BE277);
  static const accentBlue = Color(0xFF3B82F6);
  static const accentAmber = Color(0xFFF59E0B);
  static const accentPurple = Color(0xFF7C5CFC);
  static const textPrimary = Color(0xFFE8EDF5);
  static const textSecondary = Color(0xFF6B7FA3);
  static const textMuted = Color(0xFF374563);

  static Color getBg(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? bg : Theme.of(context).colorScheme.surface;
  }

  static Color getSurface(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? surface : Theme.of(context).colorScheme.surfaceContainerLow;
  }

  static Color getSurfaceHigh(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? surfaceHigh
        : Theme.of(context).colorScheme.surfaceContainer;
  }

  static Color getBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? border : Theme.of(context).colorScheme.outlineVariant;
  }

  static Color getTextPrimary(BuildContext context) {
    return context.colorScheme.onSurface;
  }

  static Color getTextSecondary(BuildContext context) {
    return context.colorScheme.onSurfaceVariant;
  }

  static Color getTextMuted(BuildContext context) {
    return context.colorScheme.outline;
  }
}

class AdminTextStyles {
  AdminTextStyles._();

  static const pageTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const sectionTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const label = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle getPageTitle(BuildContext context) {
    return pageTitle.copyWith(color: AdminColors.getTextPrimary(context));
  }

  static TextStyle getSectionTitle(BuildContext context) {
    return sectionTitle.copyWith(color: AdminColors.getTextPrimary(context));
  }

  static TextStyle getLabel(BuildContext context) {
    return label.copyWith(color: AdminColors.getTextSecondary(context));
  }
}
