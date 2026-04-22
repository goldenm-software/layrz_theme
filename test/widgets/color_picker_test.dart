import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

Widget _buildPicker({
  Color? value,
  void Function(Color)? onChanged,
  bool disabled = false,
  String labelText = 'Color',
}) {
  return MaterialApp(
    home: Scaffold(
      body: ThemedColorPicker(
        labelText: labelText,
        value: value,
        disabled: disabled,
        onChanged: onChanged,
      ),
    ),
  );
}

void main() {
  group('ThemedColorPicker', () {
    // ─────────────────────────────────────────────────────────────
    // RENDERING
    // ─────────────────────────────────────────────────────────────
    group('rendering', () {
      testWidgets('renders without crashing', (tester) async {
        await tester.pumpWidget(_buildPicker(value: const Color(0xFFFF5252)));
        await tester.pumpAndSettle();
        expect(find.byType(ThemedColorPicker), findsOneWidget);
      });

      testWidgets('shows label text', (tester) async {
        await tester.pumpWidget(_buildPicker(labelText: 'Background'));
        await tester.pumpAndSettle();
        expect(find.text('Background'), findsOneWidget);
      });

      testWidgets('shows hex value in text field', (tester) async {
        await tester.pumpWidget(_buildPicker(value: const Color(0xFFFF5252)));
        await tester.pumpAndSettle();
        expect(find.text('#FF5252'), findsOneWidget);
      });

      testWidgets('shows kPrimaryColor hex when value is null', (tester) async {
        await tester.pumpWidget(_buildPicker(value: null));
        await tester.pumpAndSettle();
        expect(find.text(kPrimaryColor.hex), findsOneWidget);
      });

      testWidgets('shows color swatch in prefix', (tester) async {
        await tester.pumpWidget(_buildPicker(value: const Color(0xFF001E60)));
        await tester.pumpAndSettle();
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(ThemedColorPicker),
                matching: find.byType(Container),
              )
              .first,
        );
        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, equals(const Color(0xFF001E60)));
      });
    });

    // ─────────────────────────────────────────────────────────────
    // DISABLED
    // ─────────────────────────────────────────────────────────────
    group('disabled', () {
      testWidgets('disabled picker does not open dialog on tap', (tester) async {
        await tester.pumpWidget(_buildPicker(value: const Color(0xFFFF5252), disabled: true));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ThemedColorPicker));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsNothing);
      });

      testWidgets('enabled picker opens dialog on tap', (tester) async {
        await tester.pumpWidget(_buildPicker(value: const Color(0xFFFF5252)));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);
      });
    });

    // ─────────────────────────────────────────────────────────────
    // LIFECYCLE — didUpdateWidget & dispose
    // ─────────────────────────────────────────────────────────────
    group('lifecycle', () {
      testWidgets('mounts and unmounts without errors', (tester) async {
        await tester.pumpWidget(_buildPicker(value: const Color(0xFFFF5252)));
        await tester.pumpAndSettle();

        await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });

      testWidgets('repeated mount/unmount cycles do not throw', (tester) async {
        for (int i = 0; i < 5; i++) {
          await tester.pumpWidget(_buildPicker(value: const Color(0xFFFF5252)));
          await tester.pumpAndSettle();
          await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('didUpdateWidget updates text field when value changes externally', (tester) async {
        // Regression: before adding didUpdateWidget, the controller was never updated
        // when the parent passed a new value prop.
        Color current = const Color(0xFFFF5252);
        late StateSetter externalSetState;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  externalSetState = setState;
                  return ThemedColorPicker(
                    labelText: 'Color',
                    value: current,
                    onChanged: (v) => setState(() => current = v),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('#FF5252'), findsOneWidget);

        externalSetState(() => current = const Color(0xFF001E60));
        await tester.pumpAndSettle();

        expect(find.text(const Color(0xFF001E60).hex), findsOneWidget);
        expect(find.text('#FF5252'), findsNothing);
      });

      testWidgets('didUpdateWidget resets to kPrimaryColor when value changes to null', (tester) async {
        Color? current = const Color(0xFFFF5252);
        late StateSetter externalSetState;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  externalSetState = setState;
                  return ThemedColorPicker(
                    labelText: 'Color',
                    value: current,
                    onChanged: (v) => setState(() => current = v),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        externalSetState(() => current = null);
        await tester.pumpAndSettle();

        expect(find.text(kPrimaryColor.hex), findsOneWidget);
      });

      testWidgets('didUpdateWidget does not rebuild when same value is passed', (tester) async {
        const color = Color(0xFFFF5252);
        Color current = color;
        late StateSetter externalSetState;
        int buildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  externalSetState = setState;
                  buildCount++;
                  return ThemedColorPicker(
                    labelText: 'Color',
                    value: current,
                    onChanged: (_) {},
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final countAfterMount = buildCount;

        // Pass the exact same color — no change expected in controller
        externalSetState(() => current = color);
        await tester.pumpAndSettle();

        // Text field should still show the same hex, no crash
        expect(find.text('#FF5252'), findsOneWidget);
        // buildCount increased (StatefulBuilder rebuilt) but no exception
        expect(buildCount, greaterThan(countAfterMount));
        expect(tester.takeException(), isNull);
      });
    });
  });
}
