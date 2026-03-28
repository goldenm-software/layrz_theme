---
name: text-inputs
description: Use ThemedTextInput, ThemedPasswordInput, or ThemedSearchInput in a layrz Flutter widget. Apply when adding a text field, password field, or search bar to any form or view.
---

## Overview

| Component | State type | `onChanged` signature | When to use |
|---|---|---|---|
| `ThemedTextInput` | `String` | `void Function(String)` | Any free-text form field; also foundation for combobox autocomplete |
| `ThemedPasswordInput` | `String` | `ValueChanged<String>` (`void Function(String)`) | Password creation or login fields; adds strength indicator and show/hide toggle |
| `ThemedSearchInput` | `String` | `OnSearch` (`void Function(String)`) | Search bars; compact icon button that expands into an overlay, or a full-width field |

Never use raw Flutter `TextField`, `TextFormField`, or `SearchBar` — always use these components.

---

## ThemedTextInput

### Minimal usage

```dart
// State
String name = '';

// Widget
ThemedTextInput(
  labelText: context.i18n.t('entity.name'),
  value: name,
  errors: context.getErrors(key: 'name'),
  onChanged: (value) {
    name = value;
    if (context.mounted) onChanged.call();
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided. Exactly one must be set — assert enforced. |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Exactly one must be set — assert enforced. |
| `value` | `String?` | `null` | Controlled value; widget syncs `TextEditingController` to this on `didUpdateWidget` |
| `onChanged` | `void Function(String)?` | `null` | Fires only when `validator` passes (defaults to always pass) |
| `controller` | `TextEditingController?` | `null` | External controller; if provided, the widget does NOT dispose it |
| `focusNode` | `FocusNode?` | `null` | External focus node; if provided, the widget does NOT dispose it |
| `disabled` | `bool` | `false` | Sets readOnly + disabled; automatically appends a lock icon as suffix |
| `readonly` | `bool` | `false` | Readonly without the disabled styling |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints area entirely |
| `isRequired` | `bool` | `false` | Prepends `*` to the label |
| `placeholder` | `String?` | `null` | Hint text shown when empty |
| `keyboardType` | `TextInputType` | `TextInputType.text` | Controls software keyboard layout |
| `obscureText` | `bool` | `false` | Hides input characters (use `ThemedPasswordInput` instead of setting this directly) |
| `maxLines` | `int` | `1` | Values > 1 switch to multiline mode and always show floating label |
| `dense` | `bool` | `false` | Reduces vertical padding |
| `padding` | `EdgeInsets?` | `EdgeInsets.all(10)` | Outer padding; use `ThemedTextInput.outerPadding` to read the static default |
| `prefixText` | `String?` | `null` | Inline text prefix inside the field (e.g. currency symbol) |
| `prefixIcon` | `IconData?` | `null` | Prefix icon. Mutually exclusive with `prefixWidget` — set only one per side. |
| `prefixWidget` | `Widget?` | `null` | Prefix widget. Mutually exclusive with `prefixIcon`. |
| `onPrefixTap` | `VoidCallback?` | `null` | Tap callback for the prefix area |
| `suffixIcon` | `IconData?` | `null` | Suffix icon. Mutually exclusive with `suffixWidget` — set only one per side. |
| `suffixText` | `String?` | `null` | Inline text suffix inside the field |
| `suffixWidget` | `Widget?` | `null` | Suffix widget. Mutually exclusive with `suffixIcon`. |
| `onSuffixTap` | `VoidCallback?` | `null` | Tap callback for the suffix area |
| `validator` | `bool Function(String)?` | `null` | If provided, `onChanged` only fires when this returns `true` |
| `onSubmitted` | `VoidCallback?` | `null` | Called when the user submits (keyboard action) |
| `onTap` | `VoidCallback?` | `null` | Called when the field is tapped |
| `inputFormatters` | `List<TextInputFormatter>` | `[]` | Applied to the underlying `TextField` |
| `autofillHints` | `List<String>` | `[]` | Browser/OS autofill hints |
| `autofocus` | `bool` | `false` | Requests focus on first build |
| `autocorrect` | `bool` | `true` | Enables autocorrect |
| `enableSuggestions` | `bool` | `true` | Enables keyboard suggestions |
| `borderRadius` | `double?` | `null` | Switches to `OutlineInputBorder` with this radius |
| `textStyle` | `TextStyle?` | `null` | Overrides the text style inside the field |
| `enableCombobox` | `bool` | `false` | Activates dropdown overlay with `choices` |
| `choices` | `List<String>` | `[]` | Options shown in the combobox overlay; reactive — updates via stream |
| `maxChoicesToDisplay` | `int` | `5` | Maximum rows visible in the combobox before scrolling |
| `emptyChoicesText` | `String` | `'No choices'` | Message when `choices` is empty |
| `position` | `ThemedComboboxPosition` | `.below` | Whether the combobox opens above or below the field |

### Behavior notes

- `label` and `labelText` are **mutually exclusive**. The constructor asserts this. Setting both causes an assertion error at runtime.
- `prefixIcon` and `prefixWidget` are **mutually exclusive per side**. Likewise, `suffixIcon` and `suffixWidget` are mutually exclusive. The widget renders both if you pass both — avoid it.
- When `disabled: true`, the widget automatically appends a lock icon (`LayrzIcons.solarOutlineLockKeyhole`) as a suffix. Do not add your own lock icon on top of this.
- `value` is synced to the internal `TextEditingController` in `didUpdateWidget`. Cursor position is preserved up to the current text length. This sync only fires when no external `controller` is provided.
- When `enableCombobox: true`, tapping the field opens an `OverlayEntry` instead of calling `onTap`. The overlay reacts to live `choices` changes via a `StreamController.broadcast`.
- `ThemedTextInput.outerPadding` is a static getter returning `EdgeInsets.all(10)`. Use it when you need to offset other widgets to match input alignment.
- `maxLines > 1` forces `floatingLabelBehavior: .always` — the label is always shown above the field.

### Common patterns

```dart
// Multiline text area
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

// Combobox autocomplete
ThemedTextInput(
  labelText: context.i18n.t('entity.city'),
  value: city,
  enableCombobox: true,
  choices: citySuggestions,
  errors: context.getErrors(key: 'city'),
  onChanged: (value) {
    city = value;
    if (context.mounted) onChanged.call();
    // trigger suggestion fetch externally
  },
)

// With prefix and suffix icons
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

## ThemedPasswordInput

### Minimal usage

```dart
// State
String password = '';

// Widget
ThemedPasswordInput(
  labelText: context.i18n.t('entity.password'),
  value: password,
  errors: context.getErrors(key: 'password'),
  onChanged: (value) {
    password = value;
    if (context.mounted) onChanged.call();
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided. Exactly one must be set — assert enforced. |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Exactly one must be set — assert enforced. |
| `value` | `String?` | `null` | Controlled value |
| `onChanged` | `ValueChanged<String>?` | `null` | Fires on every keystroke |
| `controller` | `TextEditingController?` | `null` | External controller; widget does NOT dispose it |
| `focusNode` | `FocusNode?` | `null` | External focus node; widget does NOT dispose it |
| `disabled` | `bool` | `false` | Disables the input |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors/hints area |
| `isRequired` | `bool` | `false` | Prepends `*` to the label |
| `placeholder` | `String?` | `null` | Hint text |
| `showLevels` | `bool` | `true` | Shows strength icon and requirement checklist tooltip next to the toggle |
| `autofillHints` | `List<String>` | `[AutofillHints.newPassword, AutofillHints.password]` | Adjust per context — use `newPassword` for creation, `password` for login |
| `padding` | `EdgeInsets?` | `null` | Falls through to `ThemedTextInput.outerPadding` |
| `borderRadius` | `double?` | `null` | Passed through to `ThemedTextInput` |
| `onSubmitted` | `VoidCallback?` | `null` | Called on keyboard submit |

### Strength calculation

Strength is derived exclusively from `value`. The widget computes:

1. **Requirements met** (0–4): lowercase letter, uppercase letter, digit, special character
2. **All requirements met** AND **value matches the allowed character set** → `_isValid = true`
3. **Level** (0–4, only when `_isValid`): `< 8` chars → 0, `< 12` → 1, `< 12` → 1, `< 16` → 2, `< 20` → 3, `≥ 20` → 4

Color output: level 0 → red, 1–2 → orange, 3–4 → green.

When `showLevels: true`, hovering the strength icon shows a tooltip checklist with pass/fail status for each requirement plus the current password length.

### Behavior notes

- `ThemedPasswordInput` is a thin wrapper around `ThemedTextInput`. It does not expose `prefixIcon`, `prefixWidget`, `suffixIcon`, or `suffixWidget` — the suffix area is reserved for the strength indicator and the show/hide toggle.
- `label` and `labelText` are **mutually exclusive**. Assert enforced with a descriptive message.
- The show/hide toggle always renders. Set `showLevels: false` to remove the strength indicator but keep the toggle.
- For login forms, set `autofillHints: const [AutofillHints.password]` (remove `newPassword`) so password managers match correctly.
- The allowed character regex is strict: only `A-Za-z0-9` and `!@#$%^&*()_-+=[]{};\:'",.<>/?` `` ` `` `~|\\`. Characters outside this set invalidate the password regardless of length.

### Common patterns

```dart
// Login form — disable strength indicator and use login autofill hint
ThemedPasswordInput(
  labelText: context.i18n.t('auth.password'),
  value: password,
  showLevels: false,
  autofillHints: const [AutofillHints.password],
  errors: context.getErrors(key: 'password'),
  onChanged: (value) {
    password = value;
    if (context.mounted) onChanged.call();
  },
)

// Password confirm field — no strength needed, no new-password hint
ThemedPasswordInput(
  labelText: context.i18n.t('auth.confirmPassword'),
  value: passwordConfirm,
  showLevels: false,
  autofillHints: const [],
  errors: context.getErrors(key: 'passwordConfirm'),
  onChanged: (value) {
    passwordConfirm = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## ThemedSearchInput

### Minimal usage — button mode (default)

```dart
// State
String searchQuery = '';

// Widget — renders a 40×40 icon button; tap expands overlay
ThemedSearchInput(
  value: searchQuery,
  labelText: context.i18n.t('general.search'),
  onSearch: (value) {
    searchQuery = value;
    if (context.mounted) setState(() {});
  },
)
```

### Minimal usage — field mode

```dart
// Widget — renders a full-width text field inline (no overlay)
ThemedSearchInput(
  value: searchQuery,
  labelText: context.i18n.t('general.search'),
  asField: true,
  maxWidth: 300,
  onSearch: (value) {
    searchQuery = value;
    if (context.mounted) setState(() {});
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `value` | `String` | **required** | Current search query; **non-nullable** |
| `onSearch` | `OnSearch` (`void Function(String)`) | **required** | Fired on change (debounced) and on keyboard submit |
| `labelText` | `String` | `'Search'` | Hint text inside the field. Not a form label — no i18n forced, but use `context.i18n.t(...)` in practice. |
| `maxWidth` | `double` | `300` | Max width of the expanded overlay or the field when `asField: true` |
| `asField` | `bool` | `false` | Renders a full-width inline field instead of the compact button |
| `inputPadding` | `EdgeInsets` | `EdgeInsets.zero` | Inner padding, only applied when `asField: true` |
| `disabled` | `bool` | `false` | Disables tapping the button; no effect in field mode |
| `position` | `ThemedSearchPosition` | `.left` | Overlay expansion direction: `.left` (expands leftward) or `.right` (expands rightward) |
| `debounce` | `Duration?` | `Duration(milliseconds: 300)` | Debounce delay; set to `null` to fire `onSearch` synchronously on every keystroke |
| `customChild` | `Widget?` | `null` | Replaces the default icon button with a custom widget; tap still opens the overlay |

### Behavior notes

- `ThemedSearchInput` does **not** have `errors`, `hideDetails`, `isRequired`, or `label`/`labelText` (as a form label) parameters. It is not a form field — do not pass validation state to it.
- In button mode, a 40×40 rounded icon button renders. Tapping it opens an `OverlayEntry` with a scale animation anchored to the button position. Pressing Escape or tapping outside closes it.
- In field mode (`asField: true`), the widget is a plain `SizedBox` with height 40 and width `maxWidth`. There is no overlay — the field is always visible.
- `value` is non-nullable (`String`, not `String?`). Always initialize state to `''` not `null`.
- The debounce timer is cancelled on each keystroke and reset. `onSearch` fires after the debounce expires OR immediately on keyboard submit (Enter key), which also closes the overlay in button mode.
- `position: .left` means the overlay expands to the left (use when the button is on the right side of a toolbar). `position: .right` expands to the right.
- `customChild` wraps its widget in an `InkWell` that triggers the same overlay logic as the default button.

### Common patterns

```dart
// Toolbar with search on the right edge — expands leftward
Row(
  children: [
    const Spacer(),
    ThemedSearchInput(
      value: query,
      labelText: context.i18n.t('general.search'),
      position: ThemedSearchPosition.left,
      onSearch: (value) {
        query = value;
        if (context.mounted) setState(() {});
      },
    ),
  ],
)

// Inline search field with no debounce
ThemedSearchInput(
  value: query,
  labelText: context.i18n.t('general.search'),
  asField: true,
  maxWidth: 400,
  debounce: null,
  onSearch: (value) {
    query = value;
    if (context.mounted) setState(() {});
  },
)

// Custom trigger widget
ThemedSearchInput(
  value: query,
  labelText: context.i18n.t('general.search'),
  customChild: ThemedButton(
    label: context.i18n.t('general.search'),
    icon: LayrzIcons.solarOutlineMagnifier,
    style: ThemedButtonStyle.outlined,
    onTap: () {},
  ),
  onSearch: (value) {
    query = value;
    if (context.mounted) setState(() {});
  },
)
```

---

## Integrating with layrz forms (onChanged + errors pattern)

```dart
// ThemedTextInput in a form
ThemedTextInput(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName,
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (value) {
    object.fieldName = value;
    if (context.mounted) onChanged.call();
  },
)

const SizedBox(height: 10),

// ThemedPasswordInput in the same form
ThemedPasswordInput(
  labelText: context.i18n.t('entity.password'),
  value: object.password,
  errors: context.getErrors(key: 'password'),
  onChanged: (value) {
    object.password = value;
    if (context.mounted) onChanged.call();
  },
)
```

Rules:
- Always guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Always use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Always pass `errors: context.getErrors(key: 'fieldName')` so server-side errors render.
- Separate stacked inputs with `const SizedBox(height: 10)`.
- `ThemedSearchInput` is NOT a form field. Do not pass `getErrors` or `isRequired` to it.

---

## Choosing between the three

| Situation | Use |
|---|---|
| Any free-text field in a form (name, email, URL, notes) | `ThemedTextInput` |
| Password creation or update | `ThemedPasswordInput` (with `showLevels: true`, default) |
| Password login | `ThemedPasswordInput` (with `showLevels: false`, `autofillHints: [AutofillHints.password]`) |
| Autocomplete / typeahead with a fixed string list | `ThemedTextInput` with `enableCombobox: true` and `choices` |
| Global or list search — minimal footprint in a toolbar | `ThemedSearchInput` (button mode, default) |
| Prominent search bar always visible | `ThemedSearchInput` with `asField: true` |
| Multiline textarea (notes, comments, description) | `ThemedTextInput` with `maxLines > 1` |

Decision questions:
1. Is this a password? → `ThemedPasswordInput`.
2. Is this a search (not tied to form validation)? → `ThemedSearchInput`.
3. Everything else → `ThemedTextInput`.
