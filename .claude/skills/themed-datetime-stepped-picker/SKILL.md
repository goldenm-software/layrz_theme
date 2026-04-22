---
name: themed-datetime-stepped-picker
description: Use ThemedDateTimeSteppedPicker in a layrz Flutter widget. Apply when adding a date+time field that opens the calendar first, then the time picker as a second separate dialog.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Single date+time selection where you prefer two sequential dialogs (calendar → time picker)
- Mobile-friendly UX: each step is focused and full-dialog

For a single tabbed dialog (calendar + time in one) → use `ThemedDateTimePicker`. For date+time ranges → use `ThemedDateTimeRangePicker`.

---

## Minimal usage

```dart
ThemedDateTimeSteppedPicker(
  labelText: context.i18n.t('entity.datetime'),
  value: selectedDatetime,
  errors: context.getErrors(key: 'datetime'),
  onChanged: (value) {
    selectedDatetime = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- **Step 1:** Calendar dialog opens → user picks a date.
- **Step 2:** Time picker dialog opens automatically after date selection → user picks hour/minute.
- `disableTimePickerBlink: true` turns off the blinking cursor in the time picker.
- Default time format: 12-hour. Set `use24HourFormat: true` for 24-hour.
- Display pattern same as `ThemedDateTimePicker`: `'$datePattern$patternSeparator$timePattern'`.
- `firstDay` / `lastDay` constrain the calendar step.
- `customChild` wraps any widget in an `InkWell` that opens the flow.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// 24-hour format, no blink
ThemedDateTimeSteppedPicker(
  labelText: context.i18n.t('entity.datetime'),
  value: selectedDatetime,
  use24HourFormat: true,
  disableTimePickerBlink: true,
  errors: context.getErrors(key: 'datetime'),
  onChanged: (value) {
    selectedDatetime = value;
    if (context.mounted) onChanged.call();
  },
)

// With date limits
ThemedDateTimeSteppedPicker(
  labelText: context.i18n.t('entity.scheduledAt'),
  value: scheduledAt,
  firstDay: DateTime.now(),
  lastDay: DateTime.now().add(const Duration(days: 365)),
  onChanged: (value) {
    scheduledAt = value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedDateTimeSteppedPicker(
  labelText: context.i18n.t('entity.datetime'),
  value: selectedDatetime,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
