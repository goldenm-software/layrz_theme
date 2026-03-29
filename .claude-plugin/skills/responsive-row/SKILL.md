---
name: responsive-row
description: ResponsiveRow and ResponsiveCol — Material 3 responsive grid layouts with breakpoint-based column sizing
---

## Overview

`ResponsiveRow` and `ResponsiveCol` provide a responsive 12-column grid system for layrz_theme. ResponsiveRow acts as a flex container using Wrap layout, while ResponsiveCol defines column width at different breakpoints (xs, sm, md, lg, xl). Together they create layouts that adapt to screen size without manual media queries.

| Feature | Details |
|---|---|
| Responsive Breakpoints | xs (0-600), sm (600-960), md (960-1264), lg (1264-1904), xl (1904+) |
| 12-Column Grid | Sizes enum with col1-col12 for flexible width specification |
| Wrap Layout | ResponsiveRow uses Wrap for automatic line breaking when space insufficient |
| Builder Pattern | ResponsiveRow.builder for dynamic child generation |
| Spacing Control | Configurable gap between columns |
| Alignment Options | Main axis and cross axis alignment control |
| Full-Width Enforcement | ResponsiveRow always spans full parent width |
| Fallback Chain | Missing breakpoints cascade to larger breakpoints automatically |

**When to use:** Responsive dashboards, card grids, sidebar + content layouts, responsive forms. Prefer when you need width-based column sizing without MediaQuery or custom LayoutDelegate.

## ResponsiveRow

Horizontal container that arranges ResponsiveCol children using a Wrap widget. All children are laid out horizontally with configurable spacing and alignment. Wraps to next line when space is insufficient.

### Key Parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `children` | `List<Widget>` | required (OR `builder`) | List of ResponsiveCol widgets. Type-safe at compile time |
| `builder` | `IndexedWidgetBuilder?` | required (OR `children`) | Build function for dynamic children. Use with `itemCount` |
| `itemCount` | `int?` | `null` | Number of items to build when using `builder` |
| `spacing` | `double` | `0` | Horizontal gap between columns (in pixels) |
| `mainAxisAlignment` | `WrapAlignment` | `.start` | Horizontal alignment of columns |
| `crossAxisAlignment` | `WrapCrossAlignment` | `.start` | Vertical alignment of columns |

### Minimal responsive row

```dart
ResponsiveRow(
  children: [
    ResponsiveCol(xs: Sizes.col12, sm: Sizes.col6, md: Sizes.col4, child: CardWidget()),
    ResponsiveCol(xs: Sizes.col12, sm: Sizes.col6, md: Sizes.col4, child: CardWidget()),
    ResponsiveCol(xs: Sizes.col12, sm: Sizes.col6, md: Sizes.col4, child: CardWidget()),
  ],
)
```

### Row with spacing and alignment

```dart
ResponsiveRow(
  spacing: 16,
  mainAxisAlignment: WrapAlignment.spaceEvenly,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ResponsiveCol(xs: Sizes.col12, md: Sizes.col6, child: SidebarWidget()),
    ResponsiveCol(xs: Sizes.col12, md: Sizes.col6, child: ContentWidget()),
  ],
)
```

### Row with builder for dynamic children

```dart
ResponsiveRow.builder(
  spacing: 12,
  itemCount: 12,
  itemBuilder: (context, index) {
    return ResponsiveCol(
      xs: Sizes.col12,
      sm: Sizes.col6,
      md: Sizes.col4,
      lg: Sizes.col3,
      child: ProductCard(product: products[index]),
    );
  },
)
```

## ResponsiveCol

Defines a column's width at different breakpoints. Must be a child of ResponsiveRow. Uses LayoutBuilder internally to detect current breakpoint and apply responsive sizing.

### Key Parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | Content widget displayed in this column |
| `xs` | `Sizes` | `col12` | Width at extra small breakpoint (0-600px) |
| `sm` | `Sizes?` | `null` | Width at small breakpoint (600-960px). Falls back to xs if null |
| `md` | `Sizes?` | `null` | Width at medium breakpoint (960-1264px). Falls back to sm→xs if null |
| `lg` | `Sizes?` | `null` | Width at large breakpoint (1264-1904px). Falls back to md→sm→xs if null |
| `xl` | `Sizes?` | `null` | Width at extra large breakpoint (1904px+). Falls back to lg→md→sm→xs if null |

### Sizes Enum

Column widths specified using Sizes enum with 12-column system:
- `Sizes.col1` through `Sizes.col12` — represents 1 to 12 columns
- Width = `(containerWidth / 12) * columnCount`

### Minimal column

```dart
ResponsiveCol(
  xs: Sizes.col12,
  md: Sizes.col6,
  child: CardWidget(),
)
```

### Column with all breakpoints

```dart
ResponsiveCol(
  xs: Sizes.col12,  // Mobile: full width
  sm: Sizes.col6,   // Tablet: half width
  md: Sizes.col4,   // Desktop: one-third
  lg: Sizes.col3,   // Large: one-quarter
  xl: Sizes.col2,   // Extra large: one-sixth
  child: ProductCard(),
)
```

### Column with fallback chain (lazy specification)

```dart
ResponsiveCol(
  xs: Sizes.col12,     // Mobile: full width (explicit)
  md: Sizes.col8,      // Desktop: two-thirds (sm and lg fall back to this)
  // sm → falls back to md (col8)
  // lg → falls back to xl (col12) → defaults to col12
  child: ArticleView(),
)
```

## Sizes Enum & Extension

### Sizes Enum
```dart
enum Sizes { col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12 }
```

### SizesExt Extension
```dart
extension SizesExt on Sizes {
  double boxWidth(double width)   // Calculate actual width in pixels
  int get gridSize                // Get column count (1-12)
}
```

**Usage:**
```dart
Sizes.col6.gridSize          // Returns: 6
Sizes.col6.boxWidth(1200)    // Returns: 600 (6 out of 12 = 50%)
Sizes.col3.boxWidth(600)     // Returns: 150 (3 out of 12 = 25%)
```

## Responsive Behavior

### Breakpoint Logic

ResponsiveCol evaluates width and selects the best Sizes:

```
width < 600px
  → use xs

600px ≤ width < 960px
  → use sm (or xs if sm is null)

960px ≤ width < 1264px
  → use md (fallback: sm → xs)

1264px ≤ width < 1904px
  → use lg (fallback: md → sm → xs)

width ≥ 1904px
  → use xl (fallback: lg → md → sm → xs)
```

### Example: 3-Column Grid

```dart
ResponsiveRow(
  spacing: 16,
  children: [
    ResponsiveCol(
      xs: .col12,      // 1 column on mobile
      sm: .col6,       // 2 columns on tablet portrait
      md: .col4,       // 3 columns on tablet landscape
      child: Card(),
    ),
    // ... 2 more cols with identical responsive behavior
  ],
)

// Renders as:
// Mobile (< 600px):          [full-width] [full-width] [full-width]
// Tablet Portrait (600-960): [50%] [50%] [50%] (wraps to 2 rows + 1)
// Tablet Land (960-1264):    [33%] [33%] [33%]
// Desktop (1264px+):         [33%] [33%] [33%]
```

## Testing

Widget tests are located in `test/widgets/responsive_row_test.dart`.

**Test coverage:**
- Basic rendering with children (empty, single, multiple)
- Spacing parameter (0, custom values)
- Alignment parameters (mainAxis, crossAxis)
- Full width enforcement
- builder() with various itemCounts
- ResponsiveCol rendering and child preservation
- Sizes enum calculations (boxWidth, gridSize)
- Integration: ResponsiveRow + ResponsiveCol together

**Running tests:**
```bash
flutter test test/widgets/responsive_row_test.dart
```

## Best Practices

1. **Specify xs explicitly** — Always define `xs` since it's the fallback for all breakpoints
   ```dart
   ResponsiveCol(xs: .col12, md: .col6)  // ✓ Good
   ResponsiveCol(md: .col6)              // ✗ Compile error (xs required)
   ```

2. **Use lazy specification for efficiency** — Only specify breakpoints that differ from cascading
   ```dart
   ResponsiveCol(
     xs: .col12,        // Mobile
     lg: .col6,         // Desktop (tablet will inherit xs)
     child: Widget(),
   )
   ```

3. **Combine with LayoutBuilder for complex layouts** — ResponsiveCol handles sizing, but layout decisions may need LayoutBuilder:
   ```dart
   LayoutBuilder(
     builder: (ctx, constraints) {
       bool isMobile = constraints.maxWidth < 600;
       return ResponsiveRow(
         children: [
           ResponsiveCol(xs: isMobile ? .col12 : .col6, child: Widget()),
         ],
       );
     },
   )
   ```

4. **Remember wrap behavior** — ResponsiveRow wraps children to next line when space is insufficient. Plan layouts accordingly.

5. **Spacing and alignment matter** — Use `spacing` and alignment parameters for proper visual hierarchy
   ```dart
   ResponsiveRow(
     spacing: 16,
     mainAxisAlignment: WrapAlignment.spaceEvenly,
     crossAxisAlignment: WrapCrossAlignment.center,
     children: [...],
   )
   ```

## Common Patterns

### Full-Width Sidebar + Content
```dart
ResponsiveRow(
  children: [
    ResponsiveCol(
      xs: .col12,
      lg: .col3,
      child: Sidebar(),
    ),
    ResponsiveCol(
      xs: .col12,
      lg: .col9,
      child: MainContent(),
    ),
  ],
)
```

### Card Grid with Even Spacing
```dart
ResponsiveRow.builder(
  itemCount: cards.length,
  spacing: 16,
  mainAxisAlignment: WrapAlignment.center,
  itemBuilder: (index) => ResponsiveCol(
    xs: .col12,
    sm: .col6,
    lg: .col4,
    child: CardWidget(data: cards[index]),
  ),
)
```

### Responsive Form Layout
```dart
ResponsiveRow(
  spacing: 12,
  children: [
    ResponsiveCol(
      xs: .col12,
      md: .col6,
      child: TextInput(label: 'First Name'),
    ),
    ResponsiveCol(
      xs: .col12,
      md: .col6,
      child: TextInput(label: 'Last Name'),
    ),
    ResponsiveCol(
      xs: .col12,
      child: TextInput(label: 'Email'),
    ),
  ],
)
```

## Implementation Notes

- **Wrap direction is always Axis.horizontal** — Children are laid out left-to-right and wrap to next line
- **ResponsiveCol uses LayoutBuilder** — Breakpoint evaluation is dynamic and responds to constraint changes
- **No state management** — Both components are StatelessWidget (stateless, efficient)
- **No custom LayoutDelegate** — Uses Wrap's built-in logic for simplicity and predictability
- **Type-safe children** — Dart's type system ensures only ResponsiveCol can be children of ResponsiveRow
