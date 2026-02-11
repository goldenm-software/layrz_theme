import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('ThemedAlert widget', () {
    testWidgets('renders info alert', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemedAlert(
              type: ThemedAlertType.info,
              title: 'Info Title',
              description: 'Info Description',
            ),
          ),
        ),
      );
      expect(find.text('Info Title'), findsOneWidget);
      expect(find.text('Info Description'), findsOneWidget);
      expect(find.byType(ThemedAlert), findsOneWidget);
    });

    testWidgets('renders success alert', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemedAlert(
              type: ThemedAlertType.success,
              title: 'Success Title',
              description: 'Success Description',
            ),
          ),
        ),
      );
      expect(find.text('Success Title'), findsOneWidget);
      expect(find.text('Success Description'), findsOneWidget);
      expect(find.byType(ThemedAlert), findsOneWidget);
    });

    testWidgets('renders custom alert with icon and color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemedAlert(
              type: ThemedAlertType.custom,
              title: 'Custom Title',
              description: 'Custom Description',
              color: Colors.purple,
              icon: Icons.star,
            ),
          ),
        ),
      );
      expect(find.text('Custom Title'), findsOneWidget);
      expect(find.text('Custom Description'), findsOneWidget);
      expect(find.byType(ThemedAlert), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
