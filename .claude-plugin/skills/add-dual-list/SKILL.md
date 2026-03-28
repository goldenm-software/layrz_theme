---
name: add-dual-list
description: Add a ThemedDualListInput to a layrz Flutter form or tab. Use when wiring a new list field from any layrz Input class (e.g. LocatorInput, AssetInput) into any widget — a tab, a form view, or any stateful/stateless widget.
---

## Task

Wire a new list field into any widget in a layrz Flutter package using `ThemedDualListInput`.

The user must tell you:
- The **Input class** and the **field name** (e.g. `LocatorInput.poisIds`)
- The **item model** whose list will be displayed (e.g. `Poi`)
- The **target widget** where the dual list should appear (a tab file, a form view, or any other widget)
- The **parent** that owns the Input object and must pass the item list down (if different from the target widget)

If any of these are unclear, ask before proceeding.

## Steps

### 1. Resolve the correct package version

1. Read `pubspec.lock` in the project root and find the resolved version of the package that contains the Input class (e.g. `layrz_models: 3.6.24`).
2. Locate the pub cache:
   - Default on Linux/macOS: `~/.pub-cache/hosted/pub.dev/<package>-<version>/`
   - Default on Windows: `%LOCALAPPDATA%\Pub\Cache\hosted\pub.dev/<package>-<version>/`
   - If the versioned directory is not found at either default path, ask the user for the pub cache location before continuing.
3. Confirm the directory name exactly matches the resolved version from `pubspec.lock` — do not read a different version.

### 2. Read the Input class field

Inside the resolved package directory, locate the Input class source file and confirm:
- The exact field name (e.g. `poisIds`)
- Its type (`List<String>`)

Check the item model (e.g. `Poi`) for the properties used in the selector — typically `id` and `name`.

### 2. Add the list parameter to the target widget

In the target widget class, add:

```dart
final List<ModelType> items;  // e.g. final List<Poi> pois
```

Add it to the constructor as `required`.

### 3. Add ThemedDualListInput inside the build method

Place it at the appropriate position, preceded by `const SizedBox(height: 10)` if other widgets are already present:

```dart
const SizedBox(height: 10),
ThemedDualListInput(
  labelText: context.i18n.t('<i18n.key>'),
  value: object.<fieldName>,
  items: items.map((item) => ThemedSelectItem(value: item.id, label: item.name)).toList(),
  errors: context.getErrors(key: '<fieldName>'),
  onChanged: (values) {
    object.<fieldName> = values.map((e) => e.value).nonNulls.toList();
    if (context.mounted) onChanged.call();
  },
),
```

### 4. Wire the list through the parent(s)

For each widget in the chain between the data source and the target widget:

1. **Args class** (e.g. `LocatorsFormArgs`) — add `final List<ModelType> items` and the constructor parameter if it isn't already there.
2. **Stateful parent** — add `late final List<ModelType> items`, assign it from args in `initState`, and pass it down to the child widget.
3. **If the target is a tab** — pass it in the `ThemedTab` child constructor call.
4. **If the target is the form view itself** — use it directly from the state.

### 5. Verify

```bash
flutter analyze <changed files>
```

No issues = done.

## Key conventions

- Use `nonNulls` to filter nulls: `values.map((e) => e.value).nonNulls.toList()`
- Always guard `onChanged` with `if (context.mounted)`
- i18n key typically follows `<entity>.<fieldName>` (e.g. `locators.poisIds`)
- Line width limit is **120 characters**
- Never use raw Material widgets — always use `layrz_theme` components
- Always derive the package version from `pubspec.lock`, never guess or use the latest available directory in the cache
