---
name: themed-search-input
description: Use ThemedSearchInput in a layrz Flutter widget. Apply when adding a search bar — either a compact icon button that expands into an overlay, or a full-width inline field.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.col6`, `.start`, `.left`) — never write the fully-qualified form (`Sizes.col6`, `WrapAlignment.start`).

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Global or list search with minimal toolbar footprint → button mode (default)
- Prominent always-visible search bar → `asField: true`

Not a form widget — no `errors`, `isRequired`, or validation. Do not pass `context.getErrors()` to it.

---

## Minimal usage — button mode

```dart
ThemedSearchInput(
  value: searchQuery,
  labelText: context.i18n.t('general.search'),
  onSearch: (value) {
    searchQuery = value;
    if (context.mounted) setState(() {});
  },
)
```

## Minimal usage — field mode

```dart
ThemedSearchInput(
  value: searchQuery,
  labelText: context.i18n.t('general.search'),
  asField: true,
  maxWidth: 300,
  onSearch: (value) {
    searchQuery = value;
    if (context.mounted) setState(() {});
  },
)
```

---

## Key behaviors

- Button mode: 40×40 rounded icon button. Tap opens `OverlayEntry` with scale animation. Escape or tap-outside closes it.
- Field mode: always-visible `SizedBox(height: 40, width: maxWidth)` — no overlay.
- `position: .left` → overlay expands leftward (button on the right edge of toolbar). `.right` → expands rightward.
- `debounce` fires `onSearch` after delay. Enter fires immediately and closes the overlay.
- `value` is non-nullable `String` — always init to `''`.

---

## Common patterns

```dart
// Toolbar search on right edge — expands leftward
Row(
  children: [
    const Spacer(),
    ThemedSearchInput(
      value: query,
      labelText: context.i18n.t('general.search'),
      position: .left,
      onSearch: (value) {
        query = value;
        if (context.mounted) setState(() {});
      },
    ),
  ],
)

// Synchronous search (no debounce)
ThemedSearchInput(
  value: query,
  labelText: context.i18n.t('general.search'),
  asField: true,
  maxWidth: 400,
  debounce: null,
  onSearch: (value) {
    query = value;
    if (context.mounted) setState(() {});
  },
)

// Custom trigger widget
ThemedSearchInput(
  value: query,
  labelText: context.i18n.t('general.search'),
  customChild: ThemedButton(
    label: context.i18n.t('general.search'),
    icon: LayrzIcons.solarOutlineMagnifier,
    style: ThemedButtonStyle.outlined,
    onTap: () {},
  ),
  onSearch: (value) {
    query = value;
    if (context.mounted) setState(() {});
  },
)
```
