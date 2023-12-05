part of '../helpers.dart';

/// [generateSwatch] is a helper function to generate a swatch from a color.
///
/// It will return a [MaterialColor] with the given [color] with or without shades.
/// The [color] is the color of the swatch.
/// The [withShader] is a boolean to indicate if the swatch should have shades.
MaterialColor generateSwatch({required Color color, bool withShader = false}) {
  return MaterialColor(color.value, {
    50: withShader ? color.withOpacity(0.1) : color,
    100: withShader ? color.withOpacity(0.2) : color,
    200: withShader ? color.withOpacity(0.3) : color,
    300: withShader ? color.withOpacity(0.4) : color,
    400: withShader ? color.withOpacity(0.5) : color,
    500: withShader ? color.withOpacity(0.6) : color,
    600: withShader ? color.withOpacity(0.7) : color,
    700: withShader ? color.withOpacity(0.8) : color,
    800: withShader ? color.withOpacity(0.9) : color,
    900: withShader ? color.withOpacity(1) : color,
  });
}
