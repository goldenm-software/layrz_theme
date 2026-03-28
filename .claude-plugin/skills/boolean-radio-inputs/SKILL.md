---
name: boolean-radio-inputs
description: Use ThemedCheckboxInput or ThemedRadioInput in a layrz Flutter widget. Apply when adding a boolean toggle, switch, checkbox, or radio group to any form or view.
---

## Overview

Two components cover boolean and discrete-choice inputs:

| Component | State type | `onChanged` signature | When to use |
|---|---|---|---|
| `ThemedCheckboxInput` | `bool` | `void Function(bool)?` | Single true/false flag — active state, agreement, toggle |
| `ThemedRadioInput<T>` | `T?` | `void Function(T?)?` | Pick exactly one value from a fixed, visible list of options |

Use `ThemedCheckboxInput` when the field is a plain boolean. Use `ThemedRadioInput` when the user must choose one item from a short enumerable list that should all be visible at once (not hidden behind a dialog).

Never use raw Flutter `Checkbox`, `Switch`, or `Radio` — always use these components.

---

## ThemedCheckboxInput — boolean toggle

### Minimal usage

```dart
// State
bool isActive = false;

// Widget
ThemedCheckboxInput(
  labelText: context.i18n.t('entity.isActive'),
  value: isActive,
  onChanged: (value) {
    setState(() => isActive = value);
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided. Mutually exclusive with `label`. |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Mutually exclusive with `labelText`. |
| `value` | `bool` | `false` | Current boolean state |
| `onChanged` | `void Function(bool)?` | `null` | Callback on toggle. Receives the new `bool` directly — no item unwrapping needed. |
| `disabled` | `bool` | `false` | Disables the input |
| `errors` | `List<String>` | `[]` | Validation error messages shown below |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row |
| `padding` | `EdgeInsets` | `EdgeInsets.all(10)` | Outer padding around the widget |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `style` | `ThemedCheckboxInputStyle` | `.asFlutterCheckbox` | Visual style variant — see style table below |

### Style variants

| Style | Appearance | Notes |
|---|---|---|
| `.asFlutterCheckbox` | Native Flutter `Checkbox` + label | Default. Inline checkbox, label is tappable to toggle. |
| `.asCheckbox2` | Animated custom checkbox + label | Layrz animated design. Preferred for new UIs. |
| `.asSwitch` | Material `Switch` + label | Use when the semantic is "enable/disable" rather than "agree/check". |
| `.asField` | Renders as `ThemedSelectInput<bool>` with Yes/No items | Use when the field must match the visual style of a full select input row. Opens a dialog on tap. |

### Behavior notes

- `value` is always plain `bool` — there is no nullable `T?` here. The internal state syncs from `widget.value` on `didUpdateWidget`, so the parent is the source of truth.
- `onChanged` receives the new `bool` directly (not wrapped in a `ThemedSelectItem`). No `.value` unwrapping needed.
- When `style` is `.asField`, the widget delegates entirely to `ThemedSelectInput<bool>` with two items (`true` → "Yes", `false` → "No"). Labels use `LayrzAppLocalizations` (`helpers.true` / `helpers.false`) with "Yes"/"No" fallbacks. All `ThemedSelectInput` caveats apply (dialog-based, `autoclose`, etc.).
- Tapping the label text also toggles the value for `.asFlutterCheckbox`, `.asCheckbox2`, and `.asSwitch` — the `GestureDetector` wraps the label `Expanded`.
- `label` and `labelText` are mutually exclusive — the constructor asserts this. Never pass both.

### Common patterns

```dart
// Default — animated checkbox (preferred for new code)
ThemedCheckboxInput(
  labelText: context.i18n.t('entity.isActive'),
  value: isActive,
  style: .asCheckbox2,
  errors: context.getErrors(key: 'isActive'),
  onChanged: (value) {
    setState(() => isActive = value);
  },
)

// Switch style — semantic "enable/disable"
ThemedCheckboxInput(
  labelText: context.i18n.t('entity.notificationsEnabled'),
  value: notificationsEnabled,
  style: .asSwitch,
  onChanged: (value) {
    setState(() => notificationsEnabled = value);
  },
)

// Field style — matches a form that is all select inputs
ThemedCheckboxInput(
  labelText: context.i18n.t('entity.isPublic'),
  value: isPublic,
  style: .asField,
  errors: context.getErrors(key: 'isPublic'),
  onChanged: (value) {
    setState(() => isPublic = value);
  },
)

// Disabled / read-only
ThemedCheckboxInput(
  labelText: context.i18n.t('entity.isVerified'),
  value: isVerified,
  disabled: true,
)
```

---

## ThemedRadioInput — single choice from a visible list

### Minimal usage

```dart
// State
String? selectedStatus;

// Items
final items = [
  ThemedSelectItem(value: 'active', label: 'Active'),
  ThemedSelectItem(value: 'inactive', label: 'Inactive'),
  ThemedSelectItem(value: 'pending', label: 'Pending'),
];

// Widget
ThemedRadioInput<String>(
  labelText: context.i18n.t('entity.status'),
  items: items,
  value: selectedStatus,
  onChanged: (value) {
    setState(() => selectedStatus = value);
  },
)
```

`onChanged` receives `T?` directly — no `ThemedSelectItem` unwrapping needed.

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided. Mutually exclusive with `label`. |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Mutually exclusive with `labelText`. |
| `items` | `List<ThemedSelectItem<T>>` | required | The selectable options |
| `value` | `T?` | `null` | Currently selected value |
| `onChanged` | `void Function(T?)?` | `null` | Callback — receives the raw `T?`, not a `ThemedSelectItem` |
| `disabled` | `bool` | `false` | Disables all radio buttons (selection still shows) |
| `errors` | `List<String>` | `[]` | Validation error messages shown below |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row |
| `padding` | `EdgeInsets` | `EdgeInsets.all(10)` | Outer padding around the widget |
| `xsSize` | `Sizes` | `.col12` | Column width on extra-small screens (< 600 px) |
| `smSize` | `Sizes?` | `.col6` | Column width on small screens (600–960 px) |
| `mdSize` | `Sizes?` | `.col4` | Column width on medium screens (960–1264 px) |
| `lgSize` | `Sizes?` | `.col3` | Column width on large screens (1264–1904 px) |
| `xlSize` | `Sizes?` | `.col2` | Column width on extra-large screens (> 1904 px) |

### Responsive grid

Items are laid out in a `ResponsiveRow` / `ResponsiveCol` grid. The default layout gives:

- xs → 1 column (`col12`)
- sm → 2 columns (`col6`)
- md → 3 columns (`col4`)
- lg → 4 columns (`col3`)
- xl → 6 columns (`col2`)

Override any breakpoint to control density. Example — force two columns at all sizes:

```dart
ThemedRadioInput<String>(
  labelText: context.i18n.t('entity.gender'),
  items: genderItems,
  value: selectedGender,
  xsSize: .col6,
  smSize: .col6,
  mdSize: .col6,
  lgSize: .col6,
  xlSize: .col6,
  onChanged: (value) => setState(() => selectedGender = value),
)
```

### Behavior notes

- `onChanged` is called with the raw `T?` — no `.value` unwrapping. This differs from `ThemedSelectInput` which wraps the result in `ThemedSelectItem<T>?`.
- `disabled: true` renders the widget but ignores all taps and label GestureDetector callbacks. The currently selected item remains visible.
- There is no "deselect" capability — once an item is selected the user cannot clear back to `null` through the UI. If unselected state is required, handle it in the parent (e.g., expose a clear button).
- Tapping the label `Text` next to a radio button also triggers selection via `GestureDetector`, not just tapping the radio circle itself.
- `label` and `labelText` are mutually exclusive — the constructor asserts this. Never pass both.
- Items are built from `ThemedSelectItem<T>` — reuse the same items list you would use for `ThemedSelectInput<T>`.

### Common patterns

```dart
// Enum-backed radio group
ThemedRadioInput<UserRole>(
  labelText: context.i18n.t('entity.role'),
  items: UserRole.values.map((r) => ThemedSelectItem(value: r, label: r.label)).toList(),
  value: selectedRole,
  errors: context.getErrors(key: 'role'),
  onChanged: (value) => setState(() => selectedRole = value),
)

// Full-width single column on all screens
ThemedRadioInput<int>(
  labelText: context.i18n.t('entity.priority'),
  items: priorityItems,
  value: selectedPriority,
  xsSize: .col12,
  smSize: .col12,
  mdSize: .col12,
  lgSize: .col12,
  xlSize: .col12,
  onChanged: (value) => setState(() => selectedPriority = value),
)
```

---

## Integrating with layrz forms

```dart
// ThemedCheckboxInput in a form
ThemedCheckboxInput(
  labelText: context.i18n.t('entity.isActive'),
  value: object.isActive,
  style: .asCheckbox2,
  errors: context.getErrors(key: 'isActive'),
  onChanged: (value) {
    object.isActive = value;
    if (context.mounted) onChanged.call();
  },
)

const SizedBox(height: 10),

// ThemedRadioInput in a form
ThemedRadioInput<String>(
  labelText: context.i18n.t('entity.status'),
  items: statusItems,
  value: object.status,
  errors: context.getErrors(key: 'status'),
  onChanged: (value) {
    object.status = value;
    if (context.mounted) onChanged.call();
  },
)
```

Key conventions:
- Always guard `onChanged` body with `if (context.mounted)` before calling parent callbacks that might rebuild the tree.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode display strings.
- Use `context.getErrors(key: 'fieldName')` for `errors` — never build the error list manually.
- Separate stacked inputs with `const SizedBox(height: 10)`.
- `label` and `labelText` are mutually exclusive — pick one per widget instance.

---

## Choosing between the two

### ThemedCheckboxInput vs ThemedRadioInput

Use `ThemedCheckboxInput` when:
- The field is a plain `bool` (active/inactive, agree/disagree, enabled/disabled).
- There are exactly two states and no in-between.

Use `ThemedRadioInput<T>` when:
- The field stores a discrete typed value (`String`, `int`, enum) from a fixed list.
- All options should be visible simultaneously without a dialog.
- The number of options is small enough to fit in the layout (typically 2–6 items).

For longer option lists (7+ items, or items loaded from an API), prefer `ThemedSelectInput<T>` instead — it hides options behind a searchable dialog.

### Choosing a ThemedCheckboxInput style

| Scenario | Recommended style |
|---|---|
| New UI, checkbox semantics | `.asCheckbox2` (animated, Layrz design) |
| Enable/disable toggle, prominent | `.asSwitch` |
| Form with all select-input rows, need visual consistency | `.asField` |
| Legacy form or matching older screens | `.asFlutterCheckbox` |

Avoid `.asField` unless visual consistency with `ThemedSelectInput` rows is explicitly required — it introduces a dialog tap for a simple boolean, which adds unnecessary friction.
