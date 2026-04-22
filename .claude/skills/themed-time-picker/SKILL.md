---
name: themed-time-picker
description: Use ThemedTimePicker in a layrz Flutter widget. Apply when adding a single time-of-day selection field.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Single time-of-day selection; value type: `TimeOfDay?`
- Never use Flutter's built-in `showTimePicker` — always use this widget.

For start + end time pair → use `ThemedTimeRangePicker`.

---

## Minimal usage

```dart
ThemedTimePicker(
  labelText: context.i18n.t('entity.time'),
  value: selectedTime,
  errors: context.getErrors(key: 'time'),
  onChanged: (time) {
    selectedTime = time;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- Opens a dialog with hour/minute spinners (+/− buttons on desktop, keyboard input on mobile).
- `onChanged` fires only when the user taps **Save** — not on each spinner change.
- Default format: 12-hour (`%I:%M %p`). Set `use24HourFormat: true` for 24-hour (`%H:%M`).
- `pattern` overrides the display format without changing spinner behavior.
- `disableBlink: true` disables the 700 ms blink animation on the time display.
- `customChild` wraps any widget in an `InkWell` that opens the dialog.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// 24-hour format
ThemedTimePicker(
  labelText: context.i18n.t('schedule.startTime'),
  value: startTime,
  use24HourFormat: true,
  errors: context.getErrors(key: 'startTime'),
  onChanged: (time) {
    startTime = time;
    if (context.mounted) onChanged.call();
  },
)

// Custom display pattern (hours only)
ThemedTimePicker(
  labelText: context.i18n.t('shift.hour'),
  value: shiftHour,
  use24HourFormat: true,
  pattern: '%Hh%M',
  onChanged: (time) {
    shiftHour = TimeOfDay(hour: time.hour, minute: 0);
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedTimePicker(
  labelText: context.i18n.t('entity.time'),
  value: selectedTime,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Separate stacked inputs with `const SizedBox(height: 10)`.
