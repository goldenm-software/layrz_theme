part of '../tokenizer.dart';

extension RadiusTokenizer on LayrzTokenizer {
  /// [radius] is the default border radius used in the system.
  double get radius => 8;

  /// [borderRadius] is the default border radius used in the system.
  BorderRadius get borderRadius => BorderRadius.circular(radius);

  /// [innerRadius] is a function to help to generate inner border radius, based on the [radius] value.
  ///
  /// This property essentially calculates the inner border radius by subtracting a
  /// pecified [spacer] value from the [outerRadius]. It's mathematically correct and ensures that the inner
  /// radius is always smaller than the outer radius, which is important
  /// for maintaining a consistent visual hierarchy in UI design.
  BorderRadius innerRadius({required double outerRadius, required double spacer}) {
    final double innerRadius = outerRadius - spacer;
    return BorderRadius.circular(max(innerRadius, 0)); // Clamp to 0 to avoid negative radius
  }
}
