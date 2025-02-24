part of '../colorblindness.dart';

extension ColorblindFilter on ColorblindMode {
  ColorFilter filter(double strength) {
    switch (this) {
      case ColorblindMode.protanopia:
        return ColorFilter.matrix(protanopiaFilter(strength));
      case ColorblindMode.protanomaly:
        return ColorFilter.matrix(protanomalyFilter(strength));
      case ColorblindMode.deuteranopia:
        return ColorFilter.matrix(deuteranopiaFilter(strength));
      case ColorblindMode.deuteranomaly:
        return ColorFilter.matrix(deuteranomalyFilter(strength));
      case ColorblindMode.tritanopia:
        return ColorFilter.matrix(tritanopiaFilter(strength));
      case ColorblindMode.tritanomaly:
        return ColorFilter.matrix(tritanomalyFilter(strength));
      case ColorblindMode.normal:
        return const ColorFilter.matrix([
          // ✅ Corrected to identity matrix
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0
        ]);
    }
  }
}
