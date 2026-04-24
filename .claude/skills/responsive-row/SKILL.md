---
name: responsive-row
description: Use ResponsiveRow in a layrz Flutter widget. Apply when wrapping ResponsiveCol children in a responsive 12-column grid container.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.col6`, `.start`, `.left`) — never write the fully-qualified form (`Sizes.col6`, `WrapAlignment.start`).

> **Full constructor and examples:** read `references/api.md` in this skill's directory.

---

## When to use

- Wrapping a set of `ResponsiveCol` children in a flex container that reflows automatically
- Needs spacing, horizontal alignment, or vertical alignment between columns
- Building from a dynamic list → use `ResponsiveRow.builder`

Always paired with `ResponsiveCol` as children. For breakpoint logic and `Sizes` enum, see the `responsive-col` skill.

---

## Minimal usage

```dart
ResponsiveRow(
  children: [
    ResponsiveCol(xs: .col12, md: .col6, child: WidgetA()),
    ResponsiveCol(xs: .col12, md: .col6, child: WidgetB()),
  ],
)
```

---

## Key behaviors

- Renders as `SizedBox(width: double.infinity, child: Wrap(...))` — always full parent width.
- `children` only accepts `List<ResponsiveCol>` — use `ResponsiveCol(child: Divider())` for dividers.
- `builder` takes `ResponsiveCol Function(int)` — not `Widget Function(BuildContext, int)`.
- `spacing` applies to **both axes**: horizontal gap between columns in the same row, and vertical gap between rows when columns wrap (default `0`).

---

## Common patterns

```dart
// With spacing and center alignment
ResponsiveRow(
  spacing: 16,
  mainAxisAlignment: .center,
  crossAxisAlignment: .center,
  children: [
    ResponsiveCol(xs: .col12, md: .col6, child: WidgetA()),
    ResponsiveCol(xs: .col12, md: .col6, child: WidgetB()),
  ],
)

// Dynamic list with builder
ResponsiveRow.builder(
  spacing: 16,
  itemCount: items.length,
  itemBuilder: (index) => ResponsiveCol(
    xs: .col12,
    sm: .col6,
    lg: .col4,
    child: ItemCard(item: items[index]),
  ),
)
```
