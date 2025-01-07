import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  test('Color.toJson', () {
    Color color = const Color(0xFF00FF00);
    expect(color.r, 0);
    expect(color.g, 1);
    expect(color.b, 0);
    expect(color.a, 1);
    expect(color.toHex(), "#00FF00");

    color = color.withValues(alpha: 0.5);
    debugPrint(color.toString());
    expect(color.r, 0);
    expect(color.g, 1);
    expect(color.b, 0);
    expect(color.a, 0.5);
    expect(color.toHexWithAlpha(), "#8000FF00");
  });
}
