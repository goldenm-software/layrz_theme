# ThemedEmojiPicker — API Reference

Source: `lib/src/inputs/src/pickers/general/emoji.dart`

- `ThemedEmojiPicker` class — line 3

---

## Examples

```dart
// Basic emoji picker
ThemedEmojiPicker(
  labelText: 'Emoji',
  value: selectedEmoji,
  errors: context.getErrors(key: 'emoji'),
  onChanged: (emoji) => setState(() => selectedEmoji = emoji),
)

// Restricted groups
ThemedEmojiPicker(
  labelText: 'Emoji',
  value: selectedEmoji,
  enabledGroups: [EmojiGroup.animalsAndNature, EmojiGroup.foodAndDrink],
  onChanged: (emoji) => setState(() => selectedEmoji = emoji),
)

// Disabled
ThemedEmojiPicker(
  labelText: 'Emoji',
  value: selectedEmoji,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedEmojiPicker({
  super.key,
  this.labelText,
  this.label,
  this.value,
  this.onChanged,
  this.disabled = false,
  this.errors = const [],
  this.hideDetails = false,
  this.padding,
  this.dense = false,
  this.isRequired = false,
  this.focusNode,
  this.onSubmitted,
  this.readonly = false,
  this.maxLines = 1,
  this.buttomSize,
  this.enabledGroups = const [],
  this.translations = const {
    'actions.cancel': 'Cancel',
    'actions.save': 'Save',
    'helpers.search': 'Search an emoji or group',
  },
  this.overridesLayrzTranslations = false,
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
| `value` | `String?` | `null` | Raw emoji character (e.g. `"😀"`) |
| `onChanged` | `void Function(String)?` | `null` | Fires with emoji char when user taps one |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `disabled` | `bool` | `false` | Prevents opening the picker |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `padding` | `EdgeInsets?` | `null` | Outer padding; defaults to `ThemedTextInput.outerPadding` |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `isRequired` | `bool` | `false` | Shows required indicator |
| `focusNode` | `FocusNode?` | `null` | External focus node |
| `onSubmitted` | `VoidCallback?` | `null` | Called on keyboard submit action |
| `readonly` | `bool` | `false` | Prevents opening the picker dialog |
| `maxLines` | `int` | `1` | Underlying text field line count |
| `buttomSize` | `double?` | `null` | Grid button size (width & height); `null` = auto. Note: this is the actual API parameter name — not a typo. |
| `enabledGroups` | `List<EmojiGroup>` | `[]` | Group filter; empty = all groups shown |
| `customChild` | `Widget?` | `null` | Custom trigger widget; wraps in `InkWell` |
| `hoverColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` hover color |
| `focusColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` focus color |
| `splashColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` splash color |
| `highlightColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` highlight color |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | `customChild` `InkWell` border radius |
| `translations` | `Map<String, String>` | (see below) | Fallback strings when i18n unavailable |
| `overridesLayrzTranslations` | `bool` | `false` | Force use of `translations` map |

---

## Translations map keys

| Key | Default |
|---|---|
| `actions.cancel` | `'Cancel'` |
| `actions.save` | `'Save'` |
| `helpers.search` | `'Search an emoji or group'` |

---

## Dialog behavior

- Max size: 500×700 logical pixels.
- Group filter row: horizontal scrollable chips, one per `EmojiGroup` (or `enabledGroups` subset).
- Search: `emoji.shortName.contains(query)` — case-sensitive.
- Tapping an emoji fires `onChanged` and closes immediately — no explicit Save.
- Use `Emoji.byChar(value)` from the `emojis` package to get emoji metadata from the stored char.
