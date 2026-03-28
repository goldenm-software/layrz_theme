---
name: time-pickers
description: Use ThemedTimePicker or ThemedTimeRangePicker in a layrz Flutter widget. Apply when adding a time-of-day selection field.
---

## Overview

Two components cover all time-of-day selection needs:

| Component | State type | `onChanged` signature | When to use |
|---|---|---|---|
| `ThemedTimePicker` | `TimeOfDay?` | `void Function(TimeOfDay)` | Single time value |
| `ThemedTimeRangePicker` | `List<TimeOfDay>` (empty or exactly 2) | `void Function(List<TimeOfDay>)` | Start + end time pair |

Both open a custom dialog with hour/minute spinners (+/− buttons on desktop, direct keyboard input on mobile). Never use Flutter's built-in `showTimePicker` — always use these components.

---

## ThemedTimePicker — single time value

### Minimal usage

```dart
// State
TimeOfDay? selectedTime;

// Widget
ThemedTimePicker(
  labelText: context.i18n.t('entity.fieldName'),
  value: selectedTime,
  onChanged: (time) {
    if (context.mounted) setState(() => selectedTime = time);
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided. Mutually exclusive with `label`. |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Mutually exclusive with `labelText`. |
| `value` | `TimeOfDay?` | `null` | Currently selected time; `null` renders placeholder |
| `onChanged` | `void Function(TimeOfDay)?` | `null` | Callback — receives the confirmed time (never null) |
| `use24HourFormat` | `bool` | `false` | `true` = 24 h spinners; `false` = 12 h + AM/PM toggle |
| `pattern` | `String?` | `null` | Display format string. Defaults to `'%H:%M'` (24 h) or `'%I:%M %p'` (12 h) |
| `disableBlink` | `bool` | `false` | Disables the 700 ms blink animation on the hour/minute display |
| `disabled` | `bool` | `false` | Greys out and disables tap |
| `errors` | `List<String>` | `[]` | Validation error messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `padding` | `EdgeInsets?` | `null` | Outer padding override |
| `placeholder` | `String?` | `null` | Placeholder text shown when `value` is null |
| `prefixText` | `String?` | `null` | Static text prefix inside the field |
| `prefixIcon` | `IconData?` | `null` | Icon prefix. Mutually exclusive with `prefixWidget`. |
| `prefixWidget` | `Widget?` | `null` | Widget prefix. Mutually exclusive with `prefixIcon`. |
| `onPrefixTap` | `VoidCallback?` | `null` | Callback when the prefix is tapped |
| `customChild` | `Widget?` | `null` | Replaces the text field entirely; tapping it opens the dialog |
| `hoverColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set |
| `focusColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set |
| `splashColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set |
| `highlightColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | Only applies when `customChild` is set |
| `translations` | `Map<String, String>` | see below | Fallback strings when `LayrzAppLocalizations` is absent |
| `overridesLayrzTranslations` | `bool` | `false` | Forces `translations` map over `LayrzAppLocalizations` |

### Behavior notes

- The dialog opens via `showDialog`. It initializes the spinner to `value` if set, or `TimeOfDay.now()` if `value` is null.
- `onChanged` is only called when the user taps **Save** — not on every spinner change.
- The suffix icon (`LayrzIcons.solarOutlineClockSquare`) is always rendered; it is not configurable.
- On desktop the dialog shows +/− buttons alongside each spinner. On mobile (width < `kSmallGrid`) the buttons are hidden and the user types digits directly.
- `disableBlink: true` is useful in automated tests or accessibility-focused contexts where the 700 ms blink animation is distracting.

### Common patterns

```dart
// 24-hour mode
ThemedTimePicker(
  labelText: context.i18n.t('schedule.startTime'),
  value: model.startTime,
  use24HourFormat: true,
  onChanged: (time) {
    model.startTime = time;
    if (context.mounted) onChanged.call();
  },
)

// Custom display format (hours only)
ThemedTimePicker(
  labelText: context.i18n.t('shift.hour'),
  value: model.hour,
  use24HourFormat: true,
  pattern: '%H:00',
  onChanged: (time) {
    model.hour = TimeOfDay(hour: time.hour, minute: 0);
    if (context.mounted) onChanged.call();
  },
)

// Custom trigger widget
ThemedTimePicker(
  labelText: context.i18n.t('alarm.time'),
  value: selectedTime,
  customChild: Chip(label: Text(selectedTime?.format(context) ?? 'Set time')),
  onChanged: (time) {
    if (context.mounted) setState(() => selectedTime = time);
  },
)
```

---

## ThemedTimeRangePicker — start + end time pair

### Minimal usage

```dart
// State — always empty or exactly 2 elements
List<TimeOfDay> timeRange = [];

// Widget
ThemedTimeRangePicker(
  labelText: context.i18n.t('entity.timeRange'),
  value: timeRange,
  onChanged: (range) {
    if (context.mounted) setState(() => timeRange = range);
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided. Mutually exclusive with `label`. |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Mutually exclusive with `labelText`. |
| `value` | `List<TimeOfDay>` | `const []` | Must be empty or exactly 2 elements — enforced by assert |
| `onChanged` | `void Function(List<TimeOfDay>)?` | `null` | Callback — receives sorted `[start, end]` pair; never called with 0 or 1 elements |
| `use24HourFormat` | `bool` | `false` | Propagated to both inner time utility widgets |
| `pattern` | `String?` | `null` | Display format. Defaults to `'%H:%M'` (24 h) or `'%I:%M %p'` (12 h) |
| `disableBlink` | `bool` | `false` | Disables blink animation in both spinners |
| `disabled` | `bool` | `false` | Greys out and disables tap |
| `errors` | `List<String>` | `[]` | Validation error messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row |
| `padding` | `EdgeInsets?` | `null` | Outer padding override |
| `placeholder` | `String?` | `null` | Placeholder text when `value` is empty |
| `prefixText` | `String?` | `null` | Static text prefix inside the field |
| `prefixIcon` | `IconData?` | `null` | Icon prefix. Mutually exclusive with `prefixWidget`. |
| `prefixWidget` | `Widget?` | `null` | Widget prefix. Mutually exclusive with `prefixIcon`. |
| `onPrefixTap` | `VoidCallback?` | `null` | Callback when the prefix is tapped |
| `customChild` | `Widget?` | `null` | Replaces the text field entirely; tapping it opens the dialog |
| `hoverColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set |
| `focusColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set |
| `splashColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set |
| `highlightColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | Only applies when `customChild` is set |
| `translations` | `Map<String, String>` | see below | Fallback strings when `LayrzAppLocalizations` is absent |
| `overridesLayrzTranslations` | `bool` | `false` | Forces `translations` map over `LayrzAppLocalizations` |

### Behavior notes

- The dialog renders two `_ThemedTimeUtility` spinners stacked vertically (Start / End), each updating an independent local `TimeOfDay?` variable.
- **Auto-sort**: before calling `onChanged`, the two values are sorted by hour then minute. The list you receive in `onChanged` is always `[earliest, latest]` — you do not need to sort manually.
- `onChanged` is only called if **both** start and end have been set when the user taps Save. If either is still null, the callback is not fired.
- The displayed field text is `"HH:MM - HH:MM"` (formatted with `pattern`). When `value` is empty the field is blank/placeholder.
- Dialog constraints: `maxWidth: 400`, `maxHeight: 430` (24 h) or `550` (12 h — extra height for AM/PM toggles).

### Common patterns

```dart
// 24-hour range with form integration
ThemedTimeRangePicker(
  labelText: context.i18n.t('shift.operatingHours'),
  value: model.operatingHours,
  use24HourFormat: true,
  errors: context.getErrors(key: 'operatingHours'),
  onChanged: (range) {
    model.operatingHours = range;
    if (context.mounted) onChanged.call();
  },
)

// Pre-populate with existing range (must be exactly 2 elements)
final existingRange = [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 17, minute: 0)];

ThemedTimeRangePicker(
  labelText: context.i18n.t('schedule.window'),
  value: existingRange,
  onChanged: (range) {
    if (context.mounted) setState(() => selectedRange = range);
  },
)
```

---

## 12h vs 24h format

| Aspect | 12 h (`use24HourFormat: false`, default) | 24 h (`use24HourFormat: true`) |
|---|---|---|
| Hours spinner range | 1–12 (period-relative) | 0–23 |
| AM/PM toggle | Shown below spinners | Hidden |
| Default `pattern` | `'%I:%M %p'` | `'%H:%M'` |
| Dialog max height (range) | 550 px | 430 px |
| `TimeOfDay.hour` returned | Always 0–23 (Flutter internal) | Always 0–23 (Flutter internal) |

The `pattern` parameter uses `DateTime.format()` from the `layrz_theme` extension — not `DateFormat`. Use `%I` for 12 h hours, `%H` for 24 h hours, `%M` for minutes, `%p` for AM/PM.

To override only the display pattern without changing the spinner behavior, pass `pattern` independently of `use24HourFormat`:

```dart
// 24 h spinners but display as "08h30"
ThemedTimePicker(
  labelText: context.i18n.t('departure.time'),
  value: model.departureTime,
  use24HourFormat: true,
  pattern: '%Hh%M',
  onChanged: (time) {
    model.departureTime = time;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Translation keys

Both components resolve text via `LayrzAppLocalizations` first, then fall back to the `translations` map, then fall back to the key string itself.

| Key | Default English | Used by |
|---|---|---|
| `actions.cancel` | `Cancel` | Both |
| `actions.save` | `Save` | Both |
| `layrz.timePicker.hours` | `Hours` | Both (column label) |
| `layrz.timePicker.minutes` | `Minutes` | Both (column label) |
| `layrz.timePicker.start` | `Start time` | `ThemedTimeRangePicker` only |
| `layrz.timePicker.end` | `End time` | `ThemedTimeRangePicker` only |

When `LayrzAppLocalizations` is configured project-wide you do not need to pass `translations`. Supply it only in isolated widgets or tests that lack the localizations delegate.

To force your own strings over the app-wide delegate (rare), set `overridesLayrzTranslations: true` and provide all required keys in `translations`.

---

## Integrating with layrz forms

### Single time

```dart
ThemedTimePicker(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName,
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (time) {
    object.fieldName = time;
    if (context.mounted) onChanged.call();
  },
)
```

### Time range

```dart
ThemedTimeRangePicker(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName,          // List<TimeOfDay>, empty or exactly 2 elements
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (range) {
    object.fieldName = range;        // already sorted [start, end]
    if (context.mounted) onChanged.call();
  },
)
```

### Guards and constraints

- Always guard `onChanged` with `if (context.mounted)` before calling any state mutation or external callback.
- `label` and `labelText` are mutually exclusive — the constructor enforces this with an assert. Pick one.
- `prefixIcon` and `prefixWidget` are mutually exclusive — never supply both.
- The `value` of `ThemedTimeRangePicker` must satisfy `value.length == 0 || value.length == 2`. Never pass a single-element list; the assert will throw in debug mode.
- Do not call Flutter's `showTimePicker` anywhere in the codebase. Use `ThemedTimePicker` exclusively.
