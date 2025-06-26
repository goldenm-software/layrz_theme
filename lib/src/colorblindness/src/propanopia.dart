part of '../colorblindness.dart';

List<double> protanopiaFilter(double strength) {
  List<double> identityMatrix = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
  List<double> baseMatrix = [
    0.567, 0.433, 0.0, 0.0, 0.0, // Red channel
    0.558, 0.442, 0.0, 0.0, 0.0, // Green channel
    0.0, 0.242, 0.758, 0.0, 0.0, // Blue channel
    0.0, 0.0, 0.0, 1.0, 0.0, // Alpha channel
  ];

  return List.generate(20, (i) => identityMatrix[i] * (1 - strength) + baseMatrix[i] * strength);
}
