import 'package:flutter/material.dart';
import 'dart:ui';
import 'app_colors.dart';

/// Extension for semantic colors not covered by [ColorScheme].
class SemanticColors extends ThemeExtension<SemanticColors> {
  const SemanticColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
  });

  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;

  @override
  ThemeExtension<SemanticColors> copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
  }) {
    return SemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
    );
  }

  @override
  ThemeExtension<SemanticColors> lerp(
    covariant ThemeExtension<SemanticColors>? other,
    double t,
  ) {
    if (other is! SemanticColors) return this;
    return SemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
    );
  }

  static const light = SemanticColors(
    success: AppColors.success,
    onSuccess: Colors.white,
    warning: AppColors.warning,
    onWarning: Colors.white,
    info: AppColors.info,
    onInfo: Colors.white,
  );

  static const dark = SemanticColors(
    success: AppColors.success,
    onSuccess: AppPalette.green900,
    warning: AppColors.warning,
    onWarning: AppPalette.gray900,
    info: AppColors.info,
    onInfo: Colors.white,
  );
}

/// Extension for specialized Pitch UI colors.
class PitchColors extends ThemeExtension<PitchColors> {
  const PitchColors({
    required this.available,
    required this.booked,
    required this.maintenance,
    required this.overlay,
    required this.heroGradient,
    required this.glassSurface,
    required this.glassBorder,
    required this.accentGreen,
  });

  final Color available;
  final Color booked;
  final Color maintenance;
  final Color overlay;
  final Gradient heroGradient;
  final Color glassSurface;
  final Color glassBorder;
  final Color accentGreen;

  @override
  ThemeExtension<PitchColors> copyWith({
    Color? available,
    Color? booked,
    Color? maintenance,
    Color? overlay,
    Gradient? heroGradient,
    Color? glassSurface,
    Color? glassBorder,
    Color? accentGreen,
  }) {
    return PitchColors(
      available: available ?? this.available,
      booked: booked ?? this.booked,
      maintenance: maintenance ?? this.maintenance,
      overlay: overlay ?? this.overlay,
      heroGradient: heroGradient ?? this.heroGradient,
      glassSurface: glassSurface ?? this.glassSurface,
      glassBorder: glassBorder ?? this.glassBorder,
      accentGreen: accentGreen ?? this.accentGreen,
    );
  }

  @override
  ThemeExtension<PitchColors> lerp(
    covariant ThemeExtension<PitchColors>? other,
    double t,
  ) {
    if (other is! PitchColors) return this;
    return PitchColors(
      available: Color.lerp(available, other.available, t)!,
      booked: Color.lerp(booked, other.booked, t)!,
      maintenance: Color.lerp(maintenance, other.maintenance, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      heroGradient: Gradient.lerp(heroGradient, other.heroGradient, t)!,
      glassSurface: Color.lerp(glassSurface, other.glassSurface, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
    );
  }

  static final light = PitchColors(
    available: AppPalette.green500,
    booked: AppPalette.gray400,
    maintenance: AppPalette.red500,
    overlay: const Color(0x80000000),
    accentGreen: AppPalette.green500,
    glassSurface: Colors.white.withValues(alpha: 0.7),
    glassBorder: Colors.white.withValues(alpha: 0.3),
    heroGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.black.withValues(alpha: 0.7),
      ],
    ),
  );

  static final dark = PitchColors(
    available: AppPalette.green400,
    booked: AppPalette.gray600,
    maintenance: AppPalette.red500,
    overlay: const Color(0x99000000),
    accentGreen: AppPalette.green400,
    glassSurface: const Color(0xFF131B2E).withValues(alpha: 0.7),
    glassBorder: Colors.white.withValues(alpha: 0.1),
    heroGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        AppPalette.darkBlue950.withValues(alpha: 0.9),
      ],
    ),
  );
}
