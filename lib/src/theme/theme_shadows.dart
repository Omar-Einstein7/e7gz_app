import 'package:flutter/material.dart';

/// Predefined box shadows aligned with Material 3 elevation tiers.
///
/// Usage:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     boxShadow: AppShadows.card,
///   ),
/// )
/// ```
abstract final class AppShadows {
  AppShadows._();

  /// No shadow — flat, tonal surface (elevation 0).
  static const List<BoxShadow> none = [];

  /// Subtle shadow for slightly elevated elements.
  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Color(0x0A000000), // 4% black
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  /// Standard card elevation shadow.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F000000), // 6% black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Elevated shadow for floating action buttons or popups.
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x19000000), // 10% black
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];
}
