---
name: theme-generator
description: Use generateLightTheme and generateDarkTheme in a layrz Flutter app. Apply when wiring MaterialApp.theme / darkTheme or customizing primary color and fonts.
---

> **Dart syntax:** This library requires Dart ≥ 3.10. Use dot shorthand for all enum values (e.g. `.system`, `.dark`) — never write the fully-qualified form (`ThemeMode.system`).

> **Full function signatures and parameter reference:** read `references/api.md` in this skill's directory.

---

## When to use

- Wiring `MaterialApp(theme:, darkTheme:)` with the Layrz design standard
- Applying a custom primary color via `mainColor` instead of the default `kPrimaryColor` (#001e60)
- Using a Layrz API palette name (`'BLUE'`, `'TEAL'`, `'RED'`, etc.) via the `theme` parameter
- Replacing the default fonts (Cabin / Fira Sans Condensed) with custom `AppFont` instances via `titleFont` / `bodyFont`
- Never build `ThemeData` from scratch — always use these generators to stay consistent with the Layrz design standard

---

## Minimal usage

```dart
MaterialApp(
  theme: generateLightTheme(),
  darkTheme: generateDarkTheme(),
  themeMode: .system,
  // ...
)
```

---

## Key behaviors

- Both functions share the same four parameters: `theme`, `mainColor`, `titleFont`, `bodyFont`.
- `theme` defaults to `"CUSTOM"` — when `"CUSTOM"`, `mainColor` is used to generate the palette. For any other Layrz API name, `mainColor` is ignored.
- `mainColor` defaults to `kPrimaryColor` (`Color(0xFF001e60)`).
- Title font defaults to **Cabin** from Google Fonts; body font defaults to **Fira Sans Condensed** from Google Fonts.
- For non-Google-Fonts `AppFont` values, call `await preloadFont(AppFont(...))` for each font **before** `runApp(...)`.
- Both return `ThemeData` with `useMaterial3: true`.
- Light theme uses `kLightBackgroundColor` for scaffold/canvas/dialog/card backgrounds.
- Dark theme uses `kDarkBackgroundColor` for scaffold/canvas/dialog/card backgrounds.

---

## Common patterns

```dart
// Custom primary color (CUSTOM palette)
MaterialApp(
  theme: generateLightTheme(mainColor: const Color(0xFF0057B7)),
  darkTheme: generateDarkTheme(mainColor: const Color(0xFF0057B7)),
  themeMode: .system,
)
```

```dart
// Layrz API palette name — mainColor is ignored
MaterialApp(
  theme: generateLightTheme(theme: 'TEAL'),
  darkTheme: generateDarkTheme(theme: 'TEAL'),
  themeMode: .system,
)
```

```dart
// Custom fonts loaded before runApp
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preloadFont(AppFont(name: 'Inter', source: FontSource.googleFonts));
  await preloadFont(AppFont(name: 'Roboto Mono', source: FontSource.googleFonts));
  runApp(const MyApp());
}

// Then in MaterialApp:
MaterialApp(
  theme: generateLightTheme(
    titleFont: AppFont(name: 'Inter', source: FontSource.googleFonts),
    bodyFont: AppFont(name: 'Roboto Mono', source: FontSource.googleFonts),
  ),
  darkTheme: generateDarkTheme(
    titleFont: AppFont(name: 'Inter', source: FontSource.googleFonts),
    bodyFont: AppFont(name: 'Roboto Mono', source: FontSource.googleFonts),
  ),
  themeMode: .system,
)
```

```dart
// App-controlled theme mode (e.g. user preference stored in state)
MaterialApp(
  theme: generateLightTheme(),
  darkTheme: generateDarkTheme(),
  themeMode: store.isDarkMode ? .dark : .light,
)
```

---

## App setup conventions

- Always pass both `theme:` and `darkTheme:` so system dark mode works correctly.
- Use `themeMode: .system` unless the app has an explicit user-controlled toggle.
- Call `preloadFont` before `runApp` for any non-Google-Fonts `AppFont`; repeat for each font (title and body separately).
- Keep `theme` and `mainColor` identical between the light and dark calls.
