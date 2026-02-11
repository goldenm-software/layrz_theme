import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('Layo widget', () {
    testWidgets('renders with default values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Layo(size: 50),
          ),
        ),
      );
      expect(find.byType(Layo), findsOneWidget);
    });

    testWidgets('renders with custom emotion', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Layo(size: 50, emotion: LayoEmotions.happy),
          ),
        ),
      );
      expect(find.byType(Layo), findsOneWidget);
    });

    test('throws assertion error for invalid elevation', () {
      expect(() => Layo(size: 50, elevation: 6), throwsAssertionError);
      expect(() => Layo(size: 50, elevation: -1), throwsAssertionError);
    });
  });
}
