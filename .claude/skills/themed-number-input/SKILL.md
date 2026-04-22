---
name: themed-number-input
description: Use ThemedNumberInput in a layrz Flutter widget. Apply when adding a numeric field with optional min/max bounds, step buttons, and decimal formatting.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Numeric fields: integers, decimals, quantities, prices, coordinates, percentages
- Value type: `num?`
- Never use raw `TextField` or `TextFormField` for numeric input — always use this widget.

For time span fields → use `ThemedDurationInput`.

---

## Minimal usage

```dart
ThemedNumberInput(
  labelText: context.i18n.t('entity.speed'),
  value: speed,
  errors: context.getErrors(key: 'speed'),
  onChanged: (value) {
    speed = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Renders a text field with − (prefix) and + (suffix) icon buttons for decrement/increment.
- `minimum` / `maximum` disable the ± buttons visually at the boundary — they do NOT block keyboard input. Add validation for hard limits.
- `step` controls the ± button increment amount (default: `1`).
- `onChanged` fires with `null` when field is cleared; not called for unparseable intermediate input.
- `format` requires `inputRegExp` — both must be set together (assert enforced at construction).
- `hidePrefixSuffixActions: true` hides ± buttons without disabling the field.
- `focusNode` lifecycle is the caller's responsibility — dispose it yourself.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// Integer with bounds
ThemedNumberInput(
  labelText: context.i18n.t('entity.quantity'),
  value: quantity,
  minimum: 0,
  maximum: 999,
  step: 1,
  maximumDecimalDigits: 0,
  errors: context.getErrors(key: 'quantity'),
  onChanged: (value) {
    quantity = value?.toInt();
    if (context.mounted) onChanged.call();
  },
)

// Decimal with comma separator and unit suffix
ThemedNumberInput(
  labelText: context.i18n.t('entity.temperature'),
  value: temperature,
  decimalSeparator: .comma,
  maximumDecimalDigits: 2,
  suffixText: '°C',
  errors: context.getErrors(key: 'temperature'),
  onChanged: (value) {
    temperature = value;
    if (context.mounted) onChanged.call();
  },
)

// Price with currency prefix
ThemedNumberInput(
  labelText: context.i18n.t('entity.price'),
  value: price,
  prefixText: '\$',
  maximumDecimalDigits: 2,
  minimum: 0,
  errors: context.getErrors(key: 'price'),
  onChanged: (value) {
    price = value;
    if (context.mounted) onChanged.call();
  },
)

// Free-form entry only (no ± buttons)
ThemedNumberInput(
  labelText: context.i18n.t('entity.offset'),
  value: offset,
  hidePrefixSuffixActions: true,
  onChanged: (value) {
    offset = value;
    if (context.mounted) onChanged.call();
  },
)

// Fine decimal steps (0.1 increments)
ThemedNumberInput(
  labelText: context.i18n.t('entity.opacity'),
  value: opacity,
  minimum: 0,
  maximum: 1,
  step: 0.1,
  maximumDecimalDigits: 1,
  onChanged: (value) {
    opacity = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
