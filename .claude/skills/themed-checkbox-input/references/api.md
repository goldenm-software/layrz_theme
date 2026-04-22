# ThemedCheckboxInput — API Reference

Source: `lib/src/inputs/src/general/checkbox_input.dart`

- `ThemedCheckboxInput` class — line 22
- `ThemedCheckboxInputStyle` enum — line 3

---

## Examples

```dart
// Default checkbox
ThemedCheckboxInput(
  labelText: 'Active',
  value: isActive,
  onChanged: (value) => setState(() => isActive = value),
)

// Switch style
ThemedCheckboxInput(
  labelText: 'Notifications',
  value: notificationsEnabled,
  style: .asSwitch,
  onChanged: (value) => setState(() => notificationsEnabled = value),
)

// New design checkbox
ThemedCheckboxInput(
  labelText: 'Accept terms',
  value: acceptTerms,
  style: .asCheckbox2,
  onChanged: (value) => setState(() => acceptTerms = value),
)

// Dropdown field (Yes/No picker)
ThemedCheckboxInput(
  labelText: 'Is public',
  value: isPublic,
  style: .asField,
  errors: context.getErrors(key: 'isPublic'),
  onChanged: (value) => setState(() => isPublic = value),
)

// Disabled
ThemedCheckboxInput(
  labelText: 'Is verified',
  value: isVerified,
  disabled: true,
)

// With validation errors
ThemedCheckboxInput(
  labelText: 'Accept terms',
  value: acceptTerms,
  errors: ['You must accept the terms'],
  onChanged: (value) => setState(() => acceptTerms = value),
)
```

---

## Constructor

```dart
const ThemedCheckboxInput({
  super.key,
  this.labelText,
  this.label,
  this.disabled = false,
  this.onChanged,
  this.value = false,
  this.errors = const [],
  this.hideDetails = false,
  this.padding = const EdgeInsets.all(10),
  this.dense = false,
  this.style = .asFlutterCheckbox,
}) : assert(label == null || labelText == null);
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `disabled` | `bool` | `false` | Prevents toggling; no visual disabled state on the label |
| `onChanged` | `void Function(bool)?` | `null` | Fires with new bool value |
| `value` | `bool` | `false` | Synced to internal state on `didUpdateWidget` |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `padding` | `EdgeInsets` | `EdgeInsets.all(10)` | Outer padding around the whole widget |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `style` | `ThemedCheckboxInputStyle` | `.asFlutterCheckbox` | Visual rendering style |

---

## ThemedCheckboxInputStyle enum

| Value | Description |
|---|---|
| `.asFlutterCheckbox` | Standard Flutter `Checkbox` widget (default) |
| `.asCheckbox2` | Custom `ThemedAnimatedCheckbox` — newer design |
| `.asSwitch` | Material `Switch` with label to the right |
| `.asField` | Delegates to `ThemedSelectInput<bool>` with Yes/No dropdown |
