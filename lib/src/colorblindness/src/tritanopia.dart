part of '../colorblindness.dart';

List<double> tritanopiaFilter(double strength) {
  List<double> identityMatrix = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
  List<double> baseMatrix = [
    0.95, 0.05, 0.0, 0.0, 0.0, // Red channel
    0.0, 0.433, 0.567, 0.0, 0.0, // Green channel
    0.0, 0.475, 0.525, 0.0, 0.0, // Blue channel
    0.0, 0.0, 0.0, 1.0, 0.0 // Alpha channel
  ];

  return List.generate(20, (i) => identityMatrix[i] * (1 - strength) + baseMatrix[i] * strength);
}
