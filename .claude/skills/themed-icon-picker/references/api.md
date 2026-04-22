# ThemedIconPicker — API Reference

Source: `lib/src/inputs/src/pickers/general/icon.dart`

- `ThemedIconPicker` class — line 3

---

## Examples

```dart
// Basic icon picker
ThemedIconPicker(
  labelText: 'Icon',
  value: selectedIcon,
  errors: context.getErrors(key: 'icon'),
  onChanged: (icon) => setState(() => selectedIcon = icon),
)

// Filtered subset
ThemedIconPicker(
  labelText: 'Marker icon',
  value: selectedIcon,
  allowedIcons: kAllowedMarkerIcons,
  onChanged: (icon) => setState(() => selectedIcon = icon),
)

// Custom trigger
ThemedIconPicker(
  labelText: 'Icon',
  value: selectedIcon,
  customChild: ThemedAvatar(icon: selectedIcon?.iconData, size: 48),
  onChanged: (icon) => setState(() => selectedIcon = icon),
)

// Dense
ThemedIconPicker(
  labelText: 'Icon',
  value: selectedIcon,
  dense: true,
  onChanged: (icon) => setState(() => selectedIcon = icon),
)
```

---

## Constructor

```dart
const ThemedIconPicker({
  super.key,
  this.labelText,
  this.label,
  this.disabled = false,
  this.onChanged,
  this.value,
  this.errors = const [],
  this.hideDetails = false,
  this.padding,
  this.dense = false,
  this.isRequired = false,
  this.focusNode,
  this.translations = const {
    'actions.cancel': 'Cancel',
    'actions.save': 'Save',
    'helpers.search': 'Search an emoji or group',
  },
  this.overridesLayrzTranslations = false,
  this.allowedIcons = const [],
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
| `value` | `LayrzIcon?` | `null` | Currently selected icon |
| `onChanged` | `void Function(LayrzIcon)?` | `null` | Called when user taps an icon (immediate close) |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `disabled` | `bool` | `false` | Prevents opening the picker |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `padding` | `EdgeInsets?` | `null` | Outer padding; defaults to `ThemedTextInput.outerPadding` |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `isRequired` | `bool` | `false` | Shows required indicator |
| `focusNode` | `FocusNode?` | `null` | External focus node |
| `allowedIcons` | `List<LayrzIcon>` | `[]` | Whitelist filter; empty = all icons from `iconMapping` |
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
- Icon list sourced from `iconMapping` (full Layrz/Solar icon set), sorted alphabetically by `LayrzIcon.name`.
- Search: case-insensitive `name.contains(query)`.
- Auto-scrolls to selected icon on open (item height = 50 px).
- Tapping an icon fires `onChanged` and closes — no explicit Save.
