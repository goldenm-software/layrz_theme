# ThemedRadioInput — API Reference

Source: `lib/src/inputs/src/general/radio_input.dart`

- `ThemedRadioInput<T>` class — line 3

---

## Examples

```dart
// Basic string options
ThemedRadioInput<String>(
  labelText: 'Role',
  value: selectedRole,
  items: [
    ThemedSelectItem(value: 'admin', label: 'Admin'),
    ThemedSelectItem(value: 'user', label: 'User'),
    ThemedSelectItem(value: 'viewer', label: 'Viewer'),
  ],
  onChanged: (value) => setState(() => selectedRole = value),
)

// Integer values, two columns on all screens
ThemedRadioInput<int>(
  labelText: 'Priority',
  value: priority,
  xsSize: .col6,
  smSize: .col6,
  mdSize: .col6,
  lgSize: .col6,
  xlSize: .col6,
  items: [
    ThemedSelectItem(value: 1, label: 'Low'),
    ThemedSelectItem(value: 2, label: 'Medium'),
    ThemedSelectItem(value: 3, label: 'High'),
  ],
  onChanged: (value) => setState(() => priority = value),
)

// Full width (one per row)
ThemedRadioInput<String>(
  labelText: 'Status',
  value: status,
  xsSize: .col12,
  smSize: .col12,
  mdSize: .col12,
  lgSize: .col12,
  xlSize: .col12,
  items: [
    ThemedSelectItem(value: 'active', label: 'Active'),
    ThemedSelectItem(value: 'inactive', label: 'Inactive'),
  ],
  onChanged: (value) => setState(() => status = value),
)

// Disabled
ThemedRadioInput<String>(
  labelText: 'Type',
  value: type,
  disabled: true,
  items: [
    ThemedSelectItem(value: 'a', label: 'Type A'),
    ThemedSelectItem(value: 'b', label: 'Type B'),
  ],
  onChanged: (value) => setState(() => type = value),
)

// No selection initially
ThemedRadioInput<String>(
  labelText: 'Color',
  value: null,
  items: [
    ThemedSelectItem(value: 'red', label: 'Red'),
    ThemedSelectItem(value: 'blue', label: 'Blue'),
    ThemedSelectItem(value: 'green', label: 'Green'),
  ],
  onChanged: (value) => setState(() => color = value),
)

// With errors
ThemedRadioInput<String>(
  labelText: 'Plan',
  value: selectedPlan,
  errors: context.getErrors(key: 'plan'),
  items: [
    ThemedSelectItem(value: 'basic', label: 'Basic'),
    ThemedSelectItem(value: 'pro', label: 'Pro'),
  ],
  onChanged: (value) => setState(() => selectedPlan = value),
)
```

---

## Constructor

```dart
const ThemedRadioInput({
  super.key,
  this.labelText,
  this.label,
  this.onChanged,
  this.disabled = false,
  this.value,
  required this.items,
  this.errors = const [],
  this.hideDetails = false,
  this.padding = const EdgeInsets.all(10),
  this.xsSize = .col12,
  this.smSize = .col6,
  this.mdSize = .col4,
  this.lgSize = .col3,
  this.xlSize = .col2,
}) : assert(label == null || labelText == null);
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `onChanged` | `void Function(T?)?` | `null` | Fires with selected value |
| `disabled` | `bool` | `false` | Silently ignores `onChanged`; no visual change on options |
| `value` | `T?` | `null` | Currently selected value; `null` = no selection |
| `items` | `List<ThemedSelectItem<T>>` | required | Options to render as radio buttons |
| `errors` | `List<String>` | `[]` | Validation messages shown below the group |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `padding` | `EdgeInsets` | `EdgeInsets.all(10)` | Outer padding around the widget |
| `xsSize` | `Sizes` | `.col12` | Column width on extra-small screens (< 600px) |
| `smSize` | `Sizes?` | `.col6` | Column width on small screens (600–959px) |
| `mdSize` | `Sizes?` | `.col4` | Column width on medium screens (960–1263px) |
| `lgSize` | `Sizes?` | `.col3` | Column width on large screens (1264–1903px) |
| `xlSize` | `Sizes?` | `.col2` | Column width on extra-large screens (≥ 1904px) |

---

## ThemedSelectItem<T>

Used in `items`. Defined in the select inputs module.

```dart
ThemedSelectItem<T>({
  required T value,
  required String label,
})
```

---

## Breakpoint constants

| Constant | Value | Applies when width is |
|---|---|---|
| `kExtraSmallGrid` | 600 | < 600 → xs |
| `kSmallGrid` | 960 | 600–959 → sm |
| `kMediumGrid` | 1264 | 960–1263 → md |
| `kLargeGrid` | 1904 | 1264–1903 → lg |
| — | — | ≥ 1904 → xl |

Fallback chain: `xl ?? lg ?? md ?? sm ?? xs`
