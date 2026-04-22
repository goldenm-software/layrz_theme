# ThemedDateTimeSteppedPicker — API Reference

Source: `lib/src/inputs/src/pickers/datetime/single_stepped.dart`

- `ThemedDateTimeSteppedPicker` class — line 3

---

## Examples

```dart
// Basic stepped picker (12-hour)
ThemedDateTimeSteppedPicker(
  labelText: 'Date & time',
  value: selectedDatetime,
  errors: context.getErrors(key: 'datetime'),
  onChanged: (value) => setState(() => selectedDatetime = value),
)

// 24-hour, no blink
ThemedDateTimeSteppedPicker(
  labelText: 'Date & time',
  value: selectedDatetime,
  use24HourFormat: true,
  disableTimePickerBlink: true,
  onChanged: (value) => setState(() => selectedDatetime = value),
)

// With date limits
ThemedDateTimeSteppedPicker(
  labelText: 'Scheduled at',
  value: scheduledAt,
  firstDay: DateTime.now(),
  lastDay: DateTime.now().add(const Duration(days: 365)),
  onChanged: (value) => setState(() => scheduledAt = value),
)

// Custom date format
ThemedDateTimeSteppedPicker(
  labelText: 'Date & time',
  value: selectedDatetime,
  datePattern: '%d/%m/%Y',
  use24HourFormat: true,
  onChanged: (value) => setState(() => selectedDatetime = value),
)

// Custom child trigger
ThemedDateTimeSteppedPicker(
  labelText: 'Date & time',
  value: selectedDatetime,
  customChild: Text(selectedDatetime?.toString() ?? 'Pick date & time'),
  onChanged: (value) => setState(() => selectedDatetime = value),
)

// Disabled
ThemedDateTimeSteppedPicker(
  labelText: 'Date & time',
  value: selectedDatetime,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedDateTimeSteppedPicker({
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
  this.disableTimePickerBlink = false,
  this.firstDay,
  this.lastDay,
}) : assert((label == null && labelText != null) || (label != null && labelText == null));
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `DateTime?` | `null` | Supports `TZDateTime` |
| `onChanged` | `void Function(DateTime)?` | `null` | Fires with the selected datetime |
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
| `disabledDays` | `List<DateTime>` | `[]` | Specific dates blocked in the calendar step |
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
| `disableTimePickerBlink` | `bool` | `false` | Disables the blinking cursor in the time picker dialog |
| `firstDay` | `DateTime?` | `null` | Hard lower bound — earlier dates disabled |
| `lastDay` | `DateTime?` | `null` | Hard upper bound — later dates disabled |

---

## Stepped flow

1. Calendar dialog opens (400×400 max). User selects a day → dialog closes.
2. Time picker dialog opens immediately. User selects hour/minute → dialog closes.
3. `onChanged` fires with the combined `DateTime`.

---

## Translations map keys

Same as `ThemedDateTimePicker` — see `themed-datetime-picker/references/api.md`.
