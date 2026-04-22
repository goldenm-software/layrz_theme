---
name: themed-select-input
description: Use ThemedSelectInput in a layrz Flutter widget. Apply when adding a single-value picker field that opens a searchable dialog list.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Single-value selection from a list; value type: `T?`
- Never use Flutter's `DropdownButton` — always use this widget.

For multiple-value selection → use `ThemedMultiSelectInput`. For two-panel Available/Selected layout → use `ThemedDualListInput`.

---

## Minimal usage

```dart
ThemedSelectInput<String>(
  labelText: context.i18n.t('entity.status'),
  items: statuses.map((s) => ThemedSelectItem(value: s.id, label: s.name)).toList(),
  value: selectedStatus,
  errors: context.getErrors(key: 'status'),
  onChanged: (item) {
    selectedStatus = item?.value;
    if (context.mounted) onChanged.call();
  },
)
```

`onChanged` receives `ThemedSelectItem<T>?`. Always use `.value` to extract the raw `T`.

---

## Key behaviors

- Opens a searchable dialog (500×500 max) with a scrollable item list.
- Default `autoclose: true` — dialog closes immediately on item tap (no Save button needed).
- `canUnselect: true` lets the user tap the current selection to deselect it; pair with `autoclose: false`.
- `returnNullOnClose: true` calls `onChanged(null)` when dialog is dismissed without picking.
- `autoSelectFirst: true` auto-selects `items[0]` on init when `value` is null.
- `customChild` wraps any widget in an `InkWell` that opens the dialog.
- Exactly one of `label` / `labelText` must be set — assert enforced.
- **API typo note**: the parameter is `dialogContraints` (missing 's') — not `dialogConstraints`.

---

## Common patterns

```dart
// Allow deselection
ThemedSelectInput<String>(
  labelText: context.i18n.t('entity.category'),
  items: categories.map((c) => ThemedSelectItem(value: c.id, label: c.name)).toList(),
  value: selectedCategory,
  canUnselect: true,
  autoclose: false,
  errors: context.getErrors(key: 'category'),
  onChanged: (item) {
    selectedCategory = item?.value;
    if (context.mounted) onChanged.call();
  },
)

// Clear on dialog dismiss
ThemedSelectInput<String>(
  labelText: context.i18n.t('entity.filter'),
  items: filters,
  value: selectedFilter,
  returnNullOnClose: true,
  onChanged: (item) {
    selectedFilter = item?.value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedSelectInput<String>(
  labelText: context.i18n.t('entity.status'),
  items: statuses,
  value: selectedStatus,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
