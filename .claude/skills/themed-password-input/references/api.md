# ThemedPasswordInput — API Reference

Source: `lib/src/inputs/src/general/password_input.dart`

- `ThemedPasswordInput` class — line 3

Thin wrapper over `ThemedTextInput`. Does not expose prefix/suffix — that area is reserved for the strength indicator and show/hide toggle.

---

## Examples

```dart
// Password creation (default — strength indicator shown)
String _password = 'Abc123!@#';

ThemedPasswordInput(
  labelText: 'Password field',
  value: _password,
  onChanged: (value) => setState(() => _password = value),
)

// Login — no strength indicator, correct autofill hint
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

// Confirm field — no strength, no autofill
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

// Required password field in a form
ThemedPasswordInput(
  labelText: context.i18n.t('entity.password'),
  value: object.password,
  isRequired: true,
  errors: context.getErrors(key: 'password'),
  onChanged: (value) {
    object.password = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Constructor

```dart
const ThemedPasswordInput({
  super.key,
  this.labelText,
  this.label,
  this.placeholder,
  this.disabled = false,
  this.onChanged,
  this.value,
  this.errors = const [],
  this.hideDetails = false,
  this.padding,
  this.isRequired = false,
  this.onSubmitted,
  this.borderRadius,
  this.focusNode,
  this.controller,
  this.showLevels = true,
  this.autofillHints = const [AutofillHints.newPassword, AutofillHints.password],
})
```

Assert: `(label == null && labelText != null) || (label != null && labelText == null)`  
Message: `'You must provide either a labelText or a label, but not both.'`

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Mutually exclusive with `label` |
| `label` | `Widget?` | — | Mutually exclusive with `labelText` |
| `placeholder` | `String?` | `null` | Hint text |
| `disabled` | `bool` | `false` | |
| `onChanged` | `ValueChanged<String>?` | `null` | `void Function(String)?` — fires on every keystroke |
| `value` | `String?` | `null` | Controlled value |
| `errors` | `List<String>` | `[]` | Validation messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides errors/hints row |
| `padding` | `EdgeInsets?` | `null` | Falls through to `ThemedTextInput.outerPadding` (`EdgeInsets.all(10)`) |
| `isRequired` | `bool` | `false` | Prepends `*` to the label |
| `onSubmitted` | `VoidCallback?` | `null` | Called on keyboard submit |
| `borderRadius` | `double?` | `null` | Passed through to `ThemedTextInput` |
| `focusNode` | `FocusNode?` | `null` | NOT disposed by widget |
| `controller` | `TextEditingController?` | `null` | NOT disposed by widget |
| `showLevels` | `bool` | `true` | Shows strength icon + tooltip checklist next to toggle |
| `autofillHints` | `List<String>` | `[AutofillHints.newPassword, AutofillHints.password]` | Adjust per context |

---

## Strength calculation

Computed from `value`. Requirements: lowercase, uppercase, digit, special character.  
All 4 requirements met + valid charset → `_isValid = true`.

Levels (only when `_isValid`):

| Length | Level | Color |
|---|---|---|
| `< 8` | 0 | red |
| `< 12` | 1 | orange |
| `< 16` | 2 | orange |
| `< 20` | 3 | green |
| `≥ 20` | 4 | green |

Allowed charset: `A-Za-z0-9` and `!@#$%^&*()_-+=[]{};\:'",.<>/?` `` ` `` `~|\\`.  
Characters outside this set invalidate the password regardless of length.
