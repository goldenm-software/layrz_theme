# ThemedDynamicCredentialsInput — API Reference

Source: `lib/src/inputs/src/general/dynamic_credentials_input.dart`

- `ThemedDynamicCredentialsInput` class

---

## Examples

```dart
// Editing mode
ThemedDynamicCredentialsInput(
  value: entity.credentials,
  fields: protocol.credentialFields,
  translatePrefix: 'inboundProtocols.myProtocol',
  isEditing: true,
  errors: store.errors,
  onChanged: (creds) => setState(() => entity.credentials = creds),
)

// Read-only view
ThemedDynamicCredentialsInput(
  value: entity.credentials,
  fields: protocol.credentialFields,
  translatePrefix: 'inboundProtocols.myProtocol',
  isEditing: false,
  errors: const {},
)

// With Wialon OAuth action
ThemedDynamicCredentialsInput(
  value: entity.credentials,
  fields: protocol.credentialFields,
  translatePrefix: 'inboundProtocols.wialon',
  isEditing: true,
  errors: store.errors,
  actionCallback: (action) async {
    if (action == CredentialFieldAction.wialonOAuth) {
      await _launchWialonOAuth();
    }
  },
  onChanged: (creds) => setState(() => entity.credentials = creds),
)
```

---

## Constructor

```dart
ThemedDynamicCredentialsInput({
  super.key,
  required this.value,
  required this.fields,
  this.onChanged,
  this.errors = const {},
  this.translatePrefix = '',
  this.isEditing = true,
  this.layrzGeneratedToken,
  this.nested,
  this.actionCallback,
  this.isLoading = false,
});
```

---

## Properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `value` | `Map<String, dynamic>` | required | Current credentials map; keys are `CredentialField.field` values |
| `fields` | `List<CredentialField>` | required | Schema that drives which inputs are rendered |
| `onChanged` | `void Function(Map<String, dynamic>)?` | `null` | Fires with full updated credentials map on any field change |
| `errors` | `Map<String, dynamic>` | `{}` | Error map (NOT `List<String>`) — mirrors Layrz API error structure |
| `translatePrefix` | `String` | `''` | i18n prefix; field labels resolved as `'$translatePrefix.${field.field}.title'` |
| `isEditing` | `bool` | `true` | `false` = all inputs disabled (read-only) |
| `layrzGeneratedToken` | `String?` | `null` | Shown in read-only field for `layrzApiToken` type fields; has copy button when set |
| `nested` | `String?` | `null` | Parent field name when rendered recursively for `nestedField` type |
| `actionCallback` | `void Function(CredentialFieldAction)?` | `null` | Called for special-action fields (e.g. Wialon OAuth) |
| `isLoading` | `bool` | `false` | Shows lock icon on action fields instead of refresh icon |

---

## CredentialField structure (from `layrz_models`)

```dart
class CredentialField {
  final String field;                       // map key in credentials
  final CredentialFieldType type;           // drives which input is rendered
  final List<String>? choices;             // required when type == choices
  final List<CredentialField>? requiredFields; // required when type == nestedField
  final String? onlyField;                 // conditional: show when credentials[onlyField] in onlyChoices
  final List<dynamic>? onlyChoices;        // values that make this field visible
}
```

---

## CredentialFieldType — input mapping

| Value | Rendered as | Notes |
|---|---|---|
| `string` | `ThemedTextInput` | Plain text |
| `soapUrl` | `ThemedTextInput` | URL for SOAP endpoints |
| `restUrl` | `ThemedTextInput` | URL for REST endpoints |
| `ftp` | `ThemedTextInput` | FTP address |
| `dir` | `ThemedTextInput` | Directory path |
| `integer` | `ThemedNumberInput` | Stored as `int` |
| `float` | `ThemedNumberInput` | Stored as `double` |
| `choices` | `ThemedSelectInput<String>` | Requires `field.choices`; labels from `'$translatePrefix.${field.field}.$choice'` |
| `layrzApiToken` | Read-only `ThemedTextInput` | Shows `layrzGeneratedToken`; copy-to-clipboard suffix |
| `nestedField` | Recursive `ThemedDynamicCredentialsInput` | Requires `field.requiredFields`; passes `nested: field.field` |
| `wialonToken` | Read-only `ThemedTextInput` with action suffix | Calls `actionCallback(CredentialFieldAction.wialonOAuth)` on tap |

---

## Error map wiring

`errors` is `Map<String, dynamic>` — pass the full API error map. `context.getErrors` is called internally per field with:
- Flat field: key = `'credentials.${field.field}'`
- Nested field: key = `'credentials.${widget.nested}.${field.field}'`

---

## Conditional field visibility

Fields with `onlyField` + `onlyChoices` are shown only when `credentials[field.onlyField]` is in `field.onlyChoices`. Evaluated on every build.
