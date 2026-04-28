---
name: themed-table-2
description: Use ThemedTable2<T> in a layrz Flutter widget. Apply when displaying a list of domain objects in a table with sort, search, multiselect, and row actions.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Displaying lists of domain objects in tabular form (assets, users, reports, etc.)
- Handles small and large datasets — tested up to 55,000+ rows via virtualized rendering
- Use `ThemedColumn2<T>` to define columns alongside `ThemedTable2<T>`

---

## Minimal usage

```dart
ThemedTable2<Asset>(
  items: store.assets,
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

Always wrap in `Expanded` or give a fixed height — `ThemedTable2` requires bounded height.

---

## Key behaviors

- Virtualized via `ListView.builder` + fixed `itemExtent` — only visible rows are rendered.
- Sort runs in a background isolate via `compute()` — **valueBuilder and customSort must be isolate-safe** (no BuildContext, no i18n, no Flutter objects).
- Search is debounced 600ms and searches all column values.
- `actionsCount` must equal the number of buttons `actionsBuilder` actually returns — assert enforced.
- `hasMultiselect: true` requires at least one entry in `multiselectActions` — assert enforced.
- `onTapDefaultBehavior` defaults to `.copyToClipboard`; set to `.none` to disable.
- `onFilteredCountChanged` fires after every `_filterAndSort` cycle (initial load, search, sort, `items` update) with the visible row count. Fires with `0` for an empty dataset. Optional — `null` by default, no overhead when omitted.

---

## Isolate safety — CRITICAL

`valueBuilder` and `customSort` run inside a background isolate. They **cannot capture Flutter objects** (BuildContext, i18n, State, Streams, widgets). Doing so causes a runtime crash:

```
Invalid argument(s): Illegal argument in isolate message: object is unsendable
```

**Wrong:**
```dart
// ❌ CRASH — i18n captures BuildContext
valueBuilder: (item) => i18n.t('status.${item.status}'),
```

**Right:**
```dart
// ✅ SAFE — precompute a plain Map before the ThemedTable2 call
final Map<String, String> statusLabels = {
  'active': i18n.t('status.active'),
  'inactive': i18n.t('status.inactive'),
};

valueBuilder: (item) => statusLabels[item.status] ?? item.status ?? 'N/A',
```

---

## Common patterns

```dart
// With search + actions
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
      onTap: () => _onEdit(item),
    ),
    ThemedActionButton.delete(
      labelText: i18n.t('actions.delete'),
      onTap: () => _onDelete(item),
    ),
  ],
)

// With multiselect
final ValueNotifier<List<Asset>> _selected = ValueNotifier([]);

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

// With filtered count callback
ThemedTable2<Asset>(
  items: _items,
  canSearch: true,
  actionsCount: 0,
  hasMultiselect: false,
  onFilteredCountChanged: (count) {
    setState(() => _visibleCount = count);
  },
  columns: [ /* ... */ ],
)

// With programmatic controller
final _controller = ThemedTable2Controller<Asset>();

// In dispose():
_controller.dispose();

ThemedTable2<Asset>(
  items: _items,
  controller: _controller,
  columns: [ /* ... */ ],
  actionsCount: 0,
  hasMultiselect: false,
)

// Trigger sort programmatically
_controller.sort(columnIndex: 0, ascending: true);
_controller.refresh();
```
