---
name: themed-duration-input
description: Use ThemedDurationInput in a layrz Flutter widget. Apply when adding a time span field (timeout, interval, shift length) that stores a Duration value.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Time span fields stored as `Duration`: timeouts, intervals, retention periods, shift lengths
- Value type: `Duration?`
- Prefer this over storing duration as a plain integer (seconds/milliseconds) — gives the user explicit unit controls and a human-readable display.

For scalar numeric fields → use `ThemedNumberInput`.

---

## Minimal usage

```dart
ThemedDurationInput(
  labelText: context.i18n.t('entity.timeout'),
  value: timeout,
  errors: context.getErrors(key: 'timeout'),
  onChanged: (value) {
    timeout = value;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Readonly text field — tapping opens a dialog with one `ThemedNumberInput` per visible time unit.
- Default units: days, hours, minutes, seconds (`kThemedDurationSupported`).
- `visibleValues` restricts which units appear; must be a subset of `[day, hour, minute, second]`.
- Dialog has three actions: **Cancel** (discard), **Reset** (zero all units, stay open), **Save** (commit + close).
- `onChanged` fires only on Save — not on Cancel or intermediate changes.
- Display text is humanized using the active `LayrzAppLocalizations` locale.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// Hours and minutes only
ThemedDurationInput(
  labelText: context.i18n.t('entity.shiftLength'),
  value: shiftLength,
  visibleValues: const [ThemedUnits.hour, ThemedUnits.minute],
  errors: context.getErrors(key: 'shiftLength'),
  onChanged: (value) {
    shiftLength = value;
    if (context.mounted) onChanged.call();
  },
)

// Days only (e.g. retention/expiration windows)
ThemedDurationInput(
  labelText: context.i18n.t('entity.retentionPeriod'),
  value: retentionPeriod,
  visibleValues: const [ThemedUnits.day],
  errors: context.getErrors(key: 'retentionPeriod'),
  onChanged: (value) {
    retentionPeriod = value;
    if (context.mounted) onChanged.call();
  },
)

// Full granularity with prefix icon
ThemedDurationInput(
  labelText: context.i18n.t('entity.connectionTimeout'),
  value: connectionTimeout,
  prefixIcon: LayrzIcons.solarOutlineClockCircle,
  errors: context.getErrors(key: 'connectionTimeout'),
  onChanged: (value) {
    connectionTimeout = value;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedDurationInput(
  labelText: context.i18n.t('entity.timeout'),
  value: timeout,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
