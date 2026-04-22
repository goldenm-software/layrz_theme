---
name: themed-month-range-picker
description: Use ThemedMonthRangePicker in a layrz Flutter widget. Apply when adding a multi-month selection field — supports both arbitrary selection and consecutive range mode.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.january`) — never write the fully-qualified form (`Month.january`).

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Selection of multiple months (e.g. a reporting window or subscription period)
- `consecutive: false` (default) — pick any combination of months freely
- `consecutive: true` — two-tap mode: pick start month then end month; all months between are auto-filled

For a single month → use `ThemedMonthPicker`. For day-level ranges → use `ThemedDateRangePicker`.

---

## Minimal usage

```dart
ThemedMonthRangePicker(
  labelText: context.i18n.t('entity.months'),
  value: selectedMonths,
  errors: context.getErrors(key: 'months'),
  onChanged: (value) {
    selectedMonths = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- `value` is `List<ThemedMonth>` — defaults to `const []`.
- Displays the selected months as a comma-separated list (sorted, de-duplicated).
- Dialog has year navigation; each of the 12 month cells toggles selection.
- `consecutive: true` → first tap sets anchor, second tap completes range and auto-fills intermediate months.
- `consecutive: true` → only first and last selected months can be deselected (middle months are locked).
- A **Reset** button in the dialog clears all selections.
- `minimum` / `maximum` bound the selectable range.
- `disabledMonths` is ignored when `consecutive: true`.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// Consecutive range mode (two-tap: start → end)
ThemedMonthRangePicker(
  labelText: context.i18n.t('entity.period'),
  value: selectedMonths,
  consecutive: true,
  minimum: ThemedMonth(year: 2023, month: .january),
  maximum: ThemedMonth(year: DateTime.now().year, month: Month.values[DateTime.now().month - 1]),
  errors: context.getErrors(key: 'period'),
  onChanged: (value) {
    selectedMonths = value;
    if (context.mounted) onChanged.call();
  },
)

// Free multi-select (any months, any years)
ThemedMonthRangePicker(
  labelText: context.i18n.t('entity.activeMonths'),
  value: activeMonths,
  disabledMonths: [
    ThemedMonth(year: 2024, month: .august),
  ],
  onChanged: (value) {
    activeMonths = value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedMonthRangePicker(
  labelText: context.i18n.t('entity.months'),
  value: selectedMonths,
  disabled: true,
)
```

---

## ThemedMonth construction

```dart
ThemedMonth(year: 2025, month: .april)
ThemedMonth(year: DateTime.now().year, month: Month.values[DateTime.now().month - 1])
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
