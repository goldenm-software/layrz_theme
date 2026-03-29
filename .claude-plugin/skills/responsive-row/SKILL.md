# ResponsiveRow & ResponsiveCol Skill

## Overview

ResponsiveRow and ResponsiveCol form a 12-column responsive grid system for Flutter. ResponsiveRow wraps ResponsiveCol children and uses Dart's `Wrap` widget for layout. ResponsiveCol applies responsive sizing based on breakpoints (xs, sm, md, lg, xl).

**File locations:**
- `lib/src/grid/src/row.dart` — ResponsiveRow
- `lib/src/grid/src/col.dart` — ResponsiveCol
- `lib/src/grid/src/sizes.dart` — Sizes enum and extensions

## Components

### ResponsiveRow

Horizontal flex container that arranges ResponsiveCol children using a Wrap widget. All children are arranged horizontally with configurable spacing and alignment.

**Parameters:**
- `children: List<ResponsiveCol>` — **Required.** Must be ResponsiveCol widgets only. Type-safe at compile time.
- `spacing: double` — Space between children (default: 0)
- `mainAxisAlignment: WrapAlignment` — Horizontal alignment (default: .start)
- `crossAxisAlignment: WrapCrossAlignment` — Vertical alignment (default: .start)
- `key: Key?` — Optional widget key

**Constructor:**
```dart
const ResponsiveRow({
  required this.children,
  this.mainAxisAlignment = .start,
  this.crossAxisAlignment = .start,
  this.spacing = 0,
})
```

**Factory Constructor (builder):**
```dart
static ResponsiveRow builder({
  required int itemCount,
  required ResponsiveCol Function(int) itemBuilder,
  WrapAlignment mainAxisAlignment = .start,
  WrapCrossAlignment crossAxisAlignment = .start,
  double spacing = 0,
})
```

Generates ResponsiveRow with `itemCount` children by calling `itemBuilder` for each index.

**Gotchas:**
1. **itemCount must be >= 0** — builder will iterate 0 times if itemCount is 0 (valid, renders empty Wrap)
2. **Type safety** — Dart prevents non-ResponsiveCol widgets at compile time. No runtime validation needed.
3. **Wrap behavior** — Children wrap to next line when they exceed container width
4. **Full width enforced** — ResponsiveRow always has `width: double.infinity`

**Example:**
```dart
// Manual children
ResponsiveRow(
  spacing: 16,
  mainAxisAlignment: WrapAlignment.spaceEvenly,
  children: [
    ResponsiveCol(xs: .col6, md: .col4, child: Container()),
    ResponsiveCol(xs: .col6, md: .col4, child: Container()),
    ResponsiveCol(xs: .col12, md: .col4, child: Container()),
  ],
)

// Using builder
ResponsiveRow.builder(
  itemCount: 12,
  spacing: 8,
  itemBuilder: (index) => ResponsiveCol(
    xs: .col12,
    md: .col6,
    lg: .col4,
    child: Card(child: Text('Item $index')),
  ),
)
```

### ResponsiveCol

Responsive column wrapper that applies a width based on current screen size and breakpoint configuration.

**Parameters:**
- `child: Widget` — **Required.** Widget to wrap (can be any widget type)
- `xs: Sizes` — Extra small (< 600px), **Required** (default: .col12)
- `sm: Sizes?` — Small (≥ 600px, < 960px), fallback to xs if null
- `md: Sizes?` — Medium (≥ 960px, < 1264px), fallback chain: md → sm → xs
- `lg: Sizes?` — Large (≥ 1264px, < 1904px), fallback chain: lg → md → sm → xs
- `xl: Sizes?` — Extra large (≥ 1904px), fallback chain: xl → lg → md → sm → xs
- `key: Key?` — Optional widget key

**Constructor:**
```dart
const ResponsiveCol({
  this.xs = .col12,
  this.sm,
  this.md,
  this.lg,
  this.xl,
  required this.child,
})
```

**Breakpoint Values (constants):**
```dart
const double kExtraSmallGrid = 600;    // xs
const double kSmallGrid = 960;         // sm
const double kMediumGrid = 1264;       // md
const double kLargeGrid = 1904;        // lg
// xl is anything >= kLargeGrid
```

**Sizes Enum:**
- `col1` through `col12` — grid columns (1/12 to 12/12 of available width)
- Each size calculates: `width = (containerWidth / 12) * gridSize`

**Gotchas:**
1. **Fallback chain is critical** — If md is null, ResponsiveCol will use sm or xs. This allows "lazy" specification:
   ```dart
   ResponsiveCol(
     xs: .col12,     // mobile: full width
     lg: .col6,      // desktop: half width
     // sm and md inherit: sm→xs (col12), md→xs (col12)
   )
   ```

2. **LayoutBuilder is used internally** — Breakpoints are re-evaluated when constraints change (window resize, parent reflow)

3. **Width calculation is proportional** — All widths are based on 12-column system:
   - col6 at 1200px = 600px
   - col3 at 600px = 150px
   - col1 at 1200px = 100px

4. **Width never exceeds container** — ResponsiveCol fits within parent constraints

5. **All nullable sizes default to xs if specified** — You don't need to specify all breakpoints

**Example:**
```dart
// Responsive across all breakpoints
ResponsiveCol(
  xs: .col12,     // Mobile: full width
  sm: .col6,      // Tablet portrait: 50%
  md: .col4,      // Tablet landscape: 33%
  lg: .col3,      // Desktop: 25%
  xl: .col2,      // Ultra-wide: 16%
  child: Card(child: Text('Responsive!')),
)

// Lazy specification (some breakpoints inherit)
ResponsiveCol(
  xs: .col12,
  lg: .col6,
  child: Button(onPressed: () {}),
)
// At sm/md: uses xs (.col12)
// At lg/xl: uses lg (.col6)
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
