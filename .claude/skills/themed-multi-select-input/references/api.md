# ThemedMultiSelectInput — API Reference

Source: `lib/src/inputs/src/general/multiselect_input.dart`

- `ThemedMultiSelectInput<T>` class — line 3

---

## Examples

```dart
// Basic multi-select
ThemedMultiSelectInput<String>(
  labelText: 'Tags',
  items: tags.map((t) => ThemedSelectItem(value: t.id, label: t.name)).toList(),
  value: selectedTagIds,
  errors: context.getErrors(key: 'tags'),
  onChanged: (items) => setState(() {
    selectedTagIds = items.map((e) => e.value).nonNulls.toList();
  }),
)

// Batch submit (fire onChanged only on Save)
ThemedMultiSelectInput<String>(
  labelText: 'Permissions',
  items: permissions,
  value: selectedPermissionIds,
  waitUntilClosedToSubmit: true,
  onChanged: (items) => setState(() {
    selectedPermissionIds = items.map((e) => e.value).nonNulls.toList();
  }),
)

// Disabled
ThemedMultiSelectInput<String>(
  labelText: 'Tags',
  items: tags,
  value: selectedTagIds,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedMultiSelectInput({
  super.key,
  this.labelText,
  this.label,
  required this.items,
  this.onChanged,
  this.value,
  this.disabled = false,
  this.errors = const [],
  this.isRequired = false,
  this.dense = false,
  this.hideDetails = false,
  this.autoclose = false,
  this.autoselectFirst = false,
  this.enableSearch = true,
  this.hideTitle = false,
  this.waitUntilClosedToSubmit = false,
  this.dialogConstraints = const BoxConstraints(maxWidth: 500, maxHeight: 500),
  this.itemExtent = 50,
  this.prefixIcon,
  this.customChild,
  this.hoverColor = Colors.transparent,
  this.focusColor = Colors.transparent,
  this.splashColor = Colors.transparent,
  this.highlightColor = Colors.transparent,
  this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  this.translations = const { ... },
  this.overridesLayrzTranslations = false,
  this.padding,
  this.filter,
}) : assert((label == null && labelText != null) || (label != null && labelText == null));
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `items` | `List<ThemedSelectItem<T>>` | required | All selectable options |
| `value` | `List<T>?` | `null` | Currently selected values |
| `onChanged` | `void Function(List<ThemedSelectItem<T>>)?` | `null` | Fires with full selected item list |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `disabled` | `bool` | `false` | Prevents opening the dialog |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `isRequired` | `bool` | `false` | Shows required indicator |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `autoclose` | `bool` | `false` | Closes dialog immediately on each item tap (not recommended) |
| `autoselectFirst` | `bool` | `false` | Auto-selects `items[0]` on init when `value` is empty |
| `enableSearch` | `bool` | `true` | Shows search field in dialog |
| `hideTitle` | `bool` | `false` | Hides dialog title (also disables search) |
| `waitUntilClosedToSubmit` | `bool` | `false` | Delays `onChanged` until Save is tapped |
| `dialogConstraints` | `BoxConstraints` | `BoxConstraints(maxWidth: 500, maxHeight: 500)` | Dialog size constraints |
| `itemExtent` | `double` | `50` | Fixed row height in the list |
| `prefixIcon` | `IconData?` | `null` | Icon before the text field |
| `customChild` | `Widget?` | `null` | Custom trigger widget; wraps in `InkWell` |
| `hoverColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` hover color |
| `focusColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` focus color |
| `splashColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` splash color |
| `highlightColor` | `Color` | `Colors.transparent` | `customChild` `InkWell` highlight color |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | `customChild` `InkWell` border radius |
| `padding` | `EdgeInsets?` | `null` | Outer padding |
| `filter` | `bool Function(ThemedSelectItem<T>, String)?` | `null` | Custom search filter function |
| `translations` | `Map<String, String>` | (see below) | Fallback strings when i18n unavailable |
| `overridesLayrzTranslations` | `bool` | `false` | Force use of `translations` map |

---

## Translations map keys

| Key | Default |
|---|---|
| `actions.cancel` | `'Cancel'` |
| `actions.save` | `'Save'` |
| `helpers.search` | `'Search'` |
| `helpers.selectAll` | `'Select all'` |
| `helpers.unselectAll` | `'Unselect all'` |

---

## ThemedSelectItem<T>

```dart
ThemedSelectItem<T>(
  value: T,           // the stored value
  label: String,      // displayed text
  // onTap: VoidCallback?  // optional tap handler inside dialog
)
```

---

## Dialog behavior

- Always shows: Cancel, Select All / Unselect All toggle, Save.
- `waitUntilClosedToSubmit: false` (default): `onChanged` fires on every item tap.
- `waitUntilClosedToSubmit: true`: `onChanged` fires only when Save is tapped.
- Cancel calls `onChanged` with the previous (unchanged) selection.
- Select All / Unselect All does NOT call `onChanged` — only Save does.
- `autoselectFirst` fires only during `initState`.

## Comparison with ThemedSelectInput

| Aspect | `ThemedSelectInput` | `ThemedMultiSelectInput` |
|---|---|---|
| Selection | Single (`T?`) | Multiple (`List<T>`) |
| Default `autoclose` | `true` | `false` |
| Deselect support | `canUnselect` | Always (uncheck any item) |
| Dialog buttons | Cancel, Save (configurable) | Cancel, Select All/Unselect All, Save (always) |
| `dialogContraints` param | `dialogContraints` (typo — no trailing 's') | `dialogConstraints` (correct spelling) |
