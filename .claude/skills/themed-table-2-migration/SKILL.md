---
name: themed-table-2-migration
description: Use when migrating ThemedTable<T> (v1) to ThemedTable2<T> (v2) in a layrz Flutter widget. Apply when a widget uses the old ThemedTable API with onShow/onEdit/onDelete/onMultiDelete/ThemedColumn and needs to be updated.
---

> **Full API reference for ThemedTable2:** load the `themed-table-2` skill.

---

## V1 → V2 cheatsheet

| `ThemedTable<T>` v1 | `ThemedTable2<T>` v2 |
|---|---|
| `module: '...'` | removed |
| `onAdd: canCreate ? _newItem : null` | `ThemedButton` above the table, outside `ThemedTable2` |
| `onShow: (_, item) => ...` | `ThemedActionButton.show(onTap: () => _getItem(item))` in `actionsBuilder` |
| `onEdit: (_, item) => ...` | `ThemedActionButton.edit(onTap: () => _editItem(item))` in `actionsBuilder` |
| `onDelete: (_, item) => ...` | `ThemedActionButton.delete(onTap: () => _deleteItem(item))` in `actionsBuilder` |
| `additionalActions: (context, item) => [...]` | merge into `actionsBuilder`, bump `actionsCount` |
| `onMultiDelete: (_, List<T>) async => bool` | `hasMultiselect: true` + `multiselectValue` + `multiselectActions` |
| `idBuilder:` | removed |
| `isLoading:`, `isCooldown:`, `onCooldown:` (table-level) | removed — move to each `ThemedActionButton` |
| `ThemedColumn(labelText, valueBuilder: (context, item) => ...)` | `ThemedColumn2<T>(headerText, valueBuilder: (item) => ...)` |
| `widgetBuilder: (context, item) => Widget` | `richTextBuilder: (item) => [WidgetSpan(child: ...)]` |
| no height constraint | **requires bounded height** — wrap in `Expanded` |

---

## Migration steps

### 1. State fields

Add to `State<T>`:

```dart
bool _isLoading = false;
bool _isCooldown = false;
final ValueNotifier<List<MyModel>> _selectedItems = ValueNotifier([]);

int get _actionsCount =>
    1 /* show */ +
    (widget.canEdit ? 1 : 0) +
    (widget.canDelete ? 1 : 0);
    // + 1 per extra custom action

@override
void dispose() {
  _selectedItems.dispose();
  super.dispose();
}
```

### 2. Precompute isolate-safe i18n maps

`valueBuilder` runs in a background isolate — it **cannot** capture `i18n`, `BuildContext`, or any Flutter object. Precompute plain Dart maps before the widget call:

```dart
// In build(), before ThemedTable2(...):
final String noProtocolLabel = i18n.t('services.inbound.noProtocol');
final Map<String, String> protocolLabels = {
  for (final p in widget.protocols)
    p.name: i18n.t('protocols.inbound.${p.name}'),
};
```

### 3. Layout wrapper

Wrap the table in a `Column` with a conditional create button and `Expanded`:

```dart
return Column(
  children: [
    if (widget.canCreate)
      Padding(
        padding: const EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.centerRight,
          child: ThemedButton(
            labelText: i18n.t('...title.new'),
            icon: MdiIcons.plus,
            onTap: _newItem,
          ),
        ),
      ),
    Expanded(
      child: ThemedTable2<MyModel>(/* ... */),
    ),
  ],
);
```

### 4. Row actions → `actionsBuilder`

```dart
actionsCount: _actionsCount,
actionsBuilder: (item) => [
  ThemedActionButton.show(          // NOTE: .show, not .view
    labelText: i18n.t('helpers.buttons.show'),
    isLoading: _isLoading,
    isCooldown: _isCooldown,
    onCooldownFinish: () => setState(() => _isCooldown = false),
    onTap: () => _getItem(item),
  ),
  if (widget.canEdit)
    ThemedActionButton.edit(
      labelText: i18n.t('helpers.buttons.edit'),
      isLoading: _isLoading,
      isCooldown: _isCooldown,
      onCooldownFinish: () => setState(() => _isCooldown = false),
      onTap: () => _editItem(item),
    ),
  if (widget.canDelete)
    ThemedActionButton.delete(
      labelText: i18n.t('helpers.buttons.delete'),
      isLoading: _isLoading,
      isCooldown: _isCooldown,
      onCooldownFinish: () => setState(() => _isCooldown = false),
      onTap: () => _deleteItem(item),
    ),
],
```

`actionsCount` **must equal** the maximum list length returned — use the same conditional structure.

### 5. Multiselect (replaces `onMultiDelete`)

```dart
hasMultiselect: widget.canDelete,
multiselectValue: _selectedItems,
multiselectActions: [
  ThemedActionButton(
    color: Colors.red,
    icon: LayrzIcons.solarOutlineTrashBinMinimalistic2,
    labelText: i18n.t('helpers.multipleSelection.actions.delete'),
    isLoading: _isLoading,
    onTap: () async {
      final ok = await deleteConfirmationDialog(
        context: context,
        isMultiple: true,
        isCooldown: false,
        isLoading: _isLoading,
      );
      if (!ok || !mounted) {
        _selectedItems.value = [];
        return;
      }
      final deleted = await _deleteItems(_selectedItems.value);
      if (deleted) _selectedItems.value = [];
    },
  ),
],
```

### 6. Update helper signatures

Remove the leading `_` positional argument from all action callbacks:

```dart
// v1
Future<void> _getItem(_, MyModel item) async { ... }
Future<bool> _deleteItems(_, List<MyModel> items) async { ... }

// v2
Future<void> _getItem(MyModel item) async { ... }
Future<bool> _deleteItems(List<MyModel> items) async { ... }
```

### 7. Rewrite columns

```dart
// v1
ThemedColumn(
  labelText: i18n.t('...'),
  valueBuilder: (context, item) => item.name,
)

// v2
ThemedColumn2<MyModel>(
  headerText: i18n.t('...'),
  valueBuilder: (item) => item.name,   // no context
)
```

For columns calling `i18n.t(...)` in v1, use the precomputed map from step 2:

```dart
ThemedColumn2<MyModel>(
  headerText: i18n.t('services.inbound.protocol'),
  valueBuilder: (item) {
    final name = item.protocol?.name;
    if (name == null) return noProtocolLabel;
    return protocolLabels[name] ?? name;
  },
),
```

### 7b. Custom cell widgets — `richTextBuilder`

v1 `widgetBuilder: (context, item) => Widget` becomes `richTextBuilder: (item) => List<InlineSpan>`.

`richTextBuilder` runs **in the widget tree** (not in the isolate) — `Theme.of(context)`, `i18n`, and State fields are all safe here:

```dart
ThemedColumn2<MyModel>(
  headerText: i18n.t('...progress'),
  valueBuilder: (item) => _humanizeDuration(item),     // isolate-safe: drives sort/search
  richTextBuilder: (item) => [                          // context-safe: drives display
    WidgetSpan(
      child: LinearProgressIndicator(value: item.progress),
    ),
  ],
),
```

### 8. Drop removed props

Remove from the `ThemedTable2` call: `module:`, `idBuilder:`, `isLoading:`, `isCooldown:`, `onCooldown:`.

---

## Anti-patterns

| Mistake | Fix |
|---|---|
| `valueBuilder: (item) => i18n.t(item.key)` | Precompute `Map<String,String>` from i18n before the widget |
| `actionsCount: 3` but `actionsBuilder` returns 2 conditionally | Compute `_actionsCount` with the same `if` conditions |
| `hasMultiselect: true` with `multiselectActions: []` | Always provide at least one action |
| No `Expanded` or fixed height around `ThemedTable2` | Layout overflow — wrap in `Expanded` |
| Forgetting `_selectedItems.dispose()` | Memory leak warning in debug |
| Dropping a v1 `widgetBuilder` entirely | Use `richTextBuilder` + `WidgetSpan` — it is context-safe |
| `Theme.of(context)` inside `valueBuilder` | Move visual logic to `richTextBuilder`; keep `valueBuilder` isolate-safe |
| Helper signature still `(_, item)` | Drop the leading `_` positional arg |
| Using `ThemedActionButton.view` | No such factory — use `ThemedActionButton.show` |
