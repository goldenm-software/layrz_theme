---
name: color-picker
description: Use ThemedColorPicker in a layrz Flutter widget. Apply when adding a color selection field.
---

## Overview

`ThemedColorPicker` is the only color input in layrz_theme. It renders as a `ThemedTextInput` with a color swatch prefix and opens a dialog powered by `flex_color_picker`.

---

## Minimal usage

```dart
// State
Color? selectedColor;

// Widget
ThemedColorPicker(
  labelText: context.i18n.t('entity.color'),
  value: selectedColor,
  onChanged: (color) {
    if (context.mounted) setState(() => selectedColor = color);
  },
)
```

---

## Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided. Exactly one must be set. |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Exactly one must be set. |
| `value` | `Color?` | `null` | Currently selected color. Falls back to `kPrimaryColor` when null. |
| `onChanged` | `void Function(Color)?` | `null` | Called with the picked color; never null inside the callback. |
| `disabled` | `bool` | `false` | Disables the input and prevents the dialog from opening. |
| `errors` | `List<String>` | `[]` | Validation error messages shown below the field. |
| `hideDetails` | `bool` | `false` | Hides the errors / hints row. |
| `padding` | `EdgeInsets?` | `null` | Outer padding — defaults to `ThemedTextInput.outerPadding`. |
| `dense` | `bool` | `false` | Reduces the field height. |
| `placeholder` | `String?` | `null` | Hint text shown in the text field. |
| `saveText` | `String` | `'OK'` | Label for the confirm button in the dialog. |
| `cancelText` | `String` | `'Cancel'` | Label for the cancel button in the dialog. |
| `enabledTypes` | `List<ColorPickerType>` | `[.both, .wheel]` | Color picker tabs shown in the dialog. Must not be empty. |
| `customChild` | `Widget?` | `null` | Replaces the text field; the entire widget becomes tappable. |
| `hoverColor` | `Color` | `transparent` | Only used when `customChild` is set. |
| `focusColor` | `Color` | `transparent` | Only used when `customChild` is set. |
| `splashColor` | `Color` | `transparent` | Only used when `customChild` is set. |
| `highlightColor` | `Color` | `transparent` | Only used when `customChild` is set. |
| `borderRadius` | `BorderRadius` | `circular(10)` | Only used when `customChild` is set. |
| `maxWidth` | `double` | `400` | Max width of the color picker dialog. |
| `onPrefixTap` | `VoidCallback?` | `null` | Called when the color swatch prefix is tapped. |

---

## Behavior notes

- The field is always `readonly: true` — users cannot type colors directly.
- The text field displays the hex value with `#` prefix (e.g. `#FF5252`).
- The prefix is always a small color swatch showing the current color — it cannot be replaced with an icon.
- The suffix icon is always `LayrzIcons.solarOutlinePalette2`; it cannot be overridden.
- Cancelling the dialog (Cancel button or back gesture) leaves the current value unchanged.
- `enabledTypes` must not be empty — passing `[]` produces a broken dialog with no pickers.
- When `value` changes externally (parent rebuild), the field and swatch update automatically via `didUpdateWidget`.

---

## ColorPickerType values

| Value | Description |
|---|---|
| `.both` | Both primary and accent material swatches |
| `.primary` | Primary material swatches only |
| `.accent` | Accent material swatches only |
| `.bw` | Black & white shades |
| `.custom` | Custom color swatches (requires additional config) |
| `.wheel` | HSV color wheel |

Default is `[.both, .wheel]` — the most common setup.

---

## Common patterns

```dart
// With validation errors
ThemedColorPicker(
  labelText: context.i18n.t('entity.color'),
  value: entity.color,
  errors: context.getErrors(key: 'color'),
  onChanged: (color) {
    if (context.mounted) setState(() => entity.color = color);
  },
)

// Wheel only (no material swatches)
ThemedColorPicker(
  labelText: context.i18n.t('entity.color'),
  value: entity.color,
  enabledTypes: const [ColorPickerType.wheel],
  onChanged: (color) {
    if (context.mounted) setState(() => entity.color = color);
  },
)

// Custom child (e.g. an avatar that opens the picker on tap)
ThemedColorPicker(
  labelText: context.i18n.t('entity.color'),
  value: entity.color,
  customChild: CircleAvatar(backgroundColor: entity.color, radius: 20),
  onChanged: (color) {
    if (context.mounted) setState(() => entity.color = color);
  },
)

// Localized button labels
ThemedColorPicker(
  labelText: context.i18n.t('entity.color'),
  value: entity.color,
  saveText: context.i18n.t('actions.save'),
  cancelText: context.i18n.t('actions.cancel'),
  onChanged: (color) {
    if (context.mounted) setState(() => entity.color = color);
  },
)
```

---

## Integrating with layrz forms

```dart
ThemedColorPicker(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName,
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (color) {
    object.fieldName = color;
    if (context.mounted) onChanged.call();
  },
)
```

Always guard `onChanged` with `if (context.mounted)` — the dialog is async and the widget may have been unmounted by the time it resolves.

---

## Working with Color values

```dart
// Color → hex string (with #)
final hex = color.hex;           // '#FF5252'
final hexAlpha = color.hexWithAlpha; // '#FFFF5252'

// Hex string → Color
final color = ThemedColorExtensions.fromHex('#FF5252');
final colorAlpha = ThemedColorExtensions.fromHexWithAlpha('#FFFF5252');

// Color → JSON (same as hex)
final json = color.toJson();     // '#FF5252'
final color = ThemedColorExtensions.fromJson('#FF5252');
```

---

## What NOT to use

- Never use raw Flutter `showColorPicker` or any third-party color picker directly.
- Never pass `enabledTypes: const []` — the picker will show an empty dialog.
