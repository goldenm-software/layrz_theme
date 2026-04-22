# ThemedColorPicker — API Reference

Source: `lib/src/inputs/src/pickers/general/color.dart`

- `ThemedColorPicker` class — line 3

---

## Examples

```dart
// Standard field — wheel + palette
ThemedColorPicker(
  labelText: 'Color',
  value: color,
  errors: context.getErrors(key: 'color'),
  onChanged: (value) => setState(() => color = value),
)

// Wheel only
ThemedColorPicker(
  labelText: 'Color',
  value: color,
  enabledTypes: const [.wheel],
  onChanged: (value) => setState(() => color = value),
)

// Palette only (both + primary + accent + bw)
ThemedColorPicker(
  labelText: 'Color',
  value: color,
  enabledTypes: const [.both, .primary, .accent, .bw],
  onChanged: (value) => setState(() => color = value),
)

// Custom child trigger (colored box)
ThemedColorPicker(
  labelText: 'Color',
  value: color,
  customChild: Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  onChanged: (value) => setState(() => color = value),
)

// Localized button labels
ThemedColorPicker(
  labelText: 'Color',
  value: color,
  saveText: context.i18n.t('actions.save'),
  cancelText: context.i18n.t('actions.cancel'),
  onChanged: (value) => setState(() => color = value),
)

// Disabled
ThemedColorPicker(
  labelText: 'Color',
  value: color,
  disabled: true,
)

// Wider dialog
ThemedColorPicker(
  labelText: 'Color',
  value: color,
  maxWidth: 600,
  onChanged: (value) => setState(() => color = value),
)
```

---

## Constructor

```dart
const ThemedColorPicker({
  super.key,
  this.labelText,
  this.label,
  this.disabled = false,
  this.onChanged,
  this.value,
  this.errors = const [],
  this.hideDetails = false,
  this.padding,
  this.dense = false,
  this.onPrefixTap,
  this.placeholder,
  this.saveText = "OK",
  this.cancelText = "Cancel",
  this.enabledTypes = const [.both, .wheel],
  this.customChild,
  this.hoverColor = Colors.transparent,
  this.focusColor = Colors.transparent,
  this.splashColor = Colors.transparent,
  this.highlightColor = Colors.transparent,
  this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  this.maxWidth = 400,
}) : assert((label == null) != (labelText == null));
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `disabled` | `bool` | `false` | Prevents opening the picker |
| `onChanged` | `void Function(Color)?` | `null` | Fires with the selected `Color` |
| `value` | `Color?` | `null` | Falls back to `kPrimaryColor` when null |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `padding` | `EdgeInsets?` | `null` | Defaults to `ThemedTextInput.outerPadding` (`EdgeInsets.all(10)`) |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `onPrefixTap` | `VoidCallback?` | `null` | Tap handler for the color swatch prefix |
| `placeholder` | `String?` | `null` | Hint text shown in the text field |
| `saveText` | `String` | `"OK"` | Label for the save button in the picker dialog |
| `cancelText` | `String` | `"Cancel"` | Label for the cancel button in the picker dialog |
| `enabledTypes` | `List<ColorPickerType>` | `[.both, .wheel]` | Which picker tabs are enabled |
| `customChild` | `Widget?` | `null` | Custom trigger widget; wraps in `InkWell` that opens the dialog |
| `hoverColor` | `Color` | `Colors.transparent` | Hover color for `customChild` `InkWell` |
| `focusColor` | `Color` | `Colors.transparent` | Focus color for `customChild` `InkWell` |
| `splashColor` | `Color` | `Colors.transparent` | Splash color for `customChild` `InkWell` |
| `highlightColor` | `Color` | `Colors.transparent` | Highlight color for `customChild` `InkWell` |
| `borderRadius` | `BorderRadius` | `BorderRadius.all(Radius.circular(10))` | Border radius for `customChild` `InkWell` |
| `maxWidth` | `double` | `400` | Max width of the picker dialog |

---

## ColorPickerType enum (from `flex_color_picker` package)

| Value | Description |
|---|---|
| `.both` | Both primary and accent color palette |
| `.primary` | Primary color palette only |
| `.accent` | Accent color palette only |
| `.bw` | Black and white palette |
| `.custom` | Custom color palette |
| `.wheel` | HSV color wheel |
