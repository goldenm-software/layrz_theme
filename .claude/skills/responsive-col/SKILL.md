---
name: responsive-col
description: Use ResponsiveCol in a layrz Flutter widget. Apply when defining a column's width at different breakpoints inside a ResponsiveRow.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.col6`, `.start`, `.left`) — never write the fully-qualified form (`Sizes.col6`, `WrapAlignment.start`).

> **Full constructor, Sizes enum, breakpoints, and examples:** read `references/api.md` in this skill's directory.

---

## When to use

- Defining width at different screen sizes for a child inside a `ResponsiveRow`
- Any widget that needs to be full-width on mobile and narrower on larger screens

Always a child of `ResponsiveRow`. Never used standalone.

---

## Minimal usage

```dart
ResponsiveCol(
  xs: .col12,  // full width on mobile
  md: .col6,   // half width on desktop
  child: MyWidget(),
)
```

---

## Key behaviors

- `xs` defaults to `.col12` but should always be set explicitly — it's the fallback for all other breakpoints.
- Fallback chain: `xl ?? lg ?? md ?? sm ?? xs` — only set breakpoints that differ.
- Uses `LayoutBuilder` internally — breakpoint is evaluated against the col's own available width, not the screen width.
- Width formula: `(containerWidth / 12) * gridSize`.

---

## Breakpoints

| Param | Constant | Range |
|---|---|---|
| `xs` | `kExtraSmallGrid = 600` | < 600 px |
| `sm` | `kSmallGrid = 960` | 600–959 px |
| `md` | `kMediumGrid = 1264` | 960–1263 px |
| `lg` | `kLargeGrid = 1904` | 1264–1903 px |
| `xl` | — | ≥ 1904 px |

---

## Common patterns

```dart
// All breakpoints explicit
ResponsiveCol(
  xs: .col12,
  sm: .col6,
  md: .col4,
  lg: .col3,
  xl: .col2,
  child: ProductCard(),
)

// Lazy — only set what changes
ResponsiveCol(
  xs: .col12,  // mobile: full width
  lg: .col6,   // desktop: half (sm and md also get col12 via fallback)
  child: SectionWidget(),
)
```
