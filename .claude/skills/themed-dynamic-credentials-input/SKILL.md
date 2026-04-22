---
name: themed-dynamic-credentials-input
description: Use ThemedDynamicCredentialsInput in a layrz Flutter widget. Apply when rendering a schema-driven credentials form for Layrz API protocol entities (InboundProtocol, OutboundProtocol, etc.).
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Rendering a credentials form driven by `List<CredentialField>` from a protocol entity
- Value type: `Map<String, dynamic>`

This widget is NOT a single-field picker — it renders an entire `ResponsiveRow` of inputs. It has NO `labelText` / `label` parameter.

---

## Minimal usage

```dart
ThemedDynamicCredentialsInput(
  value: credentials,
  fields: protocol.credentialFields,
  translatePrefix: 'inboundProtocols.myProtocol',
  isEditing: isEditing,
  errors: store.errors,
  onChanged: (creds) {
    credentials = creds;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Renders a `ResponsiveRow` of inputs, one per `CredentialField` in `fields`.
- Each field type maps to a specific input widget (see `references/api.md`).
- `translatePrefix` + field name compose the i18n key: `'$translatePrefix.${field.field}.title'`.
- `errors` is `Map<String, dynamic>` (not `List<String>`) — mirrors the Layrz API error structure.
- `isEditing: false` disables all inputs (read-only view).
- Fields with `onlyField` + `onlyChoices` are conditionally shown based on current credentials values.
- `nestedField` type renders a recursive `ThemedDynamicCredentialsInput` for sub-schemas.
- No `labelText` or `label` — this widget produces its own field labels from the schema.

---

## Common patterns

```dart
// Standard credentials form (editing)
ThemedDynamicCredentialsInput(
  value: entity.credentials,
  fields: selectedProtocol.credentialFields,
  translatePrefix: 'inboundProtocols.${selectedProtocol.identifier}',
  isEditing: isEditing,
  layrzGeneratedToken: entity.layrzToken,
  errors: store.errors,
  actionCallback: (action) async {
    if (action == CredentialFieldAction.wialonOAuth) {
      await _launchWialonOAuth();
    }
  },
  onChanged: (creds) {
    entity.credentials = creds;
    if (context.mounted) onChanged.call();
  },
)

// Read-only / detail view
ThemedDynamicCredentialsInput(
  value: entity.credentials,
  fields: protocol.credentialFields,
  translatePrefix: 'inboundProtocols.${protocol.identifier}',
  isEditing: false,
  errors: const {},
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Pass the full API error map to `errors` — `context.getErrors` is called internally per field.
- Error key paths: flat field → `credentials.{field}`, nested → `credentials.{parent}.{field}`.
