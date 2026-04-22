# ThemedTable2 — API Reference

Sources:
- `lib/src/table2/src/table.dart` — `ThemedTable2<T>`
- `lib/src/table2/src/column.dart` — `ThemedColumn2<T>`
- `lib/src/table2/src/controller.dart` — `ThemedTable2Controller<T>`
- `lib/src/table2/src/on_tap_behavior.dart` — `ThemedTable2OnTapBehavior`

---

## Examples

```dart
// Minimal — no actions, no multiselect
ThemedTable2<Asset>(
  items: store.assets,
  actionsCount: 0,
  hasMultiselect: false,
  columns: [
    ThemedColumn2<Asset>(
      headerText: 'Name',
      valueBuilder: (item) => item.name,
    ),
  ],
)

// With actions
ThemedTable2<Asset>(
  items: _items,
  actionsCount: 2,
  hasMultiselect: false,
  columns: [ /* ... */ ],
  actionsBuilder: (item) => [
    ThemedActionButton.edit(labelText: 'Edit', onTap: () => _edit(item)),
    ThemedActionButton.delete(labelText: 'Delete', onTap: () => _delete(item)),
  ],
)

// With multiselect
ThemedTable2<Asset>(
  items: _items,
  hasMultiselect: true,
  actionsCount: 0,
  multiselectValue: _selected,
  multiselectActions: [
    ThemedActionButton(
      icon: LayrzIcons.solarOutlineTrashBin,
      labelText: 'Delete selected',
      color: Colors.red,
      onTap: () => _deleteSelected(_selected.value),
    ),
  ],
  columns: [ /* ... */ ],
)

// With programmatic controller
final _controller = ThemedTable2Controller<Asset>();
// dispose in State.dispose()

ThemedTable2<Asset>(
  items: _items,
  controller: _controller,
  actionsCount: 0,
  hasMultiselect: false,
  columns: [ /* ... */ ],
)
_controller.sort(columnIndex: 0, ascending: true);
_controller.refresh();
```

---

## ThemedTable2 Constructor

```dart
const ThemedTable2({
  required this.items,
  required this.columns,
  super.key,
  this.actionsBuilder,
  this.actionsMobileBreakpoint = kSmallGrid,
  this.headerHeight = 40,
  this.actionsLabelText = 'Actions',
  this.hasMultiselect = true,
  this.actionsCount = 0,
  this.loadingLabelText = 'Computing data, please wait...',
  this.canSearch = true,
  this.minColumnWidth = 250,
  this.multiselectActions = const [],
  this.multiSelectionTitleText = 'Multiple items selected',
  this.multiSelectionContentText = 'You have selected multiple items. What do you want to do?',
  this.multiSelectionCancelLabelText = 'Clear',
  this.multiselectValue,
  this.populateDelay = const Duration(milliseconds: 150),
  this.reloadOnDidUpdate = false,
  this.onTapDefaultBehavior = .copyToClipboard,
  this.copyToClipboardText,
  this.controller,
})
// Asserts:
// - columns.length > 0
// - actionsCount >= 0
// - minColumnWidth > 0
// - actionsCount == 0 || actionsBuilder != null
// - hasMultiselect → multiselectActions.length > 0
```

---

## ThemedTable2 Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `items` | `List<T>` | required | Full dataset |
| `columns` | `List<ThemedColumn2<T>>` | required | At least one required |
| `actionsCount` | `int` | `0` | Expected number of actions per row; `0` hides actions column |
| `actionsBuilder` | `List<ThemedActionButton> Function(T)?` | `null` | Required when `actionsCount > 0` |
| `hasMultiselect` | `bool` | `true` | Shows checkbox column; requires `multiselectActions` |
| `multiselectActions` | `List<ThemedActionButton>` | `[]` | Required when `hasMultiselect: true` |
| `multiselectValue` | `ValueNotifier<List<T>>?` | `null` | External notifier to read/control selection |
| `canSearch` | `bool` | `true` | Shows search input above the table |
| `onTapDefaultBehavior` | `ThemedTable2OnTapBehavior` | `.copyToClipboard` | Cell tap behavior when no `onTap` on column |
| `controller` | `ThemedTable2Controller<T>?` | `null` | Programmatic sort/refresh |
| `populateDelay` | `Duration` | `150ms` | Delay before rendering data |
| `minColumnWidth` | `double` | `250` | Minimum width for flex columns |
| `headerHeight` | `double` | `40` | Header row height |
| `actionsMobileBreakpoint` | `double` | `kSmallGrid` | Width threshold for mobile action layout |
| `actionsLabelText` | `String` | `'Actions'` | Header label for actions column |
| `loadingLabelText` | `String` | `'Computing data...'` | Text shown during sort/filter |
| `reloadOnDidUpdate` | `bool` | `false` | Forces reload on hot reload (debug only) |
| `copyToClipboardText` | `String?` | `null` | Toast text override for copy-to-clipboard |
| `multiSelectionTitleText` | `String` | `'Multiple items selected'` | Fallback when i18n unavailable |
| `multiSelectionContentText` | `String` | `'You have selected...'` | Fallback when i18n unavailable |
| `multiSelectionCancelLabelText` | `String` | `'Clear'` | Fallback when i18n unavailable |

---

## ThemedColumn2 Constructor

```dart
ThemedColumn2({
  required this.headerText,
  required this.valueBuilder,
  this.richTextBuilder,
  this.alignment = .centerLeft,
  this.isSortable = true,
  this.width,
  this.onTap,
  this.customSort,
})
```

---

## ThemedColumn2 Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `headerText` | `String` | required | Column header label |
| `valueBuilder` | `String Function(T)` | required | Extracts plain string for sort, search, and display. **Must be isolate-safe** |
| `richTextBuilder` | `List<InlineSpan> Function(T)?` | `null` | Rich cell rendering; does NOT affect sort |
| `alignment` | `Alignment` | `.centerLeft` | Cell content alignment |
| `isSortable` | `bool` | `true` | Header click triggers sort |
| `width` | `double?` | `null` | Fixed pixel width; `null` = flex |
| `onTap` | `CellTap<T>?` | `null` | Per-cell tap; overrides `onTapDefaultBehavior` |
| `customSort` | `int Function(T a, T b, bool ascending)?` | `null` | Custom comparator. **Must be isolate-safe** |

---

## ThemedTable2OnTapBehavior

```dart
enum ThemedTable2OnTapBehavior {
  none,             // No action on cell tap
  copyToClipboard,  // Copies valueBuilder result to clipboard (default)
}
```

---

## ThemedTable2Controller<T>

```dart
final controller = ThemedTable2Controller<T>();

controller.sort(columnIndex: 0, ascending: true);  // Trigger sort
controller.refresh();                               // Re-filter + re-sort
controller.dispose();                               // Always call in State.dispose()
```

Wire via `controller` parameter on `ThemedTable2`. Controller must be disposed by the caller.

---

## Isolate safety

`valueBuilder` and `customSort` execute inside `compute()` (background isolate). They **cannot capture**:
- `BuildContext` (directly or indirectly)
- `LayrzAppLocalizations` / `i18n` (holds a `BuildContext`)
- `State`, streams, `AnimationController`, `ValueNotifier`
- Any Flutter widget or element

**Safe pattern:** precompute a `Map<String, String>` from `i18n` before the `ThemedTable2(...)` call, reference the map inside `valueBuilder`.

---

## Anti-patterns

| Anti-pattern | Fix |
|---|---|
| `valueBuilder: (item) => i18n.t(item.key)` | Precompute `Map<String, String>` from i18n outside the column |
| `customSort` capturing `context` or `store` | Use only item fields inside `customSort` |
| `actionsCount: 2` without `actionsBuilder` | Assert failure — always pair them |
| `hasMultiselect: true` with empty `multiselectActions` | Assert failure — provide at least one action |
| `ThemedTable2` without `Expanded` or fixed height | Layout overflow/crash — always bound the height |
