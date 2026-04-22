# ThemedAlert — API Reference

Source: `lib/src/alerts/`

- `ThemedAlert` class — `src/alert.dart` line 37
- `ThemedAlertType` enum — `src/type.dart`
- `ThemedAlertStyle` enum — `src/style.dart`
- `ThemedAlertIcon` class — `src/icon.dart` line 24

---

## Examples

```dart
// Default — info type, layrz style
ThemedAlert(
  title: 'Heads up',
  description: 'This action cannot be undone after 30 days.',
)

// Warning with filledTonal background
ThemedAlert(
  type: .warning,
  style: .filledTonal,
  title: 'Low disk space',
  description: 'You have less than 500 MB remaining.',
)

// Danger with filled (solid) background
ThemedAlert(
  type: .danger,
  style: .filled,
  title: 'Account suspended',
  description: 'Your account has been suspended due to policy violations.',
)

// Success outlined (inside a Card)
ThemedAlert(
  type: .success,
  style: .outlined,
  title: 'Export complete',
  description: 'Your file has been exported and is ready to download.',
)

// FilledIcon style — two-column layout
ThemedAlert(
  type: .info,
  style: .filledIcon,
  title: 'New version available',
  description: 'Version 3.2 introduces improved performance and bug fixes.',
)

// Custom type — override icon and color
ThemedAlert(
  type: .custom,
  color: const Color(0xFF6A0DAD),
  icon: LayrzIcons.solarOutlineShieldCheck,
  title: 'Identity verified',
  description: 'Your identity has been verified successfully.',
)

// Extended description with bumped maxLines
ThemedAlert(
  type: .context,
  title: 'About this feature',
  description: 'This feature is in beta. Some behaviors may change without '
      'notice. Please report any issues to the support team.',
  maxLines: 5,
)
```

---

## Constructor

```dart
const ThemedAlert({
  super.key,
  this.type = .info,
  required this.title,
  required this.description,
  this.maxLines = 3,
  this.style = .layrz,
  this.color,
  this.icon,
  this.iconSize,
});
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `type` | `ThemedAlertType` | `.info` | Semantic severity. Drives the default icon and color. See enum table below. |
| `title` | `String` | — | **Required.** Bold heading text of the alert. |
| `description` | `String` | — | **Required.** Body text. Clipped at `maxLines` with an ellipsis. |
| `maxLines` | `int` | `3` | Maximum lines for `description`. Increase when the message is known to be longer. |
| `style` | `ThemedAlertStyle` | `.layrz` | Visual surface treatment. See enum table below. |
| `color` | `Color?` | `null` | Used **only** when `type == .custom`. Has no effect for other types. |
| `icon` | `IconData?` | `null` | Used **only** when `type == .custom`. Has no effect for other types. |
| `iconSize` | `double?` | `null` | Icon size. Defaults to `25` when `style == .filledIcon`, `22` otherwise. |

---

## `ThemedAlertType` enum

| Value | Default icon | Default color | Notes |
|---|---|---|---|
| `.info` | `solarOutlineInfoSquare` | `Colors.blue` | Neutral informational hint. Default type. |
| `.success` | `solarOutlineCheckSquare` | `Colors.green` | Confirmation that an action completed. |
| `.warning` | `solarOutlineDangerSquare` | `Colors.orange` | Reversible caution; user can still proceed. |
| `.danger` | `solarOutlineCloseSquare` | `Colors.red` | Blocking or destructive condition. |
| `.context` | `solarOutlineMenuDotsSquare` | `Colors.grey` | Muted, low-emphasis metadata note. |
| `.custom` | `null` (must set `icon`) | `null` (must set `color`) | Both `icon` and `color` are **required** when using this type. |

---

## `ThemedAlertStyle` enum

| Value | Description |
|---|---|
| `.layrz` | Soft tonal icon chip + plain text on a transparent background. Default. |
| `.filledTonal` | Background filled at ~20% alpha of the type color; text and icon in type color. |
| `.filled` | Solid type-color background. Text color is auto-contrasted via `validateColor(typeColor)`. |
| `.outlined` | Transparent background with a 1 px type-color border. |
| `.filledIcon` | Two-column layout: icon column filled with type color; body column uses `scaffoldBackgroundColor`. |

---

## Companion — `ThemedAlertIcon`

Standalone colored icon badge matching the alert's type palette. Use when you need just the badge without a title or description — for example, as a status indicator in a table row.

```dart
const ThemedAlertIcon({
  super.key,
  this.type = .info,
  this.size = 30,
  this.iconSize = 20,
  this.padding = const EdgeInsets.all(5),
  this.color,
  this.icon,
});
```

| Property | Type | Default | Notes |
|---|---|---|---|
| `type` | `ThemedAlertType` | `.info` | Drives the icon and background color. |
| `size` | `double` | `30` | Diameter of the circular badge. |
| `iconSize` | `double` | `20` | Icon size inside the badge. |
| `padding` | `EdgeInsetsGeometry` | `EdgeInsets.all(5)` | Internal padding around the icon. |
| `color` | `Color?` | `null` | Used only when `type == .custom`. |
| `icon` | `IconData?` | `null` | Used only when `type == .custom`. |

---

## Behavior notes

- **`.filledIcon` layout:** renders a `Row` with two columns — the left column is a `Container` filled with the type color and the right column uses the scaffold's background color. The icon column width is determined by `iconSize + padding`.
- **`.filled` text contrast:** body text color is computed via `validateColor(typeColor)`, which selects black or white for maximum legibility — do not manually set text color inside a `.filled` alert.
- **`.filledTonal` alpha:** background is `typeColor.withAlpha(51)` (≈ 20% opacity on any surface).
- **`.outlined` border:** 1 px `BoxDecoration` border using the type color; no background fill.
- **No dialog helper:** `ThemedAlert` is intentionally a pure layout widget with no `show()` or imperative API. Wrap it in `showDialog`, `ScaffoldMessenger.showSnackBar`, or any other mechanism the caller controls.
