# ThemedDateTimeRangePicker — API Reference

Source: `lib/src/inputs/src/pickers/datetime/range.dart`

- `ThemedDateTimeRangePicker` class — line 3
- `ThemedDateTimeRangeDialog` class (internal dialog widget) — line ~170

---

## Examples

```dart
// Basic datetime range (empty initial)
ThemedDateTimeRangePicker(
  labelText: 'Period',
  value: const [],
  errors: context.getErrors(key: 'period'),
  onChanged: (value) => setState(() => period = value),
)

// Pre-filled range
ThemedDateTimeRangePicker(
  labelText: 'Period',
  value: [DateTime(2025, 1, 1, 8, 0), DateTime(2025, 1, 31, 18, 0)],
  onChanged: (value) => setState(() => period = value),
)

// 24-hour format
ThemedDateTimeRangePicker(
  labelText: 'Period',
  value: period,
  use24HourFormat: true,
  onChanged: (value) => setState(() => period = value),
)

// With date limits
ThemedDateTimeRangePicker(
  labelText: 'Report period',
  value: period,
  firstDay: DateTime(2020, 1, 1),
  lastDay: DateTime.now(),
  onChanged: (value) => setState(() => period = value),
)

// Custom date format
ThemedDateTimeRangePicker(
  labelText: 'Period',
  value: period,
  datePattern: '%d/%m/%Y',
  use24HourFormat: true,
  onChanged: (value) => setState(() => period = value),
)

// Disabled
ThemedDateTimeRangePicker(
  labelText: 'Period',
  value: period,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedDateTimeRangePicker({
  super.key,
  this.value = const [],
  this.onChanged,
  this.labelText,
  this.label,
  this.placeholder,
  this.prefixText,
  this.prefixIcon,
  this.prefixWidget,
  this.onPrefixTap,
  this.customChild,
  this.disabled = false,
  this.translations = const { ... },  // see Translations section
  this.overridesLayrzTranslations = false,
  this.disabledDays = const [],
  this.datePattern = '%Y-%m-%d',
  this.timePattern,
  this.use24HourFormat = false,
  this.patternSeparator = ' ',
  this.hoverColor = Colors.transparent,
  this.focusColor = Colors.transparent,
  this.splashColor = Colors.transparent,
  this.highlightColor = Colors.transparent,
  this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  this.errors = const [],
  this.hideDetails = false,
  this.padding,
  this.firstDay,
  this.lastDay,
}) : assert((label == null && labelText != null) || (label != null && labelText == null)),
     assert(value.length == 0 || value.length == 2);
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `List<DateTime>` | `[]` | Empty or exactly 2 elements (assert enforced) |
| `onChanged` | `void Function(List<DateTime>)?` | `null` | Fires with sorted `[start, end]` |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `placeholder` | `String?` | `null` | Hint text in the text field |
| `prefixText` | `String?` | `null` | Inline text prefix |
| `prefixIcon` | `IconData?` | `null` | Mutually exclusive with `prefixWidget` |
| `prefixWidget` | `Widget?` | `null` | Mutually exclusive with `prefixIcon` |
| `onPrefixTap` | `VoidCallback?` | `null` | Tap handler for the prefix |
| `customChild` | `Widget?` | `null` | Custom trigger widget; wraps in `InkWell` |
| `disabled` | `bool` | `false` | Prevents opening the picker |
| `translations` | `Map<String, String>` | (see below) | Fallback strings when i18n unavailable |
| `overridesLayrzTranslations` | `bool` | `false` | Force use of `translations` map |
| `disabledDays` | `List<DateTime>` | `[]` | Specific dates blocked in the calendar |
| `datePattern` | `String` | `'%Y-%m-%d'` | Date portion display format |
| `timePattern` | `String?` | `null` | Time portion format; overrides `use24HourFormat` when set |
| `use24HourFormat` | `bool` | `false` | `true` → `%H:%M`, `false` → `%I:%M %p` |
| `patternSeparator` | `String` | `' '` | Separator between date and time portions |
| `hoverColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` hover color |
| `focusColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` focus color |
| `splashColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` splash color |
| `highlightColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` highlight color |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | `customChild` `InkWell` border radius |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `padding` | `EdgeInsets?` | `null` | Outer padding; defaults to `ThemedTextInput.outerPadding` |
| `firstDay` | `DateTime?` | `null` | Hard lower bound — earlier dates disabled |
| `lastDay` | `DateTime?` | `null` | Hard upper bound — later dates disabled |

---

## Dialog behavior

- Tab 1 (Date): two-tap calendar. First tap sets start date, second tap sets end date.
- Tab 2 (Time): two independent time sliders — one for start time, one for end time.
- Save result is always sorted `[earlier, later]`.
- Timezone: if `value.first` is `TZDateTime`, result dates are coerced to the same timezone.

---

## Translations map keys

Same as `ThemedDateTimePicker` — see `themed-datetime-picker/references/api.md`.
