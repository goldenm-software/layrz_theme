---
name: number-duration-inputs
description: Use ThemedNumberInput or ThemedDurationInput in a layrz Flutter widget. Apply when adding a numeric field with step/min/max or a duration picker to any form or view.
---

## Overview

| Component | State type | `onChanged` signature | When to use |
|---|---|---|---|
| `ThemedNumberInput` | `num?` | `void Function(num?)?` | Numeric fields: integers, decimals, quantities, coordinates |
| `ThemedDurationInput` | `Duration?` | `Function(Duration?)?` | Time span fields: timeouts, intervals, elapsed time |

`ThemedNumberInput` renders a text field with minus (prefix) and plus (suffix) icon buttons for increment/decrement. `ThemedDurationInput` renders a readonly text field that opens a dialog with one `ThemedNumberInput` per visible time unit.

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
| `minimum` | `num?` | `null` | Clamps the decrement button; does not block typed input |
| `maximum` | `num?` | `null` | Clamps the increment button; does not block typed input |
| `step` | `num?` | `1` | Amount added/subtracted by prefix/suffix buttons |
| `maximumDecimalDigits` | `int` | `4` | Max fraction digits shown (capped at 15 internally) |
| `decimalSeparator` | `ThemedDecimalSeparator` | `.dot` | `.dot` → en locale, `.comma` → pt locale |
| `format` | `NumberFormat?` | `null` | Custom `intl` `NumberFormat`. **Requires** `inputRegExp` when set. |
| `inputRegExp` | `RegExp?` | `null` | Required when `format` is provided; filters raw character input |
| `disabled` | `bool` | `false` | Disables typing and action buttons |
| `hidePrefixSuffixActions` | `bool` | `false` | Hides increment/decrement buttons without disabling the field |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `isRequired` | `bool` | `false` | Shows required indicator |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `padding` | `EdgeInsets?` | `null` | Outer padding of the field |
| `prefixText` | `String?` | `null` | Static text before the value (e.g. `'$'`) |
| `suffixText` | `String?` | `null` | Static text after the value (e.g. `'kg'`) |
| `keyboardType` | `TextInputType` | `TextInputType.number` | Keyboard hint on mobile |
| `focusNode` | `FocusNode?` | `null` | External focus node; not disposed by the widget |
| `onSubmitted` | `VoidCallback?` | `null` | Called when the user submits the field |
| `inputFormatters` | `List<TextInputFormatter>` | `[]` | Extra formatters appended after the built-in regex filter |
| `borderRadius` | `double?` | `null` | Corner radius override |

### Behavior notes

- `label` and `labelText` are **mutually exclusive**. Providing both (or neither) throws an assertion at runtime.
- When `format` is set you **must** also set `inputRegExp`. The widget asserts this at construction time. The default regex `[-0-9\,.]` only applies when no custom format is used.
- `minimum`/`maximum` only gate the **buttons** — they do not restrict keyboard input. Add a validator in your form layer if you need hard limits.
- Cursor position is preserved across reformats: the widget counts thousand-separator characters before and after the edit and adjusts the offset to avoid jumps.
- `onChanged` is called with `null` when the field is cleared, and is **not** called when the user types a bare `-` sign (intermediate state).
- `decimalSeparator: .comma` uses the `pt` locale `NumberFormat` internally, producing `1.234,56` style formatting.
- `hidePrefixSuffixActions` also activates automatically when `disabled: true`.

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

// Custom NumberFormat (requires inputRegExp)
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

// Hidden action buttons (display-mode field, still editable via keyboard)
ThemedNumberInput(
  labelText: context.i18n.t('entity.offset'),
  value: offset,
  hidePrefixSuffixActions: true,
  onChanged: (value) {
    offset = value;
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
| `visibleValues` | `List<ThemedUnits>` | `kThemedDurationSupported` | Units shown in the dialog. Subset of `[day, hour, minute, second]`. |
| `disabled` | `bool` | `false` | Disables tapping; the field is always readonly |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `padding` | `EdgeInsets?` | `null` | Outer padding of the field |
| `prefixIcon` | `IconData?` | `null` | Icon before the text field |
| `suffixIcon` | `IconData?` | `null` | Icon after the text field |

`kThemedDurationSupported` is `[ThemedUnits.day, ThemedUnits.hour, ThemedUnits.minute, ThemedUnits.second]`.

### Behavior notes

- The field is **always readonly** — tapping it opens a dialog. Keyboard entry is not supported.
- `onChanged` is called **only when the user taps Save**. Tapping Cancel or dismissing the dialog discards changes.
- The dialog has three action buttons: **Cancel** (discard), **Reset** (zeroes all unit fields, does not close), and **Save** (commits the value and closes).
- The display text is humanized using `Duration.humanize(...)` with the active `LayrzAppLocalizations` locale and the units in `visibleValues`.
- `visibleValues` must be a subset of `kThemedDurationSupported`. Passing an unsupported unit (`year`, `month`, `week`, `millisecond`) throws an assertion at construction.
- When only one unit is visible it occupies full width; when two or more are visible they are laid out in a two-column `ResponsiveRow`.
- If the odd-last unit rule applies (last item at an odd index), it stretches to full width automatically.
- `label` and `labelText` are **mutually exclusive**.

### Common patterns

```dart
// Hours and minutes only — useful for scheduling
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

// Days only — useful for expiration windows
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

// Full granularity with a custom prefix icon
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

### ThemedNumberInput

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

### ThemedDurationInput

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

### Stacking inputs

```dart
ThemedNumberInput(
  labelText: context.i18n.t('entity.retries'),
  value: object.retries,
  errors: context.getErrors(key: 'retries'),
  onChanged: (value) {
    object.retries = value?.toInt();
    if (context.mounted) onChanged.call();
  },
),
const SizedBox(height: 10),
ThemedDurationInput(
  labelText: context.i18n.t('entity.retryDelay'),
  value: object.retryDelay,
  errors: context.getErrors(key: 'retryDelay'),
  onChanged: (value) {
    object.retryDelay = value;
    if (context.mounted) onChanged.call();
  },
),
```

---

## Choosing between the two

- Use `ThemedNumberInput` when the field represents a **scalar number**: count, weight, speed, price, percentage, coordinates.
- Use `ThemedDurationInput` when the field represents a **time span** that is stored as a `Duration`.
- Never use raw `TextField`, `TextFormField`, `Slider`, or any Material numeric widget — always use these components.
- Prefer `ThemedDurationInput` over storing duration as a plain integer (e.g. seconds) — it gives the user explicit unit controls and produces a human-readable display automatically.
- When you need to capture only a subset of time units (e.g. hours + minutes for a schedule), pass a filtered `visibleValues` list to `ThemedDurationInput` rather than building a manual multi-field layout with `ThemedNumberInput`.
