# ThemedTooltip — API Reference

Source: `lib/src/tooltips/src/custom_tooltip.dart`

- `ThemedTooltip` class — line 3
- `ThemedTooltipPosition` enum — line 296

---

## Examples

```dart
// Default — tooltip below the child
ThemedTooltip(
  message: 'Delete',
  child: IconButton(
    icon: const Icon(LayrzIcons.solarOutlineTrashBinTrash),
    onPressed: onDelete,
  ),
)

// Position above
ThemedTooltip(
  message: 'Edit',
  position: .top,
  child: IconButton(
    icon: const Icon(LayrzIcons.solarOutlinePen),
    onPressed: onEdit,
  ),
)

// Position left
ThemedTooltip(
  message: 'Save',
  position: .left,
  child: ElevatedButton(
    onPressed: onSave,
    child: const Text('Save'),
  ),
)

// Position right
ThemedTooltip(
  message: 'More info',
  position: .right,
  child: const Icon(LayrzIcons.solarOutlineInfoCircle),
)

// Custom background color (text color auto-contrasted)
ThemedTooltip(
  message: 'Warning',
  color: Colors.orange,
  child: const Icon(LayrzIcons.solarOutlineDangerTriangle),
)
```

---

## Constructor

```dart
const ThemedTooltip({
  super.key,
  required Widget child,
  required String message,
  ThemedTooltipPosition position = .bottom,
  Color? color,
});
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | — | **Required.** The widget wrapped by the tooltip. Its own gestures are preserved. |
| `message` | `String` | — | **Required.** Text displayed in the tooltip bubble. Wraps at 80% of screen width. |
| `position` | `ThemedTooltipPosition` | `.bottom` | Placement relative to the child. Auto-flips / clamps to stay on-screen. |
| `color` | `Color?` | `null` | Background color. When null, uses `Theme.of(context).tooltipTheme.decoration` color. Text color is always derived via `validateColor(...)` for contrast. |

---

## ThemedTooltipPosition enum

| Value | Description |
|---|---|
| `.top` | Tooltip rendered above the child, 10px gap; horizontally centered and clamped to screen edges. |
| `.bottom` | Tooltip rendered below the child, 10px gap; horizontally centered and clamped to screen edges. |
| `.left` | Tooltip rendered to the left; if it would overflow, flips to the right; if still no space, left-aligns with clamped width. |
| `.right` | Tooltip rendered to the right; if it would overflow, flips to the left and can narrow to fit. |

---

## Behavior notes

- **Input mode detection**: uses `RendererBinding.instance.mouseTracker.mouseIsConnected`. If a mouse is present, hover triggers the tooltip (`MouseRegion`); otherwise a `GestureDetector.onLongPress` triggers it.
- **Auto-dismiss**: any `PointerDownEvent` dismisses immediately; `PointerUpEvent` / `PointerCancelEvent` animate out. The tooltip also hides on `AppLifecycleState.paused` / `.inactive`.
- **Animation**: fades in/out using `kHoverDuration` via an internal `AnimationController`.
- **Preserves child taps**: unlike Flutter's `Tooltip` which can intercept taps on touch devices, `ThemedTooltip` wraps its child so the child's own `onTap` / `onPressed` always fire.
- **Semantics**: exposes `message` via `Semantics(tooltip: message, child: child)` for accessibility.
