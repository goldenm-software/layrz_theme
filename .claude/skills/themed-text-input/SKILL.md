---
name: themed-text-input
description: Use ThemedTextInput in a layrz Flutter widget. Apply when adding any free-text field, multiline textarea, or combobox autocomplete to a form or view.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.col6`, `.start`, `.left`) — never write the fully-qualified form (`Sizes.col6`, `WrapAlignment.start`).

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Any free-text form field (name, email, URL, notes, phone)
- Multiline textarea (`maxLines > 1`)
- Autocomplete / typeahead with a string list (`enableCombobox: true`)

For passwords → use `ThemedPasswordInput`. For search bars → use `ThemedSearchInput`.  
Never use raw `TextField` or `TextFormField`.

---

## Minimal usage

```dart
ThemedTextInput(
  labelText: context.i18n.t('entity.name'),
  value: name,
  errors: context.getErrors(key: 'name'),
  onChanged: (value) {
    name = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Exactly one of `label` / `labelText` must be set — assert enforced.
- `disabled: true` → appends `LayrzIcons.solarOutlineLockKeyhole` as suffix automatically. Do not add your own.
- `value` syncs to the internal `TextEditingController` on `didUpdateWidget` (only when no external `controller` provided).
- `validator` gates `onChanged` — if provided, `onChanged` fires only when `validator` returns `true`.
- `enableCombobox: true` → opens `OverlayEntry` on tap, overrides `onTap`. Reacts to live `choices` updates.
- `maxLines > 1` forces `floatingLabelBehavior: always`.
- `prefixIcon`/`prefixWidget` are mutually exclusive. Same for `suffixIcon`/`suffixWidget`.

---

## Common patterns

```dart
// Multiline textarea
ThemedTextInput(
  labelText: context.i18n.t('entity.description'),
  value: description,
  maxLines: 5,
  errors: context.getErrors(key: 'description'),
  onChanged: (value) {
    description = value;
    if (context.mounted) onChanged.call();
  },
)

// Combobox autocomplete
ThemedTextInput(
  labelText: context.i18n.t('entity.city'),
  value: city,
  enableCombobox: true,
  choices: citySuggestions,
  errors: context.getErrors(key: 'city'),
  onChanged: (value) {
    city = value;
    if (context.mounted) onChanged.call();
  },
)

// Prefix + suffix icons
ThemedTextInput(
  labelText: context.i18n.t('entity.url'),
  value: url,
  prefixIcon: LayrzIcons.solarOutlineLink,
  suffixIcon: LayrzIcons.solarOutlineCopy,
  onSuffixTap: () => Clipboard.setData(ClipboardData(text: url)),
  errors: context.getErrors(key: 'url'),
  onChanged: (value) {
    url = value;
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
