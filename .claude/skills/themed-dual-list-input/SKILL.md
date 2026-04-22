---
name: themed-dual-list-input
description: Use ThemedDualListInput in a layrz Flutter widget. Apply when adding a two-panel list field where users move items between an "Available" and a "Selected" list.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Multi-value selection where the user needs to see both available and selected items simultaneously
- Value type: `List<T>` (IDs or values of selected items)

For a compact multi-select dialog → use `ThemedMultiSelectInput`. For single-value selection → use `ThemedSelectInput`.

---

## Minimal usage

```dart
ThemedDualListInput<String>(
  labelText: context.i18n.t('entity.items'),
  items: sourceList.map((e) => ThemedSelectItem(value: e.id, label: e.name)).toList(),
  value: selectedIds,
  errors: context.getErrors(key: 'items'),
  onChanged: (items) {
    selectedIds = items.map((e) => e.value).nonNulls.toList();
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Renders two side-by-side scrollable lists: Available (left) and Selected (right).
- Items move between lists via individual row buttons or "Toggle all" buttons.
- On mobile (width < `kExtraSmallGrid`), the lists stack vertically; height is multiplied by `mobileScaleFactor`.
- `onChanged` fires with the full list of selected `ThemedSelectItem<T>` — extract values with `.map((e) => e.value).nonNulls.toList()`.
- `compareFunction` overrides item equality; default uses `==`.
- `availableListName` / `selectedListName` customize the column headers.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// Custom list headers
ThemedDualListInput<String>(
  labelText: context.i18n.t('asset.pois'),
  items: pois.map((p) => ThemedSelectItem(value: p.id, label: p.name)).toList(),
  value: selectedPoiIds,
  availableListName: context.i18n.t('helpers.available'),
  selectedListName: context.i18n.t('helpers.selected'),
  errors: context.getErrors(key: 'pois'),
  onChanged: (items) {
    selectedPoiIds = items.map((e) => e.value).nonNulls.toList();
    if (context.mounted) onChanged.call();
  },
)

// Custom equality (e.g. comparing by a nested property)
ThemedDualListInput<MyModel>(
  labelText: context.i18n.t('entity.items'),
  items: sourceList.map((e) => ThemedSelectItem(value: e, label: e.name)).toList(),
  value: selectedItems,
  compareFunction: (a, b) => a?.id == b?.id,
  onChanged: (items) {
    selectedItems = items.map((e) => e.value).nonNulls.toList();
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedDualListInput<String>(
  labelText: context.i18n.t('entity.items'),
  items: sourceList.map((e) => ThemedSelectItem(value: e.id, label: e.name)).toList(),
  value: selectedIds,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Use `.nonNulls` to filter nulls from the mapped values.
- Separate stacked inputs with `const SizedBox(height: 10)`.
