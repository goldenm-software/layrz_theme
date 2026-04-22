# ThemedNumberInput — API Reference

Source: `lib/src/inputs/src/general/number_input.dart`

- `ThemedNumberInput` class — line 3
- `ThemedDecimalSeparator` enum — line (end of file)

---

## Examples

```dart
// Basic number field
ThemedNumberInput(
  labelText: 'Speed',
  value: speed,
  onChanged: (value) => setState(() => speed = value),
)

// Integer with bounds
ThemedNumberInput(
  labelText: 'Quantity',
  value: quantity,
  minimum: 0,
  maximum: 999,
  step: 1,
  maximumDecimalDigits: 0,
  errors: context.getErrors(key: 'quantity'),
  onChanged: (value) => setState(() => quantity = value?.toInt()),
)

// Decimal with suffix
ThemedNumberInput(
  labelText: 'Temperature',
  value: temperature,
  decimalSeparator: .comma,
  maximumDecimalDigits: 2,
  suffixText: '°C',
  onChanged: (value) => setState(() => temperature = value),
)

// Custom NumberFormat (inputRegExp required)
ThemedNumberInput(
  labelText: 'Price',
  value: price,
  format: NumberFormat.currency(symbol: '\$'),
  inputRegExp: RegExp(r'[\d.]'),
  onChanged: (value) => setState(() => price = value),
)

// No step buttons
ThemedNumberInput(
  labelText: 'Offset',
  value: offset,
  hidePrefixSuffixActions: true,
  onChanged: (value) => setState(() => offset = value),
)

// Disabled
ThemedNumberInput(
  labelText: 'Speed',
  value: speed,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedNumberInput({
  super.key,
  this.labelText,
  this.label,
  this.disabled = false,
  this.placeholder,
  this.onChanged,
  this.value,
  this.errors = const [],
  this.hideDetails = false,
  this.padding,
  this.dense = false,
  this.isRequired = false,
  this.onSubmitted,
  this.inputFormatters = const [],
  this.borderRadius,
  this.minimum,
  this.maximum,
  this.step,
  this.keyboardType = TextInputType.number,
  this.format,
  this.decimalSeparator = ThemedDecimalSeparator.dot,
  this.inputRegExp,
  this.maximumDecimalDigits = 4,
  this.suffixText,
  this.prefixText,
  this.hidePrefixSuffixActions = false,
  this.focusNode,
}) : assert(
       (label == null && labelText != null) || (label != null && labelText == null),
     ),
     assert(
       (format != null && inputRegExp != null) || (format == null),
       'When format is set, inputRegExp is required.',
     );
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `num?` | `null` | Current numeric value |
| `onChanged` | `void Function(num?)?` | `null` | Called with `null` on clear; not called for unparseable input |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `placeholder` | `String?` | `null` | Hint text when field is empty |
| `disabled` | `bool` | `false` | Makes field read-only; hides ± buttons |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `isRequired` | `bool` | `false` | Shows required indicator |
| `padding` | `EdgeInsets?` | `null` | Outer padding |
| `minimum` | `num?` | `null` | Disables − button at boundary; does not block keyboard input |
| `maximum` | `num?` | `null` | Disables + button at boundary; does not block keyboard input |
| `step` | `num?` | `null` | Button increment/decrement amount (effective default: `1`) |
| `maximumDecimalDigits` | `int` | `4` | Max fraction digits shown; capped at 15 internally |
| `decimalSeparator` | `ThemedDecimalSeparator` | `.dot` | `.dot` → en locale; `.comma` → pt locale |
| `format` | `NumberFormat?` | `null` | Custom `intl` format; **requires** `inputRegExp` when set |
| `inputRegExp` | `RegExp?` | `null` | Input character filter; **required** when `format` is set |
| `suffixText` | `String?` | `null` | Static text after the value (e.g. `'kg'`) |
| `prefixText` | `String?` | `null` | Static text before the value (e.g. `'$'`) |
| `hidePrefixSuffixActions` | `bool` | `false` | Hides ± buttons without disabling the field |
| `keyboardType` | `TextInputType` | `TextInputType.number` | Mobile keyboard hint |
| `focusNode` | `FocusNode?` | `null` | External focus node; **caller must dispose** |
| `onSubmitted` | `VoidCallback?` | `null` | Called on keyboard submit action |
| `inputFormatters` | `List<TextInputFormatter>` | `[]` | Extra formatters appended after built-in regex filter |
| `borderRadius` | `double?` | `null` | Corner radius override |

---

## ThemedDecimalSeparator enum

| Value | Locale | Thousands | Decimal | Example |
|---|---|---|---|---|
| `.dot` (default) | en | `,` | `.` | `1,234.56` |
| `.comma` | pt | `.` | `,` | `1.234,56` |

---

## Key gotchas

- `minimum` / `maximum` only gate the ± buttons — keyboard input is unrestricted. Add form-layer validation for hard limits.
- `format` + `inputRegExp` must always be paired — the assert throws in debug mode if `format` is set without `inputRegExp`.
- After a ± button tap, cursor jumps to end of the formatted number (intentional).
- `onChanged` is not called for intermediate states (lone `-`, incomplete decimals, unparseable input).
- `focusNode` passed externally is NOT disposed by this widget — the caller owns its lifecycle.
