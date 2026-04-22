---
name: themed-color-picker
description: Use ThemedColorPicker in a layrz Flutter widget. Apply when adding a color selection field — opens a dialog with wheel and/or palette pickers.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.both`, `.wheel`) — never write the fully-qualified form (`ColorPickerType.wheel`).

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Any field where the user must pick a `Color` value
- Inline trigger via the standard field UI (color swatch prefix + palette icon suffix)
- Custom trigger via `customChild` (wraps any widget in an `InkWell`)

---

## Minimal usage

```dart
ThemedColorPicker(
  labelText: context.i18n.t('entity.color'),
  value: color,
  errors: context.getErrors(key: 'color'),
  onChanged: (value) {
    color = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Default picker types: `[.both, .wheel]` — shows both the palette grid and the color wheel.
- Falls back to `kPrimaryColor` when `value` is `null`.
- The field displays a colored swatch as a prefix and the hex string as text (readonly).
- `customChild` mode: any widget can be used as the trigger; the dialog still opens on tap.
- `saveText` / `cancelText` default to `"OK"` / `"Cancel"` — override with i18n strings.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// Wheel only (no palette)
ThemedColorPicker(
  labelText: context.i18n.t('entity.color'),
  value: color,
  enabledTypes: const [.wheel],
  onChanged: (value) {
    color = value;
    if (context.mounted) onChanged.call();
  },
)

// Custom child trigger
ThemedColorPicker(
  labelText: context.i18n.t('entity.color'),
  value: color,
  customChild: Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  onChanged: (value) {
    color = value;
    if (context.mounted) onChanged.call();
  },
)

// Localized button labels
ThemedColorPicker(
  labelText: context.i18n.t('entity.color'),
  value: color,
  saveText: context.i18n.t('actions.save'),
  cancelText: context.i18n.t('actions.cancel'),
  onChanged: (value) {
    color = value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedColorPicker(
  labelText: context.i18n.t('entity.color'),
  value: color,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
