# ThemedDatePicker — API Reference

Source: `lib/src/inputs/src/pickers/date/single.dart`

- `ThemedDatePicker` class — line 3

---

## Examples

```dart
// Basic single date
ThemedDatePicker(
  labelText: 'Date',
  value: selectedDate,
  errors: context.getErrors(key: 'date'),
  onChanged: (value) => setState(() => selectedDate = value),
)

// With date limits
ThemedDatePicker(
  labelText: 'Start date',
  value: startDate,
  firstDay: DateTime(2020, 1, 1),
  lastDay: DateTime.now(),
  onChanged: (value) => setState(() => startDate = value),
)

// Custom format
ThemedDatePicker(
  labelText: 'Date',
  value: selectedDate,
  pattern: '%d/%m/%Y',
  onChanged: (value) => setState(() => selectedDate = value),
)

// Specific disabled days
ThemedDatePicker(
  labelText: 'Date',
  value: selectedDate,
  disabledDays: [
    DateTime(2025, 1, 1),
    DateTime(2025, 12, 25),
  ],
  onChanged: (value) => setState(() => selectedDate = value),
)

// Custom child trigger
ThemedDatePicker(
  labelText: 'Date',
  value: selectedDate,
  customChild: Container(
    padding: const EdgeInsets.all(8),
    child: Text(selectedDate?.toString() ?? 'Pick a date'),
  ),
  onChanged: (value) => setState(() => selectedDate = value),
)

// With prefix icon
ThemedDatePicker(
  labelText: 'Date',
  value: selectedDate,
  prefixIcon: LayrzIcons.solarOutlineCalendar,
  onChanged: (value) => setState(() => selectedDate = value),
)

// Disabled
ThemedDatePicker(
  labelText: 'Date',
  value: selectedDate,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedDatePicker({
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
  this.disabledDays = const [],
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
}) : assert((label == null && labelText != null) || (label != null && labelText == null));
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `DateTime?` | `null` | Selected date; supports `TZDateTime` |
| `onChanged` | `void Function(DateTime)?` | `null` | Fires with the selected date |
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
| `disabledDays` | `List<DateTime>` | `[]` | Specific dates blocked in the calendar |
| `pattern` | `String` | `'%Y-%m-%d'` | Display format (strftime-style) |
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
