# ThemedDateRangePicker — API Reference

Source: `lib/src/inputs/src/pickers/date/range.dart`

- `ThemedDateRangePicker` class — line 3

---

## Examples

```dart
// Basic date range (empty initial)
ThemedDateRangePicker(
  labelText: 'Date range',
  value: const [],
  errors: context.getErrors(key: 'dateRange'),
  onChanged: (value) => setState(() => dateRange = value),
)

// Pre-filled range
ThemedDateRangePicker(
  labelText: 'Date range',
  value: [DateTime(2025, 1, 1), DateTime(2025, 1, 31)],
  onChanged: (value) => setState(() => dateRange = value),
)

// With date limits
ThemedDateRangePicker(
  labelText: 'Report period',
  value: dateRange,
  firstDay: DateTime(2020, 1, 1),
  lastDay: DateTime.now(),
  onChanged: (value) => setState(() => dateRange = value),
)

// Custom format
ThemedDateRangePicker(
  labelText: 'Date range',
  value: dateRange,
  pattern: '%d/%m/%Y',
  onChanged: (value) => setState(() => dateRange = value),
)

// Custom child trigger
ThemedDateRangePicker(
  labelText: 'Date range',
  value: dateRange,
  customChild: Text(dateRange.isEmpty ? 'Select range' : '${dateRange.first} – ${dateRange.last}'),
  onChanged: (value) => setState(() => dateRange = value),
)

// Disabled
ThemedDateRangePicker(
  labelText: 'Date range',
  value: dateRange,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedDateRangePicker({
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
  this.translations = const {
    'actions.cancel': 'Cancel',
    'actions.save': 'Save',
    'layrz.monthPicker.year': 'Year {year}',
    'layrz.monthPicker.back': 'Previous year',
    'layrz.monthPicker.next': 'Next year',
  },
  this.overridesLayrzTranslations = false,
  this.pattern = '%Y-%m-%d',
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
| `onChanged` | `void Function(List<DateTime>)?` | `null` | Fires with `[start, end]` list |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `placeholder` | `String?` | `null` | Hint text in the text field |
| `prefixText` | `String?` | `null` | Inline text prefix |
| `prefixIcon` | `IconData?` | `null` | Mutually exclusive with `prefixWidget` |
| `prefixWidget` | `Widget?` | `null` | Mutually exclusive with `prefixIcon` |
| `onPrefixTap` | `VoidCallback?` | `null` | Tap handler for the prefix |
| `customChild` | `Widget?` | `null` | Custom trigger widget; wraps in `InkWell` |
| `disabled` | `bool` | `false` | Prevents opening the calendar |
| `translations` | `Map<String, String>` | (see above) | Fallback strings when i18n unavailable |
| `overridesLayrzTranslations` | `bool` | `false` | Force use of `translations` map even when i18n is present |
| `pattern` | `String` | `'%Y-%m-%d'` | Display format for both dates (strftime-style) |
| `hoverColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` hover color |
| `focusColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` focus color |
| `splashColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` splash color |
| `highlightColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` highlight color |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | `customChild` `InkWell` border radius |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `padding` | `EdgeInsets?` | `null` | Outer padding; defaults to `ThemedTextInput.outerPadding` |
| `firstDay` | `DateTime?` | `null` | Hard lower bound — all earlier dates disabled |
| `lastDay` | `DateTime?` | `null` | Hard upper bound — all later dates disabled |

---

## Selection behavior

1. First tap → sets anchor date (highlighted on calendar).
2. Second tap → completes the range. If second < first, they are automatically swapped.
3. Result is always `[earlier, later]`.
4. Timezone: if `value.first` is `TZDateTime`, all result dates are coerced to the same timezone.
