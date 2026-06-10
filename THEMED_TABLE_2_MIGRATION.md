# `ThemedTable` → `ThemedTable2` Migration Guide

This is a recipe for migrating any `ThemedTable<T>` (v1) usage to
`ThemedTable2<T>` in a Layrz Flutter package. It was derived from the
actual migration of `layrz_inbound_services/lib/src/listing.dart` and
is intended to be handed to an AI assistant to drive future migrations
in other packages.

Skill to load for the full API reference:
`layrz-theme:themed-table-2` → run `references/api.md` inside that skill.

---

## TL;DR cheatsheet

| `ThemedTable<T>` v1 | `ThemedTable2<T>` v2 |
|---|---|
| `module: '...'` | removed |
| `onAdd: canCreate ? _newItem : null` | render a `ThemedButton` **above** the table (outside `ThemedTable2`) |
| `onShow: (_, item) => ...` | `ThemedActionButton.show(onTap: () => _getItem(item), ...)` inside `actionsBuilder` |
| `onEdit: (_, item) => ...` | `ThemedActionButton.edit(onTap: () => _editItem(item), ...)` inside `actionsBuilder` |
| `onDelete: (_, item) => ...` | `ThemedActionButton.delete(onTap: () => _deleteItem(item), ...)` inside `actionsBuilder` |
| `additionalActions: (context, item) => [...]` | merge those buttons into `actionsBuilder`, bump `actionsCount` |
| `onMultiDelete: (_, List<T>) async => bool` | `hasMultiselect: true` + `multiselectValue: ValueNotifier<List<T>>` + `multiselectActions: [...]` |
| `idBuilder: (context, item) => item.id` | removed |
| `isLoading:`, `isCooldown:`, `onCooldown:` on the table | removed — move to each `ThemedActionButton` via `isLoading`, `isCooldown`, `onCooldownFinish` |
| `ThemedColumn(labelText, valueBuilder: (context, item) => ...)` | `ThemedColumn2<T>(headerText, valueBuilder: (item) => ...)` |
| `valueBuilder` may call `i18n.t(...)` | **must be isolate-safe** — precompute `Map<String,String>` from `i18n` before the widget call |
| `widgetBuilder: (context, item) => Widget` | `richTextBuilder: (item) => [WidgetSpan(child: ...)]` — context-safe, runs in widget tree |
| No height constraint required | **`ThemedTable2` requires bounded height** — wrap in `Expanded` |
| (implicit) | new required: `actionsCount` (int), `hasMultiselect` (bool) |

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
    (widget.canDelete ? 1 : 0) +
    /* + 1 for each extra custom action */;
```

Remove the empty `initState()` override if it has no body.

Add `dispose()`:

```dart
@override
void dispose() {
  _selectedItems.dispose();
  super.dispose();
}
```

The `_isLoading`/`_isCooldown` fields are now driven only by individual
action-button `onTap` handlers and the `_handleSnackbar` cooldown callback
— they are no longer passed to the table.

### 2. Precompute isolate-safe i18n maps

`ThemedTable2` runs sort and filter inside `compute()` (a background
isolate). Anything captured by `valueBuilder` or `customSort` **must be
sendable** across isolates. `BuildContext`, `i18n`, `State`, streams,
`ValueNotifier`, and every Flutter widget are **not** sendable — capturing
them crashes at runtime with `Illegal argument in isolate message`.

For every column whose v1 `valueBuilder` called `i18n.t(...)`, precompute
plain Dart objects _before_ the `ThemedTable2(...)` call inside `build()`:

```dart
// Fixed fallback string
final String noProtocolLabel = i18n.t('services.inbound.noProtocol');

// Lookup map built from a widget list
final Map<String, String> protocolLabels = {
  for (final p in widget.inboundProtocols)
    p.name: i18n.t('protocols.inbound.${p.name}'),
};
```

Inside `valueBuilder`, only read these plain maps and the item's own
fields — never call `i18n`, reference `context`, or close over state.

### 3. Layout wrapper

Replace the bare `return ThemedTable<T>(...)` with a `Column` that places
a conditional "create" button above a height-bounded table:

```dart
return Column(
  children: [
    if (widget.canCreate)
      Padding(
        padding: const EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.centerRight,
          child: ThemedButton(
            labelText: i18n.t('services.inbound.title.new'),
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

`ThemedTable2` is a virtualized `ListView` and **must** have bounded
height — `Expanded` is the idiomatic way inside a `Column`.

### 4. Row actions → `actionsBuilder`

Replace `onShow` / `onEdit` / `onDelete` / `additionalActions` with a
single `actionsBuilder`:

```dart
actionsCount: _actionsCount,
actionsBuilder: (item) => [
  ThemedActionButton.show(
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
  // custom action example (enable/disable toggle):
  ThemedActionButton(
    onlyIcon: true,
    color: (item.isEnabled ?? false) ? Colors.red : Colors.green,
    icon: (item.isEnabled ?? false)
        ? MdiIcons.stopCircleOutline
        : MdiIcons.playCircleOutline,
    labelText: i18n.t('services.inbound.toggle'),
    isLoading: _isLoading,
    isCooldown: _isCooldown,
    onCooldownFinish: () => setState(() => _isCooldown = false),
    onTap: () async {
      setState(() => _isLoading = true);
      await myAsyncCall();
      setState(() => _isLoading = false);
    },
  ),
],
```

Key notes:
- Factory name is **`.show`**, not `.view`.
- `actionsCount` **must equal** the maximum list length actually returned.
  Use the same conditional structure as the list.
- Loading/cooldown state is now on each button, not the table.

### 5. Bulk operations → multiselect

Replace `onMultiDelete: (_, List<T>) async => bool` with:

```dart
hasMultiselect: widget.canDelete,  // or just true
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

Remove the leading `_` positional argument from all action callbacks (the
v1 `CellTap`-style `(id, item)` pair). New signatures:

```dart
// v1
Future<void> _getItem(_, InboundService item) async { ... }
Future<void> _editItem(_, InboundService item) async { ... }
Future<void> _deleteItem(_, InboundService item) async { ... }
Future<bool> _deleteItems(_, List<InboundService> items) async { ... }

// v2
Future<void> _getItem(InboundService item) async { ... }
Future<void> _editItem(InboundService item) async { ... }
Future<void> _deleteItem(InboundService item) async { ... }
Future<bool> _deleteItems(List<InboundService> items) async { ... }
```

Call sites inside `actionsBuilder` / `multiselectActions` pass the item
directly: `onTap: () => _getItem(item)`.

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
  valueBuilder: (item) => item.name,  // no context
)
```

For columns that previously called `i18n.t(...)` inside `valueBuilder`,
use the precomputed map from step 2:

```dart
ThemedColumn2<InboundService>(
  headerText: i18n.t('services.inbound.protocol'),
  valueBuilder: (item) {
    final name = item.protocol?.name;
    if (name == null) return noProtocolLabel;     // precomputed String
    return protocolLabels[name] ?? name;          // precomputed Map
  },
),
```

### 7b. Custom cell widgets — `richTextBuilder`

v1 `ThemedColumn` had a `widgetBuilder: (context, item) => Widget` for
arbitrary per-cell widget rendering. v2 replaces this with
`richTextBuilder: (item) => List<InlineSpan>`.

**Critical**: `richTextBuilder` runs in the **widget tree** (not inside
`compute()`), so it is **context-safe** — `Theme.of(context)`, `isDark`,
`i18n.t(...)`, and any State fields are all legal to use inside it.
`valueBuilder` (isolate-unsafe) still drives sort and search; `richTextBuilder`
only overrides the visual display.

Use `WidgetSpan` to embed arbitrary widgets:

```dart
// Keep a context-safe getter on your State:
bool get isDark => Theme.of(context).brightness == Brightness.dark;

ThemedColumn2<MonitorActiveCheckpoint>(
  headerText: i18n.t('one.monitor.checkpoints.progress'),
  // isolate-safe: drives sort/search
  valueBuilder: (item) => _humanizeDuration(item),
  // context-safe: drives visual display
  richTextBuilder: (item) {
    final int completed = item.waypoints.where((w) => w.startAt != null && w.endAt != null).length;
    final int total = item.waypoints.length;
    return [
      WidgetSpan(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_humanizeDuration(item), style: Theme.of(context).textTheme.bodySmall),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: LinearProgressIndicator(
                  backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  minHeight: 8,
                  color: Colors.green,
                  value: completed / total,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  },
),
```

### 8. Drop removed table-level props

Remove from the `ThemedTable2(...)` call site:

- `module:`
- `idBuilder:`
- `isLoading:` (table-level)
- `isCooldown:` (table-level)
- `onCooldown:`

### 9. Optional niceties

- `canSearch: true` — shows search input (default is already `true`).
- `onTapDefaultBehavior: .copyToClipboard` — copies cell text on tap
  (the default). Set to `.none` to disable.

---

## Final shape of `build()`

The complete `build()` skeleton after migration:

```dart
@override
Widget build(BuildContext context) {
  // Step 2: precompute isolate-safe strings
  final String noProtocolLabel = i18n.t('services.inbound.noProtocol');
  final Map<String, String> protocolLabels = {
    for (final p in widget.inboundProtocols)
      p.name: i18n.t('protocols.inbound.${p.name}'),
  };

  // Step 3: layout wrapper
  return Column(
    children: [
      if (widget.canCreate)
        Padding(
          padding: const EdgeInsets.all(8),
          child: Align(
            alignment: Alignment.centerRight,
            child: ThemedButton(
              labelText: i18n.t('services.inbound.title.new'),
              icon: MdiIcons.plus,
              onTap: _newItem,
            ),
          ),
        ),
      Expanded(
        child: ThemedTable2<InboundService>(
          items: widget.items,
          canSearch: true,
          // Step 4: actionsCount + actionsBuilder
          actionsCount: _actionsCount,
          actionsBuilder: (item) => [
            ThemedActionButton.show(
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
            ThemedActionButton(
              onlyIcon: true,
              color: (item.isEnabled ?? false) ? Colors.red : Colors.green,
              icon: (item.isEnabled ?? false)
                  ? MdiIcons.stopCircleOutline
                  : MdiIcons.playCircleOutline,
              labelText: i18n.t('services.inbound.toggle'),
              isLoading: _isLoading,
              isCooldown: _isCooldown,
              onCooldownFinish: () => setState(() => _isCooldown = false),
              onTap: () async {
                setState(() => _isLoading = true);
                await toggleState(/* ... */);
                setState(() => _isLoading = false);
              },
            ),
          ],
          // Step 5: multiselect
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
          // Step 7: columns
          columns: [
            ThemedColumn2<InboundService>(
              headerText: i18n.t('services.inbound.name'),
              valueBuilder: (item) => item.name,
            ),
            ThemedColumn2<InboundService>(
              headerText: i18n.t('services.inbound.protocol'),
              valueBuilder: (item) {
                final name = item.protocol?.name;
                if (name == null) return noProtocolLabel;
                return protocolLabels[name] ?? name;
              },
            ),
          ],
        ),
      ),
    ],
  );
}
```

---

## Anti-patterns and gotchas

| Mistake | Consequence | Fix |
|---|---|---|
| `valueBuilder: (item) => i18n.t(item.key)` | Runtime crash: `Illegal argument in isolate message` when sorting/filtering | Precompute `Map<String,String>` before the widget call |
| `actionsCount: 3` but `actionsBuilder` returns 2 conditionally | Assert failure | Compute `_actionsCount` getter with the same `if` conditions |
| `hasMultiselect: true` with `multiselectActions: []` | Assert failure | Always provide at least one action |
| `ThemedTable2` without `Expanded` or fixed height | Layout overflow / black box | Wrap in `Expanded` |
| Forgetting `_selectedItems.dispose()` | Memory leak warning in debug | Always dispose in `State.dispose()` |
| Dropping a v1 `widgetBuilder` entirely | Loss of visual richness (progress bars, avatars, etc.) | Use `richTextBuilder` + `WidgetSpan` — it is context-safe and runs in the widget tree |
| Calling `Theme.of(context)` or `isDark` inside `valueBuilder` | Runtime crash in isolate | Move visual logic to `richTextBuilder`; keep `valueBuilder` isolate-safe |
| Helper signature still `(_, item)` | Type error / arity mismatch at call site | Drop the leading `_` positional arg |
| Using `ThemedActionButton.view` | No such factory — compile error | Use `ThemedActionButton.show` |

---

## Verification checklist

1. `dart analyze lib/src/listing.dart` → 0 errors.
2. In a host app that provides all required widget params:
   - Table renders with scrollable rows.
   - Search input filters live.
   - Clicking a column header sorts without a runtime crash (confirms
     isolate safety of `valueBuilder`).
   - "New" button appears only when `canCreate: true` and pushes the form.
   - Show / Edit / Delete row actions navigate or mutate as expected.
   - Custom toggle action changes color immediately.
   - Checkbox column appears; select multiple rows; bulk delete fires
     confirmation, deletes, and clears selection.
