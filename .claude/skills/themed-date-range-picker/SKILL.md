---
name: themed-date-range-picker
description: Use ThemedDateRangePicker in a layrz Flutter widget. Apply when adding a date range selection field — user taps two dates to define start and end.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Date range selection (start date + end date)
- User taps first date, then second date to complete the range

For a single date → use `ThemedDatePicker`. For month ranges → use `ThemedMonthRangePicker`.

---

## Minimal usage

```dart
ThemedDateRangePicker(
  labelText: context.i18n.t('entity.dateRange'),
  value: dateRange,
  errors: context.getErrors(key: 'dateRange'),
  onChanged: (value) {
    dateRange = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- `value` is `List<DateTime>` — must be empty or exactly 2 elements (assert enforced).
- Displays as `"startDate - endDate"` formatted with `pattern` (default `'%Y-%m-%d'`).
- Two-tap selection: first tap sets the anchor date, second tap completes the range (order doesn't matter — earlier date becomes start).
- `firstDay` / `lastDay` set hard calendar limits.
- Timezone-aware: if start date is `TZDateTime`, the result is returned in the same timezone.
- `customChild` wraps any widget in an `InkWell` that opens the picker dialog.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// With date limits
ThemedDateRangePicker(
  labelText: context.i18n.t('entity.period'),
  value: period,
  firstDay: DateTime(2020, 1, 1),
  lastDay: DateTime.now(),
  errors: context.getErrors(key: 'period'),
  onChanged: (value) {
    period = value;
    if (context.mounted) onChanged.call();
  },
)

// Custom date format
ThemedDateRangePicker(
  labelText: context.i18n.t('entity.dateRange'),
  value: dateRange,
  pattern: '%d/%m/%Y',
  onChanged: (value) {
    dateRange = value;
    if (context.mounted) onChanged.call();
  },
)

// Empty initial value (no selection)
ThemedDateRangePicker(
  labelText: context.i18n.t('entity.dateRange'),
  value: const [],
  onChanged: (value) {
    dateRange = value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedDateRangePicker(
  labelText: context.i18n.t('entity.dateRange'),
  value: dateRange,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
