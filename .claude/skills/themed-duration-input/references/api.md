# ThemedDurationInput — API Reference

Source: `lib/src/inputs/src/general/duration_input.dart`

- `ThemedDurationInput` class
- `kThemedDurationSupported` constant — `[ThemedUnits.day, ThemedUnits.hour, ThemedUnits.minute, ThemedUnits.second]`

---

## Examples

```dart
// Basic duration (all units)
ThemedDurationInput(
  labelText: 'Timeout',
  value: timeout,
  errors: context.getErrors(key: 'timeout'),
  onChanged: (value) => setState(() => timeout = value),
)

// Hours and minutes only
ThemedDurationInput(
  labelText: 'Shift length',
  value: shiftLength,
  visibleValues: const [ThemedUnits.hour, ThemedUnits.minute],
  onChanged: (value) => setState(() => shiftLength = value),
)

// Days only
ThemedDurationInput(
  labelText: 'Retention period',
  value: retentionPeriod,
  visibleValues: const [ThemedUnits.day],
  onChanged: (value) => setState(() => retentionPeriod = value),
)

// With prefix icon
ThemedDurationInput(
  labelText: 'Connection timeout',
  value: connectionTimeout,
  prefixIcon: LayrzIcons.solarOutlineClockCircle,
  onChanged: (value) => setState(() => connectionTimeout = value),
)

// Disabled
ThemedDurationInput(
  labelText: 'Timeout',
  value: timeout,
  disabled: true,
)
```

---

## Constructor

```dart
ThemedDurationInput({
  super.key,
  this.value,
  this.onChanged,
  this.errors = const [],
  this.labelText,
  this.label,
  this.suffixIcon,
  this.prefixIcon,
  this.padding,
  this.disabled = false,
  this.visibleValues = kThemedDurationSupported,
}) : assert((label == null && labelText != null) || (label != null && labelText == null)),
     assert(
       visibleValues.every(kThemedDurationSupported.contains),
       'The visible values provided has an unsupported value',
     );
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `Duration?` | `null` | Current duration value |
| `onChanged` | `Function(Duration?)?` | `null` | Fires only on Save tap in dialog |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `disabled` | `bool` | `false` | Prevents opening the dialog |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `padding` | `EdgeInsets?` | `null` | Outer padding |
| `prefixIcon` | `IconData?` | `null` | Icon before the text field |
| `suffixIcon` | `IconData?` | `null` | Icon after the text field |
| `visibleValues` | `List<ThemedUnits>` | `kThemedDurationSupported` | Units shown in dialog; must be subset of `[day, hour, minute, second]` |

---

## kThemedDurationSupported

```dart
const kThemedDurationSupported = [
  ThemedUnits.day,
  ThemedUnits.hour,
  ThemedUnits.minute,
  ThemedUnits.second,
];
```

Passing any other `ThemedUnits` value (year, month, week, millisecond) throws an assertion.

---

## Dialog behavior

- Always readonly field — tapping opens the duration dialog.
- Dialog actions: **Cancel** (discard, close), **Reset** (zero all units, stay open), **Save** (commit + close).
- `onChanged` fires only on Save.
- One `ThemedNumberInput` per unit in `visibleValues`.
- Single unit: full width. Two or more units: two-column `ResponsiveRow` layout.
- Display text is humanized using `Duration.humanize(...)` with the active `LayrzAppLocalizations` locale.
