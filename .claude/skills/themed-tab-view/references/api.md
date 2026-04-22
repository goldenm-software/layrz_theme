# ThemedTabView — API Reference

Sources:
- `lib/src/tabs/src/view.dart` — `ThemedTabView`
- `lib/src/tabs/src/tab.dart` — `ThemedTab`
- `lib/src/tabs/src/style.dart` — `ThemedTabStyle`

---

## Examples

```dart
// Minimal
ThemedTabView(
  tabs: [
    ThemedTab(labelText: 'Home', child: HomePage()),
    ThemedTab(labelText: 'Settings', child: SettingsPage()),
  ],
)

// With underline style and arrows
ThemedTabView(
  style: .underline,
  showArrows: true,
  tabs: [
    ThemedTab(labelText: 'Tab A', child: ContentA()),
    ThemedTab(labelText: 'Tab B', child: ContentB()),
  ],
)

// Tab change callback
ThemedTabView(
  onTabIndex: (index) => setState(() => _tab = index),
  tabs: [ /* ... */ ],
)

// Tab with leading icon
ThemedTab(
  labelText: 'Dashboard',
  leadingIcon: LayrzIcons.solarOutlineDashboard,
  child: DashboardView(),
)

// Tab with custom label widget
ThemedTab(
  label: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text('Alerts'),
      const SizedBox(width: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10)),
      ),
    ],
  ),
  child: AlertsView(),
)
```

---

## ThemedTabView Constructor

```dart
const ThemedTabView({
  super.key,
  required this.tabs,
  this.padding = const EdgeInsets.all(10),
  this.crossAxisAlignment = CrossAxisAlignment.start,
  this.mainAxisAlignment = MainAxisAlignment.start,
  this.animationDuration = const Duration(milliseconds: 250),
  this.physics,
  this.separatorPadding = const EdgeInsets.only(top: 10),
  this.showArrows = false,
  this.persistTabPosition = true,
  this.initialPosition = 0,
  this.onTabIndex,
  this.additionalWidgets = const [],
  this.style = .filledTonal,
  this.wrapArrowNavigation = false,
})
```

---

## ThemedTabView Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `tabs` | `List<ThemedTab>` | required | All tabs built upfront (not lazy) |
| `style` | `ThemedTabStyle` | `.filledTonal` | Visual style for all tabs |
| `initialPosition` | `int` | `0` | Starting tab index; clamped to valid range |
| `onTabIndex` | `Function(int)?` | `null` | Fires on user tab change; NOT on initial mount |
| `persistTabPosition` | `bool` | `true` | Preserves selected tab when `tabs.length` changes |
| `animationDuration` | `Duration` | `250ms` | Tab switch animation duration |
| `showArrows` | `bool` | `false` | Adds left/right navigation buttons |
| `wrapArrowNavigation` | `bool` | `false` | Arrows wrap at boundaries (first↔last). Only applies when `showArrows: true` |
| `additionalWidgets` | `List<Widget>` | `[]` | Extra widgets placed right of the tab bar |
| `padding` | `EdgeInsetsGeometry` | `all(10)` | Outer padding (bar + content) |
| `separatorPadding` | `EdgeInsetsGeometry` | `only(top: 10)` | Padding between tab bar and content |
| `crossAxisAlignment` | `CrossAxisAlignment` | `.start` | Vertical alignment of content column |
| `mainAxisAlignment` | `MainAxisAlignment` | `.start` | Horizontal alignment of content (rarely used) |
| `physics` | `ScrollPhysics?` | `null` | Scroll physics for `TabBarView` |

---

## ThemedTab Constructor

```dart
const ThemedTab({
  super.key,
  this.labelText,
  this.label,
  this.iconSize = 30,
  this.leading,
  this.leadingIcon,
  this.trailing,
  this.trailingIcon,
  this.padding = const EdgeInsets.all(10),
  this.color,
  this.child = const SizedBox(),
  this.style = .filledTonal,
}) : assert(labelText != null || label != null);
```

---

## ThemedTab Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Mutually exclusive with `label`; at least one required |
| `label` | `Widget?` | — | Custom label widget; mutually exclusive with `labelText` |
| `child` | `Widget` | `SizedBox()` | Content shown when this tab is active |
| `leadingIcon` | `IconData?` | `null` | Icon before the label |
| `leading` | `Widget?` | `null` | Custom widget before the label; prefer `leadingIcon` |
| `trailingIcon` | `IconData?` | `null` | Icon after the label |
| `trailing` | `Widget?` | `null` | Custom widget after the label; prefer `trailingIcon` |
| `iconSize` | `double` | `30` | Size for leading/trailing icons |
| `padding` | `EdgeInsets` | `all(10)` | Padding around the tab label area |
| `color` | `Color?` | `null` | Override tab color (used for active state detection) |
| `style` | `ThemedTabStyle` | `.filledTonal` | Overridden by parent `ThemedTabView.style` |

---

## ThemedTabStyle enum

```dart
enum ThemedTabStyle {
  filledTonal,  // Material 3 filled tonal button (default)
  underline,    // Text with bottom underline when active
}
```

| Style | Active state | Best for |
|---|---|---|
| `.filledTonal` | Filled background (20% opacity) | Dashboard-style multi-tab |
| `.underline` | Bottom border via TabBar indicator | Document-style, minimal design |

---

## Behavior notes

- Tab bar is always scrollable (`TabBar(isScrollable: true)`).
- `onTabIndex` fires only when the user changes the tab (`indexIsChanging` guard) — not on initial mount.
- `persistTabPosition` only resets to 0 when `tabs.length` changes. Same-length rebuilds always preserve index.
- `initialPosition` out of range is clamped — no exception thrown.
- Tab labels are rendered as `RichText` — widget tests must use custom `RichText`-based finders, not `find.text()`.
- Active tab color detection is RGB+Alpha equality against `colorScheme.primary`. Tabs without explicit `color` use `DefaultTextStyle`.
