---
name: themed-avatar-picker
description: Use ThemedAvatarPicker in a layrz Flutter widget. Apply when adding an image avatar/photo upload field that opens a system image picker and stores result as base64.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- User profile photo / entity avatar upload
- Any single image selection that stores result as a base64 data URI

For general file uploads (non-image, or needing raw bytes) → use `ThemedFilePicker`.

---

## Minimal usage

```dart
ThemedAvatarPicker(
  labelText: context.i18n.t('entity.avatar'),
  value: avatarBase64,
  errors: context.getErrors(key: 'avatar'),
  onChanged: (value) {
    avatarBase64 = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Displays a 100×100 rounded square that shows the current avatar or an upload icon.
- Tapping opens the system image picker (images only, single file).
- `onChanged` fires with a `"data:<mimeType>;base64,<data>"` string on selection, or `null` when cleared.
- A red ✕ button appears top-right when an image is loaded — tapping it clears the value.
- `disabled: true` shows a lock icon and prevents opening the picker.
- `customChild` wraps any widget in an `InkWell` that opens the picker.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// With custom child trigger
ThemedAvatarPicker(
  labelText: context.i18n.t('entity.avatar'),
  value: avatarBase64,
  customChild: CircleAvatar(
    backgroundImage: avatarBase64 != null ? NetworkImage(avatarBase64!) : null,
    child: avatarBase64 == null ? const Icon(Icons.person) : null,
  ),
  onChanged: (value) {
    avatarBase64 = value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedAvatarPicker(
  labelText: context.i18n.t('entity.avatar'),
  value: avatarBase64,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
