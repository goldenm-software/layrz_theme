---
name: file-media-pickers
description: Use ThemedAvatarPicker, ThemedFilePicker, or ThemedColorPicker in a layrz Flutter widget. Apply when adding an image upload, file upload, or color selection field.
---

## Overview

| Component | State type | `onChanged` signature | When to use |
|---|---|---|---|
| `ThemedAvatarPicker` | `String?` (base64 data URI) | `void Function(String?)?` | Image-only upload stored as base64; displayed as a 100×100 avatar |
| `ThemedFilePicker` | `String?` (file name display) | `void Function(String, List<int>)?` | Any file upload; caller receives both a base64 data URI and a raw byte array |
| `ThemedColorPicker` | `Color?` | `void Function(Color)?` | Color selection via a dialog powered by `flutter_colorpicker` |

All three follow the same `label`/`labelText` exclusivity rule, `disabled`, `errors`, `hideDetails`, and `customChild` pattern.

---

## ThemedAvatarPicker

### Minimal usage

```dart
// State
String? avatarValue;

// Widget
ThemedAvatarPicker(
  labelText: 'Avatar',
  value: avatarValue,
  onChanged: (v) {
    avatarValue = v;
    if (context.mounted) onChanged.call();
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Exactly one must be set. |
| `value` | `String?` | `null` | Base64 data URI (`data:mime;base64,...`) or an HTTP URL |
| `onChanged` | `void Function(String?)?` | `null` | Receives the data URI string, or `null` when deleted |
| `disabled` | `bool` | `false` | Shows a lock icon; disables tapping |
| `errors` | `List<String>` | `[]` | Validation messages rendered below the avatar |
| `hideDetails` | `bool` | `false` | Hides the errors row |
| `customChild` | `Widget?` | `null` | Replaces the 100×100 card with a custom widget (see customChild pattern) |
| `hoverColor` | `Color` | `Colors.transparent` | Only active when `customChild` is set |
| `focusColor` | `Color` | `Colors.transparent` | Only active when `customChild` is set |
| `splashColor` | `Color` | `Colors.transparent` | Only active when `customChild` is set |
| `highlightColor` | `Color` | `Colors.transparent` | Only active when `customChild` is set |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | Ink splash radius; only active when `customChild` is set |

### Behavior notes

- Renders a **100×100 container** with elevation. Empty state shows an upload icon (`solarOutlineUpload`); disabled state shows a lock icon (`solarOutlineLockKeyhole`).
- On tap, opens the native file picker filtered to `FileType.image`. The selected file is parsed via `compute(parseFileToBase64, file)` off the main thread and stored as `"data:<mimeType>;base64,<data>"`.
- A **delete button** (top-right, red circle) appears with a fade-in animation (`AnimationController`, 300 ms) once a value is present. Tapping it calls `onChanged(null)` and fades the button out.
- `onChanged` receives `null` on delete; always null-guard when updating model fields.

### Common patterns

```dart
// Form field with validation
ThemedAvatarPicker(
  labelText: context.i18n.t('user.avatar'),
  value: user.avatarUrl,
  errors: context.getErrors(key: 'avatarUrl'),
  onChanged: (v) {
    user.avatarUrl = v;
    if (context.mounted) onChanged.call();
  },
)

// Disabled (view-only mode)
ThemedAvatarPicker(
  labelText: context.i18n.t('user.avatar'),
  value: user.avatarUrl,
  disabled: true,
)
```

---

## ThemedFilePicker

### Minimal usage

```dart
// State
String? fileName;        // display only
String? fileDataUri;     // stored value
List<int> fileBytes = [];

// Widget
ThemedFilePicker(
  labelText: 'Attachment',
  value: fileName,
  onChanged: (dataUri, bytes) {
    fileDataUri = dataUri;
    fileBytes = bytes;
    fileName = dataUri.isEmpty ? null : 'file';
    if (context.mounted) onChanged.call();
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided |
| `label` | `Widget?` | — | Required unless `labelText` is provided |
| `value` | `String?` | `null` | The file **name** shown in the text field (not the data URI) |
| `onChanged` | `void Function(String, List<int>)?` | `null` | First arg: base64 data URI. Second arg: raw bytes. Both are `""` / `[]` when cleared. |
| `disabled` | `bool` | `false` | Disables the input |
| `errors` | `List<String>` | `[]` | Validation messages |
| `hideDetails` | `bool` | `false` | Hides the errors row |
| `isRequired` | `bool` | `false` | Shows a required indicator |
| `acceptedTypes` | `FileType` | `FileType.any` | Filter applied to the native file picker |
| `allowedExtensions` | `List<String>?` | `null` | Only used when `acceptedTypes == FileType.custom` |
| `padding` | `EdgeInsets?` | `null` | Outer padding passed to the inner `ThemedTextInput` |
| `customChild` | `Widget?` | `null` | Replaces the text input with a custom widget |
| `hoverColor` | `Color` | `Colors.transparent` | Only active when `customChild` is set |
| `focusColor` | `Color` | `Colors.transparent` | Only active when `customChild` is set |
| `splashColor` | `Color` | `Colors.transparent` | Only active when `customChild` is set |
| `highlightColor` | `Color` | `Colors.transparent` | Only active when `customChild` is set |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | Ink splash radius; only active when `customChild` is set |

### Behavior notes

- Renders as a `ThemedTextInput` (readonly). Prefix icon is always `solarOutlineFile`. Suffix icon is a **paperclip** (`solarOutlinePaperclip2`) when empty, and an **eraser** (`solarOutlineEraserSquare`) when a file is selected.
- **Tapping the eraser clears the field** — `onChanged("", [])` is called without reopening the picker.
- On pick, both `parseFileToBase64` and `parseFileToByteArray` run via `compute()` off the main thread. Both results are passed together in one `onChanged` call.
- `value` is the **file name** for display only. Store the data URI and/or bytes yourself in state.
- To restrict extensions: set `acceptedTypes: FileType.custom` and pass `allowedExtensions: ['pdf', 'docx']`.

### Common patterns

```dart
// PDF/Word only
ThemedFilePicker(
  labelText: context.i18n.t('document.file'),
  value: doc.fileName,
  acceptedTypes: FileType.custom,
  allowedExtensions: ['pdf', 'doc', 'docx'],
  errors: context.getErrors(key: 'file'),
  onChanged: (dataUri, bytes) {
    doc.fileDataUri = dataUri;
    doc.fileBytes = bytes;
    if (context.mounted) onChanged.call();
  },
)

// Any file, required
ThemedFilePicker(
  labelText: context.i18n.t('report.attachment'),
  value: report.fileName,
  isRequired: true,
  onChanged: (dataUri, bytes) {
    report.attachment = dataUri;
    if (context.mounted) onChanged.call();
  },
)
```

---

## ThemedColorPicker

### Minimal usage

```dart
// State
Color? selectedColor;

// Widget
ThemedColorPicker(
  labelText: 'Color',
  value: selectedColor,
  onChanged: (color) {
    selectedColor = color;
    if (context.mounted) onChanged.call();
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided |
| `label` | `Widget?` | — | Required unless `labelText` is provided |
| `value` | `Color?` | `null` | Currently selected color. Falls back to `kPrimaryColor` internally if null. |
| `onChanged` | `void Function(Color)?` | `null` | Called with the confirmed color when the dialog is saved |
| `disabled` | `bool` | `false` | Disables the input |
| `errors` | `List<String>` | `[]` | Validation messages |
| `hideDetails` | `bool` | `false` | Hides the errors row |
| `padding` | `EdgeInsets?` | `null` | Outer padding passed to the inner `ThemedTextInput` |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `prefixIcon` | `IconData?` | `null` | Additional icon before the color box prefix widget |
| `onPrefixTap` | `VoidCallback?` | `null` | Callback when the prefix area is tapped |
| `placeholder` | `String?` | `null` | Placeholder text for the text field |
| `saveText` | `String` | `"OK"` | Label for the confirm button in the picker dialog |
| `cancelText` | `String` | `"Cancel"` | Label for the cancel button in the picker dialog |
| `enabledTypes` | `List<ColorPickerType>` | `[ColorPickerType.both, ColorPickerType.wheel]` | Which picker tabs are shown in the dialog |
| `maxWidth` | `double` | `400` | Max width of the picker dialog |
| `customChild` | `Widget?` | `null` | Replaces the text input with a custom widget |
| `hoverColor` | `Color` | `Colors.transparent` | Only active when `customChild` is set |
| `focusColor` | `Color` | `Colors.transparent` | Only active when `customChild` is set |
| `splashColor` | `Color` | `Colors.transparent` | Only active when `customChild` is set |
| `highlightColor` | `Color` | `Colors.transparent` | Only active when `customChild` is set |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | Ink splash radius; only active when `customChild` is set |

### Behavior notes

- Renders as a readonly `ThemedTextInput` showing the hex value (e.g. `#FF8200`) and a small color box as the prefix widget. Suffix icon is always `solarOutlinePalette2`.
- Opens a `showDialog` containing a `flutter_colorpicker` `ColorPicker`. Shades selection, tonal palette, and opacity are **disabled**. Copy format is `numHexRRGGBB`.
- The dialog has its own Cancel / Save buttons (`ThemedButton.cancel` and `ThemedButton.save`). `onChanged` is only called when Save is tapped — cancelling leaves state unchanged.
- Available `ColorPickerType` values: `both`, `primary`, `accent`, `bw`, `custom`, `wheel`. Only types listed in `enabledTypes` are active.
- If `value` is `null`, the internal state initializes to `kPrimaryColor` (`#001e60`).

### Common patterns

```dart
// Wheel only (no material swatches)
ThemedColorPicker(
  labelText: context.i18n.t('brand.primaryColor'),
  value: brand.primaryColor,
  enabledTypes: [ColorPickerType.wheel],
  errors: context.getErrors(key: 'primaryColor'),
  onChanged: (color) {
    brand.primaryColor = color;
    if (context.mounted) onChanged.call();
  },
)

// Localized dialog buttons
ThemedColorPicker(
  labelText: context.i18n.t('asset.color'),
  value: asset.color,
  saveText: context.i18n.t('general.confirm'),
  cancelText: context.i18n.t('general.cancel'),
  onChanged: (color) {
    asset.color = color;
    if (context.mounted) onChanged.call();
  },
)
```

---

## customChild pattern

All three components support replacing their default UI with an arbitrary widget via `customChild`. When provided, the component wraps `customChild` in an `InkWell` and delegates taps to the picker logic. The default UI (avatar card, text input) is not rendered.

Use `customChild` when the standard trigger widget doesn't fit the design — e.g., an icon button in a toolbar, a card tile, or a table cell.

```dart
// Avatar picker triggered by a small icon button
ThemedAvatarPicker(
  labelText: 'Photo',
  value: user.photo,
  customChild: IconButton(
    icon: const Icon(Icons.camera_alt),
    onPressed: null, // taps are handled by the wrapping InkWell
  ),
  splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
  hoverColor: Theme.of(context).primaryColor.withOpacity(0.05),
  onChanged: (v) {
    user.photo = v;
    if (context.mounted) onChanged.call();
  },
)

// Color picker triggered by a colored container in a list tile
ThemedColorPicker(
  labelText: 'Color',
  value: item.color,
  customChild: Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: item.color ?? Colors.grey,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.black12),
    ),
  ),
  borderRadius: BorderRadius.circular(8),
  onChanged: (color) {
    item.color = color;
    if (context.mounted) onChanged.call();
  },
)
```

**Rules for customChild:**
- `hoverColor`, `focusColor`, `splashColor`, `highlightColor`, and `borderRadius` only take effect when `customChild` is provided.
- Do not put `GestureDetector` or `InkWell` inside `customChild` — the wrapping `InkWell` handles all taps.
- `disabled: true` suppresses the tap even with `customChild`.

---

## Integrating with layrz forms

```dart
// Avatar picker
ThemedAvatarPicker(
  labelText: context.i18n.t('entity.avatarUrl'),
  value: object.avatarUrl,
  errors: context.getErrors(key: 'avatarUrl'),
  onChanged: (v) {
    object.avatarUrl = v;
    if (context.mounted) onChanged.call();
  },
)

// File picker — store data URI in the model, display name separately
ThemedFilePicker(
  labelText: context.i18n.t('entity.attachment'),
  value: object.attachmentName,
  errors: context.getErrors(key: 'attachment'),
  onChanged: (dataUri, bytes) {
    object.attachment = dataUri;
    object.attachmentName = dataUri.isEmpty ? null : object.attachmentName;
    if (context.mounted) onChanged.call();
  },
)

// Color picker
ThemedColorPicker(
  labelText: context.i18n.t('entity.color'),
  value: object.color,
  errors: context.getErrors(key: 'color'),
  onChanged: (color) {
    object.color = color;
    if (context.mounted) onChanged.call();
  },
)
```

Always guard `onChanged` with `if (context.mounted)`. Always use `context.i18n.t('entity.fieldName')` for `labelText`. Always pass `errors: context.getErrors(key: 'fieldName')` for validation.

---

## Choosing between the three

- Use `ThemedAvatarPicker` when the field stores a **profile image or logo**, displayed as a small square avatar. Output is a base64 data URI or URL.
- Use `ThemedFilePicker` when the field stores **any file** (document, spreadsheet, binary). Output is a base64 data URI plus raw bytes — store whichever the backend expects.
- Use `ThemedColorPicker` when the field stores a **`Color`** value — theme colors, brand colors, category colors.
- Never use raw `FilePicker`, `file_picker`, `showColorPickerDialog`, or `flutter_colorpicker` directly — always use these components.
- `ThemedAvatarPicker` is image-only (`FileType.image`). For non-image files that need a preview, use `ThemedFilePicker` with `acceptedTypes: FileType.image`.

---

## Platform setup (suggest to dev — never apply automatically)

When adding `ThemedFilePicker` or `ThemedAvatarPicker`, always warn the developer about the required platform permissions. Do NOT edit entitlement or manifest files yourself — show the exact snippet and let the dev decide.

### macOS — file-access entitlement

Without this, the picker throws `PlatformException(ENTITLEMENT_NOT_FOUND, ...)` at runtime. The macOS sandbox blocks all file-system access by default.

Tell the developer:

> Add the following entitlement to both `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements` (inside `<dict>`):
>
> ```xml
> <key>com.apple.security.files.user-selected.read-write</key>
> <true/>
> ```
>
> Use `read-only` if the app only reads files; `read-write` is the safe default for upload pickers.
> A full hot restart is required after this change — hot reload is not enough.

Check both files first. If the key is already present, no action is needed — just confirm it to the dev.
