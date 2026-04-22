---
name: themed-file-picker
description: Use ThemedFilePicker in a layrz Flutter widget. Apply when adding a file upload field that opens a system file picker and returns base64 + raw bytes.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- File attachment fields (PDFs, documents, spreadsheets, any file type)
- When you need both base64 string and raw byte array from the selected file

For image-only avatar/photo upload → use `ThemedAvatarPicker`.

---

## Minimal usage

```dart
ThemedFilePicker(
  labelText: context.i18n.t('entity.file'),
  value: fileName,
  errors: context.getErrors(key: 'file'),
  onChanged: (base64, bytes) {
    fileBase64 = base64;
    fileBytes = bytes;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Renders as a `ThemedTextInput` showing the selected filename (read-only).
- Tapping the field opens the system file picker.
- `onChanged` fires with `(String base64, List<int> bytes)` — base64 is a `"data:<mimeType>;base64,<data>"` string.
- If a file is already selected, tapping clears it instead of opening the picker — fires `onChanged("", [])`.
- `acceptedTypes` controls which file types the picker shows (default: `FileType.any`).
- `allowedExtensions` works only when `acceptedTypes == FileType.custom`.
- `customChild` wraps any widget in an `InkWell` that opens the picker.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// Images only
ThemedFilePicker(
  labelText: context.i18n.t('entity.image'),
  value: fileName,
  acceptedTypes: FileType.image,
  onChanged: (base64, bytes) {
    fileBase64 = base64;
    if (context.mounted) onChanged.call();
  },
)

// Custom extensions (e.g. CSV only)
ThemedFilePicker(
  labelText: context.i18n.t('entity.csvFile'),
  value: fileName,
  acceptedTypes: FileType.custom,
  allowedExtensions: ['csv'],
  onChanged: (base64, bytes) {
    csvBase64 = base64;
    csvBytes = bytes;
    if (context.mounted) onChanged.call();
  },
)

// Required field
ThemedFilePicker(
  labelText: context.i18n.t('entity.document'),
  value: fileName,
  isRequired: true,
  errors: context.getErrors(key: 'document'),
  onChanged: (base64, bytes) {
    documentBase64 = base64;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedFilePicker(
  labelText: context.i18n.t('entity.file'),
  value: fileName,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
