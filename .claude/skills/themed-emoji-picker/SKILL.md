---
name: themed-emoji-picker
description: Use ThemedEmojiPicker in a layrz Flutter widget. Apply when adding a field that lets the user pick a single Unicode emoji from all groups or a filtered subset.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Single emoji selection; value stored as a raw emoji character string (e.g. `"😀"`)
- Value type: `String?`

For icon selection → use `ThemedIconPicker`. For a flexible avatar (icon/emoji/url/base64) → use `ThemedDynamicAvatarInput`.

---

## Minimal usage

```dart
ThemedEmojiPicker(
  labelText: context.i18n.t('entity.emoji'),
  value: selectedEmoji,
  errors: context.getErrors(key: 'emoji'),
  onChanged: (emoji) {
    selectedEmoji = emoji;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Opens a 500×700 dialog with a group filter row and a scrollable emoji grid.
- Groups appear as a horizontal scrollable chip row; tapping a group filters the grid.
- Search filters by `emoji.shortName.contains(query)` — case-sensitive.
- Tapping an emoji closes the dialog immediately — no explicit Save step.
- `enabledGroups` restricts which groups are shown; empty = all groups.
- `value` is a raw emoji character, not a code point or short name.
- Use `Emoji.byChar(value)` from the `emojis` package if you need metadata.
- `customChild` wraps any widget in an `InkWell` that opens the picker.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// Restrict to specific groups
ThemedEmojiPicker(
  labelText: context.i18n.t('entity.emoji'),
  value: selectedEmoji,
  enabledGroups: [EmojiGroup.animalsAndNature, EmojiGroup.foodAndDrink],
  onChanged: (emoji) {
    selectedEmoji = emoji;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedEmojiPicker(
  labelText: context.i18n.t('entity.emoji'),
  value: selectedEmoji,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
