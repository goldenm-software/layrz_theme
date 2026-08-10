part of '../tokenizer.dart';

extension ShadowTokenizer on LayrzTokenizer {
  /// [shadowColor] is the color used for shadows in the system.
  Color get shadowColor => Colors.black.withValues(alpha: 0.2);

  /// [shadow] is the generator of shadows, based on the [generateContainerElevation] function.
  BoxDecoration shadow({
    /// [elevation] is the elevation of the shadow, by default it is 1.
    double elevation = 1,

    /// [borderRadius] is the border radius of the shadow, by default uses `LayrzTokenizer.radius`.
    double? borderRadius,

    /// [shadowColor] is the color of the shadow, by default uses `LayrzTokenizer.shadowColor`.
    Color? backgroundColor,
  }) {
    return generateContainerElevation(
      context: ctx,
      elevation: elevation,
      radius: borderRadius ?? radius,
      color: backgroundColor,
      shadowColor: shadowColor,
    );
  }
}
