---
name: themed-tooltip
description: Use ThemedTooltip in a layrz Flutter widget. Apply when wrapping any child with a hover/long-press hint — drop-in replacement for Flutter's Tooltip that preserves child tap gestures.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.top`, `.bottom`, `.left`, `.right`) — never write the fully-qualified form (`ThemedTooltipPosition.bottom`).

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Anywhere you would reach for Flutter's `Tooltip` — `ThemedTooltip` is the Layrz drop-in replacement.
- Use it specifically when the wrapped child must remain tappable: Flutter's `Tooltip` intercepts taps on mobile, `ThemedTooltip` does not.
- Hover on desktop/web shows the tip automatically; on touch devices a long-press shows it.
- Any icon button, action chip, or compact control that needs a short explanatory hint.
- Never wrap in a raw `Tooltip(...)` inside layrz code — always use `ThemedTooltip`.

---

## Minimal usage

```dart
ThemedTooltip(
  message: context.i18n.t('actions.delete'),
  child: IconButton(
    icon: const Icon(LayrzIcons.solarOutlineTrashBinTrash),
    onPressed: () => onDelete(),
  ),
)
```

---

## Key behaviors

- `child` and `message` are **required**.
- `position` defaults to `.bottom`. Other options: `.top`, `.left`, `.right`.
- Auto-clamps to the screen edge: if the tooltip would overflow horizontally, it shifts to `left: 0` / `right: 0`; if `.left` / `.right` don't fit, it flips to the opposite side.
- `color` defaults to `Theme.of(context).tooltipTheme.decoration` (primary color on light theme, `kDarkBackgroundColor` on dark theme). Pass a custom `Color` to override.
- Text color is auto-derived from the background via `validateColor(...)` for contrast — do not set it manually.
- Mouse detected → shows on hover via `MouseRegion`. No mouse → shows on `onLongPress`.
- Tooltip hides on pointer-down anywhere, pointer-up, pointer-cancel, or when the app is paused/inactive.
- Preserves the child's own gesture detector — taps on the child fire normally. This is the key difference from Flutter's `Tooltip`.

---

## Common patterns

```dart
// Default — hint below the child
ThemedTooltip(
  message: context.i18n.t('entity.info'),
  child: const Icon(LayrzIcons.solarOutlineInfoCircle),
)

// Position above
ThemedTooltip(
  message: context.i18n.t('actions.edit'),
  position: .top,
  child: IconButton(
    icon: const Icon(LayrzIcons.solarOutlinePen),
    onPressed: onEdit,
  ),
)

// Custom background color (text color is auto-contrasted)
ThemedTooltip(
  message: context.i18n.t('status.warning'),
  color: Colors.orange,
  child: const Icon(LayrzIcons.solarOutlineDangerTriangle),
)

// Wrapping a tappable control — tap still fires
ThemedTooltip(
  message: context.i18n.t('actions.save'),
  position: .left,
  child: ElevatedButton(
    onPressed: onSave,
    child: Text(context.i18n.t('actions.save')),
  ),
)
```

---

## Usage conventions

- Use `context.i18n.t('...')` for `message` — never hardcode strings.
- Prefer the default `.bottom` position; only override when layout constraints demand it (e.g. row of icons near the screen bottom → use `.top`).
- Don't pass `color` just to match the theme — the default already picks the correct themed color.
- Keep messages short (one line); long strings wrap to 80% of screen width but hurt scannability.
