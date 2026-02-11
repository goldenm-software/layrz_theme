import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('getThemeColor() - Predefined themes', () {
    test('PINK returns Colors.pink', () {
      final color = getThemeColor(theme: 'PINK');
      expect(color, Colors.pink);
    });

    test('RED returns Colors.red', () {
      final color = getThemeColor(theme: 'RED');
      expect(color, Colors.red);
    });

    test('DEEPORANGE returns Colors.deepOrange', () {
      final color = getThemeColor(theme: 'DEEPORANGE');
      expect(color, Colors.deepOrange);
    });

    test('ORANGE returns Colors.orange', () {
      final color = getThemeColor(theme: 'ORANGE');
      expect(color, Colors.orange);
    });

    test('AMBER returns Colors.amber', () {
      final color = getThemeColor(theme: 'AMBER');
      expect(color, Colors.amber);
    });

    test('YELLOW returns Colors.yellow', () {
      final color = getThemeColor(theme: 'YELLOW');
      expect(color, Colors.yellow);
    });

    test('LIME returns Colors.lime', () {
      final color = getThemeColor(theme: 'LIME');
      expect(color, Colors.lime);
    });

    test('LIGHTGREEN returns Colors.lightGreen', () {
      final color = getThemeColor(theme: 'LIGHTGREEN');
      expect(color, Colors.lightGreen);
    });

    test('GREEN returns Colors.green', () {
      final color = getThemeColor(theme: 'GREEN');
      expect(color, Colors.green);
    });

    test('TEAL returns Colors.teal', () {
      final color = getThemeColor(theme: 'TEAL');
      expect(color, Colors.teal);
    });

    test('CYAN returns Colors.cyan', () {
      final color = getThemeColor(theme: 'CYAN');
      expect(color, Colors.cyan);
    });

    test('LIGHTBLUE returns Colors.lightBlue', () {
      final color = getThemeColor(theme: 'LIGHTBLUE');
      expect(color, Colors.lightBlue);
    });

    test('BLUE returns Colors.blue', () {
      final color = getThemeColor(theme: 'BLUE');
      expect(color, Colors.blue);
    });

    test('INDIGO returns Colors.indigo', () {
      final color = getThemeColor(theme: 'INDIGO');
      expect(color, Colors.indigo);
    });

    test('DEEPBLUE returns Colors.deepPurple', () {
      final color = getThemeColor(theme: 'DEEPBLUE');
      expect(color, Colors.deepPurple);
    });

    test('PURPLE returns Colors.purple', () {
      final color = getThemeColor(theme: 'PURPLE');
      expect(color, Colors.purple);
    });

    test('BLUEGREY returns Colors.blueGrey', () {
      final color = getThemeColor(theme: 'BLUEGREY');
      expect(color, Colors.blueGrey);
    });

    test('GREY returns Colors.grey', () {
      final color = getThemeColor(theme: 'GREY');
      expect(color, Colors.grey);
    });

    test('BROWN returns Colors.brown', () {
      final color = getThemeColor(theme: 'BROWN');
      expect(color, Colors.brown);
    });
  });

  group('getThemeColor() - CUSTOM theme', () {
    test('CUSTOM with provided color generates swatch from that color', () {
      const customColor = Color(0xFFFF8200);
      final result = getThemeColor(theme: 'CUSTOM', color: customColor);

      // Should be a MaterialColor swatch generated from the custom color
      expect(result, isA<MaterialColor>());
      expect(result[500], customColor);
    });

    test('CUSTOM without explicit color uses kPrimaryColor', () {
      final result = getThemeColor(theme: 'CUSTOM');

      expect(result, isA<MaterialColor>());
      expect(result[500], kPrimaryColor);
    });
  });

  group('getThemeColor() - Invalid/default handling', () {
    test('Invalid theme returns swatch from kPrimaryColor', () {
      final result = getThemeColor(theme: 'INVALID_THEME');

      expect(result, isA<MaterialColor>());
      expect(result[500], kPrimaryColor);
    });

    test('Empty string theme returns swatch from kPrimaryColor', () {
      final result = getThemeColor(theme: '');

      expect(result, isA<MaterialColor>());
      expect(result[500], kPrimaryColor);
    });

    test('Lowercase theme name does not match (case-sensitive)', () {
      final result = getThemeColor(theme: 'pink');

      // Should fall through to default since it's case-sensitive
      expect(result, isA<MaterialColor>());
      expect(result[500], kPrimaryColor);
    });
  });

  group('getThemeColor() - Return type validation', () {
    test('All valid themes return MaterialColor type', () {
      final themes = [
        'PINK', 'RED', 'DEEPORANGE', 'ORANGE', 'AMBER', 'YELLOW',
        'LIME', 'LIGHTGREEN', 'GREEN', 'TEAL', 'CYAN', 'LIGHTBLUE',
        'BLUE', 'INDIGO', 'DEEPBLUE', 'PURPLE', 'BLUEGREY', 'GREY', 'BROWN'
      ];

      for (final theme in themes) {
        final result = getThemeColor(theme: theme);
        expect(result, isA<MaterialColor>(), reason: 'Theme $theme should return MaterialColor');
      }
    });

    test('MaterialColor has all required shades (50-900)', () {
      final result = getThemeColor(theme: 'BLUE');

      expect(result[50], isNotNull);
      expect(result[100], isNotNull);
      expect(result[200], isNotNull);
      expect(result[300], isNotNull);
      expect(result[400], isNotNull);
      expect(result[500], isNotNull);
      expect(result[600], isNotNull);
      expect(result[700], isNotNull);
      expect(result[800], isNotNull);
      expect(result[900], isNotNull);
    });
  });
}
