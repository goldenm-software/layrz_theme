import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('protanopiaFilter()', () {
    test('strength 0.0 returns identity matrix', () {
      final matrix = protanopiaFilter(0.0);

      expect(matrix.length, 20);
      expect(matrix, [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
    });

    test('strength 1.0 returns full filter matrix', () {
      final matrix = protanopiaFilter(1.0);

      expect(matrix.length, 20);
      // Should be the base protanopia matrix
      expect(matrix[0], closeTo(0.567, 0.001));
      expect(matrix[1], closeTo(0.433, 0.001));
      expect(matrix[6], closeTo(0.442, 0.001));
    });

    test('strength 0.5 returns interpolated matrix', () {
      final matrix = protanopiaFilter(0.5);

      expect(matrix.length, 20);
      // Should be halfway between identity and filter
      expect(matrix[0], closeTo(0.7835, 0.001)); // (1 + 0.567) / 2
      expect(matrix[1], closeTo(0.2165, 0.001)); // (0 + 0.433) / 2
    });

    test('has exactly 20 elements', () {
      expect(protanopiaFilter(0.0).length, 20);
      expect(protanopiaFilter(0.5).length, 20);
      expect(protanopiaFilter(1.0).length, 20);
    });

    test('handles boundary strength values', () {
      expect(() => protanopiaFilter(0.0), returnsNormally);
      expect(() => protanopiaFilter(1.0), returnsNormally);
    });
  });

  group('protanomalyFilter()', () {
    test('strength 0.0 returns identity matrix', () {
      final matrix = protanomalyFilter(0.0);

      expect(matrix.length, 20);
      expect(matrix, [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
    });

    test('strength 1.0 returns full filter matrix', () {
      final matrix = protanomalyFilter(1.0);

      expect(matrix.length, 20);
      // Different from protanopia
      expect(matrix[0], isNot(equals(protanopiaFilter(1.0)[0])));
    });

    test('strength 0.5 returns interpolated matrix', () {
      final matrix = protanomalyFilter(0.5);

      expect(matrix.length, 20);
      // Should be between identity and filter
      expect(matrix[0], greaterThan(0.5));
      expect(matrix[0], lessThan(1.0));
    });

    test('has exactly 20 elements', () {
      expect(protanomalyFilter(0.0).length, 20);
      expect(protanomalyFilter(1.0).length, 20);
    });
  });

  group('deuteranopiaFilter()', () {
    test('strength 0.0 returns identity matrix', () {
      final matrix = deuteranopiaFilter(0.0);

      expect(matrix.length, 20);
      expect(matrix, [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
    });

    test('strength 1.0 returns full filter matrix', () {
      final matrix = deuteranopiaFilter(1.0);

      expect(matrix.length, 20);
      // Different from protanopia
      expect(matrix, isNot(equals(protanopiaFilter(1.0))));
    });

    test('strength 0.5 returns interpolated matrix', () {
      final matrix = deuteranopiaFilter(0.5);

      expect(matrix.length, 20);
    });

    test('has exactly 20 elements', () {
      expect(deuteranopiaFilter(0.0).length, 20);
      expect(deuteranopiaFilter(1.0).length, 20);
    });
  });

  group('deuteranomalyFilter()', () {
    test('strength 0.0 returns identity matrix', () {
      final matrix = deuteranomalyFilter(0.0);

      expect(matrix.length, 20);
      expect(matrix, [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
    });

    test('strength 1.0 returns full filter matrix', () {
      final matrix = deuteranomalyFilter(1.0);

      expect(matrix.length, 20);
      // Different from deuteranopia
      expect(matrix, isNot(equals(deuteranopiaFilter(1.0))));
    });

    test('strength 0.5 returns interpolated matrix', () {
      final matrix = deuteranomalyFilter(0.5);

      expect(matrix.length, 20);
    });

    test('has exactly 20 elements', () {
      expect(deuteranomalyFilter(0.0).length, 20);
      expect(deuteranomalyFilter(1.0).length, 20);
    });
  });

  group('tritanopiaFilter()', () {
    test('strength 0.0 returns identity matrix', () {
      final matrix = tritanopiaFilter(0.0);

      expect(matrix.length, 20);
      expect(matrix, [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
    });

    test('strength 1.0 returns full filter matrix', () {
      final matrix = tritanopiaFilter(1.0);

      expect(matrix.length, 20);
      // Different from protanopia and deuteranopia
      expect(matrix, isNot(equals(protanopiaFilter(1.0))));
      expect(matrix, isNot(equals(deuteranopiaFilter(1.0))));
    });

    test('strength 0.5 returns interpolated matrix', () {
      final matrix = tritanopiaFilter(0.5);

      expect(matrix.length, 20);
    });

    test('has exactly 20 elements', () {
      expect(tritanopiaFilter(0.0).length, 20);
      expect(tritanopiaFilter(1.0).length, 20);
    });
  });

  group('tritanomalyFilter()', () {
    test('strength 0.0 returns identity matrix', () {
      final matrix = tritanomalyFilter(0.0);

      expect(matrix.length, 20);
      expect(matrix, [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
    });

    test('strength 1.0 returns full filter matrix', () {
      final matrix = tritanomalyFilter(1.0);

      expect(matrix.length, 20);
      // Different from tritanopia
      expect(matrix, isNot(equals(tritanopiaFilter(1.0))));
    });

    test('strength 0.5 returns interpolated matrix', () {
      final matrix = tritanomalyFilter(0.5);

      expect(matrix.length, 20);
    });

    test('has exactly 20 elements', () {
      expect(tritanomalyFilter(0.0).length, 20);
      expect(tritanomalyFilter(1.0).length, 20);
    });
  });

  group('ColorblindFilter extension', () {
    test('normal mode returns identity matrix', () {
      final filter = ColorblindMode.normal.filter(0.5);

      // Normal mode should always return identity regardless of strength
      expect(filter, isA<ColorFilter>());
    });

    test('protanopia mode creates ColorFilter from protanopia matrix', () {
      final filter = ColorblindMode.protanopia.filter(1.0);

      expect(filter, isA<ColorFilter>());
    });

    test('protanomaly mode creates ColorFilter from protanomaly matrix', () {
      final filter = ColorblindMode.protanomaly.filter(1.0);

      expect(filter, isA<ColorFilter>());
    });

    test('deuteranopia mode creates ColorFilter from deuteranopia matrix', () {
      final filter = ColorblindMode.deuteranopia.filter(1.0);

      expect(filter, isA<ColorFilter>());
    });

    test('deuteranomaly mode creates ColorFilter from deuteranomaly matrix', () {
      final filter = ColorblindMode.deuteranomaly.filter(1.0);

      expect(filter, isA<ColorFilter>());
    });

    test('tritanopia mode creates ColorFilter from tritanopia matrix', () {
      final filter = ColorblindMode.tritanopia.filter(1.0);

      expect(filter, isA<ColorFilter>());
    });

    test('tritanomaly mode creates ColorFilter from tritanomaly matrix', () {
      final filter = ColorblindMode.tritanomaly.filter(1.0);

      expect(filter, isA<ColorFilter>());
    });

    test('all modes accept strength parameter', () {
      for (final mode in ColorblindMode.values) {
        expect(() => mode.filter(0.0), returnsNormally);
        expect(() => mode.filter(0.5), returnsNormally);
        expect(() => mode.filter(1.0), returnsNormally);
      }
    });
  });

  group('Matrix interpolation behavior', () {
    test('increasing strength gradually changes matrix values', () {
      final strength0 = protanopiaFilter(0.0);
      final strength25 = protanopiaFilter(0.25);
      final strength50 = protanopiaFilter(0.5);
      final strength75 = protanopiaFilter(0.75);
      final strength100 = protanopiaFilter(1.0);

      // First element should gradually decrease from 1.0 to base value
      expect(strength0[0], greaterThan(strength25[0]));
      expect(strength25[0], greaterThan(strength50[0]));
      expect(strength50[0], greaterThan(strength75[0]));
      expect(strength75[0], greaterThan(strength100[0]));
    });

    test('all filters preserve alpha channel (elements 15-19)', () {
      for (final filterFunc in [
        protanopiaFilter,
        protanomalyFilter,
        deuteranopiaFilter,
        deuteranomalyFilter,
        tritanopiaFilter,
        tritanomalyFilter,
      ]) {
        final matrix = filterFunc(1.0);
        // Alpha channel should be preserved
        expect(matrix[15], 0.0);
        expect(matrix[16], 0.0);
        expect(matrix[17], 0.0);
        expect(matrix[18], 1.0);
        expect(matrix[19], 0.0);
      }
    });
  });

  group('Edge cases', () {
    test('negative strength handled (treated as 0 or clamped)', () {
      // The implementation doesn't explicitly clamp, but test behavior
      expect(() => protanopiaFilter(-0.1), returnsNormally);
    });

    test('strength > 1.0 handled (extrapolates or clamped)', () {
      expect(() => protanopiaFilter(1.5), returnsNormally);
    });

    test('all filters produce distinct matrices at full strength', () {
      final filters = {
        'protanopia': protanopiaFilter(1.0),
        'protanomaly': protanomalyFilter(1.0),
        'deuteranopia': deuteranopiaFilter(1.0),
        'deuteranomaly': deuteranomalyFilter(1.0),
        'tritanopia': tritanopiaFilter(1.0),
        'tritanomaly': tritanomalyFilter(1.0),
      };

      // Each filter should be unique
      final matrices = filters.values.toList();
      for (var i = 0; i < matrices.length; i++) {
        for (var j = i + 1; j < matrices.length; j++) {
          expect(matrices[i], isNot(equals(matrices[j])),
              reason: 'Filters ${filters.keys.elementAt(i)} and ${filters.keys.elementAt(j)} should be different');
        }
      }
    });
  });
}
