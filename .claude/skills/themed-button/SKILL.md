---
name: themed-button
description: Use ThemedButton in a layrz Flutter widget. Apply when rendering any tappable action — primary/secondary CTAs, icon-only FABs, destructive actions, cooldown buttons, or the six semantic factories (.save, .cancel, .info, .show, .edit, .delete).
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.filledTonal`, `.fab`, `.outlined`) — never write the fully-qualified form (`ThemedButtonStyle.filledTonal`).

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Any tappable action: CTA buttons, form submit/cancel, confirmation dialogs, detail pages.
- **Prefer the six semantic factories** (`.save`, `.cancel`, `.info`, `.show`, `.edit`, `.delete`) for CRUD screens — they wire up the correct icon, color, and style automatically.
- Use FAB-variant styles (`.fab`, `.filledTonalFab`, `.elevatedFab`, etc.) when the button is icon-only; `labelText` becomes the tooltip.
- Use `isCooldown` for rate-limited actions (e.g. OTP resend, export trigger) where the user must wait before retrying.
- Use `onLongPress` for destructive or confirm-before-act patterns — note it is **mutually exclusive with `onTap`**.
- **Do not use** for static icons with no interaction — use a plain `Icon` instead.
- **Do not use** for on/off toggles — use `ThemedAnimatedCheckbox` instead.
- **Do not use** for a row of actions on a list item — use `ThemedActionsButtons` instead (collapses to FAB overlay on mobile automatically).

---

## Minimal usage

```dart
// Semantic factory — recommended for CRUD save
ThemedButton.save(
  labelText: context.i18n.t('actions.save'),
  isLoading: isSaving,
  onTap: () async {
    await save();
    if (context.mounted) onSaved.call();
  },
)
```

---

## Key behaviors

- **`label` XOR `labelText`** — exactly one must be provided (compile-time assert). Use `labelText` (String) for text; use `label` (Widget) for custom content.
- **`onTap` XOR `onLongPress`** — providing both throws an assert.
- `isLoading: true` replaces the button content with a circular spinner; `loadingBackgroundColor` / `loadingForegroundColor` override the spinner colors.
- `isCooldown: true` locks the button for `cooldownDuration` (default 5 s) after a tap, then fires `onCooldownFinish`. Set `showCooldownRemainingDuration: false` to hide the countdown overlay.
- `isDisabled: true` applies a grey tint via `ThemedButton.getDisabledColor(isDark, style)` and suppresses `onTap`.
- **FAB variants** (`.fab`, `.filledTonalFab`, etc.) are icon-only — they use `labelText` as the tooltip. Set `tooltipEnabled: false` to suppress it.
- `height` defaults to `ThemedButton.defaultHeight` (40). Minimum is 30; `iconSize` must be ≤ `height` and `fontSize` must be ≤ `height`.

---

## Common patterns

```dart
// 1. Primary filledTonal with icon (default style)
ThemedButton(
  labelText: context.i18n.t('actions.export'),
  icon: LayrzIcons.solarOutlineExport,
  onTap: () async {
    await export();
    if (context.mounted) onExported.call();
  },
)

// 2. Icon-only FAB (label becomes tooltip)
ThemedButton(
  labelText: context.i18n.t('actions.add'),
  icon: LayrzIcons.solarOutlineAddSquare,
  style: .fab,
  onTap: onAdd,
)

// 3. Cooldown button (e.g. resend OTP)
ThemedButton(
  labelText: context.i18n.t('auth.resendCode'),
  icon: LayrzIcons.solarOutlineRestart,
  isCooldown: true,
  cooldownDuration: const Duration(seconds: 30),
  onCooldownFinish: onCooldownEnd,
  onTap: onResend,
)

// 4. Async loading state
ThemedButton(
  labelText: context.i18n.t('actions.submit'),
  isLoading: isSubmitting,
  onTap: onSubmit,
)

// 5. Semantic factory row — save + cancel
Row(
  children: [
    ThemedButton.cancel(
      labelText: context.i18n.t('actions.cancel'),
      isMobile: isMobile,
      onTap: onCancel,
    ),
    const SizedBox(width: 10),
    ThemedButton.save(
      labelText: context.i18n.t('actions.save'),
      isMobile: isMobile,
      isLoading: isSaving,
      onTap: onSave,
    ),
  ],
)
```

---

## Form conventions

- Localize every label with `context.i18n.t('...')` — never hardcode strings.
- Always guard async callbacks: `if (context.mounted) callback.call();`
- Use the six semantic factories on CRUD detail pages — they encode the project's icon/color conventions.
- Separate stacked buttons with `SizedBox(height: 10)`; separate buttons in a `Row` with `SizedBox(width: 10)`.
- Pass `isMobile: isMobile` (or `isMobile: context.isMobile`) to semantic factories so they switch to FAB style on small screens automatically.
