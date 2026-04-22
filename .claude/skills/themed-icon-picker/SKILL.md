---
name: themed-icon-picker
description: Use ThemedIconPicker in a layrz Flutter widget. Apply when adding a field that lets the user pick a Layrz icon from the full Solar icon set or a filtered subset.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Single icon selection from the Layrz icon set (Solar icons)
- Value type: `LayrzIcon?`

For emoji selection → use `ThemedEmojiPicker`. For a flexible avatar (icon/emoji/url/base64) → use `ThemedDynamicAvatarInput`.

---

## Minimal usage

```dart
ThemedIconPicker(
  labelText: context.i18n.t('entity.icon'),
  value: selectedIcon,
  errors: context.getErrors(key: 'icon'),
  onChanged: (icon) {
    selectedIcon = icon;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Opens a 500×700 dialog with a searchable scrolling list of icons.
- Search filters by `LayrzIcon.name` (case-insensitive).
- Auto-scrolls to the currently selected icon on open.
- Tapping an icon closes the dialog immediately — no explicit Save needed.
- `allowedIcons` restricts the picker to a specific subset when non-empty.
- `customChild` wraps any widget in an `InkWell` that opens the picker.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// Restrict to a project-defined subset
ThemedIconPicker(
  labelText: context.i18n.t('asset.markerIcon'),
  value: selectedIcon,
  allowedIcons: kAllowedMarkerIcons,
  errors: context.getErrors(key: 'markerIcon'),
  onChanged: (icon) {
    selectedIcon = icon;
    if (context.mounted) onChanged.call();
  },
)

// Custom trigger
ThemedIconPicker(
  labelText: context.i18n.t('entity.icon'),
  value: selectedIcon,
  customChild: ThemedAvatar(icon: selectedIcon?.iconData, size: 48),
  onChanged: (icon) {
    selectedIcon = icon;
    if (context.mounted) onChanged.call();
  },
)

// Dense / compact
ThemedIconPicker(
  labelText: context.i18n.t('entity.icon'),
  value: selectedIcon,
  dense: true,
  onChanged: (icon) {
    selectedIcon = icon;
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
