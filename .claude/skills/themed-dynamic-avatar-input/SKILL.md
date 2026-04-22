---
name: themed-dynamic-avatar-input
description: Use ThemedDynamicAvatarInput in a layrz Flutter widget. Apply when adding a flexible avatar field that lets the user choose from URL, base64 image upload, icon, or emoji.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Entity needs a visual identity that can be one of multiple types (image URL, file upload, icon, or emoji)
- Value type: `AvatarInput?`

For icon-only → use `ThemedIconPicker`. For emoji-only → use `ThemedEmojiPicker`. For avatar image upload only → use `ThemedAvatarPicker`.

---

## Minimal usage

```dart
ThemedDynamicAvatarInput(
  labelText: context.i18n.t('entity.avatar'),
  value: selectedAvatar,
  errors: context.getErrors(key: 'avatar'),
  onChanged: (avatar) {
    selectedAvatar = avatar;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Opens a tabbed dialog (`ThemedTabView`) with one tab per enabled type plus an always-present `none` tab.
- Default enabled types: `[AvatarType.url, AvatarType.base64, AvatarType.icon, AvatarType.emoji]`.
- `AvatarType.none` is always prepended automatically — no need to add it to `enabledTypes`.
- `onChanged` fires immediately when the user picks a value in any tab — no separate Save/Cancel.
- Initial tab is determined by matching `value.type` against `enabledTypes`.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## AvatarType tabs

| Type | Content |
|---|---|
| `none` | No avatar; always shown |
| `url` | Text input for an image URL |
| `base64` | File picker → base64 image upload |
| `icon` | Searchable Layrz icon grid |
| `emoji` | Group-filtered emoji grid |

---

## Common patterns

```dart
// Icon or emoji only
ThemedDynamicAvatarInput(
  labelText: context.i18n.t('layer.avatar'),
  value: selectedAvatar,
  enabledTypes: [AvatarType.icon, AvatarType.emoji],
  onChanged: (avatar) {
    selectedAvatar = avatar;
    if (context.mounted) onChanged.call();
  },
)

// Full avatar with all types
ThemedDynamicAvatarInput(
  labelText: context.i18n.t('asset.avatar'),
  value: selectedAvatar,
  errors: context.getErrors(key: 'avatar'),
  onChanged: (avatar) {
    selectedAvatar = avatar;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedDynamicAvatarInput(
  labelText: context.i18n.t('entity.avatar'),
  value: selectedAvatar,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
- Do NOT combine with `ThemedIconPicker` or `ThemedEmojiPicker` on the same form field — the avatar input already has those tabs built in.
