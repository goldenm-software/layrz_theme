---
name: themed-tab-view
description: Use ThemedTabView and ThemedTab in a layrz Flutter widget. Apply when adding horizontal tab navigation with Material 3 styling.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Horizontal tab navigation: settings panels, data views, dialogs with sections
- All tabs are built upfront (not lazy) — keep count reasonable (< 10)
- For lazy content within a tab, use `FutureBuilder`/`StreamBuilder` inside the tab's `child`

---

## Minimal usage

```dart
ThemedTabView(
  tabs: [
    ThemedTab(
      labelText: context.i18n.t('tabs.general'),
      child: GeneralPanel(),
    ),
    ThemedTab(
      labelText: context.i18n.t('tabs.advanced'),
      child: AdvancedPanel(),
    ),
  ],
)
```

`ThemedTabView` must be in a bounded-height context — wrap in `Expanded` or give it a fixed height.

---

## Key behaviors

- Tab bar is always scrollable (`TabBar(isScrollable: true)`).
- Two styles: `.filledTonal` (default, filled background on active) and `.underline` (bottom border on active).
- `initialPosition` is clamped to valid range — out-of-range values don't crash.
- `onTabIndex` fires only when the user **changes** the tab, not on initial mount.
- `persistTabPosition` only resets when `tabs.length` changes (not on every rebuild).
- `showArrows` adds left/right `ThemedButton` navigation; combine with `wrapArrowNavigation` for circular nav.
- `additionalWidgets` appear to the right of the tab bar (e.g., filters, search).
- Exactly one of `labelText` / `label` must be set on `ThemedTab` — assert enforced.

---

## Common patterns

```dart
// With underline style and arrows
ThemedTabView(
  style: .underline,
  showArrows: true,
  tabs: [
    ThemedTab(labelText: 'Tab A', child: ContentA()),
    ThemedTab(labelText: 'Tab B', child: ContentB()),
  ],
)

// Circular arrow navigation
ThemedTabView(
  showArrows: true,
  wrapArrowNavigation: true,
  tabs: [ /* ... */ ],
)

// Tab with leading icon
ThemedTab(
  labelText: context.i18n.t('tabs.dashboard'),
  leadingIcon: LayrzIcons.solarOutlineDashboard,
  child: DashboardView(),
)

// Tab with custom label (e.g., badge)
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

// With additionalWidgets and tab change callback
ThemedTabView(
  onTabIndex: (index) => setState(() => _activeTab = index),
  additionalWidgets: [FilterButton()],
  tabs: [ /* ... */ ],
)

// Dynamic tab list — reset to tab 0 when list changes
ThemedTabView(
  persistTabPosition: false,
  tabs: categories.map((c) => ThemedTab(labelText: c.name, child: CategoryView(c))).toList(),
)
```
