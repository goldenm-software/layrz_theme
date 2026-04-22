---
name: themed-alert
description: Use ThemedAlert in a layrz Flutter widget. Apply when rendering an inline status callout — info/success/warning/danger/context/custom severities with five visual styles (.layrz, .filledTonal, .filled, .outlined, .filledIcon).
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.info`, `.danger`, `.filledTonal`, `.filledIcon`) — never write the fully-qualified form (`ThemedAlertType.info`).

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Inline status messaging: form-level validation summaries, page-level banners, dialog body callouts, empty-state hints.
- Choose `type` by **semantic severity:**
  - `.info` — neutral informational hint (default).
  - `.success` — confirmation that an action completed successfully.
  - `.warning` — reversible caution; user can still proceed.
  - `.danger` — blocking or destructive condition; user must act before continuing.
  - `.context` — muted/grey note; low-emphasis metadata.
  - `.custom` — only when you must override both icon and color. Requires `icon` and `color`.
- Choose `style` by **surface context:**
  - `.layrz` — subtle tonal chip + plain text on transparent background; good default.
  - `.filledTonal` — soft 20% alpha background; use for moderate emphasis inside forms.
  - `.filled` — solid type-color background; use for strong emphasis, error banners.
  - `.outlined` — transparent background with type-color border; use inside cards.
  - `.filledIcon` — two-column layout (filled icon column + white body); use on dashboards.
- **`ThemedAlert` is a pure `StatelessWidget` — there is no `ThemedAlert.show()` or dialog helper.** Place it directly inside a `Column`, `AlertDialog.content`, `SnackBar.content`, or any other layout widget.
- Use `ThemedAlertIcon` when you need just the colored icon badge without a title or description.

---

## Minimal usage

```dart
ThemedAlert(
  type: .warning,
  title: context.i18n.t('entity.warning.title'),
  description: context.i18n.t('entity.warning.description'),
)
```

---

## Key behaviors

- `title` and `description` are **required** — no factory variant exists without them.
- `maxLines` (default 3) clips `description` with an ellipsis; bump it if the message is expected to be longer.
- `.custom` type **requires** both `color` and `icon` — the widget has no fallback values for custom type.
- `style` changes only the surface chrome (background, border); the semantic color always comes from `type`.
- `iconSize` defaults to **25** when `style` is `.filledIcon`, **22** otherwise. Override explicitly only when layout demands it.
- In `.filled` style, text color is auto-contrasted via `validateColor(typeColor)` — do not manually set text colors.

---

## Common patterns

```dart
// 1. Info banner — default subtle style
ThemedAlert(
  title: context.i18n.t('onboarding.tip.title'),
  description: context.i18n.t('onboarding.tip.description'),
)

// 2. Filled danger alert inside an AlertDialog
AlertDialog(
  content: ThemedAlert(
    type: .danger,
    style: .filled,
    title: context.i18n.t('errors.deleteTitle'),
    description: context.i18n.t('errors.deleteDescription'),
  ),
  actions: [...],
)

// 3. Outlined success summary inside a Card
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: ThemedAlert(
      type: .success,
      style: .outlined,
      title: context.i18n.t('export.done.title'),
      description: context.i18n.t('export.done.description'),
    ),
  ),
)

// 4. Custom type with project-specific icon and color
ThemedAlert(
  type: .custom,
  color: const Color(0xFF6A0DAD),
  icon: LayrzIcons.solarOutlineShieldCheck,
  title: context.i18n.t('security.verified.title'),
  description: context.i18n.t('security.verified.description'),
)
```

---

## Usage conventions

- Localize `title` and `description` via `context.i18n.t('...')` — never hardcode strings.
- Don't stack multiple alerts of the same severity; collapse them into one with a combined description.
- Keep descriptions short enough to fit in 3 lines. If content is inherently longer, set `maxLines` explicitly rather than leaving the default clip.
- For action-triggered feedback (e.g. after a form submit), prefer wrapping `ThemedAlert` inside `SnackBar.content` so it auto-dismisses rather than cluttering the page layout.
- Separate `ThemedAlert` from surrounding inputs or cards with `SizedBox(height: 10)`.
