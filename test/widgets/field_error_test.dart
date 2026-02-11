import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

Widget _buildApp({required Widget child}) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}

void main() {
  group('ThemedFieldDisplayError', () {
    testWidgets('displays single error message', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedFieldDisplayError(
          errors: ['This field is required'],
        ),
      ));

      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('displays multiple errors joined by comma', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedFieldDisplayError(
          errors: ['Error 1', 'Error 2', 'Error 3'],
        ),
      ));

      expect(find.text('Error 1, Error 2, Error 3'), findsOneWidget);
    });

    testWidgets('hides errors when hideDetails is true', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedFieldDisplayError(
          errors: ['This field is required'],
          hideDetails: true,
        ),
      ));

      expect(find.text('This field is required'), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('shows nothing when errors list is empty', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedFieldDisplayError(
          errors: [],
        ),
      ));

      expect(find.byType(Text), findsNothing);
    });

    testWidgets('applies custom padding', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedFieldDisplayError(
          errors: ['Error'],
          padding: EdgeInsets.all(20),
        ),
      ));

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, const EdgeInsets.all(20));
    });

    testWidgets('applies maxLines constraint', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedFieldDisplayError(
          errors: ['Error'],
          maxLines: 3,
        ),
      ));

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.maxLines, 3);
    });

    testWidgets('error text is red', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedFieldDisplayError(
          errors: ['Error'],
        ),
      ));

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.color, Colors.red);
    });

    testWidgets('default maxLines is 1', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedFieldDisplayError(
          errors: ['Error'],
        ),
      ));

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.maxLines, 1);
    });
  });
}
