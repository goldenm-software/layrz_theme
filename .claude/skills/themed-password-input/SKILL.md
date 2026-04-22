---
name: themed-password-input
description: Use ThemedPasswordInput in a layrz Flutter widget. Apply when adding a password creation or login field — includes strength indicator and show/hide toggle.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.col6`, `.start`, `.left`) — never write the fully-qualified form (`Sizes.col6`, `WrapAlignment.start`).

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Password creation field (with strength indicator, default behavior)
- Login password field (`showLevels: false`)
- Password confirm field (`showLevels: false`, `autofillHints: const []`)

Never use `ThemedTextInput` with `obscureText: true` — always use this widget for passwords.

---

## Minimal usage

```dart
ThemedPasswordInput(
  labelText: context.i18n.t('entity.password'),
  value: password,
  errors: context.getErrors(key: 'password'),
  onChanged: (value) {
    password = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- `showLevels: true` (default) → strength icon + tooltip checklist (lowercase, uppercase, digit, special char, length). Set `false` to hide indicator while keeping the show/hide toggle.
- `autofillHints` defaults to both `newPassword` and `password`. For login: `[AutofillHints.password]`. For confirm fields: `const []`.
- Suffix area is reserved — no `prefixIcon`, `prefixWidget`, `suffixIcon`, or `suffixWidget` exposed.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// Login — no strength indicator
ThemedPasswordInput(
  labelText: context.i18n.t('auth.password'),
  value: password,
  showLevels: false,
  autofillHints: const [AutofillHints.password],
  errors: context.getErrors(key: 'password'),
  onChanged: (value) {
    password = value;
    if (context.mounted) onChanged.call();
  },
)

// Confirm field — no strength, no autofill
ThemedPasswordInput(
  labelText: context.i18n.t('auth.confirmPassword'),
  value: passwordConfirm,
  showLevels: false,
  autofillHints: const [],
  errors: context.getErrors(key: 'passwordConfirm'),
  onChanged: (value) {
    passwordConfirm = value;
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
