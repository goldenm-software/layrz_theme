import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('ResponsiveRow', () {
    testWidgets('Renders basic ResponsiveRow with children', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [
                ResponsiveCol(xs: .col6, child: Container(color: Colors.red, height: 100)),
                ResponsiveCol(xs: .col6, child: Container(color: Colors.blue, height: 100)),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(ResponsiveCol), findsNWidgets(2));
      expect(find.byType(Container), findsNWidgets(2));
    });

    testWidgets('ResponsiveRow with empty children renders empty Wrap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [],
            ),
          ),
        ),
      );

      final wrap = find.byType(Wrap);
      expect(wrap, findsOneWidget);
      expect(find.byType(ResponsiveCol), findsNothing);
    });

    testWidgets('ResponsiveRow with single child', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [
                ResponsiveCol(xs: .col12, child: Container(color: Colors.green, height: 50)),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveCol), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('ResponsiveRow respects spacing parameter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              spacing: 16,
              children: [
                ResponsiveCol(xs: .col6, child: Container(color: Colors.red, height: 100)),
                ResponsiveCol(xs: .col6, child: Container(color: Colors.blue, height: 100)),
              ],
            ),
          ),
        ),
      );

      final wrap = find.byType(Wrap).evaluate().first.widget as Wrap;
      expect(wrap.spacing, 16);
    });

    testWidgets('ResponsiveRow respects spacing = 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              spacing: 0,
              children: [
                ResponsiveCol(xs: .col6, child: Container(color: Colors.red, height: 100)),
                ResponsiveCol(xs: .col6, child: Container(color: Colors.blue, height: 100)),
              ],
            ),
          ),
        ),
      );

      final wrap = find.byType(Wrap).evaluate().first.widget as Wrap;
      expect(wrap.spacing, 0);
    });

    testWidgets('ResponsiveRow default spacing is 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [
                ResponsiveCol(xs: .col6, child: Container(height: 100)),
                ResponsiveCol(xs: .col6, child: Container(height: 100)),
              ],
            ),
          ),
        ),
      );

      final wrap = find.byType(Wrap).evaluate().first.widget as Wrap;
      expect(wrap.spacing, 0); // Default spacing should be 0
    });

    testWidgets('ResponsiveRow spacing applies to Wrap.runSpacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              spacing: 20,
              children: [
                ResponsiveCol(xs: .col6, child: Container(height: 100)),
                ResponsiveCol(xs: .col6, child: Container(height: 100)),
              ],
            ),
          ),
        ),
      );

      final wrap = find.byType(Wrap).evaluate().first.widget as Wrap;
      expect(wrap.runSpacing, 20);
    });

    testWidgets('ResponsiveRow default spacing gives runSpacing of 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [
                ResponsiveCol(xs: .col6, child: Container(height: 100)),
                ResponsiveCol(xs: .col6, child: Container(height: 100)),
              ],
            ),
          ),
        ),
      );

      final wrap = find.byType(Wrap).evaluate().first.widget as Wrap;
      expect(wrap.runSpacing, 0);
    });

    testWidgets('ResponsiveRow respects mainAxisAlignment', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              mainAxisAlignment: WrapAlignment.center,
              children: [
                ResponsiveCol(xs: .col6, child: Container(color: Colors.red, height: 100)),
              ],
            ),
          ),
        ),
      );

      final wrap = find.byType(Wrap).evaluate().first.widget as Wrap;
      expect(wrap.alignment, WrapAlignment.center);
    });

    testWidgets('ResponsiveRow respects crossAxisAlignment', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ResponsiveCol(xs: .col6, child: Container(color: Colors.red, height: 100)),
              ],
            ),
          ),
        ),
      );

      final wrap = find.byType(Wrap).evaluate().first.widget as Wrap;
      expect(wrap.crossAxisAlignment, WrapCrossAlignment.center);
    });

    testWidgets('ResponsiveRow has full width (width: double.infinity)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [
                ResponsiveCol(xs: .col6, child: Container(color: Colors.red, height: 100)),
              ],
            ),
          ),
        ),
      );

      final sizedBox = find.byType(SizedBox).first.evaluate().first.widget as SizedBox;
      expect(sizedBox.width, double.infinity);
    });

    testWidgets('ResponsiveRow.builder creates correct number of children', (WidgetTester tester) async {
      int buildCount = 0;
      ResponsiveCol itemBuilder(int index) {
        buildCount++;
        return ResponsiveCol(
          xs: .col6,
          child: Container(color: Colors.red, height: 50),
        );
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow.builder(
              itemCount: 5,
              itemBuilder: itemBuilder,
            ),
          ),
        ),
      );

      expect(buildCount, 5);
      expect(find.byType(ResponsiveCol), findsNWidgets(5));
    });

    testWidgets('ResponsiveRow.builder with itemCount=0', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow.builder(
              itemCount: 0,
              itemBuilder: (index) => ResponsiveCol(xs: .col6, child: Container()),
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveCol), findsNothing);
    });

    testWidgets('ResponsiveRow.builder respects mainAxisAlignment', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow.builder(
              itemCount: 2,
              mainAxisAlignment: WrapAlignment.spaceEvenly,
              itemBuilder: (index) => ResponsiveCol(xs: .col4, child: Container()),
            ),
          ),
        ),
      );

      final wrap = find.byType(Wrap).evaluate().first.widget as Wrap;
      expect(wrap.alignment, WrapAlignment.spaceEvenly);
    });

    testWidgets('ResponsiveRow.builder respects spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow.builder(
              itemCount: 3,
              spacing: 20,
              itemBuilder: (index) => ResponsiveCol(xs: .col4, child: Container()),
            ),
          ),
        ),
      );

      final wrap = find.byType(Wrap).evaluate().first.widget as Wrap;
      expect(wrap.spacing, 20);
    });

    testWidgets('ResponsiveRow uses Wrap as layout widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [
                ResponsiveCol(xs: .col6, child: Container()),
                ResponsiveCol(xs: .col6, child: Container()),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('ResponsiveRow.builder with large itemCount', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow.builder(
              itemCount: 20,
              itemBuilder: (index) => ResponsiveCol(
                xs: .col6,
                child: Container(height: 50),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveCol), findsNWidgets(20));
    });
  });

  group('ResponsiveCol', () {
    testWidgets('ResponsiveCol renders child', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveCol(
              xs: .col6,
              child: Container(color: Colors.red, height: 100, key: const Key('test-child')),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('test-child')), findsOneWidget);
    });

    testWidgets('ResponsiveCol uses xs by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveCol(
              xs: .col12,
              child: Container(color: Colors.red, height: 100, key: const Key('test')),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('test')), findsOneWidget);
    });

    testWidgets('ResponsiveCol falls back to xs if sm is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveCol(
              xs: .col12,
              sm: null,
              child: Container(color: Colors.red, height: 100, key: const Key('test')),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('test')), findsOneWidget);
    });

    testWidgets('ResponsiveCol with all breakpoints specified', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveCol(
              xs: .col12,
              sm: .col6,
              md: .col4,
              lg: .col3,
              xl: .col2,
              child: Container(color: Colors.green, height: 100, key: const Key('test')),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('test')), findsOneWidget);
    });

    testWidgets('ResponsiveCol uses LayoutBuilder for responsive sizing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveCol(
              xs: .col12,
              child: Container(color: Colors.red, height: 100),
            ),
          ),
        ),
      );

      expect(find.byType(LayoutBuilder), findsOneWidget);
    });

    testWidgets('ResponsiveCol preserves child widget type', (WidgetTester tester) async {
      const testKey = Key('test-container');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveCol(
              xs: .col6,
              child: Container(key: testKey, color: Colors.red, height: 100),
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('ResponsiveCol with different size values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveCol(
              xs: .col1,
              sm: .col2,
              md: .col4,
              lg: .col6,
              xl: .col8,
              child: Container(height: 50, key: const Key('sized-col')),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('sized-col')), findsOneWidget);
    });
  });

  group('Sizes enum', () {
    test('Sizes.col1 returns gridSize 1', () {
      expect(Sizes.col1.gridSize, 1);
    });

    test('Sizes.col6 returns gridSize 6', () {
      expect(Sizes.col6.gridSize, 6);
    });

    test('Sizes.col12 returns gridSize 12', () {
      expect(Sizes.col12.gridSize, 12);
    });

    test('boxWidth calculates correct width for col6 at 1200px', () {
      final width = Sizes.col6.boxWidth(1200);
      expect(width, 600); // (1200 / 12) * 6 = 600
    });

    test('boxWidth calculates correct width for col12 at 1200px', () {
      final width = Sizes.col12.boxWidth(1200);
      expect(width, 1200); // (1200 / 12) * 12 = 1200
    });

    test('boxWidth calculates correct width for col3 at 600px', () {
      final width = Sizes.col3.boxWidth(600);
      expect(width, 150); // (600 / 12) * 3 = 150
    });

    test('boxWidth calculates correct width for col1 at 1200px', () {
      final width = Sizes.col1.boxWidth(1200);
      expect(width, 100); // (1200 / 12) * 1 = 100
    });

    test('boxWidth with col2 at 1200px equals 200', () {
      final width = Sizes.col2.boxWidth(1200);
      expect(width, 200);
    });

    test('boxWidth with col4 at 800px equals 266.67', () {
      final width = Sizes.col4.boxWidth(800);
      expect(width, closeTo(266.67, 0.01));
    });

    test('All sizes have valid gridSize', () {
      expect(Sizes.col1.gridSize, greaterThan(0));
      expect(Sizes.col12.gridSize, lessThanOrEqualTo(12));
    });
  });

  group('ResponsiveRow and ResponsiveCol integration', () {
    testWidgets('ResponsiveRow with multiple ResponsiveCol children renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [
                ResponsiveCol(xs: .col6, md: .col4, child: Container(key: const Key('col1'), height: 100)),
                ResponsiveCol(xs: .col6, md: .col4, child: Container(key: const Key('col2'), height: 100)),
                ResponsiveCol(xs: .col12, md: .col4, child: Container(key: const Key('col3'), height: 100)),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('col1')), findsOneWidget);
      expect(find.byKey(const Key('col2')), findsOneWidget);
      expect(find.byKey(const Key('col3')), findsOneWidget);
    });

    testWidgets('ResponsiveRow with many children', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow.builder(
              itemCount: 12,
              itemBuilder: (index) => ResponsiveCol(
                xs: .col12,
                md: .col6,
                lg: .col4,
                child: Container(height: 50),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveCol), findsNWidgets(12));
    });

    testWidgets('ResponsiveRow.builder with all parameters',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow.builder(
              itemCount: 4,
              spacing: 10,
              mainAxisAlignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.center,
              itemBuilder: (index) => ResponsiveCol(
                xs: .col6,
                lg: .col3,
                child: Container(height: 100),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveCol), findsNWidgets(4));

      final wrap = find.byType(Wrap).evaluate().first.widget as Wrap;
      expect(wrap.spacing, 10);
      expect(wrap.alignment, WrapAlignment.spaceEvenly);
      expect(wrap.crossAxisAlignment, WrapCrossAlignment.center);
    });

    testWidgets('ResponsiveCol with ResponsiveRow preserves layout structure',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [
                ResponsiveCol(
                  xs: .col12,
                  md: .col6,
                  child: Container(
                    key: const Key('responsive-item'),
                    height: 100,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('responsive-item')), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget);
    });
  });
}
