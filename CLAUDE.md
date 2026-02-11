# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**layrz_theme** is a Flutter widget library (published on pub.dev) that implements the Layrz design standard following Material Design 3 guidelines. It provides inputs, layout systems, tables, theme generators, maps, and more. SDK constraints: Dart >=3.10.0, Flutter >=3.38.1.

## Commands

```bash
flutter pub get                          # Install dependencies
flutter analyze                          # Lint (this is what CI runs on PRs)
flutter test                             # Run all tests
flutter test test/color_test.dart        # Run a single test file
```

**Example app:**
```bash
cd example && flutter pub get && flutter run
```

## Architecture

### Module System

The library is organized as a set of sub-libraries under `lib/src/`. Each module directory contains a barrel file (e.g., `inputs.dart`, `layout.dart`) that uses Dart's `library` + `part` directives to compose its implementation files. The top-level `lib/layrz_theme.dart` re-exports all sub-libraries.

**To add a new widget to an existing module:** create the implementation file in the appropriate subdirectory, then add a `part` directive in the module's barrel file.

### Key Modules

| Module | Purpose |
|--------|---------|
| `inputs/` | Form inputs (text, number, select, pickers, code editor, etc.) — largest module (~95 part files) |
| `layout/` | App shell with multiple navigation styles (sidebar, dual bar, mini, bottom nav), breadcrumbs, AppBar |
| `theme/` | Light/dark Material 3 theme generation, color constants, font config via Google Fonts |
| `table2/` | Advanced data table with sorting, filtering, multi-select, infinite scroll, controller pattern |
| `extensions/` | Extension methods on Color, DateTime, Widget, String |
| `helpers/` | Utilities for shadows, avatars, colors, file handling |
| `map/` | Flutter Map integration with toolbar and controls |
| `colorblindness/` | Color blindness simulation filters (6 modes with adjustable strength) |

### Patterns

- **Responsive breakpoints:** `kExtraSmallGrid` (600), `kSmallGrid` (960), `kMediumGrid` (1264), `kLargeGrid` (1904) — used with `LayoutBuilder` throughout.
- **Theme colors:** `kPrimaryColor` (#001e60), `kAccentColor` (#FF8200).
- **State management:** Uses `layrz_state` package. Example app has `AppStore` for theme/colorblind mode.
- **Platform-conditional imports:** File handling uses `if (dart.library.js_interop)` for web vs native.
- **Input pattern:** Widgets accept optional external `FocusNode`/`TextEditingController`; only internally-created controllers are disposed.
- **Enum-based styling:** Components use style enums (e.g., `ThemedButtonStyle`, `ThemedInputStyle`) for variant selection.

## Code Style

- Formatter: 120-char page width, trailing commas preserved (`analysis_options.yaml`)
- Linter: `flutter_lints` package
- Use modern Dart dot shorthand syntax

## CI

- PRs to `main`, `next`, `development` run `flutter analyze` and `flutter test` (Flutter 3.38.8 stable)
- Test results published as check run + PR comment with summary
- Version tags (`v*.*.*`) trigger publish to pub.dev and deploy example to GitHub Pages
