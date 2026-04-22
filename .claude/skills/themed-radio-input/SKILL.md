---
name: themed-radio-input
description: Use ThemedRadioInput in a layrz Flutter widget. Apply when adding a radio button group — renders options in a responsive grid with per-breakpoint column sizing.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.col6`, `.col4`) — never write the fully-qualified form (`Sizes.col6`).

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Single selection from a small, visible list of options (radio buttons)
- When all options should be visible at once (vs. a dropdown `ThemedSelectInput`)

For boolean yes/no → use `ThemedCheckboxInput`. For single-select with many options → use `ThemedSelectInput`.

---

## Minimal usage

```dart
ThemedRadioInput<String>(
  labelText: context.i18n.t('entity.role'),
  value: selectedRole,
  items: [
    ThemedSelectItem(value: 'admin', label: 'Admin'),
    ThemedSelectItem(value: 'user', label: 'User'),
    ThemedSelectItem(value: 'viewer', label: 'Viewer'),
  ],
  errors: context.getErrors(key: 'role'),
  onChanged: (value) {
    selectedRole = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- `items` is required — a `List<ThemedSelectItem<T>>`.
- Options are laid out via `ResponsiveRow.builder` + `ResponsiveCol` — responsive per breakpoint.
- Default column sizes: xs=`.col12`, sm=`.col6`, md=`.col4`, lg=`.col3`, xl=`.col2`.
- `value` is the currently selected `T?`. Pass `null` for no selection.
- Tapping the label text also selects the option.
- `disabled: true` → `onChanged` is silently ignored (no visual style change on individual options).
- Exactly one of `label` / `labelText` must be set — assert enforced (both null is allowed).

---

## Common patterns

```dart
// Two columns on all screens
ThemedRadioInput<String>(
  labelText: context.i18n.t('entity.status'),
  value: status,
  xsSize: .col6,
  smSize: .col6,
  mdSize: .col6,
  lgSize: .col6,
  xlSize: .col6,
  items: [
    ThemedSelectItem(value: 'active', label: context.i18n.t('status.active')),
    ThemedSelectItem(value: 'inactive', label: context.i18n.t('status.inactive')),
  ],
  onChanged: (value) {
    status = value;
    if (context.mounted) onChanged.call();
  },
)

// Full width (one per row)
ThemedRadioInput<int>(
  labelText: context.i18n.t('entity.priority'),
  value: priority,
  xsSize: .col12,
  smSize: .col12,
  mdSize: .col12,
  lgSize: .col12,
  xlSize: .col12,
  items: [
    ThemedSelectItem(value: 1, label: 'Low'),
    ThemedSelectItem(value: 2, label: 'Medium'),
    ThemedSelectItem(value: 3, label: 'High'),
  ],
  onChanged: (value) {
    priority = value;
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
