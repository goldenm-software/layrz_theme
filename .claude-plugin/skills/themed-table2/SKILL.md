---
name: themed-table2
description: ThemedTable2<T> and ThemedColumn2<T> — large-dataset virtualized table with sort, search, multiselect and actions
---

## Overview

`ThemedTable2<T>` is the layrz_theme table widget designed for **large datasets** (tested up to 55,000+ rows). It uses Flutter's `ListView.builder` with a fixed `itemExtent` for virtualized rendering, and offloads sort operations to a background isolate via `compute()`.

| Feature | Details |
|---|---|
| Rendering | Virtualized — only visible rows are built |
| Sort | Background isolate via `compute()`, non-blocking |
| Search | Debounced 600ms, searches all column values |
| Multiselect | Optional checkbox column with bulk actions |
| Actions | Per-row action buttons (icon-only on desktop, menu on mobile) |
| Scroll sync | Header + content + multiselect + actions scroll in sync |

**When to use:** Any time you display a list of domain objects in a table format. Handles both small and large datasets — it's the standard table for all modules.

---

## ThemedColumn2\<T\>

Defines a single column: its header, how to extract the display value from `T`, and optional rich rendering.

### Key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `headerText` | `String` | required | Column header label |
| `valueBuilder` | `String Function(T)` | required | Extracts the plain string value — used for sort, search, and cell display. **Must be isolate-safe** (see Isolate Safety below) |
| `richTextBuilder` | `List<InlineSpan> Function(T)?` | `null` | Custom rich rendering for the cell. Does NOT affect sort — sort always uses `valueBuilder` |
| `width` | `double?` | `null` | Fixed width in pixels. If `null`, column takes a flexible share of available space |
| `alignment` | `Alignment` | `.centerLeft` | Cell content alignment |
| `isSortable` | `bool` | `true` | Whether clicking the header triggers sort |
| `onTap` | `void Function(T)?` | `null` | Per-cell tap handler. Overrides `onTapDefaultBehavior` |
| `customSort` | `int Function(T a, T b, bool ascending)?` | `null` | Custom comparator. **Must be isolate-safe** (see Isolate Safety below) |

### Minimal column

```dart
ThemedColumn2<Asset>(
  headerText: 'Name',
  valueBuilder: (item) => item.name,
)
```

### Fixed-width column

```dart
ThemedColumn2<Asset>(
  headerText: 'ID',
  width: 80,
  valueBuilder: (item) => item.id ?? 'N/A',
)
```

### Column with rich cell rendering

```dart
// State — precompute labels map outside the build method
final Map<String, String> statusLabels = {
  'active': i18n.t('status.active'),
  'inactive': i18n.t('status.inactive'),
};

// Widget
ThemedColumn2<Asset>(
  headerText: i18n.t('asset.status'),
  valueBuilder: (item) => statusLabels[item.status] ?? item.status ?? 'N/A',
  richTextBuilder: (item) => [
    WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: StatusChip(status: item.status),
    ),
  ],
)
```

### Column with custom sort

```dart
ThemedColumn2<Asset>(
  headerText: 'Plate',
  valueBuilder: (item) => item.plate ?? 'N/A',
  customSort: (a, b, ascending) {
    // ascending == true means A→Z
    final result = (a.plate ?? '').compareTo(b.plate ?? '');
    return ascending ? result : -result;
  },
)
```

---

## ThemedTable2\<T\>

### Key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `items` | `List<T>` | required | Full dataset. Pass all items — filtering and sorting happen internally |
| `columns` | `List<ThemedColumn2<T>>` | required | At least one column required |
| `actionsCount` | `int` | `0` | Max number of actions per row. Set to `0` to hide the actions column. Must match the actual number returned by `actionsBuilder` |
| `actionsBuilder` | `List<ThemedActionButton> Function(T)?` | `null` | Required when `actionsCount > 0` |
| `canSearch` | `bool` | `true` | Shows the search input above the table |
| `hasMultiselect` | `bool` | `true` | Shows the checkbox column. Requires `multiselectActions` |
| `multiselectActions` | `List<ThemedActionButton>` | `[]` | Bulk action buttons shown when rows are selected. Required when `hasMultiselect: true` |
| `multiselectValue` | `ValueNotifier<List<T>>?` | `null` | External notifier to read/control the selection from outside |
| `onTapDefaultBehavior` | `ThemedTable2OnTapBehavior` | `.copyToClipboard` | What happens when a cell without `onTap` is tapped |
| `controller` | `ThemedTable2Controller<T>?` | `null` | Programmatic control: trigger sort or refresh from outside |
| `populateDelay` | `Duration` | `150ms` | Delay before showing data (gives the loading spinner time to appear) |
| `minColumnWidth` | `double` | `250` | Minimum width for flex columns |
| `headerHeight` | `double` | `40` | Header row height |
| `reloadOnDidUpdate` | `bool` | `false` | Forces reload on hot reload (debug only) |

---

## Minimal usage

```dart
// State
final List<Asset> _assets = store.assets;

// Widget
ThemedTable2<Asset>(
  items: _assets,
  actionsCount: 0,
  hasMultiselect: false,
  columns: [
    ThemedColumn2<Asset>(
      headerText: 'Name',
      valueBuilder: (item) => item.name,
    ),
    ThemedColumn2<Asset>(
      headerText: 'Plate',
      valueBuilder: (item) => item.plate ?? 'N/A',
    ),
  ],
)
```

---

## Common patterns

### With search + actions

```dart
// State
final List<Asset> _items = store.assets;
bool _isLoading = false;

// Widget
ThemedTable2<Asset>(
  items: _items,
  canSearch: true,
  actionsCount: 2,
  hasMultiselect: false,
  columns: [
    ThemedColumn2<Asset>(
      headerText: i18n.t('asset.name'),
      valueBuilder: (item) => item.name,
    ),
    ThemedColumn2<Asset>(
      headerText: i18n.t('asset.plate'),
      width: 150,
      valueBuilder: (item) => item.plate ?? 'N/A',
    ),
  ],
  actionsBuilder: (item) => [
    ThemedActionButton.edit(
      labelText: i18n.t('actions.edit'),
      isLoading: _isLoading,
      onTap: () => _onEdit(item),
    ),
    ThemedActionButton.delete(
      labelText: i18n.t('actions.delete'),
      isLoading: _isLoading,
      onTap: () => _onDelete(item),
    ),
  ],
)
```

### With multiselect

```dart
// State
final ValueNotifier<List<Asset>> _selected = ValueNotifier([]);

// Widget
ThemedTable2<Asset>(
  items: _items,
  hasMultiselect: true,
  actionsCount: 0,
  multiselectValue: _selected,
  multiselectActions: [
    ThemedActionButton(
      icon: LayrzIcons.solarOutlineTrashBin,
      labelText: i18n.t('actions.deleteSelected'),
      color: Colors.red,
      onTap: () => _onDeleteSelected(_selected.value),
    ),
  ],
  columns: [ /* ... */ ],
)
```

### With richTextBuilder

```dart
// State — precompute labels to avoid capturing i18n in valueBuilder
final Map<String, String> _fuelLabels = {
  for (final type in AtsFuelSubType.values)
    if (type != AtsFuelSubType.unknown)
      type.toJson(): i18n.t(type.getLocaleKey()),
};

// Widget
ThemedColumn2<CaclEntity>(
  headerText: i18n.t('cacl.product'),
  // valueBuilder must return a plain string — used for sort and search
  valueBuilder: (item) => _fuelLabels[item.product] ?? 'N/A',
  // richTextBuilder only affects visual rendering — not sort
  richTextBuilder: (item) {
    final type = AtsFuelSubType.fromJson(item.product ?? '');
    if (type == AtsFuelSubType.unknown) return [const TextSpan(text: 'N/A')];
    return [WidgetSpan(child: type.chip(i18n: i18n))];
  },
)
```

### With programmatic controller

```dart
// State
final _controller = ThemedTable2Controller<Asset>();

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

// Widget
ThemedTable2<Asset>(
  items: _items,
  controller: _controller,
  columns: [ /* ... */ ],
  actionsCount: 0,
  hasMultiselect: false,
)

// Programmatic sort (column index 0, ascending)
_controller.sort(columnIndex: 0, ascending: true);

// Programmatic refresh (re-runs filter + sort with current state)
_controller.refresh();
```

### Disable copy-to-clipboard on cell tap

```dart
ThemedTable2<Asset>(
  items: _items,
  onTapDefaultBehavior: ThemedTable2OnTapBehavior.none,
  columns: [ /* ... */ ],
  actionsCount: 0,
  hasMultiselect: false,
)
```

---

## ⚠️ Isolate Safety — CRITICAL

`valueBuilder` and `customSort` are executed inside a background isolate via `compute()`. **They cannot capture any Flutter objects from the widget tree.** If they do, the app will crash at runtime with:

```
Invalid argument(s): Illegal argument in isolate message: object is unsendable
```

### What you CANNOT capture in valueBuilder or customSort

- `BuildContext` (directly or indirectly)
- `LayrzAppLocalizations` / `i18n` — it's an `InheritedWidget` that holds a reference to `BuildContext`
- `State` objects
- Streams, `AnimationController`, `ValueNotifier`
- Any Flutter widget or element

### Safe patterns

```dart
// ❌ CRASH — i18n captures BuildContext
ThemedColumn2<Asset>(
  headerText: i18n.t('asset.status'),
  valueBuilder: (item) => i18n.t('status.${item.status}'),
)

// ✅ SAFE — precompute a simple Map of strings outside the column
final Map<String, String> statusLabels = {
  'active': i18n.t('status.active'),
  'inactive': i18n.t('status.inactive'),
  'archived': i18n.t('status.archived'),
};

ThemedColumn2<Asset>(
  headerText: i18n.t('asset.status'),
  valueBuilder: (item) => statusLabels[item.status] ?? item.status ?? 'N/A',
)

// ✅ SAFE — pure function, no captured Flutter objects
ThemedColumn2<Asset>(
  headerText: 'Name',
  valueBuilder: (item) => item.name.toUpperCase(),
)

// ✅ SAFE — customSort with no captured state
ThemedColumn2<Asset>(
  headerText: 'Created',
  valueBuilder: (item) => item.createdAt?.toIso8601String() ?? '',
  customSort: (a, b, ascending) {
    final dtA = a.createdAt ?? DateTime(0);
    final dtB = b.createdAt ?? DateTime(0);
    return ascending ? dtA.compareTo(dtB) : dtB.compareTo(dtA);
  },
)
```

### Rule of thumb

> If you need translated labels in a column, build a `Map<String, String>` from `i18n` **before** the `ThemedTable2(...)` call and reference that map inside `valueBuilder`. The map is a plain Dart object — sendable. `i18n` itself is not.

---

## Anti-patterns

| Anti-pattern | Why it's wrong | Fix |
|---|---|---|
| `valueBuilder: (item) => i18n.t(item.key)` | Captures `i18n` → `BuildContext` → non-sendable, runtime crash | Precompute a `Map<String, String>` from `i18n` outside the column |
| `customSort` capturing `context` or `store` | Same crash as above | Use only item fields inside `customSort` |
| `actionsCount: 2` without `actionsBuilder` | Assert failure at construction | Always provide `actionsBuilder` when `actionsCount > 0` |
| `hasMultiselect: true` with empty `multiselectActions` | Assert failure at construction | Always provide at least one `multiselectAction` |
| Two columns with the same `headerText` | Header tooltip and sort icon display are ambiguous | Use distinct `headerText` values, or add `width` to differentiate |
| Calling `ThemedTable2` without wrapping in `Expanded` inside a `Column` | Table needs bounded height to render — will overflow or crash layout | Always wrap in `Expanded` or give it a fixed `height` |
| Using `item.hashCode` as a key in external Maps | `hashCode` can collide; use `identityHashCode(item)` for identity-based keys | Use `identityHashCode(item)` or a unique field like `item.id` |

---

## Controller API

```dart
final controller = ThemedTable2Controller<T>();

// Sort by column index
controller.sort(columnIndex: 0, ascending: true);

// Force re-filter and re-sort (useful when items changed externally)
controller.refresh();

// Always dispose
controller.dispose();
```

The controller communicates via an event bus (`ThemedTable2SortEvent`, `ThemedTable2RefreshEvent`). Wire it up via the `controller` parameter on `ThemedTable2`.

---

## Integration in a module view

```dart
class _AssetsViewState extends State<AssetsView> {
  // State — precompute translated labels for isolate-safe valueBuilders
  late final Map<String, String> _categoryLabels = {
    for (final cat in store.categories)
      cat.id: cat.name,
  };

  @override
  Widget build(BuildContext context) {
    final i18n = LayrzAppLocalizations.of(context);

    return Expanded(
      child: ThemedTable2<Asset>(
        items: store.assets,
        canSearch: true,
        actionsCount: 3,
        hasMultiselect: true,
        multiselectActions: [
          ThemedActionButton(
            icon: LayrzIcons.solarOutlineTrashBin,
            labelText: i18n.t('actions.deleteSelected'),
            color: Colors.red,
            onTap: _onDeleteSelected,
          ),
        ],
        columns: [
          ThemedColumn2<Asset>(
            headerText: 'ID',
            width: 80,
            valueBuilder: (item) => item.id ?? 'N/A',
          ),
          ThemedColumn2<Asset>(
            headerText: i18n.t('asset.name'),
            valueBuilder: (item) => item.name,
          ),
          ThemedColumn2<Asset>(
            headerText: i18n.t('asset.category'),
            // Safe: _categoryLabels is a plain Map, not a Flutter object
            valueBuilder: (item) => _categoryLabels[item.categoryId] ?? 'N/A',
          ),
        ],
        actionsBuilder: (item) => [
          ThemedActionButton.show(
            labelText: i18n.t('actions.show'),
            onTap: () => _onShow(item),
          ),
          ThemedActionButton.edit(
            labelText: i18n.t('actions.edit'),
            onTap: () => _onEdit(item),
          ),
          ThemedActionButton.delete(
            labelText: i18n.t('actions.delete'),
            onTap: () => _onDelete(item),
          ),
        ],
      ),
    );
  }
}
```
