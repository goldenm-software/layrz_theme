---
name: icon-emoji-avatar-inputs
description: >
  Use ThemedIconPicker, ThemedEmojiPicker, ThemedDynamicAvatarInput, or ThemedDynamicCredentialsInput in a layrz
  Flutter widget. Apply when adding an icon picker, emoji picker, dynamic avatar composer, or dynamic credentials form.
---

## Overview

| Component | State type | `onChanged` signature | When to use |
|---|---|---|---|
| `ThemedIconPicker` | `LayrzIcon?` | `void Function(LayrzIcon)` | Let user pick a Layrz icon from the full icon set or a filtered subset |
| `ThemedEmojiPicker` | `String?` (single emoji char) | `void Function(String)` | Let user pick a single emoji from all groups or a filtered subset |
| `ThemedDynamicAvatarInput` | `AvatarInput?` | `void Function(AvatarInput?)` | Let user compose an avatar from url / base64 / icon / emoji — any combination of the four types |
| `ThemedDynamicCredentialsInput` | `Map<String, dynamic>` | `void Function(Map<String, dynamic>)` | Render a dynamic credentials form driven by a `List<CredentialField>` schema |

All four types come from `package:layrz_models/layrz_models.dart` (imported transitively through `layrz_theme`).

---

## ThemedIconPicker

### Minimal usage

```dart
// State
LayrzIcon? _icon;

// Widget
ThemedIconPicker(
  labelText: context.i18n.t('entity.icon'),
  value: _icon,
  errors: context.getErrors(key: 'icon'),
  onChanged: (icon) {
    setState(() => _icon = icon);
    if (context.mounted) onChanged.call();
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided. Mutually exclusive with `label`. |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Mutually exclusive with `labelText`. |
| `value` | `LayrzIcon?` | `null` | Currently selected icon |
| `onChanged` | `void Function(LayrzIcon)?` | `null` | Called when user picks an icon and confirms |
| `disabled` | `bool` | `false` | Disables the input |
| `errors` | `List<String>` | `[]` | Validation error messages shown below the field |
| `isRequired` | `bool` | `false` | Shows required indicator |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row |
| `padding` | `EdgeInsets?` | `null` | Outer padding; defaults to `ThemedTextInput.outerPadding` |
| `focusNode` | `FocusNode?` | `null` | External focus node |
| `allowedIcons` | `List<LayrzIcon>` | `[]` | When non-empty, restricts the picker to this subset only |
| `customChild` | `Widget?` | `null` | Replaces the text field trigger with a custom widget wrapped in `InkWell` |
| `hoverColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is provided |
| `focusColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is provided |
| `splashColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is provided |
| `highlightColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is provided |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | Only applies when `customChild` is provided |
| `translations` | `Map<String, String>` | cancel/save/search defaults | Fallback strings when `LayrzAppLocalizations` is absent |
| `overridesLayrzTranslations` | `bool` | `false` | Forces `translations` map over the app i18n even when i18n is present |

### Behavior notes

- The dialog opens at up to 500 × 700 logical pixels.
- The icon list is the full `iconMapping` from `layrz_icons`, sorted alphabetically by name. When `allowedIcons` is non-empty it is used as a whitelist filter.
- Search filters by `LayrzIcon.name.toLowerCase().contains(query.toLowerCase())` — not by icon code.
- On open the list auto-scrolls to the currently selected icon (`itemExtent` = 50 px per row).
- `onChanged` is only called when the user taps an icon (immediate close) — no explicit Save needed from the user's perspective; the confirm flow is internal.

### Common patterns

```dart
// Restrict to a project-defined subset
ThemedIconPicker(
  labelText: context.i18n.t('asset.markerIcon'),
  value: _icon,
  allowedIcons: kAllowedMarkerIcons, // List<LayrzIcon>
  errors: context.getErrors(key: 'markerIcon'),
  onChanged: (icon) {
    setState(() => _icon = icon);
    if (context.mounted) onChanged.call();
  },
)

// Custom trigger (e.g. an avatar card)
ThemedIconPicker(
  labelText: context.i18n.t('entity.icon'),
  value: _icon,
  onChanged: (icon) {
    setState(() => _icon = icon);
    if (context.mounted) onChanged.call();
  },
  customChild: ThemedAvatar(icon: _icon?.iconData, size: 48),
)
```

---

## ThemedEmojiPicker

### Minimal usage

```dart
// State
String? _emoji;

// Widget
ThemedEmojiPicker(
  labelText: context.i18n.t('entity.emoji'),
  value: _emoji,
  errors: context.getErrors(key: 'emoji'),
  onChanged: (emoji) {
    setState(() => _emoji = emoji);
    if (context.mounted) onChanged.call();
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided. Mutually exclusive with `label`. |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Mutually exclusive with `labelText`. |
| `value` | `String?` | `null` | The currently selected emoji character (e.g. `"😀"`) |
| `onChanged` | `void Function(String)?` | `null` | Receives the emoji char when user picks and confirms |
| `disabled` | `bool` | `false` | Disables the input |
| `errors` | `List<String>` | `[]` | Validation error messages |
| `isRequired` | `bool` | `false` | Shows required indicator |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row |
| `readonly` | `bool` | `false` | Prevents opening the picker dialog |
| `padding` | `EdgeInsets?` | `null` | Outer padding |
| `focusNode` | `FocusNode?` | `null` | External focus node |
| `onSubmitted` | `VoidCallback?` | `null` | Called on keyboard submit action |
| `maxLines` | `int` | `1` | Not typically changed; governs underlying text field lines |
| `buttomSize` | `double?` | `null` | Controls the grid button size in the picker; `null` = auto |
| `enabledGroups` | `List<EmojiGroup>` | `[]` | When non-empty, only these emoji groups appear in the picker; empty = all groups |
| `customChild` | `Widget?` | `null` | Replaces the text field trigger with a custom widget |
| `hoverColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is provided |
| `focusColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is provided |
| `splashColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is provided |
| `highlightColor` | `Color` | `Colors.transparent` | Only applies when `customChild` is provided |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | Only applies when `customChild` is provided |
| `translations` | `Map<String, String>` | cancel/save/search defaults | Fallback strings when `LayrzAppLocalizations` is absent |
| `overridesLayrzTranslations` | `bool` | `false` | Forces `translations` map over the app i18n |

### Behavior notes

- Dialog opens at up to 500 × 700 logical pixels.
- Groups are shown as a horizontal scrollable chip row above the grid. Selecting a group filters the grid.
- Search filters by `emoji.shortName.contains(query)` — case-sensitive; queries are not lowercased.
- Picking an emoji closes the dialog immediately (no explicit Save step from the user's POV).
- `value` is a raw emoji character string, not a code point or short name. Use `Emoji.byChar(value)` from the `emojis` package if you need metadata.
- `buttomSize` (note: this is the actual parameter name in the API — not a typo you should correct) controls both button width and height in the grid.

### Common patterns

```dart
// Restrict to nature + food emoji groups
ThemedEmojiPicker(
  labelText: context.i18n.t('entity.emoji'),
  value: _emoji,
  enabledGroups: [EmojiGroup.animalsAndNature, EmojiGroup.foodAndDrink],
  onChanged: (emoji) {
    setState(() => _emoji = emoji);
    if (context.mounted) onChanged.call();
  },
)
```

---

## ThemedDynamicAvatarInput

### Minimal usage

```dart
// State
AvatarInput? _avatar;

// Widget
ThemedDynamicAvatarInput(
  labelText: context.i18n.t('entity.avatar'),
  value: _avatar,
  errors: context.getErrors(key: 'avatar'),
  onChanged: (avatar) {
    setState(() => _avatar = avatar);
    if (context.mounted) onChanged.call();
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided. Mutually exclusive with `label`. |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Mutually exclusive with `labelText`. |
| `value` | `AvatarInput?` | `null` | The current avatar. `null` is treated as `AvatarInput()` (no avatar / type none). |
| `onChanged` | `void Function(AvatarInput?)?` | `null` | Receives the updated avatar, or `null` when none is selected |
| `disabled` | `bool` | `false` | Disables the input |
| `errors` | `List<String>` | `[]` | Validation error messages |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row |
| `padding` | `EdgeInsets?` | `null` | Outer padding |
| `enabledTypes` | `List<AvatarType>` | `[url, base64, icon, emoji]` | Which tabs appear in the dialog. `AvatarType.none` is always prepended automatically. |
| `heightFactor` | `double` | `0.7` | Dialog height as a fraction of screen height (not currently applied to the fixed constraints; reserved for future use) |
| `maxHeight` | `double` | `350` | Maximum dialog height in logical pixels (not currently applied to fixed constraints; reserved) |

### AvatarInput — structure (from `layrz_models`)

```dart
// Simplified view of the relevant fields:
class AvatarInput {
  AvatarType type;   // none | url | base64 | icon | emoji
  String? url;       // for type == url
  String? base64;    // for type == base64 (data URI or raw base64)
  LayrzIcon? icon;   // for type == icon
  String? emoji;     // for type == emoji (single char)
}
```

Only one of `url`, `base64`, `icon`, `emoji` is non-null at a time — the dialog clears the others on each tab selection.

### AvatarType values

| Value | Tab label (i18n key suffix) | Content |
|---|---|---|
| `AvatarType.none` | `helpers.dynamicAvatar.types.none` | Always present; shows an explanatory hint, no input |
| `AvatarType.url` | `helpers.dynamicAvatar.types.URL` | Text input for an image URL |
| `AvatarType.base64` | `helpers.dynamicAvatar.types.BASE64` | `ThemedAvatarPicker` (file pick → base64) |
| `AvatarType.icon` | `helpers.dynamicAvatar.types.icon` | Searchable icon grid (same as `ThemedIconPicker`) |
| `AvatarType.emoji` | `helpers.dynamicAvatar.types.emoji` | Group-filtered emoji grid (same as `ThemedEmojiPicker`) |

### Behavior notes

- The dialog uses `ThemedTabView` with one tab per `enabledTypes` entry (plus the auto-prepended `none` tab).
- The initial tab is determined by matching `value.type` inside `enabledTypes`.
- `onChanged` is fired inline (not on dialog close) — each sub-picker calls it immediately when the user picks a value. There is no Cancel/confirm flow at the dialog level.
- The preview `ThemedAvatar` shown in the text field reflects the current `AvatarInput` state in real time.

### Common patterns

```dart
// Icon or emoji only — no image upload
ThemedDynamicAvatarInput(
  labelText: context.i18n.t('layer.avatar'),
  value: _avatar,
  enabledTypes: [AvatarType.icon, AvatarType.emoji],
  onChanged: (avatar) {
    setState(() => _avatar = avatar);
    if (context.mounted) onChanged.call();
  },
)

// Full avatar with all types
ThemedDynamicAvatarInput(
  labelText: context.i18n.t('asset.avatar'),
  value: _avatar,
  errors: context.getErrors(key: 'avatar'),
  onChanged: (avatar) {
    setState(() => _avatar = avatar);
    if (context.mounted) onChanged.call();
  },
)
```

---

## ThemedDynamicCredentialsInput

This widget is fundamentally different from the other three. It is NOT a single-field picker — it renders an entire `ResponsiveRow` of inputs driven by a `List<CredentialField>` schema. It does NOT use `labelText` or `label`.

### Minimal usage

```dart
// State — the full credentials map (key → value)
Map<String, dynamic> _credentials = {};

// Widget
ThemedDynamicCredentialsInput(
  value: _credentials,
  fields: protocol.credentialFields, // List<CredentialField>
  translatePrefix: 'inboundProtocols.myProtocol',
  isEditing: isEditing,
  errors: context.getErrors(key: 'credentials') as Map<String, dynamic>? ?? {},
  onChanged: (creds) {
    setState(() => _credentials = creds);
    if (context.mounted) onChanged.call();
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `value` | `Map<String, dynamic>` | required | The current credentials map. Keys are field names from `CredentialField.field`. |
| `fields` | `List<CredentialField>` | required | The schema that drives which inputs are rendered |
| `onChanged` | `void Function(Map<String, dynamic>)?` | `null` | Receives the full updated credentials map on any field change |
| `errors` | `Map<String, dynamic>` | `{}` | Error map — NOT `List<String>`. Keys are credential field paths. |
| `translatePrefix` | `String` | `''` | i18n key prefix. Each field label is looked up as `'$translatePrefix.${field.field}.title'` |
| `isEditing` | `bool` | `true` | When `false`, all inputs are rendered in `disabled` mode |
| `layrzGeneratedToken` | `String?` | `null` | When set, displayed in a read-only field for `CredentialFieldType.layrzApiToken` fields, with a copy-to-clipboard suffix button |
| `nested` | `String?` | `null` | Parent field name when this widget is rendered recursively for `CredentialFieldType.nestedField`. Sets the error key path prefix. |
| `actionCallback` | `void Function(CredentialFieldAction)?` | `null` | Called for fields with special actions (e.g. `CredentialFieldAction.wialonOAuth` for `CredentialFieldType.wialonToken`) |
| `isLoading` | `bool` | `false` | When `true`, shows a lock icon on action fields instead of the refresh icon |

### CredentialField — structure (from `layrz_models`)

```dart
class CredentialField {
  final String field;                    // map key in credentials
  final CredentialFieldType type;        // drives which input widget is rendered
  final List<String>? choices;           // required when type == choices
  final List<CredentialField>? requiredFields; // required when type == nestedField
  final String? onlyField;              // conditional display: show only when credentials[onlyField] is in onlyChoices
  final List<dynamic>? onlyChoices;     // values of onlyField that make this field visible
}
```

### CredentialFieldType — all supported values

| Value | Rendered as | Notes |
|---|---|---|
| `string` | `ThemedTextInput` | Plain text |
| `soapUrl` | `ThemedTextInput` | Plain text (URL for SOAP endpoints) |
| `restUrl` | `ThemedTextInput` | Plain text (URL for REST endpoints) |
| `ftp` | `ThemedTextInput` | Plain text (FTP address) |
| `dir` | `ThemedTextInput` | Plain text (directory path) |
| `integer` | `ThemedNumberInput` | Value stored as `int` |
| `float` | `ThemedNumberInput` | Value stored as `double` |
| `choices` | `ThemedSelectInput<String>` | Requires `field.choices` to be non-null. Item labels are `'$translatePrefix.${field.field}.$choice'` |
| `layrzApiToken` | Read-only `ThemedTextInput` | Shows `layrzGeneratedToken` or a placeholder. Has copy-to-clipboard suffix when token is present. |
| `nestedField` | Recursive `ThemedDynamicCredentialsInput` | Requires `field.requiredFields`. Passes `nested: field.field` and adjusted `translatePrefix`. |
| `wialonToken` | Read-only `ThemedTextInput` with action suffix | Calls `actionCallback(CredentialFieldAction.wialonOAuth)` on suffix tap. Shows lock icon when `isLoading`. |

### Error map wiring

`errors` is `Map<String, dynamic>`, not `List<String>`. It mirrors the Layrz API error response shape.
Internally, each field calls `context.getErrors(key: path)` with the appropriate key:

- Flat field: `'credentials.${field.field}'`
- Nested field: `'credentials.${widget.nested}.${field.field}'`

Pass the full API error response's `credentials` subtree (or the whole error map) so `context.getErrors` can resolve nested paths correctly.

```dart
// Example: API returns { "credentials": { "host": ["is required"] } }
// Pass the whole error map — getErrors navigates the path internally.
errors: apiErrors, // Map<String, dynamic>
```

### Conditional field visibility

Fields with `onlyField` and `onlyChoices` set are shown only when `credentials[field.onlyField]` is contained in `field.onlyChoices`. The widget evaluates this on every build — no explicit state needed.

### Common patterns

```dart
// Standard credentials form for an inbound protocol
ThemedDynamicCredentialsInput(
  value: entity.credentials,
  fields: selectedProtocol.credentialFields,
  translatePrefix: 'inboundProtocols.${selectedProtocol.identifier}',
  isEditing: isEditing,
  layrzGeneratedToken: entity.layrzToken,
  errors: store.errors,
  actionCallback: (action) async {
    if (action == CredentialFieldAction.wialonOAuth) {
      await _launchWialonOAuth();
    }
  },
  onChanged: (creds) {
    entity.credentials = creds;
    if (context.mounted) onChanged.call();
  },
)

// Read-only view (detail screen)
ThemedDynamicCredentialsInput(
  value: entity.credentials,
  fields: protocol.credentialFields,
  translatePrefix: 'inboundProtocols.${protocol.identifier}',
  isEditing: false,
  errors: const {},
)
```

---

## Integrating with layrz forms

```dart
// ThemedIconPicker — store the LayrzIcon directly
ThemedIconPicker(
  labelText: context.i18n.t('entity.icon'),
  value: entity.icon,
  errors: context.getErrors(key: 'icon'),
  onChanged: (icon) {
    entity.icon = icon;
    if (context.mounted) onChanged.call();
  },
)

// ThemedEmojiPicker — store the emoji char string
ThemedEmojiPicker(
  labelText: context.i18n.t('entity.emoji'),
  value: entity.emoji,
  errors: context.getErrors(key: 'emoji'),
  onChanged: (emoji) {
    entity.emoji = emoji;
    if (context.mounted) onChanged.call();
  },
)

// ThemedDynamicAvatarInput — store the AvatarInput object
ThemedDynamicAvatarInput(
  labelText: context.i18n.t('entity.avatar'),
  value: entity.avatar,
  errors: context.getErrors(key: 'avatar'),
  onChanged: (avatar) {
    entity.avatar = avatar;
    if (context.mounted) onChanged.call();
  },
)

// ThemedDynamicCredentialsInput — NO label; wire directly to the credentials map
ThemedDynamicCredentialsInput(
  value: entity.credentials,
  fields: selectedProtocol.credentialFields,
  translatePrefix: 'protocols.${selectedProtocol.identifier}',
  isEditing: isEditing,
  errors: store.errors,
  onChanged: (creds) {
    entity.credentials = creds;
    if (context.mounted) onChanged.call();
  },
)
```

Conventions:
- Always guard `onChanged` body with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText`.
- Use `context.getErrors(key: 'fieldName')` for `errors` on the three standard pickers.
- For `ThemedDynamicCredentialsInput`, pass the raw API error map to `errors` — `context.getErrors` is called internally per field.
- `label` and `labelText` are mutually exclusive — the constructor asserts this.
- Never use raw Material widgets (`DropdownButton`, `TextField`, etc.) in layrz forms.

---

## Choosing between the four

- **`ThemedIconPicker`** — user picks one icon from the Layrz icon set (Solar icons). Value type: `LayrzIcon?`. The canonical choice when you need a single icon selection field.
- **`ThemedEmojiPicker`** — user picks one standard Unicode emoji. Value type: `String?` (the emoji character). Use when entities allow emoji labeling.
- **`ThemedDynamicAvatarInput`** — user composes an avatar that can be one of four types (URL, file upload, icon, or emoji). Value type: `AvatarInput?`. Use when entities need a flexible visual identity (asset, layer, user profile, etc.) and you want to support all or a subset of avatar types in one field.
- **`ThemedDynamicCredentialsInput`** — renders a schema-driven credentials form for protocol integrations. Value type: `Map<String, dynamic>`. Has no label param. Is NOT a single field — it outputs a full row of inputs. Use exclusively for Layrz API entities that carry a `credentials` map (e.g. `InboundProtocol`, `OutboundProtocol`).

Do NOT use `ThemedIconPicker` or `ThemedEmojiPicker` inside forms where `ThemedDynamicAvatarInput` is already present — the avatar input has built-in icon and emoji tabs. Compose them separately only when the entity tracks icon/emoji independently of an `AvatarInput` field.
