# Theme Generator — API Reference

Source: `lib/src/theme/src/light_theme.dart`
Source: `lib/src/theme/src/dark_theme.dart`

- `generateLightTheme` function — `light_theme.dart` line 6
- `generateDarkTheme` function — `dark_theme.dart` line 6

---

## Examples

```dart
// Defaults — Layrz primary blue, Cabin + Fira Sans Condensed fonts
MaterialApp(
  theme: generateLightTheme(),
  darkTheme: generateDarkTheme(),
  themeMode: ThemeMode.system,
)
```

```dart
// Custom primary color
MaterialApp(
  theme: generateLightTheme(mainColor: const Color(0xFF0057B7)),
  darkTheme: generateDarkTheme(mainColor: const Color(0xFF0057B7)),
  themeMode: .system,
)
```

```dart
// Layrz API palette name
MaterialApp(
  theme: generateLightTheme(theme: 'TEAL'),
  darkTheme: generateDarkTheme(theme: 'TEAL'),
  themeMode: .system,
)
```

```dart
// Custom fonts — preload before runApp
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preloadFont(AppFont(name: 'Inter', source: FontSource.googleFonts));
  await preloadFont(AppFont(name: 'Roboto Mono', source: FontSource.googleFonts));
  runApp(const MyApp());
}

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
// User-controlled theme mode
MaterialApp(
  theme: generateLightTheme(mainColor: const Color(0xFFFF8200)),
  darkTheme: generateDarkTheme(mainColor: const Color(0xFFFF8200)),
  themeMode: store.isDarkMode ? .dark : .light,
)
```

---

## Signatures

```dart
ThemeData generateLightTheme({
  String theme = "CUSTOM",
  Color mainColor = kPrimaryColor,
  AppFont? titleFont,
  AppFont? bodyFont,
})
```

```dart
ThemeData generateDarkTheme({
  String theme = "CUSTOM",
  Color mainColor = kPrimaryColor,
  AppFont? titleFont,
  AppFont? bodyFont,
})
```

---

## Parameters

Both functions share an identical parameter set.

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `theme` | `String` | `"CUSTOM"` | Layrz API palette name. When `"CUSTOM"`, `mainColor` is used. Any unrecognized value falls back to `kPrimaryColor`. |
| `mainColor` | `Color` | `kPrimaryColor` | Only applied when `theme == "CUSTOM"`. Ignored for named palettes. |
| `titleFont` | `AppFont?` | `null` | Falls back to **Cabin** (Google Fonts). Requires `await preloadFont(...)` before `runApp` if not from Google Fonts. |
| `bodyFont` | `AppFont?` | `null` | Falls back to **Fira Sans Condensed** (Google Fonts). Requires `await preloadFont(...)` before `runApp` if not from Google Fonts. |

---

## Returns

`ThemeData` configured with `useMaterial3: true`.

| Function | `Brightness` | Background constant |
|---|---|---|
| `generateLightTheme` | `Brightness.light` | `kLightBackgroundColor` |
| `generateDarkTheme` | `Brightness.dark` | `kDarkBackgroundColor` |

Both configure: tooltip, input decoration, tab bar, dialog, app bar, bottom sheet, divider, scrollbar, slider, checkbox, switch, radio, elevated button, list tile, card, and data table themes.

---

## Supported `theme` values

These names are resolved by `getThemeColor` (`lib/src/helpers/src/get_theme_color.dart`):

| Value | Maps to |
|---|---|
| `'CUSTOM'` | Generated swatch from `mainColor` |
| `'PINK'` | `Colors.pink` |
| `'RED'` | `Colors.red` |
| `'DEEPORANGE'` | `Colors.deepOrange` |
| `'ORANGE'` | `Colors.orange` |
| `'AMBER'` | `Colors.amber` |
| `'YELLOW'` | `Colors.yellow` |
| `'LIME'` | `Colors.lime` |
| `'LIGHTGREEN'` | `Colors.lightGreen` |
| `'GREEN'` | `Colors.green` |
| `'TEAL'` | `Colors.teal` |
| `'CYAN'` | `Colors.cyan` |
| `'LIGHTBLUE'` | `Colors.lightBlue` |
| `'BLUE'` | `Colors.blue` |
| `'INDIGO'` | `Colors.indigo` |
| `'DEEPBLUE'` | `Colors.deepPurple` |
| `'PURPLE'` | `Colors.purple` |
| `'BLUEGREY'` | `Colors.blueGrey` |
| `'GREY'` | `Colors.grey` |
| `'BROWN'` | `Colors.brown` |
| _(any other)_ | Falls back to `kPrimaryColor` swatch |

---

## Related helpers

- `kPrimaryColor` — default primary color (`Color(0xFF001e60)`)
- `kAccentColor` — accent color (`Color(0xFFFF8200)`)
- `kLightBackgroundColor` — light mode scaffold/canvas background
- `kDarkBackgroundColor` — dark mode scaffold/canvas background
- `preloadFont(AppFont)` — async font loader; call before `runApp` for non-Google-Fonts fonts
- `getThemeColor({required String theme, Color color})` — resolves palette name to `MaterialColor`
- `ThemedFontHandler.generateFont(...)` — builds the `TextTheme` from title/body font config
