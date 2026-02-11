import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('toHex()', () {
    test('converts black to #000000', () {
      expect(Colors.black.toHex(), '#000000');
    });

    test('converts white to #FFFFFF', () {
      expect(Colors.white.toHex(), '#FFFFFF');
    });

    test('converts kAccentColor (#FF8200)', () {
      const color = Color(0xFFFF8200);
      expect(color.toHex(), '#FF8200');
    });

    test('converts kPrimaryColor (#001e60)', () {
      const color = Color(0xFF001E60);
      expect(color.toHex(), '#001E60');
    });

    test('outputs uppercase hex', () {
      const color = Color(0xFFaabbcc);
      expect(color.toHex(), '#AABBCC');
    });

    test('ignores alpha channel', () {
      const color = Color(0x80FF8200);
      expect(color.toHex(), '#FF8200');
    });

    test('hex getter is alias for toHex()', () {
      const color = Color(0xFFFF8200);
      expect(color.hex, color.toHex());
      expect(color.hex, '#FF8200');
    });
  });

  group('toHexWithAlpha()', () {
    test('includes full alpha (#FFFFFFFF for white)', () {
      expect(Colors.white.toHexWithAlpha(), '#FFFFFFFF');
    });

    test('includes zero alpha (#00000000 for transparent)', () {
      const color = Color(0x00000000);
      expect(color.toHexWithAlpha(), '#00000000');
    });

    test('includes partial alpha (#80FF8200)', () {
      const color = Color(0x80FF8200);
      expect(color.toHexWithAlpha(), '#80FF8200');
    });

    test('alpha comes first in AARRGGBB format', () {
      Color color = const Color(0xFF00FF00);
      expect(color.toHexWithAlpha(), '#FF00FF00');

      color = color.withValues(alpha: 0.5);
      expect(color.toHexWithAlpha(), '#8000FF00');
    });

    test('hexWithAlpha getter is alias for toHexWithAlpha()', () {
      const color = Color(0x80FF8200);
      expect(color.hexWithAlpha, color.toHexWithAlpha());
      expect(color.hexWithAlpha, '#80FF8200');
    });
  });

  group('toInt()', () {
    test('converts to ARGB integer', () {
      const color = Color(0xFFFF8200);
      expect(color.toInt(), 0xFFFF8200);
    });

    test('handles alpha channel correctly', () {
      const color = Color(0x80FF8200);
      expect(color.toInt(), 0x80FF8200);
    });

    test('black is 0xFF000000', () {
      expect(Colors.black.toInt(), 0xFF000000);
    });

    test('white is 0xFFFFFFFF', () {
      expect(Colors.white.toInt(), 0xFFFFFFFF);
    });

    test('transparent is 0x00000000', () {
      const color = Color(0x00000000);
      expect(color.toInt(), 0x00000000);
    });
  });

  group('fromHex()', () {
    test('parses black #000000', () {
      final color = ThemedColorExtensions.fromHex('#000000');
      expect(color.toHex(), '#000000');
    });

    test('parses white #FFFFFF', () {
      final color = ThemedColorExtensions.fromHex('#FFFFFF');
      expect(color.toHex(), '#FFFFFF');
    });

    test('parses accent color #FF8200', () {
      final color = ThemedColorExtensions.fromHex('#FF8200');
      expect(color.toHex(), '#FF8200');
    });

    test('parses primary color #001E60', () {
      final color = ThemedColorExtensions.fromHex('#001E60');
      expect(color.toHex(), '#001E60');
    });

    test('parses lowercase hex #ff8200', () {
      final color = ThemedColorExtensions.fromHex('#ff8200');
      expect(color.toHex(), '#FF8200');
    });

    test('sets alpha to 255 (fully opaque)', () {
      final color = ThemedColorExtensions.fromHex('#FF8200');
      expect((color.a * 255.0).round(), 255);
    });
  });

  group('fromHexWithAlpha()', () {
    test('parses full alpha #FFFFFFFF', () {
      final color = ThemedColorExtensions.fromHexWithAlpha('#FFFFFFFF');
      expect(color.toHexWithAlpha(), '#FFFFFFFF');
      expect((color.a * 255.0).round(), 255);
    });

    test('parses zero alpha #00000000', () {
      final color = ThemedColorExtensions.fromHexWithAlpha('#00000000');
      expect(color.toHexWithAlpha(), '#00000000');
      expect((color.a * 255.0).round(), 0);
    });

    test('parses partial alpha #80FF8200', () {
      final color = ThemedColorExtensions.fromHexWithAlpha('#80FF8200');
      expect(color.toHexWithAlpha(), '#80FF8200');
      expect((color.a * 255.0).round(), 128);
    });

    test('parses alpha first in AARRGGBB format', () {
      final color = ThemedColorExtensions.fromHexWithAlpha('#8000FF00');
      expect((color.r * 255.0).round(), 0);
      expect((color.g * 255.0).round(), 255);
      expect((color.b * 255.0).round(), 0);
      expect((color.a * 255.0).round(), 128);
    });
  });

  group('Round-trip conversions', () {
    test('Color -> toHex() -> fromHex() -> Color preserves RGB', () {
      const original = Color(0xFFFF8200);
      final hex = original.toHex();
      final restored = ThemedColorExtensions.fromHex(hex);
      expect(restored.toHex(), original.toHex());
      expect((restored.r * 255.0).round(), (original.r * 255.0).round());
      expect((restored.g * 255.0).round(), (original.g * 255.0).round());
      expect((restored.b * 255.0).round(), (original.b * 255.0).round());
    });

    test('Color -> toHexWithAlpha() -> fromHexWithAlpha() -> Color preserves ARGB', () {
      const original = Color(0x80FF8200);
      final hex = original.toHexWithAlpha();
      final restored = ThemedColorExtensions.fromHexWithAlpha(hex);
      expect(restored.toHexWithAlpha(), original.toHexWithAlpha());
      expect((restored.a * 255.0).round(), (original.a * 255.0).round());
      expect((restored.r * 255.0).round(), (original.r * 255.0).round());
      expect((restored.g * 255.0).round(), (original.g * 255.0).round());
      expect((restored.b * 255.0).round(), (original.b * 255.0).round());
    });

    test('Color -> toInt() -> Color() preserves exact value', () {
      const original = Color(0x80FF8200);
      final intValue = original.toInt();
      final restored = Color(intValue);
      expect(restored.toInt(), original.toInt());
    });
  });

  group('JSON aliases', () {
    test('toJson() is equivalent to toHex()', () {
      const color = Color(0xFFFF8200);
      expect(color.toJson(), color.toHex());
      expect(color.toJson(), '#FF8200');
    });

    test('fromJson() is equivalent to fromHex()', () {
      final color1 = ThemedColorExtensions.fromJson('#FF8200');
      final color2 = ThemedColorExtensions.fromHex('#FF8200');
      expect(color1.toHex(), color2.toHex());
      expect(color1.toInt(), color2.toInt());
    });
  });
}
