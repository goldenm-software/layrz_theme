# ThemedMonthRangePicker — API Reference

Source: `lib/src/inputs/src/pickers/month/range.dart`

- `ThemedMonthRangePicker` class — line 3

---

## Examples

```dart
// Basic multi-select (any months)
ThemedMonthRangePicker(
  labelText: 'Active months',
  value: activeMonths,
  errors: context.getErrors(key: 'months'),
  onChanged: (value) => setState(() => activeMonths = value),
)

// Consecutive range (two-tap: start → end, intermediate auto-filled)
ThemedMonthRangePicker(
  labelText: 'Period',
  value: selectedMonths,
  consecutive: true,
  minimum: ThemedMonth(year: 2023, month: .january),
  maximum: ThemedMonth(year: DateTime.now().year, month: Month.values[DateTime.now().month - 1]),
  onChanged: (value) => setState(() => selectedMonths = value),
)

// Free multi-select with disabled months
ThemedMonthRangePicker(
  labelText: 'Months',
  value: selectedMonths,
  disabledMonths: [
    ThemedMonth(year: 2024, month: .august),
    ThemedMonth(year: 2024, month: .september),
  ],
  onChanged: (value) => setState(() => selectedMonths = value),
)

// Pre-filled range
ThemedMonthRangePicker(
  labelText: 'Q1 2025',
  value: [
    ThemedMonth(year: 2025, month: .january),
    ThemedMonth(year: 2025, month: .february),
    ThemedMonth(year: 2025, month: .march),
  ],
  onChanged: (value) => setState(() => selectedMonths = value),
)

// Custom child trigger
ThemedMonthRangePicker(
  labelText: 'Months',
  value: selectedMonths,
  customChild: Text('${selectedMonths.length} months selected'),
  onChanged: (value) => setState(() => selectedMonths = value),
)

// Disabled
ThemedMonthRangePicker(
  labelText: 'Months',
  value: selectedMonths,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedMonthRangePicker({
  super.key,
  this.value = const [],
  this.consecutive = false,
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
    'actions.reset': 'Reset',
    'layrz.monthPicker.year': 'Year {year}',
    'layrz.monthPicker.back': 'Previous year',
    'layrz.monthPicker.next': 'Next year',
  },
  this.overridesLayrzTranslations = false,
  this.minimum,
  this.maximum,
  this.disabledMonths = const [],
  this.hoverColor = Colors.transparent,
  this.focusColor = Colors.transparent,
  this.splashColor = Colors.transparent,
  this.highlightColor = Colors.transparent,
  this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  this.errors = const [],
  this.hideDetails = false,
  this.padding,
}) : assert((label == null && labelText != null) || (label != null && labelText == null));
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `List<ThemedMonth>` | `[]` | Selected months; returned sorted |
| `consecutive` | `bool` | `false` | Two-tap range mode — auto-fills all months between taps |
| `onChanged` | `void Function(List<ThemedMonth>)?` | `null` | Fires with the updated sorted list |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `placeholder` | `String?` | `null` | Hint text in the text field |
| `prefixText` | `String?` | `null` | Inline text prefix |
| `prefixIcon` | `IconData?` | `null` | Mutually exclusive with `prefixWidget` |
| `prefixWidget` | `Widget?` | `null` | Mutually exclusive with `prefixIcon` |
| `onPrefixTap` | `VoidCallback?` | `null` | Tap handler for the prefix |
| `customChild` | `Widget?` | `null` | Custom trigger widget; wraps in `InkWell` |
| `disabled` | `bool` | `false` | Prevents opening the picker |
| `translations` | `Map<String, String>` | (see above) | Fallback strings when i18n unavailable; includes `actions.reset` |
| `overridesLayrzTranslations` | `bool` | `false` | Force use of `translations` map even when i18n is present |
| `minimum` | `ThemedMonth?` | `null` | All months before this are disabled |
| `maximum` | `ThemedMonth?` | `null` | All months after this are disabled |
| `disabledMonths` | `List<ThemedMonth>` | `[]` | Ignored when `consecutive: true` |
| `hoverColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` hover color |
| `focusColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` focus color |
| `splashColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` splash color |
| `highlightColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` highlight color |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | `customChild` `InkWell` border radius |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `padding` | `EdgeInsets?` | `null` | Outer padding; defaults to `ThemedTextInput.outerPadding` |

---

## Consecutive mode behavior

- First tap → sets the anchor month.
- Second tap → completes the range; all months between anchor and second tap are auto-filled.
- Only the first and last months in the selection can be deselected (middle ones are locked).
- Reset button in the dialog clears all selections.
- `disabledMonths` has no effect in consecutive mode.

---

## ThemedMonth & Month

See `themed-month-picker/references/api.md` for full `ThemedMonth` class and `Month` enum reference.

```dart
ThemedMonth(year: 2025, month: .april)
Month.values[DateTime.now().month - 1]  // current month
```
