---
name: select-inputs
description: Use ThemedSelectInput (single select) or ThemedMultiSelectInput (multi select) in a layrz Flutter widget. Apply when wiring a single-value or multi-value picker field into any stateful widget — forms, tabs, or standalone views.
---

## Overview

Two components cover all selection needs:

| Component | State type | `onChanged` returns | Default `autoclose` |
|---|---|---|---|
| `ThemedSelectInput<T>` | `T?` | `ThemedSelectItem<T>?` | `true` |
| `ThemedMultiSelectInput<T>` | `List<T>` | `List<ThemedSelectItem<T>>` | `false` |

Both open a dialog with a searchable list. The user selects an item (or items) and confirms. Always use `ThemedSelectItem<T>` to build the `items` list.

---

## ThemedSelectItem<T>

Every item in both components is a `ThemedSelectItem<T>`:

```dart
ThemedSelectItem<int>(
  value: 1,          // T — the actual stored value
  label: 'Option 1', // displayed text
)
```

Optional: `onTap` (`VoidCallback?`) — called when the item is tapped inside the dialog.

---

## ThemedSelectInput — single value

### Minimal usage

```dart
// State
int? selectedId;

// Widget
ThemedSelectInput<int>(
  labelText: 'Country',
  items: countries.map((c) => ThemedSelectItem(value: c.id, label: c.name)).toList(),
  value: selectedId,
  onChanged: (item) => setState(() => selectedId = item?.value),
)
```

`onChanged` receives `ThemedSelectItem<T>?`. Always use `.value` to extract the raw `T`.

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Exactly one of the two must be set. |
| `items` | `List<ThemedSelectItem<T>>` | required | The selectable options |
| `value` | `T?` | `null` | Currently selected value |
| `onChanged` | `void Function(ThemedSelectItem<T>?)?` | `null` | Callback on selection |
| `disabled` | `bool` | `false` | Disables the input |
| `errors` | `List<String>` | `[]` | Validation error messages shown below |
| `isRequired` | `bool` | `false` | Shows required indicator |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row |
| `autoclose` | `bool` | `true` | Closes dialog immediately on selection |
| `canUnselect` | `bool` | `false` | Allows the user to deselect the current item; `onChanged` receives `null` |
| `returnNullOnClose` | `bool` | `false` | Calls `onChanged(null)` when dialog is dismissed without picking |
| `autoSelectFirst` | `bool` | `false` | Auto-selects `items[0]` on `initState` when `value` is null |
| `enableSearch` | `bool` | `true` | Shows a search field inside the dialog |
| `hideTitle` | `bool` | `false` | Hides the dialog title; also disables search |
| `hideButtons` | `bool` | `false` | Hides Cancel / Save buttons |
| `dialogContraints` | `BoxConstraints` | `maxWidth:500, maxHeight:500` | Dialog size constraints (note: typo in API — `Contraints`) |
| `overrideHeightDialog` | `double?` | `null` | Forces dialog height |
| `itemExtent` | `double` | `50` | Fixed row height inside the list |
| `prefixIcon` | `IconData?` | `null` | Icon before the text field |
| `customChild` | `Widget?` | `null` | Replaces the text field with a custom widget |

### Behavior notes

- When `autoclose: true` (default), the dialog closes as soon as an item is tapped — no Save button needed.
- When `autoclose: false`, the user must tap Save to confirm. Use this when `canUnselect: true` so the user can explicitly deselect and save.
- When `returnNullOnClose: true` and the user taps outside the dialog, `onChanged(null)` is called — useful to clear the field.
- `autoSelectFirst` only fires once during `initState`; it does not re-fire if `value` later becomes null.

### Common patterns

```dart
// Allow deselection
ThemedSelectInput<String>(
  labelText: 'Status',
  items: statuses,
  value: selectedStatus,
  canUnselect: true,
  autoclose: false,  // show Save button so user can confirm the unselect
  onChanged: (item) => setState(() => selectedStatus = item?.value),
)

// Clear on dismiss
ThemedSelectInput<String>(
  labelText: 'Category',
  items: categories,
  value: selectedCategory,
  autoclose: false,
  returnNullOnClose: true,
  onChanged: (item) => setState(() => selectedCategory = item?.value),
)
```

---

## ThemedMultiSelectInput — multiple values

### Minimal usage

```dart
// State
List<int> selectedIds = [];

// Widget
ThemedMultiSelectInput<int>(
  labelText: 'Tags',
  items: tags.map((t) => ThemedSelectItem(value: t.id, label: t.name)).toList(),
  value: selectedIds,
  onChanged: (items) => setState(
    () => selectedIds = items.map((e) => e.value!).toList(),
  ),
)
```

`onChanged` receives `List<ThemedSelectItem<T>>`. Use `.map((e) => e.value!).toList()` to extract the raw list of `T`.

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided |
| `label` | `Widget?` | — | Required unless `labelText` is provided |
| `items` | `List<ThemedSelectItem<T>>` | required | The selectable options |
| `value` | `List<T>?` | `null` | Currently selected values |
| `onChanged` | `void Function(List<ThemedSelectItem<T>>)?` | `null` | Callback on selection change |
| `disabled` | `bool` | `false` | Disables the input |
| `errors` | `List<String>` | `[]` | Validation error messages |
| `isRequired` | `bool` | `false` | Shows required indicator |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `hideDetails` | `bool` | `false` | Hides errors/hints row |
| `autoclose` | `bool` | `false` | Closes dialog immediately on each tap (not recommended for multi-select) |
| `autoselectFirst` | `bool` | `false` | Auto-selects `items[0]` on `initState` when `value` is empty |
| `enableSearch` | `bool` | `true` | Shows a search field inside the dialog |
| `hideTitle` | `bool` | `false` | Hides the dialog title; also disables search |
| `waitUntilClosedToSubmit` | `bool` | `false` | Delays `onChanged` call until the dialog is closed (Save tapped) |
| `dialogConstraints` | `BoxConstraints` | `maxWidth:500, maxHeight:500` | Dialog size constraints |
| `itemExtent` | `double` | `50` | Fixed row height inside the list |
| `prefixIcon` | `IconData?` | `null` | Icon before the text field |
| `customChild` | `Widget?` | `null` | Replaces the text field with a custom widget |

### Behavior notes

- The dialog always shows **Cancel**, **Select All / Unselect All**, and **Save** buttons. This cannot be hidden.
- Cancel discards all changes and calls `onChanged` with the previous selection (no change).
- By default (`waitUntilClosedToSubmit: false`), `onChanged` is fired on every tap — the parent state updates in real time while the dialog is open.
- Set `waitUntilClosedToSubmit: true` when real-time updates cause expensive side effects.
- Select All / Unselect All toggles between all items selected and none selected; it does not call `onChanged` — only Save does.

### Common patterns

```dart
// Batch submit — only fire onChanged when user confirms
ThemedMultiSelectInput<String>(
  labelText: 'Permissions',
  items: permissions,
  value: selectedPermissions,
  waitUntilClosedToSubmit: true,
  onChanged: (items) => setState(
    () => selectedPermissions = items.map((e) => e.value!).toList(),
  ),
)
```

---

## Integrating with layrz forms (onChanged + errors pattern)

```dart
ThemedSelectInput<String>(
  labelText: context.i18n.t('entity.fieldName'),
  items: sourceList.map((e) => ThemedSelectItem(value: e.id, label: e.name)).toList(),
  value: object.fieldName,
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (item) {
    object.fieldName = item?.value;
    if (context.mounted) onChanged.call();
  },
)
```

For multi-select, replace `value` with `List<T>` and `onChanged` body with:

```dart
onChanged: (items) {
  object.fieldName = items.map((e) => e.value!).nonNulls.toList();
  if (context.mounted) onChanged.call();
},
```

---

## Choosing between the two

- Use `ThemedSelectInput` when the field stores a **single value** (`T?`).
- Use `ThemedMultiSelectInput` when the field stores a **list of values** (`List<T>`).
- Never use raw Flutter `DropdownButton` or `CheckboxListTile` — always use these components.
