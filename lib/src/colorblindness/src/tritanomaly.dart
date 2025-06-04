part of '../colorblindness.dart';

List<double> tritanomalyFilter(double strength) {
  List<double> identityMatrix = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
  List<double> baseMatrix = [
    0.967, 0.033, 0.0, 0.0, 0.0, // Red channel
    0.0, 0.733, 0.267, 0.0, 0.0, // Green channel
    0.0, 0.183, 0.817, 0.0, 0.0, // Blue channel
    0.0, 0.0, 0.0, 1.0, 0.0, // Alpha channel
  ];

  return List.generate(20, (i) => identityMatrix[i] * (1 - strength) + baseMatrix[i] * strength);
}
