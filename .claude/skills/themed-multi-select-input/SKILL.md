---
name: themed-multi-select-input
description: Use ThemedMultiSelectInput in a layrz Flutter widget. Apply when adding a multiple-value picker field that opens a searchable dialog with checkboxes.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Multiple-value selection from a list; value type: `List<T>`
- Never use Flutter's `CheckboxListTile` or `DropdownButton` — always use this widget.

For single-value selection → use `ThemedSelectInput`. For two-panel Available/Selected layout → use `ThemedDualListInput`.

---

## Minimal usage

```dart
ThemedMultiSelectInput<String>(
  labelText: context.i18n.t('entity.tags'),
  items: tags.map((t) => ThemedSelectItem(value: t.id, label: t.name)).toList(),
  value: selectedTagIds,
  errors: context.getErrors(key: 'tags'),
  onChanged: (items) {
    selectedTagIds = items.map((e) => e.value).nonNulls.toList();
    if (context.mounted) onChanged.call();
  },
)
```

`onChanged` receives `List<ThemedSelectItem<T>>`. Extract values with `.map((e) => e.value).nonNulls.toList()`.

---

## Key behaviors

- Opens a searchable dialog (500×500 max) with checkboxes on each item.
- Dialog always shows: Cancel, Select All / Unselect All toggle, Save.
- Default: `onChanged` fires on every tap (real-time updates while dialog is open).
- `waitUntilClosedToSubmit: true` delays `onChanged` until Save is tapped — use when real-time updates are expensive.
- Cancel discards changes (calls `onChanged` with the previous selection).
- `autoclose: false` (default) — user must tap Save to close.
- `autoselectFirst: true` auto-selects `items[0]` on init when `value` is empty.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// Batch submit (only fire onChanged on Save)
ThemedMultiSelectInput<String>(
  labelText: context.i18n.t('entity.permissions'),
  items: permissions.map((p) => ThemedSelectItem(value: p.id, label: p.name)).toList(),
  value: selectedPermissionIds,
  waitUntilClosedToSubmit: true,
  errors: context.getErrors(key: 'permissions'),
  onChanged: (items) {
    selectedPermissionIds = items.map((e) => e.value).nonNulls.toList();
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedMultiSelectInput<String>(
  labelText: context.i18n.t('entity.tags'),
  items: tags.map((t) => ThemedSelectItem(value: t.id, label: t.name)).toList(),
  value: selectedTagIds,
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
