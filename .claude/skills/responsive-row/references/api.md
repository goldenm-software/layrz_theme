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
| `spacing` | `double` | `0` | Horizontal gap between columns in pixels |

Renders as `SizedBox(width: double.infinity, child: Wrap(...))` — always full parent width.

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
