# ThemedAvatarPicker — API Reference

Source: `lib/src/inputs/src/pickers/general/avatar.dart`

- `ThemedAvatarPicker` class — line 3

---

## Examples

```dart
// Basic avatar picker
ThemedAvatarPicker(
  labelText: 'Avatar',
  value: avatarBase64,
  errors: context.getErrors(key: 'avatar'),
  onChanged: (value) => setState(() => avatarBase64 = value),
)

// Custom child trigger
ThemedAvatarPicker(
  labelText: 'Photo',
  value: avatarBase64,
  customChild: CircleAvatar(radius: 30),
  onChanged: (value) => setState(() => avatarBase64 = value),
)

// Disabled
ThemedAvatarPicker(
  labelText: 'Avatar',
  value: avatarBase64,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedAvatarPicker({
  super.key,
  this.labelText,
  this.label,
  this.value,
  this.onChanged,
  this.disabled = false,
  this.errors = const [],
  this.hideDetails = false,
  this.customChild,
  this.hoverColor = Colors.transparent,
  this.focusColor = Colors.transparent,
  this.splashColor = Colors.transparent,
  this.highlightColor = Colors.transparent,
  this.borderRadius = const BorderRadius.all(Radius.circular(10)),
}) : assert((label == null && labelText != null) || (label != null && labelText == null));
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `String?` | `null` | Base64 data URI or URL of the current avatar |
| `onChanged` | `void Function(String?)?` | `null` | Fires with base64 data URI on select, `null` on clear |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `disabled` | `bool` | `false` | Prevents opening the picker; shows lock icon |
| `errors` | `List<String>` | `[]` | Validation messages shown below the widget |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `customChild` | `Widget?` | `null` | Custom trigger widget; wraps in `InkWell` |
| `hoverColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` hover color |
| `focusColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` focus color |
| `splashColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` splash color |
| `highlightColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` highlight color |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | `customChild` `InkWell` border radius |

---

## Behavior notes

- Default UI: 100×100 rounded square with elevation, centered label above.
- Upload icon shown when no value; avatar image shown when value is set.
- Red ✕ button (top-right) clears the avatar — fires `onChanged(null)`.
- Only image files are accepted (system picker configured with `FileType.image`).
- Result is always a `"data:<mimeType>;base64,<data>"` string.
