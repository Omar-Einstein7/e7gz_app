import 'package:flutter/material.dart';

class PitchThemeExtension extends ThemeExtension<PitchThemeExtension> {
  const PitchThemeExtension({
    required this.accentGreen,
    required this.nightBackground,
    required this.glassSurface,
    required this.glassBorder,
    required this.heroGradient,
  });

  final Color accentGreen;
  final Color nightBackground;
  final Color glassSurface;
  final Color glassBorder;
  final LinearGradient heroGradient;

  @override
  ThemeExtension<PitchThemeExtension> copyWith({
    Color? accentGreen,
    Color? nightBackground,
    Color? glassSurface,
    Color? glassBorder,
    LinearGradient? heroGradient,
  }) {
    return PitchThemeExtension(
      accentGreen: accentGreen ?? this.accentGreen,
      nightBackground: nightBackground ?? this.nightBackground,
      glassSurface: glassSurface ?? this.glassSurface,
      glassBorder: glassBorder ?? this.glassBorder,
      heroGradient: heroGradient ?? this.heroGradient,
    );
  }

  @override
  ThemeExtension<PitchThemeExtension> lerp(
    covariant ThemeExtension<PitchThemeExtension>? other,
    double t,
  ) {
    if (other is! PitchThemeExtension) return this;
    return PitchThemeExtension(
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      nightBackground: Color.lerp(nightBackground, other.nightBackground, t)!,
      glassSurface: Color.lerp(glassSurface, other.glassSurface, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      heroGradient: LinearGradient.lerp(heroGradient, other.heroGradient, t)!,
    );
  }

  static final dark = PitchThemeExtension(
    accentGreen: const Color(0xFF4BE277),
    nightBackground: const Color(0xFF0B1326),
    glassSurface: Colors.white.withOpacity(0.08),
    glassBorder: Colors.white.withOpacity(0.15),
    heroGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.0, 0.4, 0.8, 1.0],
      colors: [
        Colors.black.withOpacity(0.4),
        Colors.transparent,
        const Color(0xFF0B1326).withOpacity(0.8),
        const Color(0xFF0B1326),
      ],
    ),
  );

  static final light = PitchThemeExtension(
    accentGreen: const Color(0xFF2E7D32),
    nightBackground: const Color(0xFFF5F5F5),
    glassSurface: Colors.black.withOpacity(0.05),
    glassBorder: Colors.black.withOpacity(0.1),
    heroGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.0, 0.4, 0.8, 1.0],
      colors: [
        Colors.black.withOpacity(0.1),
        Colors.transparent,
        const Color(0xFFF5F5F5).withOpacity(0.8),
        const Color(0xFFF5F5F5),
      ],
    ),
  );
}
