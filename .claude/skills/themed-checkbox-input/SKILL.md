---
name: themed-checkbox-input
description: Use ThemedCheckboxInput in a layrz Flutter widget. Apply when adding a boolean toggle — supports checkbox, switch, and field (dropdown) styles.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.asSwitch`, `.asFlutterCheckbox`) — never write the fully-qualified form (`ThemedCheckboxInputStyle.asSwitch`).

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Boolean yes/no toggle in a form → `.asFlutterCheckbox` (default) or `.asCheckbox2`
- Toggle switch (Material Switch widget) → `.asSwitch`
- Boolean rendered as a dropdown select field → `.asField`

Never use raw `Checkbox`, `Switch`, or `SwitchListTile` — always use this widget for boolean inputs.

---

## Minimal usage

```dart
ThemedCheckboxInput(
  labelText: context.i18n.t('entity.isActive'),
  value: isActive,
  errors: context.getErrors(key: 'isActive'),
  onChanged: (value) {
    isActive = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Default style is `.asFlutterCheckbox` — standard Flutter `Checkbox` widget.
- `.asCheckbox2` uses the custom `ThemedAnimatedCheckbox` (newer design).
- `.asSwitch` renders a Material `Switch` with the label to the right.
- `.asField` delegates to `ThemedSelectInput<bool>` with Yes/No options — uses i18n keys `helpers.true` / `helpers.false`.
- `value` syncs to internal state on `didUpdateWidget`.
- Tapping the label text also toggles the value (GestureDetector wraps the label in switch/checkbox modes).
- Exactly one of `label` / `labelText` must be set — assert enforced (both null is allowed).

---

## Common patterns

```dart
// Switch style
ThemedCheckboxInput(
  labelText: context.i18n.t('entity.notifications'),
  value: notificationsEnabled,
  style: .asSwitch,
  errors: context.getErrors(key: 'notifications'),
  onChanged: (value) {
    notificationsEnabled = value;
    if (context.mounted) onChanged.call();
  },
)

// New design checkbox
ThemedCheckboxInput(
  labelText: context.i18n.t('entity.acceptTerms'),
  value: acceptTerms,
  style: .asCheckbox2,
  onChanged: (value) {
    acceptTerms = value;
    if (context.mounted) onChanged.call();
  },
)

// Dropdown field style (shows Yes/No picker)
ThemedCheckboxInput(
  labelText: context.i18n.t('entity.isPublic'),
  value: isPublic,
  style: .asField,
  errors: context.getErrors(key: 'isPublic'),
  onChanged: (value) {
    isPublic = value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedCheckboxInput(
  labelText: context.i18n.t('entity.isVerified'),
  value: isVerified,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
