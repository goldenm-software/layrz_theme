# ThemedButton — API Reference

Source: `lib/src/buttons/src/button.dart`

- `ThemedButton` class — line 122
- `ThemedButtonStyle` enum — line 1324

---

## Examples

```dart
// Default filledTonal with text + icon
ThemedButton(
  labelText: 'Export',
  icon: LayrzIcons.solarOutlineExport,
  onTap: () => doExport(),
)

// Filled style — solid background
ThemedButton(
  labelText: 'Confirm',
  style: .filled,
  onTap: () => confirm(),
)

// Outlined style
ThemedButton(
  labelText: 'More info',
  icon: LayrzIcons.solarOutlineInfoSquare,
  style: .outlined,
  onTap: () => showInfo(),
)

// Text-only (no background or border)
ThemedButton(
  labelText: 'Skip',
  style: .text,
  onTap: () => skip(),
)

// FAB — icon only, label becomes tooltip
ThemedButton(
  labelText: 'Add',
  icon: LayrzIcons.solarOutlineAddSquare,
  style: .fab,
  onTap: () => add(),
)

// FilledTonal FAB — icon only
ThemedButton(
  labelText: 'Upload',
  icon: LayrzIcons.solarOutlineUpload,
  style: .filledTonalFab,
  onTap: () => upload(),
)

// Cooldown button — locked for 30 s after tap
ThemedButton(
  labelText: 'Resend code',
  isCooldown: true,
  cooldownDuration: const Duration(seconds: 30),
  onCooldownFinish: onCooldownDone,
  onTap: () => resend(),
)

// Long-press (mutually exclusive with onTap)
ThemedButton(
  labelText: 'Delete',
  icon: LayrzIcons.solarOutlineTrashBinMinimalistic2,
  color: Colors.red,
  onLongPress: () => confirmDelete(),
)

// Disabled
ThemedButton(
  labelText: 'Submit',
  isDisabled: true,
  onTap: () => submit(),
)

// Loading state with custom spinner colors
ThemedButton(
  labelText: 'Processing',
  isLoading: true,
  loadingBackgroundColor: Colors.blue.shade100,
  loadingForegroundColor: Colors.blue,
  onTap: () => process(),
)

// Semantic factory — save
ThemedButton.save(
  labelText: 'Save',
  isMobile: false,
  isLoading: isSaving,
  onTap: () => save(),
)

// Semantic factory — delete
ThemedButton.delete(
  labelText: 'Delete',
  isMobile: true,
  onTap: () => delete(),
)
```

---

## Constructor

```dart
const ThemedButton({
  super.key,
  this.label,
  this.labelText,
  this.icon,
  this.onTap,
  this.isLoading = false,
  this.color,
  this.style = .filledTonal,
  this.isCooldown = false,
  this.cooldownDuration = const Duration(seconds: 5),
  this.onCooldownFinish,
  this.hintText,
  this.width,
  this.isDisabled = false,
  this.tooltipPosition = .bottom,
  this.fontSize = 14,
  this.tooltipEnabled = true,
  this.showCooldownRemainingDuration = true,
  this.height = defaultHeight,
  this.iconSize = 22,
  this.iconSeparatorSize = 8,
  this.loadingBackgroundColor,
  this.loadingForegroundColor,
  this.customLongPressDuration = const Duration(milliseconds: 500),
  this.onLongPress,
}) : assert(label != null || labelText != null, "You must provide a label or labelText, not both or none."),
     assert(height >= 30, "Height must be greater than 30"),
     assert(iconSize >= 0, "Icon size must be greater than 0"),
     assert(iconSize <= height, "Icon size must be less than or equal to height"),
     assert(fontSize >= 0, "Font size must be greater than 0"),
     assert(fontSize <= height, "Font size must be less than or equal to height"),
     assert(!(onTap != null && onLongPress != null), "You must provide either onTap or onLongPress, not both.");
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `label` | `Widget?` | `null` | Custom widget label. Mutually exclusive with `labelText` — provide exactly one. |
| `labelText` | `String?` | `null` | **Required** (unless `label` provided). Plain-text label. FAB variants use this as tooltip text. |
| `icon` | `IconData?` | `null` | Icon displayed before the label. Required for FAB-variant styles to render correctly. |
| `onTap` | `VoidCallback?` | `null` | Tap handler. Mutually exclusive with `onLongPress`. |
| `isLoading` | `bool` | `false` | Replaces content with a circular spinner. |
| `color` | `Color?` | `null` | Overrides the button's accent color. Defaults to `Theme.of(context).colorScheme.primary`. |
| `style` | `ThemedButtonStyle` | `.filledTonal` | Visual variant. See enum table below. |
| `isCooldown` | `bool` | `false` | Locks button after a tap for `cooldownDuration`. |
| `cooldownDuration` | `Duration` | `Duration(seconds: 5)` | How long the button stays locked after a tap when `isCooldown` is true. |
| `onCooldownFinish` | `VoidCallback?` | `null` | Called when the cooldown period ends. |
| `hintText` | `String?` | `null` | Additional tooltip hint shown alongside the label tooltip. |
| `width` | `double?` | `null` | Fixed width. When null the button sizes to its content. |
| `isDisabled` | `bool` | `false` | Disables interaction and applies `ThemedButton.getDisabledColor(isDark, style)`. |
| `tooltipPosition` | `ThemedTooltipPosition` | `.bottom` | Where the tooltip appears relative to the button. |
| `fontSize` | `double` | `14` | Label font size. Must be ≥ 0 and ≤ `height`. |
| `tooltipEnabled` | `bool` | `true` | Set to `false` to suppress the tooltip entirely (e.g. when label is already visible). |
| `showCooldownRemainingDuration` | `bool` | `true` | Shows a countdown overlay during cooldown. Set to `false` to hide the number. |
| `height` | `double` | `40` (`defaultHeight`) | Button height. Minimum 30. `iconSize` and `fontSize` must not exceed this. |
| `iconSize` | `double` | `22` | Icon size in logical pixels. Must be ≥ 0 and ≤ `height`. |
| `iconSeparatorSize` | `double` | `8` | Gap between icon and label. |
| `loadingBackgroundColor` | `Color?` | `null` | Spinner track color while `isLoading` is true. |
| `loadingForegroundColor` | `Color?` | `null` | Spinner indicator color while `isLoading` is true. |
| `customLongPressDuration` | `Duration` | `Duration(milliseconds: 500)` | How long to hold before `onLongPress` fires. |
| `onLongPress` | `VoidCallback?` | `null` | Long-press handler. Mutually exclusive with `onTap`. |

---

## Factory constructors

All six semantic factories share the same parameter shape:

```dart
factory ThemedButton.<name>({
  bool isMobile = false,
  required VoidCallback onTap,
  required String labelText,
  bool isLoading = false,
  bool isDisabled = false,
  bool isCooldown = false,
  VoidCallback? onCooldownFinish,
});
```

`isMobile: true` switches the style to the FAB variant (icon-only with tooltip), `false` renders the labelled variant.

| Factory | Icon | Color | Desktop style | Mobile style |
|---|---|---|---|---|
| `.save` | `solarOutlineInboxIn` | `Colors.green` | `.filledTonal` | `.filledTonalFab` |
| `.cancel` | `solarOutlineCloseSquare` | `Colors.red` | `.text` | `.fab` |
| `.info` | `solarOutlineInfoSquare` | `Colors.blue` | `.filledTonal` | `.filledTonalFab` |
| `.show` | `solarOutlineEyeScan` | `Colors.blue` | `.filledTonal` | `.filledTonalFab` |
| `.edit` | `solarOutlinePenNewSquare` | `Colors.orange` | `.filledTonal` | `.filledTonalFab` |
| `.delete` | `solarOutlineTrashBinMinimalistic2` | `Colors.red` | `.filledTonal` | `.filledTonalFab` |

> **Deprecated:** `ThemedButton.legacyLoading(...)` — do not use; prefer the primary constructor.

---

## `ThemedButtonStyle` enum

| Value | FAB counterpart | Description |
|---|---|---|
| `.elevated` | `.elevatedFab` | Raised surface with shadow; primary color tint. |
| `.filled` | `.filledFab` | Solid primary color background; contrast text via `validateColor(...)`. |
| `.filledTonal` | `.filledTonalFab` | Soft tonal background (secondary container); default style. |
| `.outlined` | `.outlinedFab` | Transparent background with 1 px primary-color border. |
| `.text` | `.fab` | No background or border; text/icon in primary color. |
| `.outlinedTonal` | `.outlinedTonalFab` | Transparent background with 1 px tonal border. |

FAB counterparts (right column) render **icon-only** and use `labelText` as the `ThemedTooltip` message.

---

## Static members

| Member | Signature | Notes |
|---|---|---|
| `defaultHeight` | `static const double defaultHeight = 40` | Used as the default for the `height` parameter. |
| `getDisabledColor` | `static Color getDisabledColor(bool isDark, ThemedButtonStyle style)` | Returns the appropriate grey shade for a disabled button based on dark mode and style. Used internally when `isDisabled: true`. |

---

## Companion widgets

The `buttons` barrel (`lib/src/buttons/buttons.dart`) also exports:

- **`ThemedActionsButtons`** — renders a row of actions on desktop and collapses to a single FAB with an overlay menu on mobile. Use this instead of a manual `Row` of `ThemedButton`s on list items.
- **`ThemedActionButton`** — data class (not a widget) used by `ThemedActionsButtons`; mirrors `ThemedButton`'s parameters plus dynamic `notifier`/builder callbacks.
- **`ThemedAnimatedCheckbox`** — animated checkbox widget; use for boolean toggles instead of a button.

---

## Behavior notes

- **Loading animation:** when `isLoading` flips to `true`, button content cross-fades to a `CircularProgressIndicator.adaptive`. The button width is preserved so the layout does not jump.
- **Cooldown countdown:** a `Stack` overlays the remaining seconds as text centred on the button surface while locked. Suppress with `showCooldownRemainingDuration: false`.
- **Tooltip for FAB variants:** `ThemedTooltip` wraps the icon with `message: labelText`. Setting `tooltipEnabled: false` removes the wrapper entirely.
- **Long-press timing:** `customLongPressDuration` is passed to a `GestureDetector`; the default 500 ms is the Material long-press threshold.
- **Disabled vs loading:** both suppress `onTap`; `isDisabled` persists until the flag is cleared, `isLoading` is expected to be reset when the async operation completes.
