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

- Renders as `SizedBox(width: double.infinity, child: LayoutBuilder(...))` — uses a Column of Rows internally; LayoutBuilder provides the total row width for per-child sizing calculations. The internal Wrap-based implementation was replaced in v7.5.33 to enforce true gaps.
- `children` only accepts `List<ResponsiveCol>` — use `ResponsiveCol(child: Divider())` for dividers.
- `builder` takes `ResponsiveCol Function(int)` — not `Widget Function(BuildContext, int)`.
- `spacing` applies to **both axes**: horizontal gap between columns in the same row, and vertical gap between rows when columns wrap (default `0`). As of v7.5.33, spacing is a TRUE pixel gap: `availableWidth = totalWidth - spacing * (n - 1)`, then each child's width = `(availableWidth / 12) * gridSize`. Two col6 children with spacing=12 each receive `(totalWidth - 12) / 2` pixels — not `totalWidth / 2 - 6`.

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

// Fully responsive breakpoint reflow — 1/2/3/4 cols across breakpoints
ResponsiveRow(
  spacing: 12,
  children: [
    for (final item in items)
      ResponsiveCol(
        xs: .col12,  // mobile: 1 column
        sm: .col6,   // small: 2 columns
        md: .col4,   // medium: 3 columns
        lg: .col3,   // large: 4 columns
        child: ItemCard(item: item),
      ),
  ],
)
```

---

## Pitfalls

- **Do not place `ResponsiveCol` outside a `ResponsiveRow`.** It renders as a pass-through and will receive whatever width its parent provides, which is almost never correct.
- **Do not wrap `ResponsiveRow` in an unbounded-width parent** (e.g. a horizontal `ListView`). The row needs a finite width to compute gridSize.
- **`children` only accepts `List<ResponsiveCol>`.** Raw widgets won't compile. For dividers/spacers use `const ResponsiveCol(child: Divider())`.
- **Spacing > 0 is a TRUE gap — it does NOT reduce each child's gridSize.** Two `.col6` with `spacing: 12` fit on one row; the gap is carved from `totalWidth` before distributing the 12-column grid.
- **Do not nest `ResponsiveRow` inside another `ResponsiveRow`** without awareness that spacing is applied per-row independently.
