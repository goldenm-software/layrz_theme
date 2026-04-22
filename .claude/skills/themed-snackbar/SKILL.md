---
name: themed-snackbar
description: Use ThemedSnackbar in a layrz Flutter app. Apply when showing transient, dismissible feedback — drop-in replacement for Flutter's ScaffoldMessenger.showSnackBar. Requires a ThemedSnackbarMessenger ancestor.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for enum values where applicable — never write fully-qualified forms.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Any transient feedback after an action: save confirmation, error surface, background-task result, copy-to-clipboard acknowledgement.
- **Always use this instead of Flutter's `ScaffoldMessenger.showSnackBar(...)` or raw `SnackBar` in layrz code.** The custom messenger does not depend on a `Scaffold`.
- Not for persistent status callouts — use `ThemedAlert` (inline widget) for those.
- Not for blocking confirmations — use an `AlertDialog` with a `ThemedAlert` body instead.

---

## Setup

`ThemedSnackbarMessenger` must wrap the app **once** before any call to `showSnackbar`. The canonical place is the `builder:` of `MaterialApp` or `MaterialApp.router`:

```dart
MaterialApp.router(
  // ...
  builder: (context, child) {
    return ThemedSnackbarMessenger(
      child: child ?? const SizedBox(),
    );
  },
)
```

If the ancestor is missing, `ThemedSnackbarMessenger.of(context)` throws an assert at runtime.

---

## Minimal usage

```dart
ThemedSnackbarMessenger.of(context).showSnackbar(
  ThemedSnackbar(
    message: context.i18n.t('actions.saved'),
    color: Colors.green,
    icon: LayrzIcons.solarOutlineCheckSquare,
  ),
);
```

---

## Key behaviors

- `message` is **required** and must be non-empty; `duration` must be > 0 s.
- Defaults: 5 s duration, `Colors.blue` background, `solarOutlineInfoCircle` icon. Foreground text is auto-contrasted via `validateColor(...)`.
- **Desktop/tablet:** top-right stack, snackbars queue downward.
- **Mobile portrait:** bottom, respects the virtual keyboard via `MediaQuery.viewInsetsOf(context).bottom` (controlled by `useViewInsetsBottom` on the messenger, default `true`).
- Hover pauses the progress timer on desktop.
- The close icon is always rendered — `isDismissible` on the data class does not suppress it in the current implementation.
- Multiple queued snackbars show a red `+N` badge (capped at `+9`); tapping it clears the entire queue.
- `ThemedSnackbarMessenger.of(context)` throws if no ancestor exists — use `.maybeOf(context)` in tests or partial widget trees where the ancestor may be absent.
- **Do not use** the deprecated `width` or `maxLines` parameters (removed in 8.0.0). Configure width on the messenger via `maxWidth:` instead.

---

## Common patterns

```dart
// 1. Success after a save
await save();
if (context.mounted) {
  ThemedSnackbarMessenger.of(context).showSnackbar(
    ThemedSnackbar(
      message: context.i18n.t('entity.saved'),
      color: Colors.green,
      icon: LayrzIcons.solarOutlineCheckSquare,
    ),
  );
}

// 2. Error after a failed request
if (context.mounted) {
  ThemedSnackbarMessenger.of(context).showSnackbar(
    ThemedSnackbar(
      title: context.i18n.t('errors.generic.title'),
      message: context.i18n.t('errors.generic.message'),
      color: Colors.red,
      icon: LayrzIcons.solarOutlineCloseSquare,
    ),
  );
}

// 3. Info with a longer display duration
ThemedSnackbarMessenger.of(context).showSnackbar(
  ThemedSnackbar(
    message: context.i18n.t('export.queued'),
    duration: const Duration(seconds: 10),
  ),
);

// 4. maybeOf guard — safe outside a full widget tree (e.g. tests, storybook)
ThemedSnackbarMessenger.maybeOf(context)?.showSnackbar(
  ThemedSnackbar(message: context.i18n.t('actions.copied')),
);
```

---

## Usage conventions

- Localize `title` and `message` via `context.i18n.t('...')` — never hardcode strings.
- Always guard async callsites with `if (context.mounted)` before calling `of(context).showSnackbar(...)`.
- Pick colors by severity — no enum is needed, just the `Color` value:
  - `Colors.blue` — info / neutral (default)
  - `Colors.green` — success
  - `Colors.orange` — warning
  - `Colors.red` — danger / error
- Keep `message` to one line. Use `title` for a bold lead when the message needs a header; skip `title` for single-line content.
- To widen snackbars on a dashboard layout, set `maxWidth:` on `ThemedSnackbarMessenger` — do **not** pass the deprecated `width:` on `ThemedSnackbar`.
