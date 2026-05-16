import 'package:e7gz/src/theme/color_schemes.dart';
import 'package:flutter/material.dart';
import '../theme_extensions.dart';

/// Extension on [BuildContext] for easier access to theme-related data.
extension ThemeContextExtension on BuildContext {
  /// Access to [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Access to [ColorScheme].
  ColorScheme get colorScheme => theme.colorScheme;

  /// Alias for [colorScheme].
  ColorScheme get colors => colorScheme;

  /// Access to [TextTheme].
  TextTheme get textTheme => theme.textTheme;

  /// Alias for [textTheme].
  TextTheme get typography => textTheme;

  /// Access to [AppColorsExtension].
  AppColorsExtension get appColors => theme.extension<AppColorsExtension>()!;

  /// Access to [SemanticColors] extension.
  SemanticColors get semanticColors => theme.extension<SemanticColors>()!;

  /// Access to [PitchColors] extension.
  PitchColors get pitchColors => theme.extension<PitchColors>()!;

  /// Alias for [pitchColors].
  PitchColors get pitchTheme => pitchColors;

  /// Shortcut for brightness.
  bool get isDarkMode => theme.brightness == Brightness.dark;
}
