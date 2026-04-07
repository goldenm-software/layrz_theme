---
name: number-duration-inputs
description: Use ThemedNumberInput or ThemedDurationInput in a layrz Flutter widget. Apply when adding a numeric field with step/min/max or a duration picker to any form or view.
---

## Overview

| Component | State type | `onChanged` signature | When to use |
|---|---|---|---|
| `ThemedNumberInput` | `num?` | `void Function(num?)?` | Numeric fields: integers, decimals, quantities, coordinates |
| `ThemedDurationInput` | `Duration?` | `Function(Duration?)?` | Time span fields: timeouts, intervals, elapsed time |

`ThemedNumberInput` renders a text field with minus (prefix) and plus (suffix) icon buttons for increment/decrement. The buttons show a **visual disabled state (0.4 opacity)** when the value reaches `minimum` or `maximum` — implemented via `prefixIconDisabled`/`suffixIconDisabled` on the internal `ThemedTextInput`. `ThemedDurationInput` renders a readonly text field that opens a dialog with one `ThemedNumberInput` per visible time unit.

---

## ThemedNumberInput

### Minimal usage

```dart
// State
num? speed;

// Widget
ThemedNumberInput(
  labelText: context.i18n.t('entity.speed'),
  value: speed,
  onChanged: (value) {
    speed = value;
    if (context.mounted) onChanged.call();
  },
)
```

### Key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Exactly one must be set. |
| `value` | `num?` | `null` | Current numeric value |
| `onChanged` | `void Function(num?)?` | `null` | Called with `null` when field is cleared |
| `minimum` | `num?` | `null` | Disables decrement button visually at boundary; does **not** block typed input |
| `maximum` | `num?` | `null` | Disables increment button visually at boundary; does **not** block typed input |
| `step` | `num?` | `1` | Amount added/subtracted by the ± buttons |
| `maximumDecimalDigits` | `int` | `4` | Max fraction digits shown (capped at 15 internally) |
| `decimalSeparator` | `ThemedDecimalSeparator` | `.dot` | `.dot` → en locale (`1,234.56`), `.comma` → pt locale (`1.234,56`) |
| `format` | `NumberFormat?` | `null` | Custom `intl` `NumberFormat`. **Requires** `inputRegExp` when set. |
| `inputRegExp` | `RegExp?` | `null` | Overrides the default `[-0-9\,.]` regex when provided. **Required** when `format` is set. |
| `disabled` | `bool` | `false` | Makes field read-only and hides ± buttons |
| `hidePrefixSuffixActions` | `bool` | `false` | Hides ± buttons without disabling the field |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `isRequired` | `bool` | `false` | Shows `*` required indicator |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `padding` | `EdgeInsets?` | `null` | Outer padding of the field |
| `prefixText` | `String?` | `null` | Static text before the value (e.g. `'$'`) |
| `suffixText` | `String?` | `null` | Static text after the value (e.g. `'kg'`) |
| `keyboardType` | `TextInputType` | `TextInputType.number` | Keyboard hint on mobile |
| `focusNode` | `FocusNode?` | `null` | External focus node; **not** disposed by this widget (caller owns it) |
| `onSubmitted` | `VoidCallback?` | `null` | Called when the user submits the field |
| `inputFormatters` | `List<TextInputFormatter>` | `[]` | Extra formatters appended after the built-in regex filter |
| `borderRadius` | `double?` | `null` | Corner radius override |

### Behavior notes

- `label` and `labelText` are **mutually exclusive**. Providing both (or neither) throws an assertion at construction.
- When `format` is set you **must** also set `inputRegExp`. The widget asserts this at construction. The default regex `[-0-9\,.]` only applies when no custom format is used — if you provide `inputRegExp`, that takes priority.
- `minimum`/`maximum` only gate the **buttons** — they do not restrict keyboard input. Add a validator in your form layer if you need hard limits on typed values.
- The ± buttons show **0.4 opacity** (visually disabled) when the next step would exceed the boundary. This is reactive — no manual state management needed.
- **Cursor after step:** When using ± buttons, the cursor always moves to the end of the formatted number. When typing manually, the cursor stays at the current position. This distinction is tracked internally via a `_stepTriggered` flag.
- `onChanged` is called with `null` when the field is cleared, and is **not** called when the user types only a `-` sign (intermediate state waiting for digits) or when `format.tryParse()` returns null (unparseable input is silently ignored — last valid value is preserved).
- `decimalSeparator: .comma` uses the `pt` locale `NumberFormat` internally, producing `1.234,56` style output.
- `hidePrefixSuffixActions` also activates automatically when `disabled: true`.

---

### Common patterns

```dart
// Integer-only field with bounds
ThemedNumberInput(
  labelText: context.i18n.t('entity.quantity'),
  value: quantity,
  minimum: 0,
  maximum: 999,
  step: 1,
  maximumDecimalDigits: 0,
  errors: context.getErrors(key: 'quantity'),
  onChanged: (value) {
    quantity = value?.toInt();
    if (context.mounted) onChanged.call();
  },
)

// Decimal field with comma separator and unit suffix
ThemedNumberInput(
  labelText: context.i18n.t('entity.temperature'),
  value: temperature,
  decimalSeparator: ThemedDecimalSeparator.comma,
  maximumDecimalDigits: 2,
  suffixText: '°C',
  errors: context.getErrors(key: 'temperature'),
  onChanged: (value) {
    temperature = value;
    if (context.mounted) onChanged.call();
  },
)

// Price field with currency prefix
ThemedNumberInput(
  labelText: context.i18n.t('entity.price'),
  value: price,
  prefixText: '\$',
  maximumDecimalDigits: 2,
  minimum: 0,
  errors: context.getErrors(key: 'price'),
  onChanged: (value) {
    price = value;
    if (context.mounted) onChanged.call();
  },
)

// Custom NumberFormat (inputRegExp is required when format is set)
ThemedNumberInput(
  labelText: context.i18n.t('entity.price'),
  value: price,
  format: NumberFormat.currency(symbol: '\$'),
  inputRegExp: RegExp(r'[\d.]'),
  errors: context.getErrors(key: 'price'),
  onChanged: (value) {
    price = value;
    if (context.mounted) onChanged.call();
  },
)

// No step buttons (free-form entry only)
ThemedNumberInput(
  labelText: context.i18n.t('entity.offset'),
  value: offset,
  hidePrefixSuffixActions: true,
  onChanged: (value) {
    offset = value;
    if (context.mounted) onChanged.call();
  },
)

// Fine decimal steps (0.1 increments, 0–1 range)
ThemedNumberInput(
  labelText: context.i18n.t('entity.opacity'),
  value: opacity,
  minimum: 0,
  maximum: 1,
  step: 0.1,
  maximumDecimalDigits: 1,
  onChanged: (value) {
    opacity = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## ThemedDurationInput

### Minimal usage

```dart
// State
Duration? timeout;

// Widget
ThemedDurationInput(
  labelText: context.i18n.t('entity.timeout'),
  value: timeout,
  onChanged: (value) {
    timeout = value;
    if (context.mounted) onChanged.call();
  },
)
```

### Key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Exactly one must be set. |
| `value` | `Duration?` | `null` | Current duration value |
| `onChanged` | `Function(Duration?)?` | `null` | Called only when the user taps Save in the dialog |
| `visibleValues` | `List<ThemedUnits>` | `kThemedDurationSupported` | Units shown in the dialog. Subset of `[day, hour, minute, second]` |
| `disabled` | `bool` | `false` | Disables tapping; field is always readonly |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `padding` | `EdgeInsets?` | `null` | Outer padding of the field |
| `prefixIcon` | `IconData?` | `null` | Icon before the text field |
| `suffixIcon` | `IconData?` | `null` | Icon after the text field |

`kThemedDurationSupported` is `[ThemedUnits.day, ThemedUnits.hour, ThemedUnits.minute, ThemedUnits.second]`.

### Behavior notes

- The field is **always readonly** — tapping it opens a dialog. Keyboard entry is not supported.
- `onChanged` fires **only when the user taps Save**. Cancel or dismiss discards changes.
- The dialog has three actions: **Cancel**, **Reset** (zeroes all units, doesn't close), and **Save** (commits and closes).
- Display text is humanized using `Duration.humanize(...)` with the active `LayrzAppLocalizations` locale.
- `visibleValues` must be a subset of `kThemedDurationSupported`. Passing `year`, `month`, `week`, or `millisecond` throws an assertion.
- When only one unit is visible it occupies full width; two or more use a two-column `ResponsiveRow`.

### Common patterns

```dart
// Hours and minutes only — for scheduling
ThemedDurationInput(
  labelText: context.i18n.t('entity.shiftLength'),
  value: shiftLength,
  visibleValues: const [ThemedUnits.hour, ThemedUnits.minute],
  errors: context.getErrors(key: 'shiftLength'),
  onChanged: (value) {
    shiftLength = value;
    if (context.mounted) onChanged.call();
  },
)

// Days only — for expiration windows
ThemedDurationInput(
  labelText: context.i18n.t('entity.retentionPeriod'),
  value: retentionPeriod,
  visibleValues: const [ThemedUnits.day],
  errors: context.getErrors(key: 'retentionPeriod'),
  onChanged: (value) {
    retentionPeriod = value;
    if (context.mounted) onChanged.call();
  },
)

// Full granularity with icon
ThemedDurationInput(
  labelText: context.i18n.t('entity.connectionTimeout'),
  value: connectionTimeout,
  prefixIcon: LayrzIcons.solarOutlineClockCircle,
  errors: context.getErrors(key: 'connectionTimeout'),
  onChanged: (value) {
    connectionTimeout = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Integrating with layrz forms (onChanged + errors pattern)

```dart
ThemedNumberInput(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName,
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (value) {
    object.fieldName = value;
    if (context.mounted) onChanged.call();
  },
)
```

```dart
ThemedDurationInput(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName,
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (value) {
    object.fieldName = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Gotchas & Edge Cases

### 1. `minimum`/`maximum` gate buttons, not keyboard

The `minimum`/`maximum` parameters only disable the ± buttons visually. A user can still type a value outside the range. Add explicit validation in your form layer if hard limits are required.

```dart
// Button disabled at 0, but user can still type "-5"
ThemedNumberInput(
  value: qty,
  minimum: 0,
  step: 1,
  errors: qty != null && qty! < 0 ? ['Must be >= 0'] : [],
  onChanged: (v) => setState(() => qty = v),
)
```

### 2. `onChanged` is NOT called for unparseable input

When `format.tryParse()` returns null (e.g. a lone `.` or incomplete number), `onChanged` is silently skipped. The last valid value is preserved in the parent state. This is intentional — don't rely on `onChanged` being called on every keystroke.

```dart
// User types "1." — onChanged not called until they type "1.5"
// Parent keeps the previous value during partial input
```

### 3. Cursor moves to end after ± buttons

After tapping the increment or decrement button, the cursor always jumps to the end of the formatted number. This is correct and intentional — don't fight it. When typing manually, cursor position is preserved.

```dart
// 9 → tap + → "10" with cursor at end (position 2) ✅
// Was broken before: cursor would land at position 1 (between "1" and "0")
```

### 4. `format` requires `inputRegExp` — assertion at construction

This is enforced via a Dart `assert`. If you provide a custom `format` without `inputRegExp`, the app crashes in debug mode immediately. Always pair them.

```dart
// ❌ Crashes in debug
ThemedNumberInput(
  format: NumberFormat.currency(symbol: '\$'),
  // inputRegExp missing!
)

// ✅ Correct
ThemedNumberInput(
  format: NumberFormat.currency(symbol: '\$'),
  inputRegExp: RegExp(r'[\d.]'),
)
```

### 5. `focusNode` lifecycle is the caller's responsibility

If you pass a `focusNode`, **you** must dispose it. The widget only disposes `FocusNode` instances it creates internally (when `focusNode` is null).

```dart
// Caller owns lifecycle
final _focus = FocusNode();

@override
void dispose() {
  _focus.dispose(); // your responsibility
  super.dispose();
}

ThemedNumberInput(focusNode: _focus, ...)
```

### 6. `decimalSeparator: .comma` affects the full format

`.comma` uses the `pt` locale pattern internally, which means **thousands separator is `.`** and **decimal separator is `,`**. The input regex accepts both `.` and `,` regardless of locale, so typos can still occur. Validate the parsed `num` value rather than the raw string.

---

## Choosing between the two

- Use `ThemedNumberInput` when the field represents a **scalar number**: count, weight, speed, price, percentage, coordinates.
- Use `ThemedDurationInput` when the field represents a **time span** stored as `Duration`.
- Never use raw `TextField`, `TextFormField`, `Slider`, or any Material numeric widget — always use these components.
- Prefer `ThemedDurationInput` over storing duration as a plain integer (seconds, milliseconds) — it gives the user explicit unit controls and produces a human-readable display automatically.

---

## Testing ThemedNumberInput

```dart
import 'package:layrz_icons/layrz_icons.dart';
import 'package:layrz_theme/layrz_theme.dart';

// Find the ± buttons by icon
final addButton = find.byIcon(LayrzIcons.solarOutlineAddSquare);
final subButton = find.byIcon(LayrzIcons.solarOutlineMinusSquare);

// Tap increment
await tester.tap(addButton);
await tester.pumpAndSettle();
expect(currentValue, equals(expectedValue));

// Verify button is disabled at max (icon is wrapped in Opacity 0.4 InkWell with null onTap)
// To test the boundary, verify onChanged is NOT called at maximum:
int calls = 0;
// pump widget with value == maximum, tap add, assert calls == 0

// Enter text via keyboard
await tester.enterText(find.byType(TextField), '42');
await tester.pump();
expect(received, equals(42));

// Clear field → onChanged(null)
await tester.enterText(find.byType(TextField), '');
await tester.pump();
expect(received, isNull);

// Verify cursor is at end after step (regression guard)
final tf = tester.widget<TextField>(find.byType(TextField));
expect(
  tf.controller!.selection.extentOffset,
  equals(tf.controller!.text.length),
  reason: 'Cursor must be at end after step button tap',
);
```

### StatefulBuilder pattern for reactive tests

```dart
Widget buildReactive(num? Function() get, void Function(num?) set) {
  num? value = get();
  return MaterialApp(
    home: Scaffold(
      body: StatefulBuilder(
        builder: (context, setState) {
          return ThemedNumberInput(
            labelText: 'Number',
            value: value,
            onChanged: (v) => setState(() { value = v; set(v); }),
          );
        },
      ),
    ),
  );
}
```
