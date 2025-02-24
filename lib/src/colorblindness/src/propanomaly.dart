part of '../colorblindness.dart';

List<double> protanomalyFilter(double strength) {
  List<double> identityMatrix = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
  List<double> baseMatrix = [
    0.817, 0.183, 0.0, 0.0, 0.0, // Red channel
    0.333, 0.667, 0.0, 0.0, 0.0, // Green channel
    0.0, 0.125, 0.875, 0.0, 0.0, // Blue channel
    0.0, 0.0, 0.0, 1.0, 0.0 // Alpha channel
  ];

  return List.generate(20, (i) => identityMatrix[i] * (1 - strength) + baseMatrix[i] * strength);
}
