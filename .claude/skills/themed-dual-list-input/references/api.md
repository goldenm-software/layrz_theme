# ThemedDualListInput — API Reference

Source: `lib/src/inputs/src/general/duallist_input.dart`

- `ThemedDualListInput<T>` class — line 3

---

## Examples

```dart
// Basic dual list
ThemedDualListInput<String>(
  labelText: 'Items',
  items: sourceList.map((e) => ThemedSelectItem(value: e.id, label: e.name)).toList(),
  value: selectedIds,
  errors: context.getErrors(key: 'items'),
  onChanged: (items) => setState(() {
    selectedIds = items.map((e) => e.value).nonNulls.toList();
  }),
)

// Custom headers
ThemedDualListInput<String>(
  labelText: 'POIs',
  items: pois.map((p) => ThemedSelectItem(value: p.id, label: p.name)).toList(),
  value: selectedPoiIds,
  availableListName: 'Available POIs',
  selectedListName: 'Assigned POIs',
  onChanged: (items) => setState(() {
    selectedPoiIds = items.map((e) => e.value).nonNulls.toList();
  }),
)

// Custom equality
ThemedDualListInput<MyModel>(
  labelText: 'Items',
  items: models.map((m) => ThemedSelectItem(value: m, label: m.name)).toList(),
  value: selectedModels,
  compareFunction: (a, b) => a?.id == b?.id,
  onChanged: (items) => setState(() {
    selectedModels = items.map((e) => e.value).nonNulls.toList();
  }),
)

// Disabled
ThemedDualListInput<String>(
  labelText: 'Items',
  items: sourceList.map((e) => ThemedSelectItem(value: e.id, label: e.name)).toList(),
  value: selectedIds,
  disabled: true,
)
```

---

## Constructor

```dart
const ThemedDualListInput({
  super.key,
  this.labelText,
  this.label,
  required this.items,
  this.onChanged,
  this.value,
  this.disabled = false,
  this.errors = const [],
  this.translations = const {
    'actions.cancel': 'Cancel',
    'actions.save': 'Save',
    'layrz.duallist.search': 'Search in {name}',
    'layrz.duallist.toggleToSelected': 'Toggle all to selected',
    'layrz.duallist.toggleToAvailable': 'Toggle all to available',
  },
  this.overridesLayrzTranslations = false,
  this.height = 400,
  this.availableListName = 'Available',
  this.selectedListName = 'Selected',
  this.mobileScaleFactor = 2,
  this.compareFunction,
  this.itemExtent = 50,
}) : assert((label == null && labelText != null) || (label != null && labelText == null));
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `items` | `List<ThemedSelectItem<T>>` | required | All available items (both panels) |
| `value` | `List<T>?` | `null` | Currently selected values |
| `onChanged` | `void Function(List<ThemedSelectItem<T>>)?` | `null` | Fires with the full selected item list |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `disabled` | `bool` | `false` | Prevents item movement |
| `errors` | `List<String>` | `[]` | Validation messages shown below the widget |
| `height` | `double` | `400` | Height of each list panel (desktop) |
| `availableListName` | `String` | `'Available'` | Header label for the left (available) panel |
| `selectedListName` | `String` | `'Selected'` | Header label for the right (selected) panel |
| `mobileScaleFactor` | `double` | `2` | Multiplied by `height` on mobile (< `kExtraSmallGrid`) for stacked layout |
| `compareFunction` | `bool Function(T?, T?)?` | `null` | Custom equality; defaults to `==` |
| `itemExtent` | `double` | `50` | Fixed row height in each list |
| `translations` | `Map<String, String>` | (see below) | Fallback strings when i18n unavailable |
| `overridesLayrzTranslations` | `bool` | `false` | Force use of `translations` map |

---

## Translations map keys

| Key | Default | Notes |
|---|---|---|
| `actions.cancel` | `'Cancel'` | Cancel button |
| `actions.save` | `'Save'` | Save button |
| `layrz.duallist.search` | `'Search in {name}'` | Search field placeholder; `{name}` = list panel name |
| `layrz.duallist.toggleToSelected` | `'Toggle all to selected'` | Move-all-right button tooltip |
| `layrz.duallist.toggleToAvailable` | `'Toggle all to available'` | Move-all-left button tooltip |

---

## ThemedSelectItem<T>

```dart
ThemedSelectItem<T>(
  value: T,          // the stored value
  label: String,     // displayed text
  // onTap: VoidCallback?  // optional tap handler inside dialog
)
```

---

## Layout behavior

- Desktop: two panels side-by-side with arrow buttons between them.
- Mobile (width < `kExtraSmallGrid`): panels stack vertically; total height = `height * mobileScaleFactor`.
- Each panel has an independent search field.
- Individual row buttons move one item at a time; "Toggle all" buttons move all items at once.
