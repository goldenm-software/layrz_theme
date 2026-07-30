import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('ThemedTabView widget', () {
    // Helper function to find text in RichText
    Finder findRichText(String text) {
      return find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          return widget.text.toPlainText().contains(text);
        }
        return false;
      });
    }

    testWidgets('renders with multiple tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ThemedTabView), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
      expect(findRichText('Tab 1'), findsWidgets);
      expect(findRichText('Tab 2'), findsWidgets);
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('displays initial tab content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                initialPosition: 0,
                tabs: [
                  ThemedTab(
                    labelText: 'First',
                    child: const Text('First Content'),
                  ),
                  ThemedTab(
                    labelText: 'Second',
                    child: const Text('Second Content'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('First Content'), findsOneWidget);
      expect(find.text('Second Content'), findsNothing);
    });

    testWidgets('switches tabs on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                tabs: [
                  ThemedTab(
                    labelText: 'Tab A',
                    child: const Text('Content A'),
                  ),
                  ThemedTab(
                    labelText: 'Tab B',
                    child: const Text('Content B'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Content A'), findsOneWidget);
      expect(find.text('Content B'), findsNothing);

      // Tap on Tab B - find by RichText
      await tester.tap(findRichText('Tab B'));
      await tester.pumpAndSettle();

      expect(find.text('Content A'), findsNothing);
      expect(find.text('Content B'), findsOneWidget);
    });

    testWidgets('calls onTabIndex callback when tab changes', (WidgetTester tester) async {
      int? lastIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 3',
                    child: const Text('Content 3'),
                  ),
                ],
                onTabIndex: (index) {
                  lastIndex = index;
                },
              ),
            ),
          ),
        ),
      );

      // Initial tab doesn't trigger callback because it's not a change
      expect(lastIndex, isNull);

      // Switch to second tab
      await tester.tap(findRichText('Tab 2'));
      await tester.pumpAndSettle();
      expect(lastIndex, equals(1));

      // Switch to third tab
      await tester.tap(findRichText('Tab 3'));
      await tester.pumpAndSettle();
      expect(lastIndex, equals(2));

      // Switch back to first tab
      await tester.tap(findRichText('Tab 1'));
      await tester.pumpAndSettle();
      expect(lastIndex, equals(0));
    });

    testWidgets('renders arrow buttons when showArrows is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                showArrows: true,
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Should have two arrow buttons
      expect(find.byType(ThemedButton), findsWidgets);
    });

    testWidgets('arrow buttons exist and are functional', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                showArrows: true,
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Content 1'), findsOneWidget);
      expect(find.byType(ThemedButton), findsWidgets);
    });

    testWidgets('left arrow is disabled on first tab', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                showArrows: true,
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Left arrow should be disabled on first tab
      final buttons = find.byType(ThemedButton);
      final leftButton = tester.widget<ThemedButton>(buttons.at(0));
      expect(leftButton.isDisabled, isTrue);
    });

    testWidgets('right arrow is disabled on last tab', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                showArrows: true,
                initialPosition: 1,
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Right arrow should be disabled on last tab
      final buttons = find.byType(ThemedButton);
      final rightButton = tester.widget<ThemedButton>(buttons.at(1));
      expect(rightButton.isDisabled, isTrue);
    });

    testWidgets('handles initialPosition correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                initialPosition: 1,
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 3',
                    child: const Text('Content 3'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Content 2'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Content 3'), findsNothing);
    });

    testWidgets('clamps invalid initialPosition to valid range', (WidgetTester tester) async {
      // Test with initialPosition larger than tabs length
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                initialPosition: 10, // Out of bounds
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Should show last tab content instead of crashing
      expect(find.text('Content 2'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
    });

    testWidgets('persists tab position on widget rebuild', (WidgetTester tester) async {
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text('Rebuild'),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 800,
                        child: ThemedTabView(
                          persistTabPosition: true,
                          tabs: [
                            ThemedTab(
                              labelText: 'Tab 1',
                              child: const Text('Content 1'),
                            ),
                            ThemedTab(
                              labelText: 'Tab 2',
                              child: const Text('Content 2'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      // Switch to second tab
      await tester.tap(findRichText('Tab 2'));
      await tester.pumpAndSettle();
      expect(find.text('Content 2'), findsOneWidget);

      // Trigger rebuild
      await tester.tap(find.text('Rebuild'));
      await tester.pumpAndSettle();

      // Tab position should be preserved
      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets('resets tab position when tabs list changes and persistTabPosition is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // This will change the tabs length, triggering didUpdateWidget
                        setState(() {});
                      },
                      child: const Text('ToggleTabs'),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 800,
                        child: Builder(
                          builder: (context) {
                            // Generate a different tab list on each rebuild
                            final tabsList = [
                              ThemedTab(
                                labelText: 'Tab 1',
                                child: const Text('Content 1'),
                              ),
                              ThemedTab(
                                labelText: 'Tab 2',
                                child: const Text('Content 2'),
                              ),
                              ThemedTab(
                                labelText: 'Tab 3',
                                child: const Text('Content 3'),
                              ),
                            ];

                            return ThemedTabView(
                              persistTabPosition: false,
                              tabs: tabsList,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      // Switch to third tab
      await tester.tap(findRichText('Tab 3'));
      await tester.pumpAndSettle();
      expect(find.text('Content 3'), findsOneWidget);

      // Now change tabs (by adding one more)
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text('ToggleTabs'),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 800,
                        child: Builder(
                          builder: (context) {
                            final tabsList = [
                              ThemedTab(
                                labelText: 'Tab A',
                                child: const Text('Content A'),
                              ),
                              ThemedTab(
                                labelText: 'Tab B',
                                child: const Text('Content B'),
                              ),
                              ThemedTab(
                                labelText: 'Tab C',
                                child: const Text('Content C'),
                              ),
                              ThemedTab(
                                labelText: 'Tab D',
                                child: const Text('Content D'),
                              ),
                            ];

                            return ThemedTabView(
                              persistTabPosition: false,
                              tabs: tabsList,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      await tester.pumpAndSettle();
      // Tab position should be reset to first tab since persistTabPosition: false
      expect(find.text('Content A'), findsOneWidget);
    });

    testWidgets('renders additionalWidgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                additionalWidgets: [
                  const Chip(label: Text('Filter 1')),
                  const Chip(label: Text('Filter 2')),
                ],
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Filter 1'), findsOneWidget);
      expect(find.text('Filter 2'), findsOneWidget);
      expect(find.byType(Chip), findsWidgets);
    });

    testWidgets('renders with different tab styles', (WidgetTester tester) async {
      for (final style in ThemedTabStyle.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 800,
                height: 600,
                child: ThemedTabView(
                  style: style,
                  tabs: [
                    ThemedTab(
                      labelText: 'Tab 1',
                      child: const Text('Content 1'),
                    ),
                    ThemedTab(
                      labelText: 'Tab 2',
                      child: const Text('Content 2'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ThemedTabView), findsOneWidget);
        expect(findRichText('Tab 1'), findsWidgets);
        expect(findRichText('Tab 2'), findsWidgets);
      }
    });

    testWidgets('ThemedTab renders with leading icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                tabs: [
                  ThemedTab(
                    labelText: 'Home',
                    leadingIcon: Icons.home,
                    child: const Text('Home Content'),
                  ),
                  ThemedTab(
                    labelText: 'Settings',
                    leadingIcon: Icons.settings,
                    child: const Text('Settings Content'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(findRichText('Home'), findsWidgets);
    });

    testWidgets('ThemedTab renders with trailing icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                tabs: [
                  ThemedTab(
                    labelText: 'Notifications',
                    trailingIcon: Icons.notifications,
                    child: const Text('Notifications Content'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.notifications), findsOneWidget);
      expect(findRichText('Notifications'), findsWidgets);
    });

    testWidgets('renders with custom padding and alignment', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                padding: const EdgeInsets.all(20),
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ThemedTabView), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('arrow button state updates when navigating between tabs (bug regression)', (WidgetTester tester) async {
      // This test verifies the fix: setState() must be called on tab index changes
      // even without onTabIndex callback, so arrow disabled state updates correctly
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                showArrows: true,
                initialPosition: 0,
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 3',
                    child: const Text('Content 3'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      var buttons = find.byType(ThemedButton);
      var leftButton = tester.widget<ThemedButton>(buttons.at(0));
      var rightButton = tester.widget<ThemedButton>(buttons.at(1));

      // Initially on first tab: left disabled, right enabled
      expect(leftButton.isDisabled, isTrue, reason: 'Left arrow should be disabled on first tab');
      expect(rightButton.isDisabled, isFalse, reason: 'Right arrow should be enabled on first tab');

      // Navigate to second tab via right arrow tap
      await tester.tap(find.byType(ThemedButton).at(1));
      await tester.pumpAndSettle();

      // Re-fetch buttons after navigation
      buttons = find.byType(ThemedButton);
      leftButton = tester.widget<ThemedButton>(buttons.at(0));
      rightButton = tester.widget<ThemedButton>(buttons.at(1));

      // After navigation to middle tab: neither should be disabled
      expect(leftButton.isDisabled, isFalse, reason: 'Left arrow should be enabled on middle tab');
      expect(rightButton.isDisabled, isFalse, reason: 'Right arrow should be enabled on middle tab');

      // Navigate to last tab
      await tester.tap(find.byType(ThemedButton).at(1));
      await tester.pumpAndSettle();

      // Re-fetch buttons after navigation
      buttons = find.byType(ThemedButton);
      leftButton = tester.widget<ThemedButton>(buttons.at(0));
      rightButton = tester.widget<ThemedButton>(buttons.at(1));

      // On last tab: left enabled, right disabled
      expect(leftButton.isDisabled, isFalse, reason: 'Left arrow should be enabled on last tab');
      expect(rightButton.isDisabled, isTrue, reason: 'Right arrow should be disabled on last tab');

      // Navigate back to middle tab
      await tester.tap(find.byType(ThemedButton).at(0));
      await tester.pumpAndSettle();

      // Re-fetch buttons after navigation
      buttons = find.byType(ThemedButton);
      leftButton = tester.widget<ThemedButton>(buttons.at(0));
      rightButton = tester.widget<ThemedButton>(buttons.at(1));

      expect(leftButton.isDisabled, isFalse, reason: 'Left arrow should be enabled on middle tab');
      expect(rightButton.isDisabled, isFalse, reason: 'Right arrow should be enabled on middle tab');
    });

    testWidgets('wrapArrowNavigation wraps from last tab to first tab', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                showArrows: true,
                wrapArrowNavigation: true,
                initialPosition: 2, // Last tab
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 3',
                    child: const Text('Content 3'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Content 3'), findsOneWidget);

      // Right arrow on last tab should wrap to first tab
      final buttons = find.byType(ThemedButton);
      await tester.tap(buttons.at(1)); // Right arrow
      await tester.pumpAndSettle();

      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Content 3'), findsNothing);
    });

    testWidgets('wrapArrowNavigation wraps from first tab to last tab', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                showArrows: true,
                wrapArrowNavigation: true,
                initialPosition: 0, // First tab
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 3',
                    child: const Text('Content 3'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Content 1'), findsOneWidget);

      // Left arrow on first tab should wrap to last tab
      final buttons = find.byType(ThemedButton);
      await tester.tap(buttons.at(0)); // Left arrow
      await tester.pumpAndSettle();

      expect(find.text('Content 3'), findsOneWidget);
      expect(find.text('Content 1'), findsNothing);
    });

    testWidgets('wrapArrowNavigation keeps arrows enabled at boundaries', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: ThemedTabView(
                showArrows: true,
                wrapArrowNavigation: true,
                initialPosition: 0, // First tab
                tabs: [
                  ThemedTab(
                    labelText: 'Tab 1',
                    child: const Text('Content 1'),
                  ),
                  ThemedTab(
                    labelText: 'Tab 2',
                    child: const Text('Content 2'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      var buttons = find.byType(ThemedButton);
      var leftButton = tester.widget<ThemedButton>(buttons.at(0));
      var rightButton = tester.widget<ThemedButton>(buttons.at(1));

      // With wrap enabled, both arrows should be enabled even at boundaries
      expect(leftButton.isDisabled, isFalse);
      expect(rightButton.isDisabled, isFalse);

      // Navigate to last tab
      await tester.tap(buttons.at(1));
      await tester.pumpAndSettle();

      // Both arrows should still be enabled at last tab
      buttons = find.byType(ThemedButton);
      leftButton = tester.widget<ThemedButton>(buttons.at(0));
      rightButton = tester.widget<ThemedButton>(buttons.at(1));
      expect(leftButton.isDisabled, isFalse);
      expect(rightButton.isDisabled, isFalse);
    });

    testWidgets('isScrollable false makes tabs share the available width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 600,
              height: 400,
              child: ThemedTabView(
                isScrollable: false,
                padding: EdgeInsets.zero,
                tabs: [
                  ThemedTab(labelText: 'A', child: const Text('Content A')),
                  ThemedTab(labelText: 'B', child: const Text('Content B')),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.isScrollable, isFalse);

      // Both tabs must end up the same width, and each must be wider than its bare label.
      final containers = find.descendant(
        of: find.byType(TabBar),
        matching: find.byType(AnimatedContainer),
      );
      final firstWidth = tester.getSize(containers.at(0)).width;
      final secondWidth = tester.getSize(containers.at(1)).width;
      expect(firstWidth, equals(secondWidth));
      expect(firstWidth, greaterThan(100));
    });

    testWidgets('isScrollable false leaves room for additionalWidgets', (tester) async {
      const double barWidth = 600;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: barWidth,
              height: 400,
              child: ThemedTabView(
                isScrollable: false,
                padding: EdgeInsets.zero,
                additionalWidgets: const [SizedBox(width: 120, height: 40)],
                tabs: [
                  ThemedTab(labelText: 'A', child: const Text('Content A')),
                  ThemedTab(labelText: 'B', child: const Text('Content B')),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The extra widget keeps its intrinsic size; only the TabBar gives up space.
      expect(tester.getSize(find.byType(TabBar)).width, lessThanOrEqualTo(barWidth - 120));

      final containers = find.descendant(
        of: find.byType(TabBar),
        matching: find.byType(AnimatedContainer),
      );
      final firstWidth = tester.getSize(containers.at(0)).width;
      final secondWidth = tester.getSize(containers.at(1)).width;

      // Tabs still split evenly, now over the reduced width.
      expect(firstWidth, equals(secondWidth));
      expect(firstWidth + secondWidth, lessThanOrEqualTo(barWidth - 120));
    });

    testWidgets('isScrollable false expands the tab background to the full cell', (tester) async {
      // Regression: the active background used to shrink to the label while the ink splash covered
      // the whole cell, so the highlight looked smaller than the splash.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 600,
              height: 400,
              child: ThemedTabView(
                isScrollable: false,
                padding: EdgeInsets.zero,
                tabs: [
                  ThemedTab(labelText: 'Summary', child: const Text('Content A')),
                  ThemedTab(labelText: 'B', child: const Text('Content B')),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final containers = find.descendant(
        of: find.byType(TabBar),
        matching: find.byType(AnimatedContainer),
      );
      final longLabelWidth = tester.getSize(containers.at(0)).width;
      final shortLabelWidth = tester.getSize(containers.at(1)).width;

      // Both containers fill their own cell, so 'Summary' and 'B' end up identical despite very
      // different label lengths. Before the fix each shrank to its label and the splash — which
      // always covers the full cell — painted a visibly larger area than the background.
      expect(longLabelWidth, equals(shortLabelWidth));

      // And together they span the whole bar, leaving no unpainted gap for the splash to reveal.
      final barWidth = tester.getSize(find.byType(TabBar)).width;
      expect(longLabelWidth + shortLabelWidth, moreOrLessEquals(barWidth, epsilon: 1));
    });

    testWidgets('isScrollable true keeps tabs at their intrinsic width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 600,
              height: 400,
              child: ThemedTabView(
                padding: EdgeInsets.zero,
                tabs: [
                  ThemedTab(labelText: 'A', child: const Text('Content A')),
                  ThemedTab(labelText: 'a much longer tab label', child: const Text('Content B')),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.isScrollable, isTrue);

      // Intrinsic sizing: the long label must be wider than the short one.
      final containers = find.descendant(
        of: find.byType(TabBar),
        matching: find.byType(AnimatedContainer),
      );
      final shortWidth = tester.getSize(containers.at(0)).width;
      final longWidth = tester.getSize(containers.at(1)).width;
      expect(longWidth, greaterThan(shortWidth));

      // A scrollable TabBar lays tabs out unbounded, so expanding here would assert with
      // `BoxConstraints forces an infinite width`. Reaching this point proves it does not expand.
      expect(tester.takeException(), isNull);
    });

    testWidgets('isScrollable true with additionalWidgets does not overflow', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 600,
              height: 400,
              child: ThemedTabView(
                padding: EdgeInsets.zero,
                additionalWidgets: const [SizedBox(width: 120, height: 40)],
                tabs: [
                  ThemedTab(labelText: 'A', child: const Text('Content A')),
                  ThemedTab(labelText: 'a much longer tab label', child: const Text('Content B')),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(tester.widget<TabBar>(find.byType(TabBar)).isScrollable, isTrue);
    });
  });
}
