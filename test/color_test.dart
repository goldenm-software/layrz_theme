import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  test('Color.toJson', () {
    Color color = const Color(0xFF00FF00);

    expect(color.toJson(), "#00FF00");
  });
}
