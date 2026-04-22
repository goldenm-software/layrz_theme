---
name: themed-time-range-picker
description: Use ThemedTimeRangePicker in a layrz Flutter widget. Apply when adding a start + end time selection field.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values — never write the fully-qualified form.

> **Full constructor and property reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Start + end time-of-day pair; value type: `List<TimeOfDay>` (empty or exactly 2 elements)
- Never use Flutter's built-in `showTimePicker` — always use this widget.

For a single time → use `ThemedTimePicker`.

---

## Minimal usage

```dart
ThemedTimeRangePicker(
  labelText: context.i18n.t('entity.timeRange'),
  value: timeRange,
  errors: context.getErrors(key: 'timeRange'),
  onChanged: (range) {
    timeRange = range;
    if (context.mounted) onChanged.call();
  },
)
```

---

## Key behaviors

- `value` must be empty or exactly 2 elements — assert enforced.
- Opens a dialog with two independent hour/minute spinners (Start / End) stacked vertically.
- Result is always sorted `[earliest, latest]` — no manual sorting needed.
- `onChanged` fires only when the user taps **Save** and both start and end are set.
- Default format: 12-hour (`%I:%M %p`). Set `use24HourFormat: true` for 24-hour (`%H:%M`).
- Display: `"HH:MM - HH:MM"` formatted with `pattern`.
- `disableBlink: true` disables the blink animation in both spinners.
- `customChild` wraps any widget in an `InkWell` that opens the dialog.
- Exactly one of `label` / `labelText` must be set — assert enforced.

---

## Common patterns

```dart
// 24-hour format
ThemedTimeRangePicker(
  labelText: context.i18n.t('shift.operatingHours'),
  value: operatingHours,
  use24HourFormat: true,
  errors: context.getErrors(key: 'operatingHours'),
  onChanged: (range) {
    operatingHours = range;
    if (context.mounted) onChanged.call();
  },
)

// Pre-populated range
ThemedTimeRangePicker(
  labelText: context.i18n.t('schedule.window'),
  value: const [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 17, minute: 0)],
  onChanged: (range) {
    selectedRange = range;
    if (context.mounted) onChanged.call();
  },
)

// Disabled
ThemedTimeRangePicker(
  labelText: context.i18n.t('entity.timeRange'),
  value: timeRange,
  disabled: true,
)
```

---

## Form conventions

- Guard `onChanged` with `if (context.mounted)` before calling the parent callback.
- Use `context.i18n.t('entity.fieldName')` for `labelText` — never hardcode strings.
- Pass `errors: context.getErrors(key: 'fieldName')`.
- Never pass a single-element list to `value` — the assert will throw.
- Separate stacked inputs with `const SizedBox(height: 10)`.
