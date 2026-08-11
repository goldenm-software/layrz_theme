part of '../tokenizer.dart';

extension ShadowTokenizer on LayrzTokenizer {
  /// [shadow] is the generator of shadows, based on the [generateContainerElevation] function.
  BoxDecoration shadow({
    /// [elevation] is the elevation of the shadow, by default it is 1.
    double elevation = 1,

    /// [borderRadius] is the border radius of the shadow, by default uses `LayrzTokenizer.radius`.
    double? borderRadius,

    /// [backgroundColor] is the color of the shadow, by default uses `LayrzTokenizer.shadowColor`.
    Color? backgroundColor,
  }) {
    if (ctx == null) {
      throw Exception("LayrzTokenizer context is null. Please provide a valid BuildContext.");
    }
    return generateContainerElevation(
      context: ctx!,
      elevation: elevation,
      radius: borderRadius ?? radius,
      color: backgroundColor,
    );
  }
}
