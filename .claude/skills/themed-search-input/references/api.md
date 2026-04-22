# ThemedSearchInput — API Reference

Source: `lib/src/inputs/src/general/search_input.dart`

- `ThemedSearchInput` class — line 5
- `ThemedSearchPosition` enum — line 318

---

## Examples

```dart
// Button mode — toolbar right edge, expands leftward
String _query = '';

Row(
  children: [
    const Spacer(),
    ThemedSearchInput(
      value: _query,
      labelText: 'Search',
      position: .left,
      onSearch: (value) => setState(() => _query = value),
    ),
  ],
)

// Field mode — always visible inline search bar
ThemedSearchInput(
  value: _query,
  labelText: 'Search',
  asField: true,
  maxWidth: 300,
  onSearch: (value) => setState(() => _query = value),
)

// Wider field mode, no debounce (synchronous)
ThemedSearchInput(
  value: _query,
  labelText: 'Search',
  asField: true,
  maxWidth: 400,
  debounce: null,
  onSearch: (value) => setState(() => _query = value),
)

// Button mode expanding rightward (button on the left edge)
ThemedSearchInput(
  value: _query,
  labelText: 'Search',
  position: .right,
  onSearch: (value) => setState(() => _query = value),
)

// Custom trigger widget replacing the default icon button
ThemedSearchInput(
  value: _query,
  labelText: 'Search',
  customChild: ThemedButton(
    label: 'Search',
    icon: LayrzIcons.solarOutlineMagnifier,
    style: ThemedButtonStyle.outlined,
    onTap: () {},
  ),
  onSearch: (value) => setState(() => _query = value),
)

// Disabled search button
ThemedSearchInput(
  value: _query,
  labelText: 'Search',
  disabled: true,
  onSearch: (value) => setState(() => _query = value),
)
```

---

## Constructor

```dart
const ThemedSearchInput({
  super.key,
  required this.value,
  required this.onSearch,
  this.maxWidth = 300,
  this.labelText = 'Search',
  this.customChild,
  this.disabled = false,
  this.position = .left,
  this.asField = false,
  this.inputPadding = EdgeInsets.zero,
  this.debounce = const Duration(milliseconds: 300),
})
```

Not a form widget — no `label`, `errors`, `hideDetails`, or `isRequired`.

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `String` | required | Non-nullable — init state to `''`, never `null` |
| `onSearch` | `OnSearch` (`void Function(String)`) | required | Fires after debounce or immediately on Enter |
| `maxWidth` | `double` | `300` | Max width of overlay (button mode) or field (field mode) |
| `labelText` | `String` | `'Search'` | Hint text inside the field — not a form label |
| `customChild` | `Widget?` | `null` | Replaces the default icon button; tap still opens overlay |
| `disabled` | `bool` | `false` | Disables tapping in button mode; no effect in field mode |
| `position` | `ThemedSearchPosition` | `.left` | Overlay expansion direction |
| `asField` | `bool` | `false` | Renders full-width inline field instead of compact button |
| `inputPadding` | `EdgeInsets` | `EdgeInsets.zero` | Inner padding — only applies when `asField: true` |
| `debounce` | `Duration?` | `Duration(milliseconds: 300)` | `null` = fire synchronously on every keystroke |

---

## ThemedSearchPosition enum

| Value | Description |
|---|---|
| `.left` | Overlay expands leftward (use when button is on the right edge) |
| `.right` | Overlay expands rightward (use when button is on the left edge) |
