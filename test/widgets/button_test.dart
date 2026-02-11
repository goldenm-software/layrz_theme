import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('ThemedButton widget', () {
    testWidgets('renders with labelText', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemedButton(
              labelText: 'Button Text',
              onTap: () {},
            ),
          ),
        ),
      );
      expect(find.byType(ThemedButton), findsOneWidget);
      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      final allText = richTexts.map((rt) => (rt.text as TextSpan).toPlainText()).join(' ');
      expect(allText, contains('Button Text'));
    });

    testWidgets('renders with icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemedButton(
              labelText: 'Icon Button',
              icon: Icons.add,
              onTap: () {},
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      final allText = richTexts.map((rt) => (rt.text as TextSpan).toPlainText()).join(' ');
      expect(allText, contains('Icon Button'));
    });

    testWidgets('renders as disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemedButton(
              labelText: 'Disabled',
              isDisabled: true,
              onTap: () {},
            ),
          ),
        ),
      );
      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      final allText = richTexts.map((rt) => (rt.text as TextSpan).toPlainText()).join(' ');
      expect(allText, contains('Disabled'));
      // Optionally check for disabled state visually
    });

    testWidgets('renders loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemedButton(
              labelText: 'Loading',
              isLoading: true,
              onTap: () {},
            ),
          ),
        ),
      );
      // Loading state may not show label text, so check for LinearProgressIndicator
      expect(find.byType(LinearProgressIndicator), findsWidgets);
    });

    testWidgets('renders with custom color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemedButton(
              labelText: 'Colored',
              color: Colors.purple,
              onTap: () {},
            ),
          ),
        ),
      );
      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      final allText = richTexts.map((rt) => (rt.text as TextSpan).toPlainText()).join(' ');
      expect(allText, contains('Colored'));
    });

    testWidgets('renders with different styles', (WidgetTester tester) async {
      for (final style in ThemedButtonStyle.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ThemedButton(
                labelText: style.toString(),
                style: style,
                icon: Icons.star,
                onTap: () {},
              ),
            ),
          ),
        );
        // FAB styles only show icon, not label text
        final isFab = [
          ThemedButtonStyle.outlinedFab,
          ThemedButtonStyle.fab,
          ThemedButtonStyle.filledFab,
          ThemedButtonStyle.filledTonalFab,
          ThemedButtonStyle.elevatedFab,
          ThemedButtonStyle.outlinedTonalFab,
        ].contains(style);
        if (isFab) {
          expect(find.byIcon(Icons.star), findsOneWidget);
        } else {
          final richTexts = tester.widgetList<RichText>(find.byType(RichText));
          final allText = richTexts.map((rt) => (rt.text as TextSpan).toPlainText()).join(' ');
          expect(allText, contains(style.toString()));
        }
      }
    });

    testWidgets('renders with factory constructors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              ThemedButton.save(onTap: () {}, labelText: 'Save'),
              ThemedButton.cancel(onTap: () {}, labelText: 'Cancel'),
              ThemedButton.info(onTap: () {}, labelText: 'Info'),
              ThemedButton.show(onTap: () {}, labelText: 'Show'),
              ThemedButton.edit(onTap: () {}, labelText: 'Edit'),
              ThemedButton.delete(onTap: () {}, labelText: 'Delete'),
            ],
          ),
        ),
      );
      // Only check for label text in non-FAB styles
      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      final allText = richTexts.map((rt) => (rt.text as TextSpan).toPlainText()).join(' ');
      expect(allText, contains('Save'));
      expect(allText, contains('Cancel'));
      expect(allText, contains('Info'));
      expect(allText, contains('Show'));
      expect(allText, contains('Edit'));
      expect(allText, contains('Delete'));
    });
  });
}
