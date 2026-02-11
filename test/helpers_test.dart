import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('useBlack', () {
    test('returns true for white (high luminance)', () {
      expect(useBlack(color: Colors.white), true);
    });

    test('returns false for black (low luminance)', () {
      expect(useBlack(color: Colors.black), false);
    });

    test('returns true for yellow (high luminance)', () {
      expect(useBlack(color: Colors.yellow), true);
    });

    test('returns false for dark blue (low luminance)', () {
      expect(useBlack(color: const Color(0xFF001E60)), false);
    });

    test('respects custom tolerance', () {
      final color = const Color(0xFF808080); // mid-grey
      final luminance = color.computeLuminance();
      // With a high tolerance, even mid-grey should return false
      expect(useBlack(color: color, tolerance: luminance + 0.1), false);
      // With a low tolerance, mid-grey should return true
      expect(useBlack(color: color, tolerance: luminance - 0.1), true);
    });
  });

  group('validateColor', () {
    test('returns black for light colors', () {
      expect(validateColor(color: Colors.white), Colors.black);
    });

    test('returns white for dark colors', () {
      expect(validateColor(color: Colors.black), Colors.white);
    });
  });

  group('getPrimaryColor', () {
    test('returns kPrimaryColor when null', () {
      expect(getPrimaryColor(), kPrimaryColor);
    });

    test('returns provided color when non-null', () {
      expect(getPrimaryColor(primary: Colors.red), Colors.red);
    });
  });

  group('getAccentColor', () {
    test('returns kAccentColor when null', () {
      expect(getAccentColor(), kAccentColor);
    });

    test('returns provided color when non-null', () {
      expect(getAccentColor(accent: Colors.blue), Colors.blue);
    });
  });

  group('generateSwatch', () {
    test('without shader all shades are the same color', () {
      final swatch = generateSwatch(color: Colors.red);
      for (final shade in [50, 100, 200, 300, 400, 500, 600, 700, 800, 900]) {
        expect(swatch[shade], Colors.red);
      }
    });

    test('with shader shades have increasing alpha', () {
      final swatch = generateSwatch(color: Colors.blue, withShader: true);
      final expectedAlphas = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
      final shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

      for (var i = 0; i < shades.length; i++) {
        final shade = swatch[shades[i]]!;
        expect(shade.a, closeTo(expectedAlphas[i], 0.01));
      }
    });

    test('swatch has all 10 shade levels', () {
      final swatch = generateSwatch(color: Colors.green);
      for (final shade in [50, 100, 200, 300, 400, 500, 600, 700, 800, 900]) {
        expect(swatch[shade], isNotNull);
      }
    });
  });
}
