---
name: themed-datetime-picker
description: Use ThemedDateTimePicker in a layrz Flutter widget. Apply when adding a single date+time selection field — opens a tabbed dialog with calendar and time picker.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Single date + time selection (year, month, day, hour, minute)
- Tab-based dialog: "Date" tab (calendar) + "Time" tab (hour/minute sliders) shown together

For date only → use `ThemedDatePicker`. For date+time in two separate sequential dialogs → use `ThemedDateTimeSteppedPicker`. For date+time ranges → use `ThemedDateTimeRangePicker`.

---

## Minimal usage

```dart
ThemedDateTimePicker(
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

- Dialog has two tabs: **Date** (calendar) and **Time** (hour/minute sliders) — user switches between them freely before saving.
- Default time format: 12-hour (`%I:%M %p`). Set `use24HourFormat: true` for 24-hour (`%H:%M`).
- Display pattern is `'$datePattern$patternSeparator$timePattern'` — default `'%Y-%m-%d %I:%M %p'`.
- `firstDay` / `lastDay` constrain the calendar.
- Timezone-aware: if `value` is `TZDateTime`, the result is returned in the same timezone.
- `customChild` wraps any widget in an `InkWell` that opens the dialog.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// 24-hour format
ThemedDateTimePicker(
  labelText: context.i18n.t('entity.datetime'),
  value: selectedDatetime,
  use24HourFormat: true,
  errors: context.getErrors(key: 'datetime'),
  onChanged: (value) {
    selectedDatetime = value;
    if (context.mounted) onChanged.call();
  },
)

// With date limits
ThemedDateTimePicker(
  labelText: context.i18n.t('entity.scheduledAt'),
  value: scheduledAt,
  firstDay: DateTime.now(),
  lastDay: DateTime.now().add(const Duration(days: 365)),
  onChanged: (value) {
    scheduledAt = value;
    if (context.mounted) onChanged.call();
  },
)

// Custom display format
ThemedDateTimePicker(
  labelText: context.i18n.t('entity.datetime'),
  value: selectedDatetime,
  datePattern: '%d/%m/%Y',
  use24HourFormat: true,
  onChanged: (value) {
    selectedDatetime = value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedDateTimePicker(
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
