# ThemedTimeRangePicker — API Reference

Source: `lib/src/inputs/src/pickers/time/range.dart`

- `ThemedTimeRangePicker` class — line 3

---

## Examples

```dart
// Basic time range (empty initial)
ThemedTimeRangePicker(
  labelText: 'Time range',
  value: const [],
  errors: context.getErrors(key: 'timeRange'),
  onChanged: (range) => setState(() => timeRange = range),
)

// Pre-populated range
ThemedTimeRangePicker(
  labelText: 'Operating hours',
  value: const [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 17, minute: 0)],
  onChanged: (range) => setState(() => operatingHours = range),
)

// 24-hour format
ThemedTimeRangePicker(
  labelText: 'Shift window',
  value: timeRange,
  use24HourFormat: true,
  onChanged: (range) => setState(() => timeRange = range),
)

// Disabled
ThemedTimeRangePicker(
  labelText: 'Time range',
  value: timeRange,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedTimeRangePicker({
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
    'layrz.timePicker.hours': 'Hours',
    'layrz.timePicker.minutes': 'Minutes',
    'layrz.timePicker.start': 'Start time',
    'layrz.timePicker.end': 'End time',
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
}) : assert((label == null && labelText != null) || (label != null && labelText == null)),
     assert(value.length == 0 || value.length == 2);
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `List<TimeOfDay>` | `[]` | Empty or exactly 2 elements (assert enforced) |
| `onChanged` | `void Function(List<TimeOfDay>)?` | `null` | Fires with sorted `[start, end]` only when both are set on Save |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `placeholder` | `String?` | `null` | Hint text when value is empty |
| `prefixText` | `String?` | `null` | Inline text prefix |
| `prefixIcon` | `IconData?` | `null` | Mutually exclusive with `prefixWidget` |
| `prefixWidget` | `Widget?` | `null` | Mutually exclusive with `prefixIcon` |
| `onPrefixTap` | `VoidCallback?` | `null` | Tap handler for the prefix |
| `customChild` | `Widget?` | `null` | Custom trigger widget; wraps in `InkWell` |
| `disabled` | `bool` | `false` | Prevents opening the picker |
| `use24HourFormat` | `bool` | `false` | `true` → 24 h; `false` → 12 h + AM/PM |
| `pattern` | `String?` | `null` | Display format override |
| `disableBlink` | `bool` | `false` | Disables blink animation in both spinners |
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

| Key | Default | Used by |
|---|---|---|
| `actions.cancel` | `'Cancel'` | Both |
| `actions.save` | `'Save'` | Both |
| `layrz.timePicker.hours` | `'Hours'` | Both |
| `layrz.timePicker.minutes` | `'Minutes'` | Both |
| `layrz.timePicker.start` | `'Start time'` | Range only |
| `layrz.timePicker.end` | `'End time'` | Range only |

---

## Dialog behavior

- Two `_ThemedTimeUtility` spinners stacked vertically (Start / End label above each).
- Dialog max size: 400×430 (24 h) or 400×550 (12 h — extra height for AM/PM toggles).
- Result sorted by hour then minute before calling `onChanged`.
- `onChanged` not called if either spinner is still null when Save is tapped.
- Display: `"HH:MM - HH:MM"` joined with ` - `.
