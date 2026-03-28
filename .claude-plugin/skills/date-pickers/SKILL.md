---
name: date-pickers
description: Use ThemedDatePicker, ThemedDateRangePicker, ThemedMonthPicker, or ThemedMonthRangePicker in a layrz
  Flutter widget. Apply when adding a date or month selection field.
---

## Overview

Four components cover all date and month selection needs:

| Component | State type | `onChanged` signature | Granularity |
|---|---|---|---|
| `ThemedDatePicker` | `DateTime?` | `void Function(DateTime)` | Single day |
| `ThemedDateRangePicker` | `List<DateTime>` (0 or 2) | `void Function(List<DateTime>)` | Day range |
| `ThemedMonthPicker` | `ThemedMonth?` | `void Function(ThemedMonth)` | Single month + year |
| `ThemedMonthRangePicker` | `List<ThemedMonth>` | `void Function(List<ThemedMonth>)` | Month range |

All four open a dialog — never use raw Flutter `showDatePicker` or `showDateRangePicker`.

---

## ThemedDatePicker — single day

### Minimal usage

```dart
// State
DateTime? selectedDate;

// Widget
ThemedDatePicker(
  labelText: context.i18n.t('entity.date'),
  value: selectedDate,
  onChanged: (date) {
    if (context.mounted) setState(() => selectedDate = date);
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided |
| `label` | `Widget?` | — | Required unless `labelText` is provided. Exactly one must be set. |
| `value` | `DateTime?` | `null` | Currently selected date |
| `onChanged` | `void Function(DateTime)?` | `null` | Called with the picked day; never null inside callback |
| `pattern` | `String` | `'%Y-%m-%d'` | Display format string passed to `DateTime.format()` |
| `disabledDays` | `List<DateTime>` | `[]` | Days greyed out and non-tappable in the calendar |
| `disabled` | `bool` | `false` | Disables the entire input |
| `errors` | `List<String>` | `[]` | Validation error messages shown below the field |
| `hideDetails` | `bool` | `false` | Hides the errors / hints row |
| `padding` | `EdgeInsets?` | `null` | Outer padding of the input |
| `placeholder` | `String?` | `null` | Hint text when no date is selected |
| `prefixText` | `String?` | `null` | Static text before the input |
| `prefixIcon` | `IconData?` | `null` | Icon before the field. Mutually exclusive with `prefixWidget`. |
| `prefixWidget` | `Widget?` | `null` | Widget before the field. Mutually exclusive with `prefixIcon`. |
| `onPrefixTap` | `VoidCallback?` | `null` | Called when prefix is tapped |
| `customChild` | `Widget?` | `null` | Replaces the text field; the entire widget becomes tappable |
| `translations` | `Map<String, String>` | see below | Override i18n keys when `LayrzAppLocalizations` is absent |
| `overridesLayrzTranslations` | `bool` | `false` | Force `translations` map even when localizations are present |

### Behavior notes

- The dialog renders a `ThemedCalendar` inside a `Dialog` constrained to `maxWidth: 400, maxHeight: 400`.
- If `value` is a `TZDateTime`, the returned `DateTime` is also wrapped in the same `TZDateTime` location —
  the timezone is preserved automatically.
- The suffix icon is always `LayrzIcons.solarOutlineCalendar`; it cannot be overridden.
- The field is always `readonly: true` — users cannot type dates directly.

### Common patterns

```dart
// With timezone-aware value (TZDateTime)
ThemedDatePicker(
  labelText: context.i18n.t('trip.departureDate'),
  value: trip.departureDate, // TZDateTime
  onChanged: (date) {
    // date is already TZDateTime with the same location
    if (context.mounted) setState(() => trip.departureDate = date as TZDateTime);
  },
)

// With disabled days
ThemedDatePicker(
  labelText: context.i18n.t('schedule.date'),
  value: schedule.date,
  disabledDays: holidays,
  errors: context.getErrors(key: 'date'),
  onChanged: (date) {
    if (context.mounted) setState(() => schedule.date = date);
  },
)

// Custom display format
ThemedDatePicker(
  labelText: context.i18n.t('report.period'),
  value: report.date,
  pattern: '%d/%m/%Y',
  onChanged: (date) {
    if (context.mounted) setState(() => report.date = date);
  },
)
```

---

## ThemedDateRangePicker — day range

### Minimal usage

```dart
// State — always empty or exactly 2 elements: [start, end]
List<DateTime> dateRange = [];

// Widget
ThemedDateRangePicker(
  labelText: context.i18n.t('entity.dateRange'),
  value: dateRange,
  onChanged: (range) {
    if (context.mounted) setState(() => dateRange = range);
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided |
| `label` | `Widget?` | — | Required unless `labelText` is provided |
| `value` | `List<DateTime>` | `[]` | Must be empty or exactly 2 items: `[start, end]` |
| `onChanged` | `void Function(List<DateTime>)?` | `null` | Returns `[start, end]`, always sorted |
| `pattern` | `String` | `'%Y-%m-%d'` | Display format for both dates; they are joined with ` - ` |
| `disabled` | `bool` | `false` | Disables the input |
| `errors` | `List<String>` | `[]` | Validation error messages |
| `hideDetails` | `bool` | `false` | Hides the errors / hints row |
| `padding` | `EdgeInsets?` | `null` | Outer padding of the input |
| `placeholder` | `String?` | `null` | Hint text when no range is selected |
| `prefixText` | `String?` | `null` | Static text before the input |
| `prefixIcon` | `IconData?` | `null` | Icon before the field. Mutually exclusive with `prefixWidget`. |
| `prefixWidget` | `Widget?` | `null` | Widget before the field. Mutually exclusive with `prefixIcon`. |
| `onPrefixTap` | `VoidCallback?` | `null` | Called when prefix is tapped |
| `customChild` | `Widget?` | `null` | Replaces the text field |
| `translations` | `Map<String, String>` | see below | Override i18n keys |
| `overridesLayrzTranslations` | `bool` | `false` | Force `translations` map |

### Behavior notes

- The dialog uses the same `ThemedCalendar` constrained to `maxWidth: 400, maxHeight: 400`.
- Selection is a two-tap flow: first tap sets the start date (highlighted); second tap sets the end date
  and closes the dialog immediately. The result is always sorted — no need to sort on the receiving side.
- If the existing `value` is non-empty, the calendar pre-highlights the full current range until the user
  taps to start a new selection.
- If `value.first` is a `TZDateTime`, the returned list is also converted to the same timezone.
- The assert `value.length == 0 || value.length == 2` is enforced at runtime — never pass a single-element list.

### Common patterns

```dart
// Form integration
ThemedDateRangePicker(
  labelText: context.i18n.t('report.dateRange'),
  value: report.dateRange,
  errors: context.getErrors(key: 'dateRange'),
  onChanged: (range) {
    if (context.mounted) setState(() => report.dateRange = range);
  },
)

// Clearing the range
ThemedDateRangePicker(
  labelText: context.i18n.t('filter.period'),
  value: filter.dateRange,
  onChanged: (range) {
    // range is always [start, end] — to clear, set state to []
    if (context.mounted) setState(() => filter.dateRange = range);
  },
)
```

---

## ThemedMonthPicker — single month

### Minimal usage

```dart
// State
ThemedMonth? selectedMonth;

// Widget
ThemedMonthPicker(
  labelText: context.i18n.t('entity.month'),
  value: selectedMonth,
  onChanged: (month) {
    if (context.mounted) setState(() => selectedMonth = month);
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided |
| `label` | `Widget?` | — | Required unless `labelText` is provided |
| `value` | `ThemedMonth?` | `null` | Currently selected month |
| `onChanged` | `void Function(ThemedMonth)?` | `null` | Called with the picked month |
| `minimum` | `ThemedMonth?` | `null` | Months before this are greyed out and non-tappable |
| `maximum` | `ThemedMonth?` | `null` | Months after this are greyed out and non-tappable |
| `disabledMonths` | `List<ThemedMonth>` | `[]` | Specific months to disable individually |
| `disabled` | `bool` | `false` | Disables the input |
| `errors` | `List<String>` | `[]` | Validation error messages |
| `hideDetails` | `bool` | `false` | Hides the errors / hints row |
| `padding` | `EdgeInsets?` | `null` | Outer padding |
| `placeholder` | `String?` | `null` | Hint text when no month is selected |
| `prefixText` | `String?` | `null` | Static text before the input |
| `prefixIcon` | `IconData?` | `null` | Icon before the field. Mutually exclusive with `prefixWidget`. |
| `prefixWidget` | `Widget?` | `null` | Widget before the field. Mutually exclusive with `prefixIcon`. |
| `onPrefixTap` | `VoidCallback?` | `null` | Called when prefix is tapped |
| `customChild` | `Widget?` | `null` | Replaces the text field |
| `translations` | `Map<String, String>` | see below | Override i18n keys |
| `overridesLayrzTranslations` | `bool` | `false` | Force `translations` map |

### ThemedMonth struct

```dart
ThemedMonth(
  month: Month.january, // Month enum: january … december (index 0–11)
  year: 2024,
)
```

`Month` is an enum with values `january` through `december`. Use `Month.values[index]` to convert from a
0-based integer.

### Behavior notes

- The dialog renders a responsive 4-column month grid (2 columns on small screens, 3 on medium).
- The header shows the focused year with prev/next arrow buttons — the user navigates years without closing.
- Tapping a month closes the dialog immediately and calls `onChanged`.
- Cancel and Save buttons are shown at the bottom; Save without selecting does nothing (returns `null`).
- The dialog is constrained to `maxWidth: 500, maxHeight: 600`.
- `minimum` and `maximum` enforce bounds by year+month comparison; `disabledMonths` disables exact entries.

### Common patterns

```dart
// With min/max bounds
ThemedMonthPicker(
  labelText: context.i18n.t('invoice.billingMonth'),
  value: invoice.billingMonth,
  minimum: ThemedMonth(month: Month.january, year: 2020),
  maximum: ThemedMonth(month: Month.december, year: DateTime.now().year),
  errors: context.getErrors(key: 'billingMonth'),
  onChanged: (month) {
    if (context.mounted) setState(() => invoice.billingMonth = month);
  },
)

// Disable specific months
ThemedMonthPicker(
  labelText: context.i18n.t('schedule.month'),
  value: schedule.month,
  disabledMonths: closedMonths, // List<ThemedMonth>
  onChanged: (month) {
    if (context.mounted) setState(() => schedule.month = month);
  },
)
```

---

## ThemedMonthRangePicker — month range

### Minimal usage

```dart
// State
List<ThemedMonth> monthRange = [];

// Widget
ThemedMonthRangePicker(
  labelText: context.i18n.t('entity.monthRange'),
  value: monthRange,
  onChanged: (range) {
    if (context.mounted) setState(() => monthRange = range);
  },
)
```

### Constructor — key parameters

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `labelText` | `String?` | — | Required unless `label` is provided |
| `label` | `Widget?` | — | Required unless `labelText` is provided |
| `value` | `List<ThemedMonth>` | `[]` | Currently selected months |
| `onChanged` | `void Function(List<ThemedMonth>)?` | `null` | Returns sorted list of selected months |
| `consecutive` | `bool` | `false` | Selection mode — see behavior notes |
| `minimum` | `ThemedMonth?` | `null` | Months before this are disabled |
| `maximum` | `ThemedMonth?` | `null` | Months after this are disabled |
| `disabledMonths` | `List<ThemedMonth>` | `[]` | Specific months to disable (only in non-consecutive mode) |
| `disabled` | `bool` | `false` | Disables the input |
| `errors` | `List<String>` | `[]` | Validation error messages |
| `hideDetails` | `bool` | `false` | Hides the errors / hints row |
| `padding` | `EdgeInsets?` | `null` | Outer padding |
| `placeholder` | `String?` | `null` | Hint text when empty |
| `prefixText` | `String?` | `null` | Static text before the input |
| `prefixIcon` | `IconData?` | `null` | Icon before the field. Mutually exclusive with `prefixWidget`. |
| `prefixWidget` | `Widget?` | `null` | Widget before the field. Mutually exclusive with `prefixIcon`. |
| `onPrefixTap` | `VoidCallback?` | `null` | Called when prefix is tapped |
| `customChild` | `Widget?` | `null` | Replaces the text field |
| `translations` | `Map<String, String>` | see below | Override i18n keys (includes `actions.reset`) |
| `overridesLayrzTranslations` | `bool` | `false` | Force `translations` map |

### Behavior notes

- **`consecutive: false` (default):** each tap toggles the individual month on/off. Any combination is valid.
  `disabledMonths` works in this mode.
- **`consecutive: true`:** first tap sets the anchor; second tap fills in all months between anchor and the
  tapped month, inclusive. Only months at the start or end of the current selection can be re-tapped to change
  bounds. `disabledMonths` has no effect in this mode.
- The dialog has three footer buttons: **Cancel** (discards, returns `null`), **Reset** (clears selection in
  place without closing), and **Save** (confirms and calls `onChanged`).
- The result passed to `onChanged` is always sorted ascending by year then month.
- If Save is pressed while a consecutive first-pick is pending (anchor set, no end yet), the range resolves to
  a single-month list containing only the anchor.
- Dialog constrained to `maxWidth: 500, maxHeight: 600`. Responsive grid: 2/3/4 columns by breakpoint.

### Common patterns

```dart
// Arbitrary month toggle (non-consecutive)
ThemedMonthRangePicker(
  labelText: context.i18n.t('report.months'),
  value: report.selectedMonths,
  errors: context.getErrors(key: 'selectedMonths'),
  onChanged: (months) {
    if (context.mounted) setState(() => report.selectedMonths = months);
  },
)

// Consecutive range with bounds
ThemedMonthRangePicker(
  labelText: context.i18n.t('contract.period'),
  value: contract.months,
  consecutive: true,
  minimum: ThemedMonth(month: Month.january, year: 2022),
  maximum: ThemedMonth(month: Month.december, year: DateTime.now().year),
  errors: context.getErrors(key: 'months'),
  onChanged: (months) {
    if (context.mounted) setState(() => contract.months = months);
  },
)
```

---

## Translation keys

All four widgets use `LayrzAppLocalizations` by default. Pass a `translations` map only when localizations are
absent or you need to override specific strings. Keys and their English fallbacks:

| Key | English fallback | Used by |
|---|---|---|
| `actions.cancel` | `'Cancel'` | All four |
| `actions.save` | `'Save'` | All four |
| `actions.reset` | `'Reset'` | `ThemedMonthRangePicker` only |
| `layrz.monthPicker.year` | `'Year {year}'` | All four (supports `{year}` interpolation) |
| `layrz.monthPicker.back` | `'Previous year'` | All four |
| `layrz.monthPicker.next` | `'Next year'` | All four |

Set `overridesLayrzTranslations: true` to force the `translations` map even when `LayrzAppLocalizations` is
available in context.

---

## Integrating with layrz forms

```dart
// Single date
ThemedDatePicker(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName,
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (date) {
    object.fieldName = date;
    if (context.mounted) onChanged.call();
  },
)

// Date range
ThemedDateRangePicker(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName, // List<DateTime> — empty or [start, end]
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (range) {
    object.fieldName = range;
    if (context.mounted) onChanged.call();
  },
)

// Single month
ThemedMonthPicker(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName,
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (month) {
    object.fieldName = month;
    if (context.mounted) onChanged.call();
  },
)

// Month range
ThemedMonthRangePicker(
  labelText: context.i18n.t('entity.fieldName'),
  value: object.fieldName, // List<ThemedMonth>
  errors: context.getErrors(key: 'fieldName'),
  onChanged: (months) {
    object.fieldName = months;
    if (context.mounted) onChanged.call();
  },
)
```

Always guard `onChanged` with `if (context.mounted)` before calling the parent callback — the dialog is async
and the widget may have been unmounted by the time it resolves.

---

## Choosing between the four

| Need | Use |
|---|---|
| Pick a single calendar day | `ThemedDatePicker` |
| Pick a start date and an end date (two days) | `ThemedDateRangePicker` |
| Pick a month and year (no specific day) | `ThemedMonthPicker` |
| Pick one or many months, or a month span | `ThemedMonthRangePicker` |
| Pick an unordered set of months | `ThemedMonthRangePicker` with `consecutive: false` |
| Pick a contiguous block of months | `ThemedMonthRangePicker` with `consecutive: true` |

Never use raw Flutter `showDatePicker`, `showDateRangePicker`, or any Material date dialog directly. Always use
the Layrz-themed components above.
