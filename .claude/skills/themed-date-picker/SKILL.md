---
name: themed-date-picker
description: Use ThemedDatePicker in a layrz Flutter widget. Apply when adding a single date selection field — opens a calendar dialog.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Single date selection (year + month + day)
- Inline calendar dialog triggered from a text field

For date ranges → use `ThemedDateRangePicker`. For month/year only → use `ThemedMonthPicker`.

---

## Minimal usage

```dart
ThemedDatePicker(
  labelText: context.i18n.t('entity.date'),
  value: selectedDate,
  errors: context.getErrors(key: 'date'),
  onChanged: (value) {
    selectedDate = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Displays selected date formatted with `pattern` (default `'%Y-%m-%d'`).
- Opens a `ThemedCalendar` dialog (400×400 max) on tap; suffix is a calendar icon.
- `disabledDays` blocks specific dates in the calendar.
- `firstDay` / `lastDay` set hard limits — all dates outside the range are disabled.
- Timezone-aware: if `value` is `TZDateTime`, the selected date is returned in the same timezone.
- `customChild` wraps any widget in an `InkWell` that opens the calendar.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// With date limits
ThemedDatePicker(
  labelText: context.i18n.t('entity.startDate'),
  value: startDate,
  firstDay: DateTime(2020, 1, 1),
  lastDay: DateTime.now(),
  errors: context.getErrors(key: 'startDate'),
  onChanged: (value) {
    startDate = value;
    if (context.mounted) onChanged.call();
  },
)

// Custom date format
ThemedDatePicker(
  labelText: context.i18n.t('entity.date'),
  value: selectedDate,
  pattern: '%d/%m/%Y',
  onChanged: (value) {
    selectedDate = value;
    if (context.mounted) onChanged.call();
  },
)

// Custom child trigger
ThemedDatePicker(
  labelText: context.i18n.t('entity.date'),
  value: selectedDate,
  customChild: ThemedButton(
    labelText: selectedDate?.toString() ?? 'Pick date',
    icon: LayrzIcons.solarOutlineCalendar,
    onTap: () {},
  ),
  onChanged: (value) {
    selectedDate = value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedDatePicker(
  labelText: context.i18n.t('entity.date'),
  value: selectedDate,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
