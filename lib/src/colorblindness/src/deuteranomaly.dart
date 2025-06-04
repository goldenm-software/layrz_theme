part of '../colorblindness.dart';

List<double> deuteranomalyFilter(double strength) {
  List<double> identityMatrix = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
  List<double> baseMatrix = [
    0.8, 0.2, 0.0, 0.0, 0.0, // Red channel
    0.3, 0.7, 0.0, 0.0, 0.0, // Green channel
    0.0, 0.258, 0.742, 0.0, 0.0, // Blue channel
    0.0, 0.0, 0.0, 1.0, 0.0, // Alpha channel
  ];

  return List.generate(20, (i) => identityMatrix[i] * (1 - strength) + baseMatrix[i] * strength);
}
