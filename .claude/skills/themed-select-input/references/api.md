# ThemedSelectInput — API Reference

Source: `lib/src/inputs/src/general/select_input.dart`

- `ThemedSelectInput<T>` class — line 3
- `DialogSelectInput<T>` class (internal dialog widget)
- `SelectInputResult<T>` class (result wrapper)

---

## Examples

```dart
// Basic single select
ThemedSelectInput<String>(
  labelText: 'Status',
  items: statuses.map((s) => ThemedSelectItem(value: s.id, label: s.name)).toList(),
  value: selectedStatus,
  errors: context.getErrors(key: 'status'),
  onChanged: (item) => setState(() => selectedStatus = item?.value),
)

// Allow deselection
ThemedSelectInput<String>(
  labelText: 'Category',
  items: categories,
  value: selectedCategory,
  canUnselect: true,
  autoclose: false,
  onChanged: (item) => setState(() => selectedCategory = item?.value),
)

// Clear on dismiss
ThemedSelectInput<String>(
  labelText: 'Filter',
  items: filters,
  value: selectedFilter,
  returnNullOnClose: true,
  onChanged: (item) => setState(() => selectedFilter = item?.value),
)

// Disabled
ThemedSelectInput<String>(
  labelText: 'Status',
  items: statuses,
  value: selectedStatus,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedSelectInput({
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
  this.autoclose = true,
  this.canUnselect = false,
  this.returnNullOnClose = false,
  this.autoSelectFirst = false,
  this.enableSearch = true,
  this.hideTitle = false,
  this.hideButtons = false,
  this.dialogContraints = const BoxConstraints(maxWidth: 500, maxHeight: 500),
  this.overrideHeightDialog,
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
| `items` | `List<ThemedSelectItem<T>>` | required | Selectable options |
| `value` | `T?` | `null` | Currently selected value |
| `onChanged` | `void Function(ThemedSelectItem<T>?)?` | `null` | Fires with item on select, `null` on deselect/dismiss |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `disabled` | `bool` | `false` | Prevents opening the dialog |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `isRequired` | `bool` | `false` | Shows required indicator |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `autoclose` | `bool` | `true` | Closes dialog immediately on item tap |
| `canUnselect` | `bool` | `false` | Allows tapping current selection to deselect it |
| `returnNullOnClose` | `bool` | `false` | Calls `onChanged(null)` when dialog is dismissed without picking |
| `autoSelectFirst` | `bool` | `false` | Auto-selects `items[0]` on init when `value` is null |
| `enableSearch` | `bool` | `true` | Shows search field in dialog |
| `hideTitle` | `bool` | `false` | Hides dialog title (also disables search) |
| `hideButtons` | `bool` | `false` | Hides Cancel / Save buttons |
| `dialogContraints` | `BoxConstraints` | `BoxConstraints(maxWidth: 500, maxHeight: 500)` | **Note: parameter is `dialogContraints` (typo in API — missing 's')** |
| `overrideHeightDialog` | `double?` | `null` | Forces dialog height |
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

- Max size: 500×500 (controlled by `dialogContraints`).
- `autoclose: true`: dialog closes immediately on tap — no Save button shown.
- `autoclose: false`: user must tap Save to confirm selection.
- `canUnselect: true` + `autoclose: false`: user can tap the selected item to deselect, then Save to confirm `null`.
- `autoSelectFirst` fires only during `initState` — does not re-fire if `value` later becomes null.
