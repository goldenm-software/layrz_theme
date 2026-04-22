# ThemedTimePicker — API Reference

Source: `lib/src/inputs/src/pickers/time/single.dart`

- `ThemedTimePicker` class — line 3

---

## Examples

```dart
// Basic 12-hour picker
ThemedTimePicker(
  labelText: 'Time',
  value: selectedTime,
  errors: context.getErrors(key: 'time'),
  onChanged: (time) => setState(() => selectedTime = time),
)

// 24-hour format
ThemedTimePicker(
  labelText: 'Time',
  value: selectedTime,
  use24HourFormat: true,
  onChanged: (time) => setState(() => selectedTime = time),
)

// Custom display pattern
ThemedTimePicker(
  labelText: 'Hour',
  value: selectedTime,
  use24HourFormat: true,
  pattern: '%Hh%M',
  onChanged: (time) => setState(() => selectedTime = time),
)

// No blink animation
ThemedTimePicker(
  labelText: 'Time',
  value: selectedTime,
  disableBlink: true,
  onChanged: (time) => setState(() => selectedTime = time),
)

// Disabled
ThemedTimePicker(
  labelText: 'Time',
  value: selectedTime,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedTimePicker({
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
    'layrz.timePicker.hours': 'Hours',
    'layrz.timePicker.minutes': 'Minutes',
  },
  this.overridesLayrzTranslations = false,
  this.pattern,
  this.use24HourFormat = false,
  this.hoverColor = Colors.transparent,
  this.focusColor = Colors.transparent,
  this.splashColor = Colors.transparent,
  this.highlightColor = Colors.transparent,
  this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  this.errors = const [],
  this.hideDetails = false,
  this.disableBlink = false,
  this.padding,
  this.dense = false,
}) : assert((label == null && labelText != null) || (label != null && labelText == null));
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `TimeOfDay?` | `null` | Currently selected time |
| `onChanged` | `void Function(TimeOfDay)?` | `null` | Fires only on Save tap |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `placeholder` | `String?` | `null` | Hint text when value is null |
| `prefixText` | `String?` | `null` | Inline text prefix |
| `prefixIcon` | `IconData?` | `null` | Mutually exclusive with `prefixWidget` |
| `prefixWidget` | `Widget?` | `null` | Mutually exclusive with `prefixIcon` |
| `onPrefixTap` | `VoidCallback?` | `null` | Tap handler for the prefix |
| `customChild` | `Widget?` | `null` | Custom trigger widget; wraps in `InkWell` |
| `disabled` | `bool` | `false` | Prevents opening the picker |
| `use24HourFormat` | `bool` | `false` | `true` → 24 h spinners + `%H:%M`; `false` → 12 h + AM/PM toggle + `%I:%M %p` |
| `pattern` | `String?` | `null` | Display format override; uses `DateTime.format()` extension — not `DateFormat` |
| `disableBlink` | `bool` | `false` | Disables the 700 ms blink animation on hour/minute display |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `padding` | `EdgeInsets?` | `null` | Outer padding; defaults to `ThemedTextInput.outerPadding` |
| `hoverColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` hover color |
| `focusColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` focus color |
| `splashColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` splash color |
| `highlightColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` highlight color |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | `customChild` `InkWell` border radius |
| `translations` | `Map<String, String>` | (see below) | Fallback strings when i18n unavailable |
| `overridesLayrzTranslations` | `bool` | `false` | Force use of `translations` map |

---

## Translations map keys

| Key | Default |
|---|---|
| `actions.cancel` | `'Cancel'` |
| `actions.save` | `'Save'` |
| `layrz.timePicker.hours` | `'Hours'` |
| `layrz.timePicker.minutes` | `'Minutes'` |

---

## Dialog behavior

- Dialog max size: 400×400 logical pixels.
- Initializes to `value` if set, or `TimeOfDay.now()` if null.
- Desktop: +/− buttons flank each spinner. Mobile (width < `kSmallGrid`): buttons hidden, user types digits.
- `onChanged` called only on Save tap — not on intermediate spinner changes.
- Suffix icon (`LayrzIcons.solarOutlineClockSquare`) is always shown; not configurable.

## Format tokens (DateTime.format extension)

| Token | Meaning |
|---|---|
| `%H` | 24 h hour (00–23) |
| `%I` | 12 h hour (01–12) |
| `%M` | Minutes (00–59) |
| `%p` | AM/PM |
