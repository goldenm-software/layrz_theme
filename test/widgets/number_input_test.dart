import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_icons/layrz_icons.dart';
import 'package:layrz_theme/layrz_theme.dart';

/// Wraps [ThemedNumberInput] in a [StatefulBuilder] so tests can drive
/// value changes from outside, simulating a real parent widget.
Widget _buildInput({
  num? initialValue,
  void Function(num?)? onChanged,
  num? minimum,
  num? maximum,
  num? step,
  ThemedDecimalSeparator decimalSeparator = ThemedDecimalSeparator.dot,
  int maximumDecimalDigits = 4,
  bool disabled = false,
  bool hidePrefixSuffixActions = false,
  bool isRequired = false,
  bool hideDetails = false,
  List<String> errors = const [],
  String? suffixText,
  String? prefixText,
  String labelText = 'Number',
}) {
  return MaterialApp(
    home: Scaffold(
      body: StatefulBuilder(
        builder: (context, setState) {
          num? value = initialValue;
          return ThemedNumberInput(
            labelText: labelText,
            value: value,
            minimum: minimum,
            maximum: maximum,
            step: step,
            decimalSeparator: decimalSeparator,
            maximumDecimalDigits: maximumDecimalDigits,
            disabled: disabled,
            hidePrefixSuffixActions: hidePrefixSuffixActions,
            isRequired: isRequired,
            hideDetails: hideDetails,
            errors: errors,
            suffixText: suffixText,
            prefixText: prefixText,
            onChanged: (v) {
              setState(() => value = v);
              onChanged?.call(v);
            },
          );
        },
      ),
    ),
  );
}

/// Builds a fully reactive version where the parent owns the state.
Widget _buildReactive({
  required num? Function() getValue,
  required void Function(num?) setValue,
  num? minimum,
  num? maximum,
  num? step,
  ThemedDecimalSeparator decimalSeparator = ThemedDecimalSeparator.dot,
  int maximumDecimalDigits = 4,
  bool hidePrefixSuffixActions = false,
}) {
  num? _value = getValue();
  return MaterialApp(
    home: Scaffold(
      body: StatefulBuilder(
        builder: (context, setState) {
          return ThemedNumberInput(
            labelText: 'Number',
            value: _value,
            minimum: minimum,
            maximum: maximum,
            step: step,
            decimalSeparator: decimalSeparator,
            maximumDecimalDigits: maximumDecimalDigits,
            hidePrefixSuffixActions: hidePrefixSuffixActions,
            onChanged: (v) {
              setState(() {
                _value = v;
                setValue(v);
              });
            },
          );
        },
      ),
    ),
  );
}

void main() {
  group('ThemedNumberInput', () {
    // ─────────────────────────────────────────────────────────────
    // RENDERING
    // ─────────────────────────────────────────────────────────────
    group('rendering', () {
      testWidgets('renders without crashing', (tester) async {
        await tester.pumpWidget(_buildInput());
        await tester.pumpAndSettle();
        expect(find.byType(ThemedNumberInput), findsOneWidget);
      });

      testWidgets('shows label text', (tester) async {
        await tester.pumpWidget(_buildInput(labelText: 'My Label'));
        await tester.pumpAndSettle();
        expect(find.text('My Label'), findsOneWidget);
      });

      testWidgets('shows initial value formatted in the text field', (tester) async {
        await tester.pumpWidget(_buildInput(initialValue: 42));
        await tester.pumpAndSettle();
        final tf = tester.widget<TextField>(find.byType(TextField));
        expect(tf.controller!.text, equals('42'));
      });

      testWidgets('shows empty field when value is null', (tester) async {
        await tester.pumpWidget(_buildInput(initialValue: null));
        await tester.pumpAndSettle();
        final tf = tester.widget<TextField>(find.byType(TextField));
        expect(tf.controller!.text, equals(''));
      });

      testWidgets('shows suffixText when provided', (tester) async {
        await tester.pumpWidget(_buildInput(suffixText: '°C'));
        await tester.pumpAndSettle();
        expect(find.text('°C'), findsOneWidget);
      });

      testWidgets('shows prefixText when provided', (tester) async {
        await tester.pumpWidget(_buildInput(prefixText: '\$'));
        await tester.pumpAndSettle();
        expect(find.text('\$'), findsOneWidget);
      });

      testWidgets('shows required asterisk when isRequired is true', (tester) async {
        await tester.pumpWidget(_buildInput(isRequired: true));
        await tester.pumpAndSettle();
        expect(find.text('*'), findsOneWidget);
      });

      testWidgets('shows error text when errors list is non-empty', (tester) async {
        await tester.pumpWidget(_buildInput(errors: ['Value is required']));
        await tester.pumpAndSettle();
        expect(find.text('Value is required'), findsOneWidget);
      });

      testWidgets('hides error space when hideDetails is true', (tester) async {
        await tester.pumpWidget(_buildInput(errors: ['Hidden error'], hideDetails: true));
        await tester.pumpAndSettle();
        expect(find.text('Hidden error'), findsNothing);
      });
    });

    // ─────────────────────────────────────────────────────────────
    // onChanged — keyboard input
    // ─────────────────────────────────────────────────────────────
    group('onChanged via keyboard', () {
      testWidgets('calls onChanged with parsed num when user types a number', (tester) async {
        num? received;
        await tester.pumpWidget(_buildInput(onChanged: (v) => received = v));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), '42');
        await tester.pump();

        expect(received, equals(42));
      });

      testWidgets('calls onChanged(null) when user clears the field', (tester) async {
        num? received = 99;
        await tester.pumpWidget(_buildInput(initialValue: 99, onChanged: (v) => received = v));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), '');
        await tester.pump();

        expect(received, isNull);
      });

      testWidgets('does NOT call onChanged when user types only a minus sign', (tester) async {
        int callCount = 0;
        await tester.pumpWidget(_buildInput(onChanged: (_) => callCount++));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), '-');
        await tester.pump();

        // "-" alone should not trigger onChanged
        expect(callCount, equals(0));
      });

      testWidgets('does NOT call onChanged when input cannot be parsed (C3 regression)', (tester) async {
        // Regression for C3: tryParse returning null must not fire onChanged(null)
        // We simulate this by directly calling the internal onChanged of ThemedTextInput
        // with a string that passes the regex but cannot be parsed as a number (e.g. just "-").
        // "-" is handled separately, so we use a value that slips through in edge cases:
        // a lone decimal separator "." which passes the regex but tryParse returns null.
        num? lastReceived = 99; // sentinel — should stay 99 if onChanged is NOT called
        await tester.pumpWidget(_buildInput(initialValue: 99, onChanged: (v) => lastReceived = v));
        await tester.pumpAndSettle();

        // Enter a value that the formatter allows but NumberFormat.tryParse returns null for
        await tester.enterText(find.byType(TextField), '.');
        await tester.pump();

        // onChanged(null) must NOT have been called — lastReceived stays 99
        expect(lastReceived, equals(99));
      });

      testWidgets('calls onChanged with negative number', (tester) async {
        num? received;
        await tester.pumpWidget(_buildInput(onChanged: (v) => received = v));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), '-5');
        await tester.pump();

        expect(received, equals(-5));
      });
    });

    // ─────────────────────────────────────────────────────────────
    // STEP BUTTONS — increment / decrement
    // ─────────────────────────────────────────────────────────────
    group('step buttons', () {
      testWidgets('increment button increases value by step', (tester) async {
        num? current = 5;
        await tester.pumpWidget(
          _buildReactive(
            getValue: () => current,
            setValue: (v) => current = v,
            step: 1,
          ),
        );
        await tester.pumpAndSettle();

        // suffix icon = add button
        await tester.tap(find.byIcon(LayrzIcons.solarOutlineAddSquare));
        await tester.pumpAndSettle();

        expect(current, equals(6));
      });

      testWidgets('decrement button decreases value by step', (tester) async {
        num? current = 5;
        await tester.pumpWidget(
          _buildReactive(
            getValue: () => current,
            setValue: (v) => current = v,
            step: 1,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(LayrzIcons.solarOutlineMinusSquare));
        await tester.pumpAndSettle();

        expect(current, equals(4));
      });

      testWidgets('step defaults to 1 when not provided', (tester) async {
        num? current = 10;
        await tester.pumpWidget(
          _buildReactive(
            getValue: () => current,
            setValue: (v) => current = v,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(LayrzIcons.solarOutlineAddSquare));
        await tester.pumpAndSettle();

        expect(current, equals(11));
      });

      testWidgets('value starts at 0 when null and step button is tapped', (tester) async {
        num? current;
        await tester.pumpWidget(
          _buildReactive(
            getValue: () => current,
            setValue: (v) => current = v,
            step: 1,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(LayrzIcons.solarOutlineAddSquare));
        await tester.pumpAndSettle();

        expect(current, equals(1)); // 0 + 1
      });

      testWidgets('increment is disabled at maximum — does not call onChanged', (tester) async {
        int callCount = 0;
        num? current = 10;
        await tester.pumpWidget(
          _buildReactive(
            getValue: () => current,
            setValue: (v) {
              current = v;
              callCount++;
            },
            step: 1,
            maximum: 10,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(LayrzIcons.solarOutlineAddSquare));
        await tester.pumpAndSettle();

        expect(callCount, equals(0));
        expect(current, equals(10));
      });

      testWidgets('decrement is disabled at minimum — does not call onChanged', (tester) async {
        int callCount = 0;
        num? current = 0;
        await tester.pumpWidget(
          _buildReactive(
            getValue: () => current,
            setValue: (v) {
              current = v;
              callCount++;
            },
            step: 1,
            minimum: 0,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(LayrzIcons.solarOutlineMinusSquare));
        await tester.pumpAndSettle();

        expect(callCount, equals(0));
        expect(current, equals(0));
      });

      testWidgets('step buttons are hidden when hidePrefixSuffixActions is true', (tester) async {
        await tester.pumpWidget(_buildInput(hidePrefixSuffixActions: true));
        await tester.pumpAndSettle();

        expect(find.byIcon(LayrzIcons.solarOutlineAddSquare), findsNothing);
        expect(find.byIcon(LayrzIcons.solarOutlineMinusSquare), findsNothing);
      });

      testWidgets('step buttons are hidden when disabled is true', (tester) async {
        await tester.pumpWidget(_buildInput(disabled: true, initialValue: 5));
        await tester.pumpAndSettle();

        expect(find.byIcon(LayrzIcons.solarOutlineAddSquare), findsNothing);
        expect(find.byIcon(LayrzIcons.solarOutlineMinusSquare), findsNothing);
      });
    });

    // ─────────────────────────────────────────────────────────────
    // CURSOR POSITION — step bug regression
    // ─────────────────────────────────────────────────────────────
    group('cursor position after step', () {
      testWidgets('cursor is at end after incrementing from 9 to 10 (digit count changes)', (tester) async {
        // Regression: cursor was left at position 1 (between "1" and "0") instead of end.
        num? current = 9;
        await tester.pumpWidget(
          _buildReactive(
            getValue: () => current,
            setValue: (v) => current = v,
            step: 1,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(LayrzIcons.solarOutlineAddSquare));
        await tester.pumpAndSettle();

        expect(current, equals(10));

        final tf = tester.widget<TextField>(find.byType(TextField));
        final cursorOffset = tf.controller!.selection.extentOffset;
        final textLength = tf.controller!.text.length;

        // Cursor MUST be at the end — not stuck at old position 1
        expect(cursorOffset, equals(textLength), reason: 'Cursor should be at end after step, got $cursorOffset on "${tf.controller!.text}"');
      });

      testWidgets('cursor is at end after incrementing from 99 to 100', (tester) async {
        num? current = 99;
        await tester.pumpWidget(
          _buildReactive(
            getValue: () => current,
            setValue: (v) => current = v,
            step: 1,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(LayrzIcons.solarOutlineAddSquare));
        await tester.pumpAndSettle();

        expect(current, equals(100));

        final tf = tester.widget<TextField>(find.byType(TextField));
        final cursorOffset = tf.controller!.selection.extentOffset;
        final textLength = tf.controller!.text.length;

        expect(cursorOffset, equals(textLength), reason: 'Cursor stuck at $cursorOffset on "${tf.controller!.text}"');
      });

      testWidgets('cursor is at end after decrementing from 10 to 9 (digit count shrinks)', (tester) async {
        num? current = 10;
        await tester.pumpWidget(
          _buildReactive(
            getValue: () => current,
            setValue: (v) => current = v,
            step: 1,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(LayrzIcons.solarOutlineMinusSquare));
        await tester.pumpAndSettle();

        expect(current, equals(9));

        final tf = tester.widget<TextField>(find.byType(TextField));
        final cursorOffset = tf.controller!.selection.extentOffset;
        final textLength = tf.controller!.text.length;

        expect(cursorOffset, equals(textLength), reason: 'Cursor stuck at $cursorOffset on "${tf.controller!.text}"');
      });

      testWidgets('cursor is at end after incrementing into thousands (999 to 1,000)', (tester) async {
        num? current = 999;
        await tester.pumpWidget(
          _buildReactive(
            getValue: () => current,
            setValue: (v) => current = v,
            step: 1,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(LayrzIcons.solarOutlineAddSquare));
        await tester.pumpAndSettle();

        expect(current, equals(1000));

        final tf = tester.widget<TextField>(find.byType(TextField));
        final cursorOffset = tf.controller!.selection.extentOffset;
        final textLength = tf.controller!.text.length;

        expect(cursorOffset, equals(textLength), reason: 'Cursor stuck at $cursorOffset on "${tf.controller!.text}"');
      });
    });

    // ─────────────────────────────────────────────────────────────
    // DECIMAL SEPARATORS
    // ─────────────────────────────────────────────────────────────
    group('decimal separators', () {
      testWidgets('dot separator formats 1234.5 as "1,234.5"', (tester) async {
        await tester.pumpWidget(
          _buildInput(initialValue: 1234.5, decimalSeparator: ThemedDecimalSeparator.dot, maximumDecimalDigits: 2),
        );
        await tester.pumpAndSettle();

        final tf = tester.widget<TextField>(find.byType(TextField));
        expect(tf.controller!.text, equals('1,234.5'));
      });

      testWidgets('comma separator formats 1234.5 as "1.234,5"', (tester) async {
        await tester.pumpWidget(
          _buildInput(initialValue: 1234.5, decimalSeparator: ThemedDecimalSeparator.comma, maximumDecimalDigits: 2),
        );
        await tester.pumpAndSettle();

        final tf = tester.widget<TextField>(find.byType(TextField));
        expect(tf.controller!.text, equals('1.234,5'));
      });
    });

    // ─────────────────────────────────────────────────────────────
    // LIFECYCLE — memory / controller disposal
    // ─────────────────────────────────────────────────────────────
    group('lifecycle', () {
      testWidgets('widget mounts and unmounts without errors', (tester) async {
        // Regression for C1: controller was not disposed, causing errors on unmount
        await tester.pumpWidget(_buildInput(initialValue: 42));
        await tester.pumpAndSettle();

        // Replace with an empty container to force disposal
        await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
        await tester.pumpAndSettle();

        // No exceptions should have been thrown
        expect(tester.takeException(), isNull);
      });

      testWidgets('repeated mount/unmount cycles do not throw', (tester) async {
        for (int i = 0; i < 5; i++) {
          await tester.pumpWidget(_buildInput(initialValue: i.toDouble()));
          await tester.pumpAndSettle();
          await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('controller text clears when value changes to null', (tester) async {
        // Regression: _updateCursorOffset must reset text to '' when value becomes null
        num? current = 42;
        late StateSetter externalSetState;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  externalSetState = setState;
                  return ThemedNumberInput(
                    labelText: 'Number',
                    value: current,
                    onChanged: (v) => setState(() => current = v),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Force value to null from outside
        externalSetState(() => current = null);
        await tester.pumpAndSettle();

        final tf = tester.widget<TextField>(find.byType(TextField));
        expect(tf.controller!.text, equals(''));
      });
    });
  });
}
