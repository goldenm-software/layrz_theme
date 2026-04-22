# ThemedFilePicker — API Reference

Source: `lib/src/inputs/src/pickers/general/file.dart`

- `ThemedFilePicker` class — line 3

---

## Examples

```dart
// Basic file picker (any type)
ThemedFilePicker(
  labelText: 'Attachment',
  value: fileName,
  errors: context.getErrors(key: 'file'),
  onChanged: (base64, bytes) => setState(() {
    fileBase64 = base64;
    fileBytes = bytes;
  }),
)

// Images only
ThemedFilePicker(
  labelText: 'Image',
  value: fileName,
  acceptedTypes: FileType.image,
  onChanged: (base64, bytes) => setState(() => fileBase64 = base64),
)

// Custom extensions
ThemedFilePicker(
  labelText: 'CSV file',
  value: fileName,
  acceptedTypes: FileType.custom,
  allowedExtensions: ['csv', 'tsv'],
  onChanged: (base64, bytes) => setState(() {
    csvBase64 = base64;
    csvBytes = bytes;
  }),
)

// Disabled
ThemedFilePicker(
  labelText: 'Document',
  value: fileName,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedFilePicker({
  super.key,
  this.labelText,
  this.label,
  this.value,
  this.onChanged,
  this.disabled = false,
  this.errors = const [],
  this.hideDetails = false,
  this.isRequired = false,
  this.acceptedTypes = FileType.any,
  this.customChild,
  this.hoverColor = Colors.transparent,
  this.focusColor = Colors.transparent,
  this.splashColor = Colors.transparent,
  this.highlightColor = Colors.transparent,
  this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  this.allowedExtensions,
  this.padding,
}) : assert((label == null && labelText != null) || (label != null && labelText == null));
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `String?` | `null` | Displayed filename in the text field |
| `onChanged` | `void Function(String, List<int>)?` | `null` | Fires with `(base64DataUri, rawBytes)`; fires `("", [])` on clear |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `disabled` | `bool` | `false` | Prevents opening the picker |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `isRequired` | `bool` | `false` | Marks the field as required |
| `acceptedTypes` | `FileType` | `FileType.any` | File type filter for the system picker |
| `allowedExtensions` | `List<String>?` | `null` | Extension whitelist; only used when `acceptedTypes == FileType.custom` |
| `customChild` | `Widget?` | `null` | Custom trigger widget; wraps in `InkWell` |
| `hoverColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` hover color |
| `focusColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` focus color |
| `splashColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` splash color |
| `highlightColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` highlight color |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | `customChild` `InkWell` border radius |
| `padding` | `EdgeInsets?` | `null` | Outer padding; defaults to `ThemedTextInput.outerPadding` |

---

## FileType values (from `file_picker` package)

| Value | Description |
|---|---|
| `FileType.any` | All files |
| `FileType.image` | Image files |
| `FileType.video` | Video files |
| `FileType.audio` | Audio files |
| `FileType.media` | Images and videos |
| `FileType.custom` | Only extensions listed in `allowedExtensions` |

---

## Behavior notes

- Renders as a `ThemedTextInput` (read-only) showing the filename.
- Tapping when empty → opens system file picker.
- Tapping when a file is selected → clears the field, fires `onChanged("", [])`.
- Result base64 is always `"data:<mimeType>;base64,<data>"`.
- Raw bytes are available as `List<int>` in the second `onChanged` argument.
