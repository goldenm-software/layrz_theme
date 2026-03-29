---
name: themed-tabview
description: ThemedTabView and ThemedTab — Material 3 styled tab navigation with flexible layouts and callbacks
---

## Overview

`ThemedTabView` is the layrz_theme tab navigation widget. It combines a horizontal tab bar with a content view that switches based on the selected tab. All tabs are built upfront (not lazy-loaded), making it suitable for a small to medium number of tabs.

| Feature | Details |
|---|---|
| Tab Styles | Two styles: `filledTonal` (default, Material 3 filled buttons) and `underline` (text-based with underline) |
| Scrollable TabBar | Horizontal scroll for many tabs |
| Optional Arrows | Left/right navigation buttons for non-scrollable contexts |
| Additional Widgets | Extra widgets (filters, buttons) can be placed next to the tab bar |
| Callbacks | `onTabIndex` fires when tab selection changes |
| State Persistence | `persistTabPosition` controls whether selected tab is preserved on widget rebuild |
| Custom Alignment | Control padding and alignment of the tab bar and content area |
| Icons & Labels | Tabs support leading/trailing icons alongside text labels |

**When to use:** Any horizontal navigation scenario — settings tabs, data views, dialogs with multiple sections. Keep tab count reasonable (< 10 recommended).

---

## ThemedTab

Defines a single tab's appearance and content.

### Key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | required (OR `label`) | Tab label text. Use for simple text labels. **Either `labelText` or `label` must be provided** |
| `label` | `Widget?` | required (OR `labelText`) | Custom label widget. Use for complex label layouts (e.g., with badges) |
| `child` | `Widget` | `SizedBox()` | Content widget displayed when this tab is active. Required in practice |
| `leadingIcon` | `IconData?` | `null` | Icon displayed before the label. Use `leading` for custom widgets |
| `leading` | `Widget?` | `null` | Custom widget displayed before the label. Prefer `leadingIcon` for simplicity |
| `trailingIcon` | `IconData?` | `null` | Icon displayed after the label. Use `trailing` for custom widgets |
| `trailing` | `Widget?` | `null` | Custom widget displayed after the label. Prefer `trailingIcon` for simplicity |
| `iconSize` | `double` | `30` | Size for leading/trailing icons |
| `padding` | `EdgeInsets` | `all(10)` | Padding around the tab's entire label area |
| `color` | `Color?` | `null` | Override the tab's color (used for active state detection). If not provided, uses the theme's primary color |
| `style` | `ThemedTabStyle` | `.filledTonal` | Visual style. Inherited from parent `ThemedTabView.style` via `overrideStyle()` |

### Minimal tab

```dart
ThemedTab(
  labelText: 'Settings',
  child: SettingsPanel(),
)
```

### Tab with leading icon

```dart
ThemedTab(
  labelText: 'Dashboard',
  leadingIcon: Icons.dashboard,
  child: DashboardView(),
)
```

### Tab with custom label widget

```dart
ThemedTab(
  label: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.notifications),
      const SizedBox(width: 8),
      const Text('Alerts'),
      // Custom badge
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10)),
      ),
    ],
  ),
  child: AlertsView(),
)
```

---

## ThemedTabView

The container widget that manages tab selection and displays both the tab bar and content area.

### Key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `tabs` | `List<ThemedTab>` | required | List of tabs to display. All tabs are built upfront (not lazy). Minimum 1 tab |
| `style` | `ThemedTabStyle` | `.filledTonal` | Visual style for all tabs. Options: `.filledTonal`, `.underline` |
| `initialPosition` | `int` | `0` | Starting tab index. **Clamped to valid range** — invalid indices don't crash |
| `onTabIndex` | `Function(int)?` | `null` | Callback fired when user taps a different tab. Receives the new tab index (0-based) |
| `persistTabPosition` | `bool` | `true` | If `true`, the selected tab is remembered when the widget list changes. If `false`, resets to tab 0 when `tabs.length` changes |
| `animationDuration` | `Duration` | `250ms` | Duration of the tab switch animation |
| `showArrows` | `bool` | `false` | If `true`, left/right arrow buttons appear for manual tab navigation |
| `wrapArrowNavigation` | `bool` | `false` | If `true`, arrows wrap around: left arrow on first tab goes to last, right arrow on last tab goes to first. If `false`, arrows are disabled at boundaries. Only applies when `showArrows: true` |
| `additionalWidgets` | `List<Widget>` | `[]` | Extra widgets (filters, search, etc.) placed next to the tab bar on the right |
| `padding` | `EdgeInsetsGeometry` | `all(10)` | Padding around the entire tab view (bar + content) |
| `separatorPadding` | `EdgeInsetsGeometry` | `only(top: 10)` | Padding between the tab bar and content area |
| `crossAxisAlignment` | `CrossAxisAlignment` | `.start` | Vertical alignment of the content area |
| `mainAxisAlignment` | `MainAxisAlignment` | `.start` | Horizontal alignment of the content area (rarely used) |
| `physics` | `ScrollPhysics?` | `null` | Scroll physics for the `TabBarView` content area |

### Minimal tab view

```dart
ThemedTabView(
  tabs: [
    ThemedTab(
      labelText: 'Home',
      child: HomePage(),
    ),
    ThemedTab(
      labelText: 'Settings',
      child: SettingsPage(),
    ),
  ],
)
```

### With arrows and custom styling

```dart
ThemedTabView(
  showArrows: true,
  style: .underline,
  initialPosition: 1,
  tabs: [
    ThemedTab(labelText: 'Tab A', child: ContentA()),
    ThemedTab(labelText: 'Tab B', child: ContentB()),
    ThemedTab(labelText: 'Tab C', child: ContentC()),
  ],
)
```

### With circular arrow navigation

```dart
ThemedTabView(
  showArrows: true,
  wrapArrowNavigation: true,  // Wrap around at boundaries
  tabs: [
    ThemedTab(labelText: 'Tab 1', child: Content1()),
    ThemedTab(labelText: 'Tab 2', child: Content2()),
    ThemedTab(labelText: 'Tab 3', child: Content3()),
  ],
)
// Left arrow on Tab 1 → Tab 3
// Right arrow on Tab 3 → Tab 1
```

### With callbacks and additional widgets

```dart
ThemedTabView(
  onTabIndex: (index) {
    print('User switched to tab $index');
    // Update analytics, state, etc.
  },
  additionalWidgets: [
    SearchBar(),
    FilterButton(),
  ],
  tabs: [
    ThemedTab(labelText: 'All', child: AllItemsView()),
    ThemedTab(labelText: 'Favorites', child: FavoritesView()),
  ],
)
```

### With icons and custom padding

```dart
ThemedTabView(
  padding: const EdgeInsets.all(20),
  separatorPadding: const EdgeInsets.symmetric(vertical: 16),
  tabs: [
    ThemedTab(
      labelText: 'Profile',
      leadingIcon: Icons.person,
      child: ProfileView(),
    ),
    ThemedTab(
      labelText: 'Orders',
      leadingIcon: Icons.shopping_bag,
      child: OrdersView(),
    ),
  ],
)
```

---

## Styling

### ThemedTabStyle enum

```dart
enum ThemedTabStyle {
  filledTonal,  // Material 3 filled tonal button (default)
  underline,    // Text-based with bottom underline when active
}
```

### filledTonal style

- Active tab: filled background with 20% opacity of the tab color
- Inactive tab: transparent background
- Animation: smooth 200ms fade when tab changes
- Best for: Dashboard-style multi-tab interfaces

### underline style

- Active tab: bottom underline (via TabBar indicator)
- Inactive tab: no underline
- Animation: smooth 250ms scroll animation
- Best for: Document-style tabs, minimal design

---

## Gotchas & Edge Cases

### 1. **All Tabs Are Built Upfront**

`ThemedTabView` builds all tab content widgets immediately, not lazily. This is fine for 2–5 tabs, but for 10+ tabs or expensive content widgets, consider:
- Lazy loading within each tab's `child` widget
- Using `visibility`-aware widgets to defer expensive work

```dart
// Good: Each tab's content is lightweight, or loads data on first interaction
ThemedTab(
  labelText: 'Analytics',
  child: Builder(
    builder: (context) {
      // This builder only runs when the widget is first mounted
      // Content loading happens inside this widget via FutureBuilder, StreamBuilder, etc.
      return AnalyticsPanel();
    },
  ),
)
```

### 2. **Invalid initialPosition is Clamped, Not Rejected**

If `initialPosition >= tabs.length`, it's clamped to the last valid index. No exception is thrown.

```dart
// initialPosition: 10, but only 3 tabs → starts at tab 2 (not crash)
ThemedTabView(
  initialPosition: 10,
  tabs: [tab1, tab2, tab3],
)
```

### 3. **persistTabPosition Requires tabs.length Change**

`persistTabPosition: false` only resets to tab 0 if the **number of tabs changes**. If the widget rebuilds with the same `tabs.length`, the tab index is preserved.

```dart
// Scenario 1: persistTabPosition: true + tabs.length changes → remembers old index
// Scenario 2: persistTabPosition: false + tabs.length changes → resets to tab 0
// Scenario 3: Widget rebuilds but tabs.length unchanged → index is preserved (regardless of persistTabPosition)
```

### 4. **onTabIndex Doesn't Fire on Initial Load**

The `onTabIndex` callback is only called when the user **changes** the tab, not when the widget first mounts.

```dart
// This callback won't fire initially; you need to handle initialPosition separately
onTabIndex: (index) {
  print('User switched to $index');
  // NOT called if initialPosition was 0 and no user interaction yet
}
```

### 5. **Arrow Button State Updates Reactively During Navigation**

When `showArrows: true` and `wrapArrowNavigation: false` (default), arrow buttons automatically enable/disable at tab boundaries. This is reactive — the button state updates every time the tab index changes, even without an `onTabIndex` callback. The widget rebuilds internally to reflect the current position.

```dart
// Scenario: Currently on first tab, right arrow enabled, left arrow disabled
// User taps right arrow → navigates to second tab → both arrows become enabled (automatically)
// User taps right arrow → navigates to third tab (last) → left arrow enabled, right arrow disabled

ThemedTabView(
  showArrows: true,
  wrapArrowNavigation: false,  // Default: arrows disabled at boundaries
  tabs: [tab1, tab2, tab3],
)
// The arrow disabled/enabled state is always correct, no manual state management needed
```

If you need `wrapArrowNavigation: true` for circular navigation, both arrows stay enabled at all times.

### 6. **Color Detection is RGB-Based**

The active tab highlight color is determined by comparing the tab's `color` to the theme's primary color (RGB + Alpha match required). If your tabs don't have explicit colors, they use `DefaultTextStyle.of(context).style.color`, which might be `null` and default to primary.

```dart
// Custom colors for different tabs
ThemedTab(
  labelText: 'Custom',
  color: Colors.purple,  // Will show as active if this matches the primary color
  child: CustomView(),
)
```

### 7. **Tab Bar Text is RichText**

Tab labels are rendered with `RichText` and `TextSpan`, not plain `Text`. This means:
- Custom styling per part of the label (e.g., icon + text) is easy
- Finding tabs by text in widget tests requires custom finders (see Testing below)

---

## Best Practices

### 1. **Use `persistTabPosition: true` for Settings/Navigation Tabs**

If users might apply settings or make selections in a tab, remember their position when they return.

```dart
ThemedTabView(
  persistTabPosition: true,  // Preserve tab selection across rebuilds
  tabs: [
    ThemedTab(labelText: 'General', child: GeneralSettings()),
    ThemedTab(labelText: 'Advanced', child: AdvancedSettings()),
  ],
)
```

### 2. **Use `persistTabPosition: false` for Filtered/Dynamic Tab Lists**

If the tab list changes dynamically (e.g., filtering by category), reset to the first tab.

```dart
ThemedTabView(
  persistTabPosition: false,  // Reset when categories change
  tabs: activeCategories.map((cat) =>
    ThemedTab(labelText: cat.name, child: CategoryView(cat))
  ).toList(),
)
```

### 3. **Keep Tabs Lightweight; Defer Expensive Work**

Don't do heavy computation in tab content build methods. Use `FutureBuilder` or `StreamBuilder` inside each tab's `child`.

```dart
// Bad: Expensive work in the child widget's build method
ThemedTab(
  labelText: 'Reports',
  child: ReportGenerator(),  // ← This runs upfront for ALL tabs
)

// Good: Lazy loading inside the tab
ThemedTab(
  labelText: 'Reports',
  child: FutureBuilder(
    future: _loadReports(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return const CircularProgressIndicator();
      return ReportView(snapshot.data!);
    },
  ),
)
```

### 4. **Use Arrows Only When Tab Bar Doesn't Scroll**

The `showArrows` buttons are for non-scrollable tab bar scenarios. If your tabs fit on screen or the `TabBar` is already scrollable, skip arrows.

```dart
// With arrows: controlled, button-based navigation
ThemedTabView(
  showArrows: true,
  tabs: many_tabs,
)

// Without arrows: natural scrolling (TabBar is isScrollable: true)
ThemedTabView(
  showArrows: false,  // Let TabBar handle horizontal scroll
  tabs: many_tabs,
)
```

### 4b. **Choose Between Linear and Wrap Arrow Navigation**

When using `showArrows: true`, decide if arrows should disable at boundaries or wrap around:

```dart
// Linear navigation (default): arrows disabled at first/last tabs
ThemedTabView(
  showArrows: true,
  wrapArrowNavigation: false,
  tabs: [tab1, tab2, tab3],
)
// On first tab: left arrow disabled, right arrow enabled
// On last tab: left arrow enabled, right arrow disabled

// Circular navigation: arrows wrap around
ThemedTabView(
  showArrows: true,
  wrapArrowNavigation: true,
  tabs: [tab1, tab2, tab3],
)
// On first tab: left arrow goes to last tab, right arrow goes to second tab
// On last tab: left arrow goes to previous tab, right arrow goes to first tab
// Both arrows always enabled
```

### 5. **Pass Constants for Theme Consistency**

Use inherited theme values for spacing and animation durations rather than magic numbers.

```dart
ThemedTabView(
  animationDuration: Theme.of(context).pageTransitionsTheme.buildTransitions == null
    ? const Duration(milliseconds: 250)
    : const Duration(milliseconds: 300),
  padding: const EdgeInsets.all(16),  // Match Material 3 spacing
  tabs: tabs,
)
```

### 6. **Combine with LayoutBuilder for Responsive Tabs**

If tab list or additional widgets should change based on screen size, wrap in `LayoutBuilder`.

```dart
LayoutBuilder(
  builder: (context, constraints) {
    return ThemedTabView(
      showArrows: constraints.maxWidth < 600,  // Show arrows on mobile
      additionalWidgets: constraints.maxWidth > 960
        ? [SearchBar(), FilterButton()]
        : [],
      tabs: tabs,
    );
  },
)
```

---

## Testing

When writing widget tests for tabs:

1. **Find tabs by RichText content**, not plain text:
   ```dart
   Finder findTabByText(String text) {
     return find.byWidgetPredicate((widget) {
       if (widget is RichText) {
         return widget.text.toPlainText().contains(text);
       }
       return false;
     });
   }

   await tester.tap(findTabByText('Settings'));
   await tester.pumpAndSettle();
   ```

2. **Verify tab content changes** after tapping:
   ```dart
   expect(find.text('Settings Content'), findsOneWidget);
   ```

3. **Test callbacks**:
   ```dart
   int? lastIndex;
   await tester.pumpWidget(
     ThemedTabView(
       onTabIndex: (index) { lastIndex = index; },
       tabs: tabs,
     ),
   );
   await tester.tap(findTabByText('Tab 2'));
   await tester.pumpAndSettle();
   expect(lastIndex, equals(1));
   ```

---

## Common Patterns

### Pattern: Analytics Tracking

```dart
ThemedTabView(
  onTabIndex: (index) {
    analytics.logEvent(
      name: 'tab_switched',
      parameters: {'tab_index': index, 'tab_name': tabs[index].labelText},
    );
  },
  tabs: tabs,
)
```

### Pattern: Save User Preference

```dart
ThemedTabView(
  initialPosition: savedTabIndex,  // Load from SharedPreferences
  onTabIndex: (index) {
    prefs.setInt('last_tab', index);  // Save on change
  },
  tabs: tabs,
)
```

### Pattern: Conditional Tab Visibility

```dart
ThemedTabView(
  tabs: [
    if (user.isAdmin) ...[
      ThemedTab(labelText: 'Admin Panel', child: AdminView()),
    ],
    if (showDebugTabs) ...[
      ThemedTab(labelText: 'Debug', child: DebugView()),
    ],
    ThemedTab(labelText: 'Profile', child: ProfileView()),
  ],
)
```

### Pattern: Dynamic Tab Title with Badge

```dart
ThemedTab(
  label: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text('Notifications'),
      if (notificationCount > 0) ...[
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$notificationCount',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      ],
    ],
  ),
  child: NotificationsView(),
)
```

---

## Summary

- **Use `ThemedTabView` for horizontal tab navigation** with Material 3 styling
- **Keep tabs lightweight**; defer expensive work to each tab's content widget
- **Use `persistTabPosition: true` for settings**, `false` for dynamic tab lists
- **Test with custom RichText finders**, not plain text finds
- **Combine with `LayoutBuilder` for responsive designs**
