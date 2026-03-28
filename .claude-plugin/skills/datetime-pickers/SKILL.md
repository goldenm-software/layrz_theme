---
name: datetime-pickers
description: Use ThemedDateTimePicker, ThemedDateTimeRangePicker, or ThemedDateTimeSteppedPicker in a layrz
  Flutter widget. Apply when adding a combined date-and-time selection field.
---

## Overview

Three components cover all combined date+time selection needs:

| Component | State type | UX style | When to prefer it |
|---|---|---|---|
| `ThemedDateTimePicker` | `DateTime?` | Single tabbed dialog (Date tab / Time tab) | General purpose; user can switch freely between date and time |
| `ThemedDateTimeSteppedPicker` | `DateTime?` | Two sequential dialogs (calendar, then time) | When date and time feel like separate decisions; cleaner on mobile |
| `ThemedDateTimeRangePicker` | `List<DateTime>` | Single tabbed dialog with start/end time pickers | When the field represents a time interval (start → end) |

All three render as a read-only `ThemedTextInput` with a calendar icon suffix. Tapping opens the picker dialog.
`TZDateTime` (from `timezone` package) is preserved: when the incoming `value` is a `TZDateTime`, the result
returned by `onChanged` is also a `TZDateTime` using the same `Location`.

---

## Pattern composition — datePattern + patternSeparator + timePattern

The displayed text in the field is built as:

```
$datePattern$patternSeparator$timePattern
```

| Parameter | Default | Notes |
|---|---|---|
| `datePattern` | `'%Y-%m-%d'` | strftime-style pattern for the date portion |
| `patternSeparator` | `' '` (space) | Placed between date and time tokens |
| `timePattern` | auto | When `null`: `'%I:%M %p'` (12h) or `'%H:%M'` (24h) based on `use24HourFormat` |
| `use24HourFormat` | `false` | Ignored when an explicit `timePattern` is provided |

Examples:

```dart
// Result: "2024-06-15 02:30 PM"  (defaults)
ThemedDateTimePicker(value: dt, ...)

// Result: "15/06/2024 — 14:30"
ThemedDateTimePicker(
  datePattern: '%d/%m/%Y',
  patternSeparator: ' — ',
  timePattern: '%H:%M',
  ...
)

// Result: "2024-06-15 14:30"  (24h auto)
ThemedDateTimePicker(
  use24HourFormat: true,
  ...
)
```

---

## ThemedDateTimePicker — tabbed dialog

### Minimal usage

```dart
// State
DateTime? scheduledAt;

// Widget
ThemedDateTimePicker(
  labelText: context.i18n.t('entity.scheduledAt'),
  value: scheduledAt,
  onChanged: (dt) {
    scheduledAt = dt;
    if (context.mounted) onChanged.call();
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided. Mutually exclusive with `label`. |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Mutually exclusive with `labelText`. |
| `value` | `DateTime?` | `null` | Currently selected date+time. Accepts `TZDateTime`. |
| `onChanged` | `void Function(DateTime)?` | `null` | Returns a plain `DateTime` or `TZDateTime` (timezone preserved). |
| `disabled` | `bool` | `false` | Disables the field; tap does nothing. |
| `errors` | `List<String>` | `[]` | Validation error messages shown below the field. |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row. |
| `datePattern` | `String` | `'%Y-%m-%d'` | Display format for the date portion. |
| `timePattern` | `String?` | `null` | Display format for the time portion. Overrides `use24HourFormat`. |
| `use24HourFormat` | `bool` | `false` | Toggles 12h/24h when `timePattern` is null. |
| `patternSeparator` | `String` | `' '` | Separator between date and time in the displayed text. |
| `disabledDays` | `List<DateTime>` | `[]` | Days blocked from selection in the calendar. |
| `placeholder` | `String?` | `null` | Hint shown when `value` is null. |
| `prefixIcon` | `IconData?` | `null` | Icon at the start of the field. Mutually exclusive with `prefixWidget`. |
| `prefixWidget` | `Widget?` | `null` | Widget at the start of the field. Mutually exclusive with `prefixIcon`. |
| `prefixText` | `String?` | `null` | Text prefix inside the field. |
| `onPrefixTap` | `VoidCallback?` | `null` | Callback when the prefix is tapped. |
| `customChild` | `Widget?` | `null` | Replaces the text field with a custom widget that acts as the tap target. |
| `hoverColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set. |
| `focusColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set. |
| `splashColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set. |
| `highlightColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set. |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | Only applies when `customChild` is set. |
| `padding` | `EdgeInsets?` | `null` | Outer padding around the input. |
| `translations` | `Map<String, String>` | see Translation keys section | Fallback strings when `LayrzAppLocalizations` is absent. |
| `overridesLayrzTranslations` | `bool` | `false` | Forces use of `translations` map even when `LayrzAppLocalizations` is present. |

### Behavior notes

- The dialog shows two tabs: **Date** (calendar) and **Time** (drum/spinner pickers for hours and minutes).
- The user can switch between tabs freely before confirming. Both values are saved together on Save.
- If `value` is null, the dialog opens with today's date and current time pre-selected.
- Saving calls `onChanged` only when both a date and a time are set (both are always set when opening the dialog,
  so save always fires).
- The tab controller resets to the Date tab after saving.

### Common patterns

```dart
// 24-hour format, European date
ThemedDateTimePicker(
  labelText: context.i18n.t('event.startsAt'),
  value: event.startsAt,
  use24HourFormat: true,
  datePattern: '%d/%m/%Y',
  errors: context.getErrors(key: 'startsAt'),
  onChanged: (dt) {
    event.startsAt = dt;
    if (context.mounted) onChanged.call();
  },
)

// Block past days
ThemedDateTimePicker(
  labelText: context.i18n.t('task.dueAt'),
  value: task.dueAt,
  disabledDays: [
    for (int i = 1; i <= DateTime.now().day - 1; i++)
      DateTime(DateTime.now().year, DateTime.now().month, i),
  ],
  onChanged: (dt) {
    task.dueAt = dt;
    if (context.mounted) onChanged.call();
  },
)
```

---

## ThemedDateTimeSteppedPicker — sequential dialogs

### Minimal usage

```dart
// State
DateTime? appointmentAt;

// Widget
ThemedDateTimeSteppedPicker(
  labelText: context.i18n.t('entity.appointmentAt'),
  value: appointmentAt,
  onChanged: (dt) {
    appointmentAt = dt;
    if (context.mounted) onChanged.call();
  },
)
```

### Constructor — key parameters

All parameters from `ThemedDateTimePicker` apply, plus:

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `disableTimePickerBlink` | `bool` | `false` | Suppresses the blinking cursor animation in the time picker spinner. |

Parameters identical to `ThemedDateTimePicker` (same types, same defaults): `value`, `onChanged`, `labelText`,
`label`, `disabled`, `errors`, `hideDetails`, `datePattern`, `timePattern`, `use24HourFormat`,
`patternSeparator`, `disabledDays`, `placeholder`, `prefixIcon`, `prefixWidget`, `prefixText`, `onPrefixTap`,
`customChild`, `hoverColor`, `focusColor`, `splashColor`, `highlightColor`, `borderRadius`, `padding`,
`translations`, `overridesLayrzTranslations`.

### Behavior notes

- Dialog 1 is a calendar. Tapping any day immediately closes it and opens Dialog 2.
- Dialog 2 is the time picker. Confirming calls `onChanged`. Cancelling the time picker discards the whole
  selection (no partial save).
- Unlike `ThemedDateTimePicker`, the date is committed when the day is tapped — not on a Save button.
- `TZDateTime` is NOT preserved in `ThemedDateTimeSteppedPicker` — the result is always a plain `DateTime`.
  Use `ThemedDateTimePicker` when timezone preservation is required.
- Set `disableTimePickerBlink: true` in automated tests or when the blinking cursor causes visual noise in
  screenshot comparisons.

### Common patterns

```dart
// Stepped picker with 24-hour time, blink disabled for tests
ThemedDateTimeSteppedPicker(
  labelText: context.i18n.t('report.generatedAt'),
  value: report.generatedAt,
  use24HourFormat: true,
  disableTimePickerBlink: true,
  errors: context.getErrors(key: 'generatedAt'),
  onChanged: (dt) {
    report.generatedAt = dt;
    if (context.mounted) onChanged.call();
  },
)
```

---

## ThemedDateTimeRangePicker — start/end interval

### Minimal usage

```dart
// State — must be empty list OR exactly 2 elements (enforced by assert)
List<DateTime> period = [];

// Widget
ThemedDateTimeRangePicker(
  labelText: context.i18n.t('entity.period'),
  value: period,
  onChanged: (range) {
    period = range;
    if (context.mounted) onChanged.call();
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided. Mutually exclusive with `label`. |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Mutually exclusive with `labelText`. |
| `value` | `List<DateTime>` | `[]` | Must be empty or exactly length 2. Enforced by assert at construction time. |
| `onChanged` | `void Function(List<DateTime>)?` | `null` | Returns a sorted list of exactly 2 `DateTime` values: `[start, end]`. |
| `disabled` | `bool` | `false` | Disables the field. |
| `errors` | `List<String>` | `[]` | Validation error messages shown below the field. |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row. |
| `datePattern` | `String` | `'%Y-%m-%d'` | Display format for the date portion of each bound. |
| `timePattern` | `String?` | `null` | Display format for the time portion. Overrides `use24HourFormat`. |
| `use24HourFormat` | `bool` | `false` | Toggles 12h/24h when `timePattern` is null. |
| `patternSeparator` | `String` | `' '` | Separator between date and time tokens in the displayed text. |
| `disabledDays` | `List<DateTime>` | `[]` | Days blocked from selection in the calendar. |
| `placeholder` | `String?` | `null` | Hint shown when `value` is empty. |
| `prefixIcon` | `IconData?` | `null` | Mutually exclusive with `prefixWidget`. |
| `prefixWidget` | `Widget?` | `null` | Mutually exclusive with `prefixIcon`. |
| `prefixText` | `String?` | `null` | Text prefix inside the field. |
| `onPrefixTap` | `VoidCallback?` | `null` | Callback when the prefix is tapped. |
| `customChild` | `Widget?` | `null` | Replaces the text field with a custom widget. |
| `hoverColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set. |
| `focusColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set. |
| `splashColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set. |
| `highlightColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is set. |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | Only applies when `customChild` is set. |
| `padding` | `EdgeInsets?` | `null` | Outer padding around the input. |
| `translations` | `Map<String, String>` | see Translation keys section | Fallback strings. |
| `overridesLayrzTranslations` | `bool` | `false` | Forces `translations` map over `LayrzAppLocalizations`. |

### Behavior notes

- The displayed text joins both datetimes with ` - `: e.g. `"2024-06-01 08:00 AM - 2024-06-15 06:00 PM"`.
- The dialog has the same two-tab layout (Date / Time) as `ThemedDateTimePicker`, but the Time tab shows
  **two** time pickers stacked: one for the start time, one for the end time.
- On the Date tab, tapping the first day sets `startDate` and highlights it; tapping a second day sets
  `endDate` and fills the range highlight between the two. The user can re-tap to pick a new start.
- The result list is always sorted ascending before being returned: `[earlier, later]`.
- `TZDateTime` is preserved: when `value.first` is a `TZDateTime`, both `start` and `end` in the result use
  the same `Location`.
- `value.length` must be 0 or 2 — passing a list of length 1 throws an assertion error.

### Common patterns

```dart
// Range picker, 24h, with validation errors
ThemedDateTimeRangePicker(
  labelText: context.i18n.t('report.period'),
  value: report.period,
  use24HourFormat: true,
  errors: context.getErrors(key: 'period'),
  onChanged: (range) {
    report.period = range;
    if (context.mounted) onChanged.call();
  },
)

// Initialise from nullable start/end fields on a model
ThemedDateTimeRangePicker(
  labelText: context.i18n.t('shift.interval'),
  value: (shift.startAt != null && shift.endAt != null) ? [shift.startAt!, shift.endAt!] : [],
  onChanged: (range) {
    shift.startAt = range.first;
    shift.endAt = range.last;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Translation keys

All three components share the same set of required translation keys. `LayrzAppLocalizations` provides them
automatically. Only supply `translations` when `LayrzAppLocalizations` is not in the widget tree, or set
`overridesLayrzTranslations: true` to force custom strings.

| Key | Default (English) | Used in |
|---|---|---|
| `actions.cancel` | `'Cancel'` | Cancel button |
| `actions.save` | `'Save'` | Save button |
| `layrz.monthPicker.year` | `'Year {year}'` | Year label in month picker (use `{year}` placeholder) |
| `layrz.monthPicker.back` | `'Previous year'` | Year navigation |
| `layrz.monthPicker.next` | `'Next year'` | Year navigation |
| `layrz.datetimePicker.date` | `'Date'` | Date tab label |
| `layrz.datetimePicker.time` | `'Time'` | Time tab label |
| `layrz.timePicker.hours` | `'Hours'` | Hours label in time utility |
| `layrz.timePicker.minutes` | `'Minutes'` | Minutes label in time utility |
| `layrz.calendar.month.back` | `'Previous month'` | Calendar month navigation |
| `layrz.calendar.month.next` | `'Next month'` | Calendar month navigation |
| `layrz.calendar.today` | `'Today'` | Today button in calendar |
| `layrz.calendar.month` | `'View as month'` | Calendar view toggle |
| `layrz.calendar.pickMonth` | `'Pick a month'` | Month picker trigger |

---

## Integrating with layrz forms

```dart
// Single datetime
ThemedDateTimePicker(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName,
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (dt) {
    object.fieldName = dt;
    if (context.mounted) onChanged.call();
  },
)

// Stepped single datetime
ThemedDateTimeSteppedPicker(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName,
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (dt) {
    object.fieldName = dt;
    if (context.mounted) onChanged.call();
  },
)

// Range (store as List<DateTime> on the model)
ThemedDateTimeRangePicker(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName,   // List<DateTime>, empty or length 2
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (range) {
    object.fieldName = range;
    if (context.mounted) onChanged.call();
  },
)
```

Rules:
- Always guard `onChanged` body with `if (context.mounted)` before calling external callbacks.
- Use `context.i18n.t('entity.fieldName')` for `labelText`.
- Use `context.getErrors(key: 'fieldName')` for `errors`.
- `label` and `labelText` are mutually exclusive — the constructor asserts exactly one is set.
- Never use raw Material pickers (`showDatePicker`, `showTimePicker`) — always use these components.

---

## Choosing between the three

| Scenario | Use |
|---|---|
| User picks a single datetime, may want to tweak date and time independently | `ThemedDateTimePicker` |
| User picks a single datetime, date and time feel like two separate decisions | `ThemedDateTimeSteppedPicker` |
| User picks a start datetime AND an end datetime | `ThemedDateTimeRangePicker` |
| `TZDateTime` timezone must be round-tripped through the picker | `ThemedDateTimePicker` or `ThemedDateTimeRangePicker` |
| You need to disable the time picker animation (e.g., for tests) | `ThemedDateTimeSteppedPicker` (has `disableTimePickerBlink`) |
| The field represents a reporting window, shift, or booking interval | `ThemedDateTimeRangePicker` |

**Never** mix these widgets for the same field. Pick one and keep it consistent throughout the form.
