import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('ThemedChip widget', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemedChip(labelText: 'Test Chip'),
          ),
        ),
      );
      // The label is rendered as a TextSpan inside RichText, not a Text widget
      final richText = tester.widget<RichText>(find.byType(RichText));
      final textSpan = richText.text as TextSpan;
      expect(textSpan.toPlainText(), contains('Test Chip'));
      expect(find.byType(ThemedChip), findsOneWidget);
    });

    testWidgets('renders with custom color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemedChip(labelText: 'Colored Chip', color: Colors.red),
          ),
        ),
      );
      final richText = tester.widget<RichText>(find.byType(RichText));
      final textSpan = richText.text as TextSpan;
      expect(textSpan.toPlainText(), contains('Colored Chip'));
      expect(find.byType(ThemedChip), findsOneWidget);
    });
  });
}
