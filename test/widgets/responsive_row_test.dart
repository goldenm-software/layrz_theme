import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('ResponsiveRow', () {
    testWidgets('Renders basic ResponsiveRow with children', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
      addTearDown(tester.view.resetPhysicalSize);

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

      expect(find.byType(LayoutBuilder), findsWidgets);
      expect(find.byType(ResponsiveCol), findsNWidgets(2));
      expect(find.byType(Container), findsNWidgets(2));
    });

    testWidgets('ResponsiveRow with empty children renders no Row widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [],
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveCol), findsNothing);
      expect(find.byType(Row), findsNothing);
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

    testWidgets('ResponsiveRow respects spacing parameter (geometric)', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              spacing: 16,
              children: [
                ResponsiveCol(xs: .col6, child: Container(color: Colors.red, height: 100, key: const Key('a'))),
                ResponsiveCol(xs: .col6, child: Container(color: Colors.blue, height: 100, key: const Key('b'))),
              ],
            ),
          ),
        ),
      );

      final aRight = tester.getTopRight(find.byKey(const Key('a')));
      final bLeft = tester.getTopLeft(find.byKey(const Key('b')));
      // Gap between right edge of 'a' and left edge of 'b' should equal spacing (16)
      expect(bLeft.dx - aRight.dx, closeTo(16, 1));
    });

    testWidgets('ResponsiveRow respects spacing = 0 (geometric)', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              spacing: 0,
              children: [
                ResponsiveCol(xs: .col6, child: Container(color: Colors.red, height: 100, key: const Key('a'))),
                ResponsiveCol(xs: .col6, child: Container(color: Colors.blue, height: 100, key: const Key('b'))),
              ],
            ),
          ),
        ),
      );

      final aRight = tester.getTopRight(find.byKey(const Key('a')));
      final bLeft = tester.getTopLeft(find.byKey(const Key('b')));
      // With spacing=0 children are adjacent
      expect(bLeft.dx - aRight.dx, closeTo(0, 1));
    });

    testWidgets('ResponsiveRow default spacing is 0 (geometric)', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [
                ResponsiveCol(xs: .col6, child: Container(height: 100, key: const Key('a'))),
                ResponsiveCol(xs: .col6, child: Container(height: 100, key: const Key('b'))),
              ],
            ),
          ),
        ),
      );

      final aRight = tester.getTopRight(find.byKey(const Key('a')));
      final bLeft = tester.getTopLeft(find.byKey(const Key('b')));
      expect(bLeft.dx - aRight.dx, closeTo(0, 1));
    });

    testWidgets('ResponsiveRow spacing applies as vertical gap between wrapped rows', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              spacing: 20,
              children: [
                ResponsiveCol(xs: .col6, child: Container(height: 100, key: const Key('a'))),
                ResponsiveCol(xs: .col6, child: Container(height: 100, key: const Key('b'))),
                ResponsiveCol(xs: .col6, child: Container(height: 100, key: const Key('c'))),
                ResponsiveCol(xs: .col6, child: Container(height: 100, key: const Key('d'))),
              ],
            ),
          ),
        ),
      );

      final aBottom = tester.getBottomLeft(find.byKey(const Key('a')));
      final cTop = tester.getTopLeft(find.byKey(const Key('c')));
      // Vertical gap between row 1 bottom and row 2 top should equal spacing
      expect(cTop.dy - aBottom.dy, closeTo(20, 1));
    });

    testWidgets('ResponsiveRow default spacing gives no vertical gap between rows', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [
                ResponsiveCol(xs: .col6, child: Container(height: 100, key: const Key('a'))),
                ResponsiveCol(xs: .col6, child: Container(height: 100, key: const Key('b'))),
                ResponsiveCol(xs: .col6, child: Container(height: 100, key: const Key('c'))),
                ResponsiveCol(xs: .col6, child: Container(height: 100, key: const Key('d'))),
              ],
            ),
          ),
        ),
      );

      final aBottom = tester.getBottomLeft(find.byKey(const Key('a')));
      final cTop = tester.getTopLeft(find.byKey(const Key('c')));
      expect(cTop.dy - aBottom.dy, closeTo(0, 1));
    });

    testWidgets('ResponsiveRow respects mainAxisAlignment (inner Row)', (WidgetTester tester) async {
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

      final row = tester.widget<Row>(find.byType(Row).first);
      expect(row.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('ResponsiveRow respects crossAxisAlignment (inner Row)', (WidgetTester tester) async {
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

      final row = tester.widget<Row>(find.byType(Row).first);
      expect(row.crossAxisAlignment, CrossAxisAlignment.center);
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

    testWidgets('ResponsiveRow.builder respects mainAxisAlignment (inner Row)', (WidgetTester tester) async {
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

      final row = tester.widget<Row>(find.byType(Row).first);
      expect(row.mainAxisAlignment, MainAxisAlignment.spaceEvenly);
    });

    testWidgets('ResponsiveRow.builder respects spacing (geometric)', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow.builder(
              itemCount: 2,
              spacing: 20,
              itemBuilder: (index) => ResponsiveCol(
                xs: .col4,
                child: Container(key: Key('item-$index'), height: 50),
              ),
            ),
          ),
        ),
      );

      final aRight = tester.getTopRight(find.byKey(const Key('item-0')));
      final bLeft = tester.getTopLeft(find.byKey(const Key('item-1')));
      expect(bLeft.dx - aRight.dx, closeTo(20, 1));
    });

    testWidgets('ResponsiveRow uses LayoutBuilder + Column as layout widgets', (WidgetTester tester) async {
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

      expect(find.byType(LayoutBuilder), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Wrap), findsNothing);
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

    testWidgets('ResponsiveCol is a transparent pass-through (no own LayoutBuilder)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              children: [
                ResponsiveCol(
                  xs: .col12,
                  child: Container(color: Colors.red, height: 100, key: const Key('pass-through')),
                ),
              ],
            ),
          ),
        ),
      );

      // Child is discoverable
      expect(find.byKey(const Key('pass-through')), findsOneWidget);
      // Only the ResponsiveRow creates exactly one LayoutBuilder, not per-col
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

    testWidgets('ResponsiveRow.builder with all parameters', (WidgetTester tester) async {
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

      final row = tester.widget<Row>(find.byType(Row).first);
      expect(row.mainAxisAlignment, MainAxisAlignment.spaceEvenly);
      expect(row.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('ResponsiveCol with ResponsiveRow preserves layout structure', (WidgetTester tester) async {
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
      expect(find.byType(LayoutBuilder), findsOneWidget);
    });
  });

  // New TDD tests — written RED before implementation (FR-001, FR-002, FR-003, FR-008)
  group('ResponsiveRow horizontal layout', () {
    testWidgets('two col6 with spacing=12 at md (W=1000) stay on one row', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              spacing: 12,
              children: [
                ResponsiveCol(md: .col6, child: Container(key: const Key('a'), height: 50)),
                ResponsiveCol(md: .col6, child: Container(key: const Key('b'), height: 50)),
              ],
            ),
          ),
        ),
      );

      final aRect = tester.getRect(find.byKey(const Key('a')));
      final bRect = tester.getRect(find.byKey(const Key('b')));

      // Both children on the same vertical row
      expect(aRect.top, closeTo(bRect.top, 1));

      // available = 1000 - 12*(2-1) = 988; each = 988 * 6 / 12 = 494
      expect(aRect.width, closeTo(494, 1));
      expect(bRect.width, closeTo(494, 1));

      // Second child starts after first + spacing
      expect(bRect.left, closeTo(aRect.right + 12, 1));
    });

    testWidgets('three col4 with spacing=12 at md (W=1000) stay on one row', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              spacing: 12,
              children: [
                ResponsiveCol(md: .col4, child: Container(key: const Key('a'), height: 50)),
                ResponsiveCol(md: .col4, child: Container(key: const Key('b'), height: 50)),
                ResponsiveCol(md: .col4, child: Container(key: const Key('c'), height: 50)),
              ],
            ),
          ),
        ),
      );

      final aRect = tester.getRect(find.byKey(const Key('a')));
      final bRect = tester.getRect(find.byKey(const Key('b')));
      final cRect = tester.getRect(find.byKey(const Key('c')));

      // All three on the same row
      expect(aRect.top, closeTo(bRect.top, 1));
      expect(aRect.top, closeTo(cRect.top, 1));

      // available = 1000 - 12*(3-1) = 976; each = 976 * 4 / 12 ≈ 325.33
      expect(aRect.width, closeTo(325.33, 1));
      expect(bRect.width, closeTo(325.33, 1));
      expect(cRect.width, closeTo(325.33, 1));
    });

    testWidgets('mixed [col6, col6, col4, col4, col4] groups into two rows', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              spacing: 12,
              children: [
                ResponsiveCol(md: .col6, child: Container(key: const Key('a'), height: 50)),
                ResponsiveCol(md: .col6, child: Container(key: const Key('b'), height: 50)),
                ResponsiveCol(md: .col4, child: Container(key: const Key('c'), height: 50)),
                ResponsiveCol(md: .col4, child: Container(key: const Key('d'), height: 50)),
                ResponsiveCol(md: .col4, child: Container(key: const Key('e'), height: 50)),
              ],
            ),
          ),
        ),
      );

      final aRect = tester.getRect(find.byKey(const Key('a')));
      final bRect = tester.getRect(find.byKey(const Key('b')));
      final cRect = tester.getRect(find.byKey(const Key('c')));
      final dRect = tester.getRect(find.byKey(const Key('d')));
      final eRect = tester.getRect(find.byKey(const Key('e')));

      // Row 1: a and b share same top
      expect(aRect.top, closeTo(bRect.top, 1));

      // Row 2: c, d, e share same top (which is greater than row 1 top)
      expect(cRect.top, closeTo(dRect.top, 1));
      expect(cRect.top, closeTo(eRect.top, 1));
      expect(cRect.top, greaterThan(aRect.bottom));

      // Vertical gap between row 1 bottom and row 2 top equals spacing (12)
      expect(cRect.top - aRect.bottom, closeTo(12, 1));
    });

    testWidgets('spacing=0 produces width = W * g / 12', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              spacing: 0,
              children: [
                ResponsiveCol(md: .col6, child: Container(key: const Key('a'), height: 50)),
                ResponsiveCol(md: .col6, child: Container(key: const Key('b'), height: 50)),
              ],
            ),
          ),
        ),
      );

      final aRect = tester.getRect(find.byKey(const Key('a')));
      final bRect = tester.getRect(find.byKey(const Key('b')));

      // available = 1000 - 0 = 1000; each = 1000 * 6 / 12 = 500
      expect(aRect.width, closeTo(500, 1));
      expect(bRect.width, closeTo(500, 1));
      // Children are adjacent
      expect(bRect.left, closeTo(aRect.right, 1));
    });

    testWidgets('breakpoint transition from xs to md regroups children', (WidgetTester tester) async {
      // At xs (W < 600): col6 xs default → gridSize 12, so two rows of 1
      await tester.binding.setSurfaceSize(const Size(500, 800));
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              spacing: 0,
              children: [
                ResponsiveCol(md: .col6, child: Container(key: const Key('a'), height: 50)),
                ResponsiveCol(md: .col6, child: Container(key: const Key('b'), height: 50)),
              ],
            ),
          ),
        ),
      );

      final aRectXs = tester.getRect(find.byKey(const Key('a')));
      final bRectXs = tester.getRect(find.byKey(const Key('b')));
      // At xs both cols fill full width → different rows (different top values)
      expect(bRectXs.top, greaterThan(aRectXs.top));

      // Now transition to md (W=1000)
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      await tester.pump();

      final aRectMd = tester.getRect(find.byKey(const Key('a')));
      final bRectMd = tester.getRect(find.byKey(const Key('b')));
      // At md both cols are col6 → same row
      expect(aRectMd.top, closeTo(bRectMd.top, 1));
    });

    testWidgets('vertical gap between row groups equals spacing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveRow(
              spacing: 16,
              children: [
                ResponsiveCol(md: .col6, child: Container(key: const Key('a'), height: 50)),
                ResponsiveCol(md: .col6, child: Container(key: const Key('b'), height: 50)),
                ResponsiveCol(md: .col6, child: Container(key: const Key('c'), height: 50)),
                ResponsiveCol(md: .col6, child: Container(key: const Key('d'), height: 50)),
              ],
            ),
          ),
        ),
      );

      final aRect = tester.getRect(find.byKey(const Key('a')));
      final cRect = tester.getRect(find.byKey(const Key('c')));

      // Row 1: a, b at top; Row 2: c, d below with gap=16
      expect(cRect.top - aRect.bottom, closeTo(16, 1));
    });
  });
}
