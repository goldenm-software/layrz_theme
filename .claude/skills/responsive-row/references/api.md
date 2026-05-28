# ResponsiveRow — API Reference

Source: `lib/src/grid/src/row.dart` — `ResponsiveRow` class line 3

---

## Constructor

```dart
const ResponsiveRow({
  super.key,
  required this.children,          // List<ResponsiveCol>
  this.mainAxisAlignment = .start,
  this.crossAxisAlignment = .start,
  this.spacing = 0,                // double
})
```

## Static builder

```dart
ResponsiveRow.builder({
  required int itemCount,
  required ResponsiveCol Function(int) itemBuilder,  // NOT IndexedWidgetBuilder
  WrapAlignment mainAxisAlignment = .start,
  WrapCrossAlignment crossAxisAlignment = .start,
  double spacing = 0,
})
```

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `children` | `List<ResponsiveCol>` | required | Only `ResponsiveCol`. For dividers: `ResponsiveCol(child: Divider())` |
| `mainAxisAlignment` | `WrapAlignment` | `.start` | Horizontal alignment of columns |
| `crossAxisAlignment` | `WrapCrossAlignment` | `.start` | Vertical alignment of columns |
| `spacing` | `double` | `0` | Gap between columns (horizontal) and between wrapped rows (vertical) in pixels |

Renders as `SizedBox(width: double.infinity, child: LayoutBuilder(...))`. Internally produces a Column of Rows; spacing creates true pixel gaps. See the Algorithm section below for details.

---

## Algorithm (post-v7.5.33)

`ResponsiveRow` replaces the old `Wrap`-based layout with a deterministic two-pass algorithm:

**Step 1 — Row grouping**
Children are walked in order. Each child's `gridSizeAt(totalWidth)` is accumulated. When adding the next child would make the running sum exceed 12, a new row begins. This guarantees predictable row breaks (e.g. col6+col6 fills one row; adding a col4 starts a second row).

**Step 2 — Width calculation**
For a row containing *n* children:
```
available = totalWidth - spacing * (n - 1)
childWidth = available * gridSize / 12
```
Each child is wrapped in `SizedBox(width: childWidth)`. Horizontal `SizedBox(width: spacing)` widgets are interleaved between siblings.

**Step 3 — Vertical gap**
`SizedBox(height: spacing)` is inserted between consecutive rows.

**Step 4 — Alignment mapping**
`mainAxisAlignment` (`WrapAlignment`) maps to `MainAxisAlignment`; `crossAxisAlignment` (`WrapCrossAlignment`) maps to `CrossAxisAlignment` — the property names are kept for backwards compatibility.

**`gridSizeAt(double rowWidth)`** is a package-internal method on `ResponsiveCol`, called by `ResponsiveRow._groupIntoRows` and `ResponsiveRow._buildRow`. It returns the active grid column count (1–12) for the given parent row width. It is not part of the public widget API and should not be called by application code.

---

## Examples

```dart
// Basic row
ResponsiveRow(
  children: [
    ResponsiveCol(xs: .col12, md: .col6, child: WidgetA()),
    ResponsiveCol(xs: .col12, md: .col6, child: WidgetB()),
  ],
)

// Sidebar + content (3/9 split)
ResponsiveRow(
  children: [
    ResponsiveCol(xs: .col12, lg: .col3, child: Sidebar()),
    ResponsiveCol(xs: .col12, lg: .col9, child: MainContent()),
  ],
)

// Responsive form — two fields per row on desktop
ResponsiveRow(
  spacing: 12,
  children: [
    ResponsiveCol(xs: .col12, md: .col6, child: ThemedTextInput(labelText: 'First Name', ...)),
    ResponsiveCol(xs: .col12, md: .col6, child: ThemedTextInput(labelText: 'Last Name', ...)),
    ResponsiveCol(xs: .col12, child: ThemedTextInput(labelText: 'Email', ...)),
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

// Centered card grid
ResponsiveRow(
  spacing: 16,
  mainAxisAlignment: .center,
  crossAxisAlignment: .center,
  children: [
    ResponsiveCol(xs: .col12, sm: .col6, md: .col4, child: CardA()),
    ResponsiveCol(xs: .col12, sm: .col6, md: .col4, child: CardB()),
    ResponsiveCol(xs: .col12, sm: .col6, md: .col4, child: CardC()),
  ],
)

// Divider inside a row
ResponsiveRow(
  children: [
    ResponsiveCol(xs: .col12, md: .col6, child: WidgetA()),
    const ResponsiveCol(child: Divider()),
    ResponsiveCol(xs: .col12, md: .col6, child: WidgetB()),
  ],
)
```
