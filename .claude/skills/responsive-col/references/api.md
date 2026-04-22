# ResponsiveCol — API Reference

Sources:
- `ResponsiveCol` — `lib/src/grid/src/col.dart` line 3
- `Sizes` enum + `SizesExt` — `lib/src/grid/src/sizes.dart` line 11
- Breakpoint constants — `lib/src/theme/src/constants.dart`

---

## Breakpoint constants

| Constant | Value | Param | Range |
|---|---|---|---|
| `kExtraSmallGrid` | `600` | `xs` | < 600 px |
| `kSmallGrid` | `960` | `sm` | 600–959 px |
| `kMediumGrid` | `1264` | `md` | 960–1263 px |
| `kLargeGrid` | `1904` | `lg` | 1264–1903 px |
| — | — | `xl` | ≥ 1904 px |

Fallback chain (from `_currentSize`):

```
width < 600         → xs
600 ≤ width < 960   → sm ?? xs
960 ≤ width < 1264  → md ?? sm ?? xs
1264 ≤ width < 1904 → lg ?? md ?? sm ?? xs
width ≥ 1904        → xl ?? lg ?? md ?? sm ?? xs
```

---

## Constructor

```dart
const ResponsiveCol({
  super.key,
  this.xs = .col12,  // Sizes — base fallback for all breakpoints
  this.sm,                // Sizes?
  this.md,                // Sizes?
  this.lg,                // Sizes?
  this.xl,                // Sizes?
  required this.child,    // Widget
})
```

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `xs` | `Sizes` | `.col12` | < 600 px. Always set explicitly — fallback for all other breakpoints |
| `sm` | `Sizes?` | `null` | 600–959 px. Falls back to `xs` |
| `md` | `Sizes?` | `null` | 960–1263 px. Falls back to `sm → xs` |
| `lg` | `Sizes?` | `null` | 1264–1903 px. Falls back to `md → sm → xs` |
| `xl` | `Sizes?` | `null` | ≥ 1904 px. Falls back to `lg → md → sm → xs` |
| `child` | `Widget` | required | |

Rendered via `LayoutBuilder` — breakpoint is evaluated against the col's own constraint width.  
Width formula: `(containerWidth / 12) * gridSize`

---

## Sizes enum

Source: `lib/src/grid/src/sizes.dart` line 11

```dart
enum Sizes { col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12 }
```

| Value | Columns | % of parent |
|---|---|---|
| `.col1` | 1 | 8.3% |
| `.col2` | 2 | 16.7% |
| `.col3` | 3 | 25% |
| `.col4` | 4 | 33.3% |
| `.col6` | 6 | 50% |
| `.col8` | 8 | 66.7% |
| `.col9` | 9 | 75% |
| `.col12` | 12 | 100% |

### SizesExt extension

```dart
extension SizesExt on Sizes {
  double boxWidth(double width)  // (width / 12) * gridSize
  int get gridSize               // column count 1–12
}
```

---

## Examples

```dart
// Minimum — full on mobile, half on desktop
ResponsiveCol(
  xs: .col12,
  md: .col6,
  child: MyWidget(),
)

// All breakpoints explicit
ResponsiveCol(
  xs: .col12,
  sm: .col6,
  md: .col4,
  lg: .col3,
  xl: .col2,
  child: ProductCard(),
)

// Lazy — only set what changes from xs
ResponsiveCol(
  xs: .col12,  // mobile + tablet: full width (sm and md fall back to xs)
  lg: .col6,   // desktop: half width
  child: SectionWidget(),
)

// Sidebar — narrow on large screens
ResponsiveCol(
  xs: .col12,
  lg: .col3,
  child: Sidebar(),
)

// Content area — remaining space after sidebar
ResponsiveCol(
  xs: .col12,
  lg: .col9,
  child: MainContent(),
)

// Divider spanning full width
const ResponsiveCol(child: Divider())

// Real example from example app — code editor side by side
ResponsiveCol(
  xs: .col12,
  md: .col6,
  child: ThemedCodeEditor(
    labelText: 'Python example',
    language: LayrzSupportedLanguage.python,
    value: _pythonCode,
    onChanged: (val) => setState(() => _pythonCode = val),
  ),
)
```
