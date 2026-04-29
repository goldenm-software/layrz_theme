import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

// Minimal domain object for tests.
// Value-based hashCode ensures item.hashCode is stable across isolate boundaries.
class _Item {
  final String id;
  final String name;
  final String secondary;

  const _Item({required this.id, required this.name, required this.secondary});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _Item && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Full value-equality item — simulates Freezed objects (all fields compared).
// Used in the DeepCollectionEquality regression test.
class _ItemFull {
  final String id;
  final String name;
  final String secondary;

  const _ItemFull({required this.id, required this.name, required this.secondary});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ItemFull && id == other.id && name == other.name && secondary == other.secondary;

  @override
  int get hashCode => Object.hash(id, name, secondary);
}

// Waits for a _filterAndSort cycle to complete.
//
// compute() spawns a REAL isolate even in widget tests. pumpAndSettle() cannot
// be used because:
//   1. CircularProgressIndicator animates while loading → frames never settle.
//   2. pump(duration) advances the FAKE scheduler clock, not real wall-clock time,
//      so the isolate may not finish within that fake window.
//
// Strategy:
//   1. pump(1ms) — advances the fake clock by 1ms, which fires Future.delayed(Duration.zero)
//      (populateDelay). pump(Duration.zero) does NOT fire zero-duration timers because
//      FakeAsync uses strict less-than comparison (elapsed > fireTime). Advancing by ≥1μs
//      makes the timer due and _filterAndSort continues, kicking off compute().
//   2. runAsync(500ms) — exits fake-async so the real isolate gets CPU time to finish.
//   3. Three pump() calls — flush _filteredData ValueNotifier, _isLoading = false,
//      addPostFrameCallback setState, and the final tree rebuild.
Future<void> _waitForCompute(WidgetTester tester) async {
  // Advance the fake clock by 1ms so Future.delayed(Duration.zero) fires.
  await tester.pump(const Duration(milliseconds: 1));
  await tester.runAsync(() async {
    // 500ms of REAL time is more than enough for a small-dataset isolate.
    await Future.delayed(const Duration(milliseconds: 500));
  });
  await tester.pump(); // flush _filteredData update + _isLoading = false
  await tester.pump(); // flush addPostFrameCallback → setState
  await tester.pump(); // final rebuild
}

// Builds a bounded, minimal table for testing.
Widget _buildTable(
  List<_Item> items, {
  List<ThemedColumn2<_Item>>? columns,
  bool canSearch = false,
  ThemedTable2Controller<_Item>? controller,
  void Function(int count)? onFilteredCountChanged,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        height: 600,
        width: 800,
        child: ThemedTable2<_Item>(
          items: items,
          actionsCount: 0,
          hasMultiselect: false,
          canSearch: canSearch,
          populateDelay: Duration.zero,
          controller: controller,
          onFilteredCountChanged: onFilteredCountChanged,
          columns: columns ??
              [
                ThemedColumn2<_Item>(
                  headerText: 'Name',
                  valueBuilder: (item) => item.name,
                ),
              ],
        ),
      ),
    ),
  );
}

void main() {
  group('ThemedTable2', () {
    // ─────────────────────────────────────────────
    // Rendering
    // ─────────────────────────────────────────────
    group('rendering', () {
      testWidgets('renders item values after compute completes', (tester) async {
        final items = [
          const _Item(id: '1', name: 'Alpha', secondary: 'X'),
          const _Item(id: '2', name: 'Beta', secondary: 'Y'),
          const _Item(id: '3', name: 'Gamma', secondary: 'Z'),
        ];

        await tester.pumpWidget(_buildTable(items));
        await tester.pump(); // trigger postFrameCallback → _filterAndSort
        await _waitForCompute(tester);

        expect(find.text('Alpha'), findsOneWidget);
        expect(find.text('Beta'), findsOneWidget);
        expect(find.text('Gamma'), findsOneWidget);
      });

      testWidgets('shows CircularProgressIndicator while loading', (tester) async {
        final items = [
          const _Item(id: '1', name: 'Item 1', secondary: ''),
          const _Item(id: '2', name: 'Item 2', secondary: ''),
        ];

        await tester.pumpWidget(_buildTable(items));

        // After first pump, postFrameCallback fires and _isLoading becomes true.
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // After compute completes, loading disappears.
        await _waitForCompute(tester);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Item 1'), findsOneWidget);
      });

      testWidgets('renders without errors when items is empty', (tester) async {
        await tester.pumpWidget(_buildTable([]));
        await tester.pump();
        await _waitForCompute(tester);

        expect(tester.takeException(), isNull);
        expect(find.byType(ThemedTable2<_Item>), findsOneWidget);
      });
    });

    // ─────────────────────────────────────────────
    // Column key collision regression
    // ─────────────────────────────────────────────
    group('column key collision regression', () {
      testWidgets(
        'two columns with identical headerText show distinct data',
        (tester) async {
          // Before the fix, the inner key of _itemsStrings was col.hashCode.
          // hashCode == headerText.hashCode, so two columns named 'Label'
          // would collide — the second overwrites the first and BOTH cells
          // display the same value.
          //
          // After the fix, column INDEX is used as the inner key, so each
          // column is independent regardless of shared headerText.
          final items = [
            const _Item(id: '1', name: 'Alice', secondary: 'Engineer'),
          ];

          await tester.pumpWidget(
            _buildTable(
              items,
              columns: [
                ThemedColumn2<_Item>(
                  headerText: 'Label',
                  valueBuilder: (item) => item.name,
                ),
                ThemedColumn2<_Item>(
                  headerText: 'Label',
                  valueBuilder: (item) => item.secondary,
                ),
              ],
            ),
          );
          await tester.pump();
          await _waitForCompute(tester);

          // Both distinct values must be visible.
          // If only one appears, column collision has returned.
          expect(find.text('Alice'), findsOneWidget);
          expect(find.text('Engineer'), findsOneWidget);
        },
      );
    });

    // ─────────────────────────────────────────────
    // Search
    // ─────────────────────────────────────────────
    group('search', () {
      testWidgets('filters items matching the query', (tester) async {
        final items = [
          const _Item(id: '1', name: 'Apple', secondary: 'Fruit'),
          const _Item(id: '2', name: 'Banana', secondary: 'Fruit'),
          const _Item(id: '3', name: 'Carrot', secondary: 'Veggie'),
        ];

        await tester.pumpWidget(_buildTable(items, canSearch: true));
        await tester.pump();
        await _waitForCompute(tester);

        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Carrot'), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'Apple');
        await tester.pump(const Duration(milliseconds: 650)); // past 600ms debounce
        await _waitForCompute(tester);

        // 'Apple' may appear in both the search input and the table row.
        // The key invariant is that non-matching items are gone.
        expect(find.text('Apple'), findsAtLeastNWidgets(1));
        expect(find.text('Banana'), findsNothing);
        expect(find.text('Carrot'), findsNothing);
      });

      testWidgets('search matches values from all columns', (tester) async {
        final items = [
          const _Item(id: '1', name: 'Alpha', secondary: 'Engineer'),
          const _Item(id: '2', name: 'Beta', secondary: 'Designer'),
        ];

        await tester.pumpWidget(
          _buildTable(
            items,
            canSearch: true,
            columns: [
              ThemedColumn2<_Item>(
                headerText: 'Name',
                valueBuilder: (item) => item.name,
              ),
              ThemedColumn2<_Item>(
                headerText: 'Role',
                valueBuilder: (item) => item.secondary,
              ),
            ],
          ),
        );
        await tester.pump();
        await _waitForCompute(tester);

        // Search by secondary column value — 'Designer' only belongs to Beta.
        await tester.enterText(find.byType(TextField), 'Designer');
        await tester.pump(const Duration(milliseconds: 650));
        await _waitForCompute(tester);

        expect(find.text('Beta'), findsOneWidget);
        expect(find.text('Alpha'), findsNothing);
      });

      testWidgets('shows all items when search is cleared', (tester) async {
        final items = [
          const _Item(id: '1', name: 'Apple', secondary: ''),
          const _Item(id: '2', name: 'Banana', secondary: ''),
        ];

        await tester.pumpWidget(_buildTable(items, canSearch: true));
        await tester.pump();
        await _waitForCompute(tester);

        await tester.enterText(find.byType(TextField), 'Apple');
        await tester.pump(const Duration(milliseconds: 650));
        await _waitForCompute(tester);
        expect(find.text('Banana'), findsNothing);

        await tester.enterText(find.byType(TextField), '');
        await tester.pump(const Duration(milliseconds: 650));
        await _waitForCompute(tester);

        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
      });
    });

    // ─────────────────────────────────────────────
    // Sort (via controller — avoids RichText header finders)
    // ─────────────────────────────────────────────
    group('sort', () {
      testWidgets('controller.sort ascending orders items A→Z', (tester) async {
        final controller = ThemedTable2Controller<_Item>();
        addTearDown(controller.dispose);

        final items = [
          const _Item(id: '1', name: 'Zebra', secondary: ''),
          const _Item(id: '2', name: 'Apple', secondary: ''),
          const _Item(id: '3', name: 'Mango', secondary: ''),
        ];

        await tester.pumpWidget(_buildTable(items, controller: controller));
        await tester.pump();
        await _waitForCompute(tester);

        controller.sort(columnIndex: 0, ascending: true);
        await _waitForCompute(tester);

        final appleY = tester.getTopLeft(find.text('Apple')).dy;
        final mangoY = tester.getTopLeft(find.text('Mango')).dy;
        final zebraY = tester.getTopLeft(find.text('Zebra')).dy;

        expect(appleY, lessThan(mangoY), reason: 'Apple must appear before Mango');
        expect(mangoY, lessThan(zebraY), reason: 'Mango must appear before Zebra');
      });

      testWidgets('controller.sort descending orders items Z→A', (tester) async {
        final controller = ThemedTable2Controller<_Item>();
        addTearDown(controller.dispose);

        final items = [
          const _Item(id: '1', name: 'Apple', secondary: ''),
          const _Item(id: '2', name: 'Mango', secondary: ''),
          const _Item(id: '3', name: 'Zebra', secondary: ''),
        ];

        await tester.pumpWidget(_buildTable(items, controller: controller));
        await tester.pump();
        await _waitForCompute(tester);

        controller.sort(columnIndex: 0, ascending: false);
        await _waitForCompute(tester);

        final appleY = tester.getTopLeft(find.text('Apple')).dy;
        final zebraY = tester.getTopLeft(find.text('Zebra')).dy;

        expect(zebraY, lessThan(appleY), reason: 'Zebra must appear before Apple in descending');
      });

      testWidgets('numeric values sort as numbers not as strings', (tester) async {
        final controller = ThemedTable2Controller<_Item>();
        addTearDown(controller.dispose);

        // '10' > '9' numerically, but '10' < '9' lexicographically.
        final items = [
          const _Item(id: '1', name: '9', secondary: ''),
          const _Item(id: '2', name: '10', secondary: ''),
          const _Item(id: '3', name: '2', secondary: ''),
        ];

        await tester.pumpWidget(_buildTable(items, controller: controller));
        await tester.pump();
        await _waitForCompute(tester);

        controller.sort(columnIndex: 0, ascending: true);
        await _waitForCompute(tester);

        final y2 = tester.getTopLeft(find.text('2')).dy;
        final y9 = tester.getTopLeft(find.text('9')).dy;
        final y10 = tester.getTopLeft(find.text('10')).dy;

        // Numeric order: 2 < 9 < 10
        expect(y2, lessThan(y9), reason: '2 must appear before 9');
        expect(y9, lessThan(y10), reason: '9 must appear before 10');
      });

      testWidgets('controller.refresh re-runs sort without changing order', (tester) async {
        final controller = ThemedTable2Controller<_Item>();
        addTearDown(controller.dispose);

        final items = [
          const _Item(id: '1', name: 'Zebra', secondary: ''),
          const _Item(id: '2', name: 'Apple', secondary: ''),
        ];

        await tester.pumpWidget(_buildTable(items, controller: controller));
        await tester.pump();
        await _waitForCompute(tester);

        controller.sort(columnIndex: 0, ascending: true);
        await _waitForCompute(tester);

        controller.refresh();
        await _waitForCompute(tester);

        final appleY = tester.getTopLeft(find.text('Apple')).dy;
        final zebraY = tester.getTopLeft(find.text('Zebra')).dy;
        expect(appleY, lessThan(zebraY), reason: 'Sort order must be preserved after refresh');
      });
    });

    // ─────────────────────────────────────────────
    // didUpdateWidget
    // ─────────────────────────────────────────────
    group('didUpdateWidget', () {
      testWidgets('reflects new items when widget rebuilds with a different list', (tester) async {
        List<_Item> items = [const _Item(id: '1', name: 'Original', secondary: '')];
        late StateSetter rebuildState;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              rebuildState = setState;
              return MaterialApp(
                home: Scaffold(
                  body: SizedBox(
                    height: 600,
                    width: 800,
                    child: ThemedTable2<_Item>(
                      items: items,
                      actionsCount: 0,
                      hasMultiselect: false,
                      canSearch: false,
                      populateDelay: Duration.zero,
                      columns: [
                        ThemedColumn2<_Item>(
                          headerText: 'Name',
                          valueBuilder: (item) => item.name,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
        await tester.pump();
        await _waitForCompute(tester);

        expect(find.text('Original'), findsOneWidget);

        rebuildState(() {
          items = [const _Item(id: '2', name: 'Updated', secondary: '')];
        });
        await tester.pump();
        await _waitForCompute(tester);

        expect(find.text('Original'), findsNothing);
        expect(find.text('Updated'), findsOneWidget);
      });

      testWidgets('handles growing list without losing existing rows', (tester) async {
        List<_Item> items = [const _Item(id: '1', name: 'First', secondary: '')];
        late StateSetter rebuildState;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              rebuildState = setState;
              return MaterialApp(
                home: Scaffold(
                  body: SizedBox(
                    height: 600,
                    width: 800,
                    child: ThemedTable2<_Item>(
                      items: items,
                      actionsCount: 0,
                      hasMultiselect: false,
                      canSearch: false,
                      populateDelay: Duration.zero,
                      columns: [
                        ThemedColumn2<_Item>(
                          headerText: 'Name',
                          valueBuilder: (item) => item.name,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
        await tester.pump();
        await _waitForCompute(tester);

        rebuildState(() {
          items = [
            const _Item(id: '1', name: 'First', secondary: ''),
            const _Item(id: '2', name: 'Second', secondary: ''),
          ];
        });
        await tester.pump();
        await _waitForCompute(tester);

        expect(find.text('First'), findsOneWidget);
        expect(find.text('Second'), findsOneWidget);
      });

      testWidgets(
        'detects edit in middle of same-length list (DeepCollectionEquality regression)',
        (tester) async {
          // BUG DE PRODUCCIÓN: con la heurística O(1) anterior, si la lista tenía
          // el mismo largo y el mismo primer elemento pero un elemento del medio
          // cambiaba, c1=false y la tabla NUNCA se actualizaba.
          // _ItemFull tiene igualdad por valor completa (simula Freezed).
          // DeepCollectionEquality detecta el cambio de 'name' aunque el 'id' sea igual.
          List<_ItemFull> items = [
            const _ItemFull(id: '1', name: 'First', secondary: ''),
            const _ItemFull(id: '2', name: 'OriginalMiddle', secondary: ''),
            const _ItemFull(id: '3', name: 'Last', secondary: ''),
          ];
          late StateSetter rebuildState;

          await tester.pumpWidget(
            StatefulBuilder(
              builder: (context, setState) {
                rebuildState = setState;
                return MaterialApp(
                  home: Scaffold(
                    body: SizedBox(
                      height: 600,
                      width: 800,
                      child: ThemedTable2<_ItemFull>(
                        items: items,
                        actionsCount: 0,
                        hasMultiselect: false,
                        canSearch: false,
                        populateDelay: Duration.zero,
                        columns: [
                          ThemedColumn2<_ItemFull>(
                            headerText: 'Name',
                            valueBuilder: (item) => item.name,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
          await tester.pump();
          await _waitForCompute(tester);

          expect(find.text('OriginalMiddle'), findsOneWidget);

          // Mismo largo (3), mismo primer elemento ('First'), pero el del medio cambió.
          rebuildState(() {
            items = [
              const _ItemFull(id: '1', name: 'First', secondary: ''),
              const _ItemFull(id: '2', name: 'EditedMiddle', secondary: ''),
              const _ItemFull(id: '3', name: 'Last', secondary: ''),
            ];
          });
          await tester.pump();
          await _waitForCompute(tester);

          // Con la heurística rota: OriginalMiddle seguía visible (bug).
          // Con DeepCollectionEquality: EditedMiddle debe aparecer.
          expect(find.text('OriginalMiddle'), findsNothing);
          expect(find.text('EditedMiddle'), findsOneWidget);
        },
      );
    });

    // ─────────────────────────────────────────────
    // onFilteredCountChanged
    // ─────────────────────────────────────────────
    group('onFilteredCountChanged', () {
      testWidgets('fires with full count on initial load', (tester) async {
        final counts = <int>[];
        final items = [
          const _Item(id: '1', name: 'Alpha', secondary: ''),
          const _Item(id: '2', name: 'Beta', secondary: ''),
          const _Item(id: '3', name: 'Gamma', secondary: ''),
        ];

        await tester.pumpWidget(_buildTable(items, onFilteredCountChanged: counts.add));
        await tester.pump();
        await _waitForCompute(tester);

        expect(counts.last, equals(3));
      });

      testWidgets('null callback does not throw', (tester) async {
        final items = [const _Item(id: '1', name: 'Alpha', secondary: '')];

        await tester.pumpWidget(_buildTable(items));
        await tester.pump();
        await _waitForCompute(tester);

        expect(tester.takeException(), isNull);
      });

      testWidgets('fires with 0 on empty items list', (tester) async {
        final counts = <int>[];

        await tester.pumpWidget(_buildTable([], onFilteredCountChanged: counts.add));
        await tester.pump();
        await _waitForCompute(tester);

        expect(counts.last, equals(0));
      });

      testWidgets('fires filtered count after search narrows results', (tester) async {
        final counts = <int>[];
        final items = [
          const _Item(id: '1', name: 'Apple', secondary: ''),
          const _Item(id: '2', name: 'Banana', secondary: ''),
          const _Item(id: '3', name: 'Apricot', secondary: ''),
        ];

        await tester.pumpWidget(
          _buildTable(items, canSearch: true, onFilteredCountChanged: counts.add),
        );
        await tester.pump();
        await _waitForCompute(tester);
        expect(counts.last, equals(3));

        // 'Ap' matches Apple and Apricot (both start with 'Ap'), but not Banana.
        await tester.enterText(find.byType(TextField), 'Ap');
        await tester.pump(const Duration(milliseconds: 700));
        await _waitForCompute(tester);

        expect(counts.last, equals(2));
      });

      testWidgets('fires updated count when items list grows via didUpdateWidget', (tester) async {
        final counts = <int>[];
        List<_Item> items = [const _Item(id: '1', name: 'First', secondary: '')];
        late StateSetter rebuildState;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              rebuildState = setState;
              return MaterialApp(
                home: Scaffold(
                  body: SizedBox(
                    height: 600,
                    width: 800,
                    child: ThemedTable2<_Item>(
                      items: items,
                      actionsCount: 0,
                      hasMultiselect: false,
                      canSearch: false,
                      populateDelay: Duration.zero,
                      onFilteredCountChanged: counts.add,
                      columns: [
                        ThemedColumn2<_Item>(
                          headerText: 'Name',
                          valueBuilder: (item) => item.name,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
        await tester.pump();
        await _waitForCompute(tester);
        expect(counts.last, equals(1));

        rebuildState(() {
          items = [
            const _Item(id: '1', name: 'First', secondary: ''),
            const _Item(id: '2', name: 'Second', secondary: ''),
          ];
        });
        await tester.pump();
        await _waitForCompute(tester);

        expect(counts.last, equals(2));
      });

      testWidgets('fires with same count after controller.sort', (tester) async {
        final counts = <int>[];
        final controller = ThemedTable2Controller<_Item>();
        addTearDown(controller.dispose);

        final items = [
          const _Item(id: '1', name: 'Zebra', secondary: ''),
          const _Item(id: '2', name: 'Apple', secondary: ''),
        ];

        await tester.pumpWidget(
          _buildTable(items, controller: controller, onFilteredCountChanged: counts.add),
        );
        await tester.pump();
        await _waitForCompute(tester);
        final countAfterInit = counts.last;

        controller.sort(columnIndex: 0, ascending: true);
        await _waitForCompute(tester);

        expect(counts.last, equals(countAfterInit));
        expect(counts.last, equals(2));
      });

      testWidgets('does not fire after widget is disposed', (tester) async {
        final counts = <int>[];
        final items = [const _Item(id: '1', name: 'Alpha', secondary: '')];

        await tester.pumpWidget(_buildTable(items, onFilteredCountChanged: counts.add));
        await tester.pump();
        await _waitForCompute(tester);
        final countAfterMount = counts.length;

        await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
        await tester.pump();

        expect(counts.length, equals(countAfterMount));
      });
    });
  });
}
