part of '../colorblindness.dart';

extension ColorblindFilter on ColorblindMode {
  ColorFilter filter(double strength) {
    switch (this) {
      case .protanopia:
        return ColorFilter.matrix(protanopiaFilter(strength));
      case .protanomaly:
        return ColorFilter.matrix(protanomalyFilter(strength));
      case .deuteranopia:
        return ColorFilter.matrix(deuteranopiaFilter(strength));
      case .deuteranomaly:
        return ColorFilter.matrix(deuteranomalyFilter(strength));
      case .tritanopia:
        return ColorFilter.matrix(tritanopiaFilter(strength));
      case .tritanomaly:
        return ColorFilter.matrix(tritanomalyFilter(strength));
      case .normal:
        return const ColorFilter.matrix([
          // ✅ Corrected to identity matrix
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ]);
    }
  }
}
