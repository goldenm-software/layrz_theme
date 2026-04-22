# ThemedSnackbar — API Reference

Sources:

- `ThemedSnackbar` data class — `lib/src/snackbar/src/snackbar.dart` L3
- `ThemedSnackbarMessenger` widget — `lib/src/snackbar/src/messenger.dart` L5
- `ThemedSnackbarMessengerState` — `lib/src/snackbar/src/messenger.dart` L52
- Constants & helpers — `lib/src/snackbar/snackbar.dart`

---

## Examples

```dart
// App setup — wrap MaterialApp.router once
MaterialApp.router(
  builder: (context, child) {
    return ThemedSnackbarMessenger(
      child: child ?? const SizedBox(),
    );
  },
)

// Minimal call — message only
ThemedSnackbarMessenger.of(context).showSnackbar(
  ThemedSnackbar(message: 'File saved'),
);

// Success with icon and color
ThemedSnackbarMessenger.of(context).showSnackbar(
  ThemedSnackbar(
    message: 'Record created successfully',
    color: Colors.green,
    icon: LayrzIcons.solarOutlineCheckSquare,
  ),
);

// Error with title + extended duration
ThemedSnackbarMessenger.of(context).showSnackbar(
  ThemedSnackbar(
    title: 'Upload failed',
    message: 'The server returned a 503 error. Please try again.',
    color: Colors.red,
    icon: LayrzIcons.solarOutlineCloseSquare,
    duration: const Duration(seconds: 10),
  ),
);

// Title + message (two-line layout)
ThemedSnackbarMessenger.of(context).showSnackbar(
  ThemedSnackbar(
    title: 'Export queued',
    message: 'Your CSV will be ready in a few seconds.',
    icon: LayrzIcons.solarOutlineExport,
  ),
);

// maybeOf — safe when ancestor may be absent
ThemedSnackbarMessenger.maybeOf(context)?.showSnackbar(
  ThemedSnackbar(message: 'Copied to clipboard'),
);

// Custom messenger width (dashboard layouts)
ThemedSnackbarMessenger(
  maxWidth: 600,
  child: child,
)
```

---

## `ThemedSnackbar` constructor

```dart
ThemedSnackbar({
  String? title,
  required String message,
  IconData? icon,
  Color? color,
  Duration duration = const Duration(seconds: 5),
  @Deprecated('Will be removed in 8.0.0. Use maxWidth on ThemedSnackbarMessenger instead.')
  double? width,
  @Deprecated('Will be removed in 8.0.0.')
  int maxLines = 2,
  bool isDismissible = true,
});
```

---

## `ThemedSnackbar` properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `title` | `String?` | `null` | Optional bold heading line. Skip for single-line snackbars. |
| `message` | `String` | — | **Required.** Must be non-empty (runtime assert). |
| `icon` | `IconData?` | `null` | Icon displayed on the left. Falls back to `solarOutlineInfoCircle` when null. |
| `color` | `Color?` | `null` | Background color. Falls back to `Colors.blue` when null. Foreground is auto-contrasted. |
| `duration` | `Duration` | `Duration(seconds: 5)` | How long the snackbar stays visible. Must be > 0 s (runtime assert). |
| `width` | `double?` | `null` | **Deprecated — do not use.** Removed in 8.0.0. Set `maxWidth` on `ThemedSnackbarMessenger` instead. |
| `maxLines` | `int` | `2` | **Deprecated — do not use.** Removed in 8.0.0. |
| `isDismissible` | `bool` | `true` | Stored but does not suppress the close icon in the current implementation. |

---

## `ThemedSnackbarMessenger` constructor

```dart
const ThemedSnackbarMessenger({
  Key? key,
  required Widget child,
  double maxWidth = 400,
  double mobileBreakpoint = kSmallGrid,
  bool useViewInsetsBottom = true,
});
```

---

## `ThemedSnackbarMessenger` properties

| Property | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | — | **Required.** The subtree that can call `of(context).showSnackbar(...)`. |
| `maxWidth` | `double` | `400` | Maximum snackbar width in logical pixels on desktop/tablet. |
| `mobileBreakpoint` | `double` | `kSmallGrid` (960) | Width threshold below which mobile layout (bottom position) is used. |
| `useViewInsetsBottom` | `bool` | `true` | When true, adds `MediaQuery.viewInsetsOf(context).bottom` to the bottom offset so the snackbar clears the virtual keyboard. |

---

## Static accessors

| Method | Return type | Notes |
|---|---|---|
| `ThemedSnackbarMessenger.of(context)` | `ThemedSnackbarMessengerState` | Asserts a `ThemedSnackbarMessenger` ancestor exists. Throws in debug mode if absent. |
| `ThemedSnackbarMessenger.maybeOf(context)` | `ThemedSnackbarMessengerState?` | Nullable variant — returns `null` when no ancestor is found. Use in tests or partial widget trees. |

---

## `ThemedSnackbarMessengerState` public members

| Member | Signature | Notes |
|---|---|---|
| `showSnackbar` | `void showSnackbar(ThemedSnackbar snackbar)` | Enqueues and displays the snackbar. |
| `show` | `void show(ThemedSnackbar snackbar)` | Alias for `showSnackbar`. |
| `snackbars` | `final List<ThemedSnackbar> snackbars` | Current display/queue list. Read-only in practice. |

---

## Constants & helpers

| Identifier | Type / Signature | Value / Notes |
|---|---|---|
| `kSnackbarAnimationDuration` | `const Duration` | `Duration(milliseconds: 300)` — shared fade-in/out animation duration. |
| `ThemedSnackbarCallback` | `typedef bool Function()` | Callback type used internally by the messenger state. |
| `debugCheckHasThemedSnackbarMessenger` | `bool Function(BuildContext context)` | Debug assertion helper — throws a descriptive `FlutterError` if no `ThemedSnackbarMessenger` ancestor exists. Called internally by `of(context)`. |

---

## Behavior notes

- **Positioning:** desktop/tablet → top-right, snackbars stack downward. Mobile portrait (width < `mobileBreakpoint` or Android/iOS portrait) → bottom, offset by `MediaQuery.viewInsetsOf(context).bottom` when `useViewInsetsBottom` is true.
- **Width:** `min(screenWidth × 0.7, maxWidth)` on desktop/tablet; full screen width minus view padding on mobile portrait.
- **Stacking and queue:** snackbars are queued. While one is visible a red badge in its top-right corner shows the remaining count. Badge shows `+9` when the queue exceeds 9. Tapping the badge dismisses the entire queue.
- **Timer pause:** a `MouseRegion` wraps each snackbar. `onEnter` pauses the linear progress indicator; `onExit` resumes it. Only effective on pointer devices (desktop/web).
- **Icon fallback:** `LayrzIcons.solarOutlineInfoCircle` when `icon == null`.
- **Color fallback:** `Colors.blue` when `color == null`. The foreground (text + icon tint) is computed via `validateColor(color: resolvedColor)` for legibility contrast.
- **No `ScaffoldMessenger` dependency:** `ThemedSnackbarMessenger` renders its overlay via a custom `Stack` + `Positioned` at the top of its own subtree. A `Scaffold` is not required.
- **`isDismissible` caveat:** the `isDismissible` field is stored on `ThemedSnackbar` but the widget always renders a close `InkWell` (`solarOutlineCloseCircle`). The field has no observable effect on the close affordance in the current implementation.
- **Animation timing:** 150 ms fade-in, linear progress bar consuming `duration`, 100 ms delay before widget removal, `kSnackbarAnimationDuration` (300 ms) governs the overall animation controller.
