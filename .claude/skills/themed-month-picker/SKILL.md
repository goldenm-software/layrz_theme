---
name: themed-month-picker
description: Use ThemedMonthPicker in a layrz Flutter widget. Apply when adding a month + year selection field — opens a grid dialog with month buttons and year navigation.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.january`, `.february`) — never write the fully-qualified form (`Month.january`).

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Month + year selection (no specific day)
- Billing periods, reporting months, subscription start

For a specific day → use `ThemedDatePicker`. For month ranges → use `ThemedMonthRangePicker`.

---

## Minimal usage

```dart
ThemedMonthPicker(
  labelText: context.i18n.t('entity.month'),
  value: selectedMonth,
  errors: context.getErrors(key: 'month'),
  onChanged: (value) {
    selectedMonth = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- `value` is `ThemedMonth?` — a `{month: Month, year: int}` object.
- Displays the selected month name + year (e.g. `"April 2025"`), localized via i18n.
- Dialog shows a 12-cell grid; year navigation via arrow buttons.
- `minimum` / `maximum` bound the selectable range by `ThemedMonth`.
- `disabledMonths` blocks specific months.
- `customChild` wraps any widget in an `InkWell` that opens the picker.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// With min/max bounds
ThemedMonthPicker(
  labelText: context.i18n.t('entity.billingMonth'),
  value: billingMonth,
  minimum: ThemedMonth(year: 2023, month: .january),
  maximum: ThemedMonth(year: DateTime.now().year, month: .values[DateTime.now().month - 1]),
  errors: context.getErrors(key: 'billingMonth'),
  onChanged: (value) {
    billingMonth = value;
    if (context.mounted) onChanged.call();
  },
)

// Specific disabled months
ThemedMonthPicker(
  labelText: context.i18n.t('entity.month'),
  value: selectedMonth,
  disabledMonths: [
    ThemedMonth(year: 2024, month: .february),
    ThemedMonth(year: 2024, month: .march),
  ],
  onChanged: (value) {
    selectedMonth = value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedMonthPicker(
  labelText: context.i18n.t('entity.month'),
  value: selectedMonth,
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
