# ThemedMonthPicker — API Reference

Source: `lib/src/inputs/src/pickers/month/single.dart`

- `ThemedMonthPicker` class — line 3
- `ThemedMonth` class — line ~220
- `Month` enum — line ~200

---

## Examples

```dart
// Basic month picker
ThemedMonthPicker(
  labelText: 'Month',
  value: selectedMonth,
  errors: context.getErrors(key: 'month'),
  onChanged: (value) => setState(() => selectedMonth = value),
)

// With min/max bounds
ThemedMonthPicker(
  labelText: 'Billing month',
  value: billingMonth,
  minimum: ThemedMonth(year: 2023, month: .january),
  maximum: ThemedMonth(year: DateTime.now().year, month: Month.values[DateTime.now().month - 1]),
  onChanged: (value) => setState(() => billingMonth = value),
)

// With specific disabled months
ThemedMonthPicker(
  labelText: 'Month',
  value: selectedMonth,
  disabledMonths: [
    ThemedMonth(year: 2024, month: .february),
    ThemedMonth(year: 2024, month: .march),
  ],
  onChanged: (value) => setState(() => selectedMonth = value),
)

// Custom child trigger
ThemedMonthPicker(
  labelText: 'Month',
  value: selectedMonth,
  customChild: Text(selectedMonth?.toString() ?? 'Select month'),
  onChanged: (value) => setState(() => selectedMonth = value),
)

// Disabled
ThemedMonthPicker(
  labelText: 'Month',
  value: selectedMonth,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedMonthPicker({
  super.key,
  this.value,
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
| `value` | `ThemedMonth?` | `null` | Selected month+year |
| `onChanged` | `void Function(ThemedMonth)?` | `null` | Fires with the selected `ThemedMonth` |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `placeholder` | `String?` | `null` | Hint text in the text field |
| `prefixText` | `String?` | `null` | Inline text prefix |
| `prefixIcon` | `IconData?` | `null` | Mutually exclusive with `prefixWidget` |
| `prefixWidget` | `Widget?` | `null` | Mutually exclusive with `prefixIcon` |
| `onPrefixTap` | `VoidCallback?` | `null` | Tap handler for the prefix |
| `customChild` | `Widget?` | `null` | Custom trigger widget; wraps in `InkWell` |
| `disabled` | `bool` | `false` | Prevents opening the picker |
| `translations` | `Map<String, String>` | (see above) | Fallback strings when i18n unavailable |
| `overridesLayrzTranslations` | `bool` | `false` | Force use of `translations` map even when i18n is present |
| `minimum` | `ThemedMonth?` | `null` | All months before this are disabled |
| `maximum` | `ThemedMonth?` | `null` | All months after this are disabled |
| `disabledMonths` | `List<ThemedMonth>` | `[]` | Specific months to block |
| `hoverColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` hover color |
| `focusColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` focus color |
| `splashColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` splash color |
| `highlightColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` highlight color |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | `customChild` `InkWell` border radius |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `padding` | `EdgeInsets?` | `null` | Outer padding; defaults to `ThemedTextInput.outerPadding` |

---

## ThemedMonth class

```dart
const ThemedMonth({
  required Month month,
  required int year,  // assert: year >= 0
})
```

| Member | Description |
|---|---|
| `month` | `Month` enum value |
| `year` | Integer year |
| `toString()` | Returns `'year-month'` |
| `==`, `<`, `>`, `<=`, `>=` | Comparison operators |
| `compareTo(ThemedMonth)` | For sorting |

---

## Month enum

```
.january, .february, .march, .april, .may, .june,
.july, .august, .september, .october, .november, .december
```

Access current month: `Month.values[DateTime.now().month - 1]`
