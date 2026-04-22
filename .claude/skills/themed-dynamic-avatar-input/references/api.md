# ThemedDynamicAvatarInput — API Reference

Source: `lib/src/inputs/src/general/dynamic_avatar_input.dart`

- `ThemedDynamicAvatarInput` class

---

## Examples

```dart
// Full avatar — all types
ThemedDynamicAvatarInput(
  labelText: 'Avatar',
  value: selectedAvatar,
  errors: context.getErrors(key: 'avatar'),
  onChanged: (avatar) => setState(() => selectedAvatar = avatar),
)

// Icon or emoji only
ThemedDynamicAvatarInput(
  labelText: 'Avatar',
  value: selectedAvatar,
  enabledTypes: [AvatarType.icon, AvatarType.emoji],
  onChanged: (avatar) => setState(() => selectedAvatar = avatar),
)

// Disabled
ThemedDynamicAvatarInput(
  labelText: 'Avatar',
  value: selectedAvatar,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedDynamicAvatarInput({
  super.key,
  this.labelText,
  this.label,
  this.value,
  this.onChanged,
  this.disabled = false,
  this.errors = const [],
  this.hideDetails = false,
  this.padding,
  this.enabledTypes = const [
    AvatarType.url,
    AvatarType.base64,
    AvatarType.icon,
    AvatarType.emoji,
  ],
  this.heightFactor = 0.7,
  this.maxHeight = 350,
}) : assert((label == null && labelText != null) || (label != null && labelText == null));
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `AvatarInput?` | `null` | Current avatar; `null` treated as `AvatarInput()` (type = none) |
| `onChanged` | `void Function(AvatarInput?)?` | `null` | Fires immediately when user picks in any tab |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `disabled` | `bool` | `false` | Prevents opening the dialog |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `padding` | `EdgeInsets?` | `null` | Outer padding |
| `enabledTypes` | `List<AvatarType>` | `[url, base64, icon, emoji]` | Tabs shown in dialog; `none` is always prepended automatically |
| `heightFactor` | `double` | `0.7` | Reserved for future use |
| `maxHeight` | `double` | `350` | Reserved for future use |

---

## AvatarInput structure (from `layrz_models`)

```dart
class AvatarInput {
  AvatarType type;   // none | url | base64 | icon | emoji
  String? url;       // for type == url
  String? base64;    // for type == base64 (data URI or raw base64)
  LayrzIcon? icon;   // for type == icon
  String? emoji;     // for type == emoji (single char)
}
```

Only one field is non-null at a time — the dialog clears the others on tab switch.

---

## AvatarType values

| Value | Tab content | i18n key suffix |
|---|---|---|
| `AvatarType.none` | No avatar — always shown, auto-prepended | `helpers.dynamicAvatar.types.none` |
| `AvatarType.url` | Text input for an image URL | `helpers.dynamicAvatar.types.URL` |
| `AvatarType.base64` | `ThemedAvatarPicker` (file → base64) | `helpers.dynamicAvatar.types.BASE64` |
| `AvatarType.icon` | Searchable Layrz icon grid | `helpers.dynamicAvatar.types.icon` |
| `AvatarType.emoji` | Group-filtered emoji grid | `helpers.dynamicAvatar.types.emoji` |

---

## Dialog behavior

- Uses `ThemedTabView` — one tab per `enabledTypes` entry plus the auto-prepended `none` tab.
- Initial tab determined by matching `value.type` in `enabledTypes`.
- `onChanged` fires inline (immediately on pick) — no Cancel/Save flow at the dialog level.
- The field preview (`ThemedAvatar`) reflects current state in real time.
