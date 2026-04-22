# ThemedTextInput — API Reference

Source: `lib/src/inputs/src/general/text_input.dart`

- `ThemedTextInput` class — line 3
- `ThemedTextInput.outerPadding` static getter — line 184 → `EdgeInsets.all(10)`
- `ThemedComboboxPosition` enum — line 595

---

## Examples

```dart
// Basic form field
ThemedTextInput(
  labelText: context.i18n.t('entity.name'),
  value: name,
  errors: context.getErrors(key: 'name'),
  onChanged: (value) {
    name = value;
    if (context.mounted) onChanged.call();
  },
)

// Shared state — two inputs bound to the same variable
ThemedTextInput(
  labelText: 'Primary label',
  value: _text,
  onChanged: (value) => setState(() => _text = value),
)
ThemedTextInput(
  labelText: 'Secondary label (same state)',
  value: _text,
  onChanged: (value) => setState(() => _text = value),
)

// Prefix + suffix icons
ThemedTextInput(
  labelText: 'URL',
  prefixIcon: LayrzIcons.mdiAccessPoint,
  suffixIcon: LayrzIcons.mdiAccessPoint,
)

// Placeholder with custom text style and input formatter
ThemedTextInput(
  labelText: 'Formatted field',
  placeholder: 'Numbers only',
  textStyle: TextStyle(color: Colors.purple),
  inputFormatters: [
    TextInputFormatter.withFunction((oldValue, newValue) {
      final regex = RegExp(r'^\d+\,?\d*$');
      if (newValue.text.isEmpty) return newValue;
      if (regex.hasMatch(newValue.text)) return newValue;
      return oldValue;
    }),
  ],
)

// Validation errors
const ThemedTextInput(
  labelText: 'Field with errors',
  errors: ['Error 1', 'Error 2'],
)

// Combobox autocomplete
const ThemedTextInput(
  labelText: 'City',
  choices: ['Choice 1', 'Choice 2', 'Choice 3'],
  enableCombobox: true,
)

// Multiline textarea
ThemedTextInput(
  labelText: context.i18n.t('entity.description'),
  value: description,
  maxLines: 5,
  errors: context.getErrors(key: 'description'),
  onChanged: (value) {
    description = value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled (lock icon added automatically)
ThemedTextInput(
  labelText: context.i18n.t('entity.name'),
  value: name,
  disabled: true,
)

// Required field marker
ThemedTextInput(
  labelText: context.i18n.t('entity.name'),
  value: name,
  isRequired: true,
  onChanged: (value) {
    name = value;
    if (context.mounted) onChanged.call();
  },
)

// Copy-to-clipboard suffix
ThemedTextInput(
  labelText: context.i18n.t('entity.url'),
  value: url,
  prefixIcon: LayrzIcons.solarOutlineLink,
  suffixIcon: LayrzIcons.solarOutlineCopy,
  onSuffixTap: () => Clipboard.setData(ClipboardData(text: url)),
  errors: context.getErrors(key: 'url'),
  onChanged: (value) {
    url = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Constructor

```dart
const ThemedTextInput({
  super.key,
  this.keyboardType = .text,
  this.labelText,
  this.label,
  this.disabled = false,
  this.placeholder,
  this.prefixText,
  this.prefixIcon,
  this.prefixWidget,
  this.onPrefixTap,
  this.prefixIconDisabled = false,
  this.suffixIconDisabled = false,
  this.suffixIcon,
  this.suffixText,
  this.suffixWidget,
  this.onSuffixTap,
  this.onTap,
  this.obscureText = false,
  this.controller,
  this.onChanged,
  this.value,
  this.errors = const [],
  this.hideDetails = false,
  this.padding,
  this.dense = false,
  this.isRequired = false,
  this.focusNode,
  this.validator,
  this.onSubmitted,
  this.readonly = false,
  this.inputFormatters = const [],
  this.autofillHints = const [],
  this.borderRadius,
  this.maxLines = 1,
  this.autocorrect = true,
  this.enableSuggestions = true,
  this.autofocus = false,
  this.choices = const [],
  this.maxChoicesToDisplay = 5,
  this.enableCombobox = false,
  this.emptyChoicesText = "No choices",
  this.position = .below,
  this.textStyle,
})
```

Assert: `(label == null && labelText != null) || (label != null && labelText == null)`

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `keyboardType` | `TextInputType` | `.text` | Software keyboard layout |
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `disabled` | `bool` | `false` | Sets readOnly + appends lock icon suffix automatically |
| `placeholder` | `String?` | `null` | Hint text shown when empty |
| `prefixText` | `String?` | `null` | Inline text prefix inside the field |
| `prefixIcon` | `IconData?` | `null` | Mutually exclusive with `prefixWidget` |
| `prefixWidget` | `Widget?` | `null` | Mutually exclusive with `prefixIcon` |
| `onPrefixTap` | `VoidCallback?` | `null` | |
| `prefixIconDisabled` | `bool` | `false` | 0.4 opacity + ignores taps |
| `suffixIconDisabled` | `bool` | `false` | 0.4 opacity + ignores taps |
| `suffixIcon` | `IconData?` | `null` | Mutually exclusive with `suffixWidget` |
| `suffixText` | `String?` | `null` | Inline text suffix inside the field |
| `suffixWidget` | `Widget?` | `null` | Mutually exclusive with `suffixIcon` |
| `onSuffixTap` | `VoidCallback?` | `null` | |
| `onTap` | `VoidCallback?` | `null` | Overridden when `enableCombobox: true` |
| `obscureText` | `bool` | `false` | Use `ThemedPasswordInput` instead of setting this directly |
| `controller` | `TextEditingController?` | `null` | NOT disposed by widget |
| `onChanged` | `void Function(String)?` | `null` | Fires only when `validator` passes |
| `value` | `String?` | `null` | Synced to internal controller on `didUpdateWidget` |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints row entirely |
| `padding` | `EdgeInsets?` | `null` | Defaults to `EdgeInsets.all(10)`; read via `ThemedTextInput.outerPadding` |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `isRequired` | `bool` | `false` | Prepends `*` to the label |
| `focusNode` | `FocusNode?` | `null` | NOT disposed by widget |
| `validator` | `bool Function(String)?` | `null` | Gates `onChanged`; if provided, fires only when `true` |
| `onSubmitted` | `VoidCallback?` | `null` | Called on keyboard submit action |
| `readonly` | `bool` | `false` | Readonly without disabled styling |
| `inputFormatters` | `List<TextInputFormatter>` | `[]` | Applied to the underlying `TextField` |
| `autofillHints` | `List<String>` | `[]` | Browser/OS autofill hints |
| `borderRadius` | `double?` | `null` | Switches to `OutlineInputBorder` when set |
| `maxLines` | `int` | `1` | Values > 1 force `floatingLabelBehavior: always` |
| `autocorrect` | `bool` | `true` | |
| `enableSuggestions` | `bool` | `true` | |
| `autofocus` | `bool` | `false` | |
| `choices` | `List<String>` | `[]` | Combobox options; reactive via `StreamController.broadcast` |
| `maxChoicesToDisplay` | `int` | `5` | Max rows before scrolling in combobox |
| `enableCombobox` | `bool` | `false` | Opens `OverlayEntry` on tap instead of calling `onTap` |
| `emptyChoicesText` | `String` | `"No choices"` | Shown when `choices` is empty |
| `position` | `ThemedComboboxPosition` | `.below` | Combobox opens above or below the field |
| `textStyle` | `TextStyle?` | `null` | Overrides text style inside the field |

---

## ThemedComboboxPosition enum

| Value | Description |
|---|---|
| `.above` | Combobox opens above the field |
| `.below` | Combobox opens below the field (default) |

---

## Static API

| Member | Type | Value |
|---|---|---|
| `ThemedTextInput.outerPadding` | `EdgeInsets` | `EdgeInsets.all(10)` |
