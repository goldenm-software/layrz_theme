---
name: themed-datetime-range-picker
description: Use ThemedDateTimeRangePicker in a layrz Flutter widget. Apply when adding a date+time range selection field — picks start and end datetimes with separate time controls.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Date+time range selection (start datetime + end datetime)
- Dialog shows a two-tap calendar (first tap = start date, second tap = end date) with separate start/end time sliders

For date-only ranges → use `ThemedDateRangePicker`. For a single datetime → use `ThemedDateTimePicker`.

---

## Minimal usage

```dart
ThemedDateTimeRangePicker(
  labelText: context.i18n.t('entity.datetimeRange'),
  value: datetimeRange,
  errors: context.getErrors(key: 'datetimeRange'),
  onChanged: (value) {
    datetimeRange = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- `value` is `List<DateTime>` — must be empty or exactly 2 elements (assert enforced).
- Dialog has two tabs: **Date** (two-tap range calendar) and **Time** (two independent time sliders for start and end).
- Result is always sorted `[earlier, later]`.
- Default time format: 12-hour. Set `use24HourFormat: true` for 24-hour.
- Display: `"startDatetime - endDatetime"` formatted with the pattern.
- Timezone-aware: if `value.first` is `TZDateTime`, the result is returned in the same timezone.
- `customChild` wraps any widget in an `InkWell` that opens the dialog.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// 24-hour format
ThemedDateTimeRangePicker(
  labelText: context.i18n.t('entity.period'),
  value: period,
  use24HourFormat: true,
  errors: context.getErrors(key: 'period'),
  onChanged: (value) {
    period = value;
    if (context.mounted) onChanged.call();
  },
)

// With date limits
ThemedDateTimeRangePicker(
  labelText: context.i18n.t('entity.period'),
  value: period,
  firstDay: DateTime(2020, 1, 1),
  lastDay: DateTime.now(),
  onChanged: (value) {
    period = value;
    if (context.mounted) onChanged.call();
  },
)

// Empty initial value
ThemedDateTimeRangePicker(
  labelText: context.i18n.t('entity.period'),
  value: const [],
  onChanged: (value) {
    period = value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedDateTimeRangePicker(
  labelText: context.i18n.t('entity.period'),
  value: period,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
