import 'package:flutter/material.dart';

/// Standardized spacing and layout constants.
abstract final class AppSpacing {
  AppSpacing._();

  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Semantic paddings
  static const double screenPadding = md;
  static const double cardPadding = md;
  static const double itemPadding = sm;
}

/// Standardized border radius constants.
abstract final class AppRadius {
  AppRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 999.0;

  static BorderRadius get bxs => BorderRadius.circular(xs);
  static BorderRadius get bsm => BorderRadius.circular(sm);
  static BorderRadius get bmd => BorderRadius.circular(md);
  static BorderRadius get blg => BorderRadius.circular(lg);
  static BorderRadius get bxl => BorderRadius.circular(xl);
  static BorderRadius get bxxl => BorderRadius.circular(xxl);
  static BorderRadius get bfull => BorderRadius.circular(full);
}

/// Standardized elevation/shadow constants.
abstract final class AppElevation {
  AppElevation._();

  static const double none = 0.0;
  static const double low = 2.0;
  static const double medium = 4.0;
  static const double high = 8.0;
}
