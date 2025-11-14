# Changelog

## 7.5.0 (BETA)

- Updated constraint of Dart SDK to `>=3.10.0 <4.0.0`
- Updated constraint of Flutter SDK to `>=3.38.0`
- Dot shorthands everywhere!
- Added `ThemedTable2Controller` to handle programmatically sorting, filtering and refreshing the table data.
- Added `debounce` property to `ThemedSearchInput` to handle debounced search inputs.
- Improvements over `ThemedImage` base64 caching to prevent memory leaks.
- Updated `ThemedChip` to support more styles and configurations.
- New `ThemedChipStyle` enum to define the style of the `ThemedChip`.
- New `ThemedChipGroup` widget to handle groups of chips with selection support.

## 7.4.12

- Changed `ThemedButton` loading and disabled behavior to use the original coloring of the button style instead of from context.

## 7.4.11

- Added `padding` prop to `ThemedDateTimePicker` to handle the padding of the input field.

## 7.4.10

- New `ThemedTabStyle` enum to define the style of the `ThemedTabView` tabs.

## 7.4.9

- Add `additionalWidgets` in `ThemedTabView`.

## 7.4.8

- Updated design of `ThemedButton` to support new styling when loading or in cooldown.
- Added factory on `ThemedButton.legacyLoading` to support the previous loading design.

## 7.4.7

- Added `customConfirm` and `customDismiss` parameters to the `deleteConfirmationDialog` utility.

## 7.4.6+1

- Fix on filtering items on `ThemedTable2` when it's empty.

## 7.4.6

- Fixed an issue with the `ThemedTable2` where the filtering was not working correctly after the last changes.
- Changed behavior on `dispose()` on `ThemedTextInput` to only dispose the internal controller and focus node when they are not provided externally.

## 7.4.5

- Added `initialPosition` and `onTabIndex` in `ThemedTabView`

## 7.4.4

- Solved extremely weird bug using the `ThemedTable2`, now creates a copy of the items list to prevent issues when filtering and sorting the data. (Discovered by @ManuelRomeroA)

## 7.4.3

- Added `ThemedTable2OnTapBehavior` enum to define the default behavior of onTap events on table cells.

## 7.4.2

- Added `notifier` and other props on `ThemedActionButton` to support dynamic coloring, labeling and iconing of the button based on the notifier.

## 7.4.1

- Fix visual issues on `ThemedCalendar` when you select a date outside of the current month

## 7.4.0+2

- Added `locatorLink` function on LML language and `ThemedCodeEditor`.

## 7.4.0+1

- Fixed dispose of `_zoomListenable` in `ThemedMapToolbar` to prevent memory leaks when an external `ValueNotifier` is not provided.

## 7.4.0

- Stable release of 7.4.0 with all the prerelease changes included.

## 7.4.0-prerelease10

- Fixed an issue with the `assert` in `ThemedTable2` that was causing issues when `multiselectActions` is empty and `hasMultiselect` is false.

## 7.4.0-prerelease9

- Some optimizations on `ThemedTable2`, and some props that supports development environment tools.

## 7.4.0-prerelease8

- Changes on `ThemedCheckboxInput` to support a more compact design when used `ThemedCheckboxInputStyle.asField`.
- Changed default value of `ThemedCheckboxInput.style` to `ThemedCheckboxInputStyle.asFlutterCheckbox` instead of `ThemedCheckboxInputStyle.asCheckbox2` to avoid some issues of performance on high number of checkboxes.

## 7.4.0-prerelease7

- Updated `ThemedDurationInput` to be precise on sizing, and allow two col selectors

## 7.4.0-prerelease6

- Changed behavior of multiselection on `ThemedTable2`, now will use internally also the `ValueNotifier` to handle the selected items.

## 7.4.0-prerelease5

- Added external `ValueNotifier` support to `ThemedMapToolbar` to listen to zoom changes externally.
- New `VxStateUtilsMixin` to handle `VxState` changes in a more generic way.

## 7.4.0-prerelease4

- Added multi selection support to `ThemedTable2` with `ValueNotifier` to handle the selected items.
- Updates on `ThemedSnackbar` to prevent issues with multiple snackbars in the queue.

## 7.4.0-prerelease3

- Added multi selection support to `ThemedTable2` with actions
- Fixes on `ThemedMapToolbar` to prevent oversize.

## 7.4.0-prerelease2

- Massive changes on `ThemedTable2` to improve performance and reduce the number of `setState`s.
- Changes on `ThemedMapToolbar` to now depend on `AnimatedMapController` from `flutter_map_animations`.

## 7.4.0-prerelease1

- Small adjustments on `ThemedTable2` to prevent actions to be non `onlyIcon`
- Renamed from `additionalActions` to `actionsBuilder` on `ThemedTable2` to be more descriptive

## 7.4.0-beta1

- Fix generateContainerElevation in dark mode
- Add `ThemedTable2` with `ThemedColum2` to support infinity items

## 7.3.12

- Updated `ThemedPlatform` to use `defaultTargetPlatform` instead of `Platform` to prevent issues on native builds.
- Added `useViewInsetsBottom` property to `ThemedSnackbarMessenger` to allow the snackbar to consider the virtual keyboard height when showing the snackbar on mobile devices.

## 7.3.11

- Removed dependency on `flutter_map_cancellable_tile_provider` due to deprecation
- Updated `flutter_map` to `8.2.1` and updated `ThemedTileLayer` accordingly

## 7.3.10

- Rework `ThemedSelectInput` to support `canUnselect`, `returnNullOnClose` and `autoClose`

## 7.3.9

- Added new property `onSearchChanged` in `ThemedTable` component

## 7.3.8

- Added a condition in the `Themed SelectInput` where the deselect scenario is considered

## 7.3.7

- Adjusted `ThemedTextInput` dense padding to adjust top label padding.

## 7.3.6

- Added `iconSeparatorSize` prop to `ThemedButton`

## 7.3.5

- Added `ThemedNavigatorWidget` to the `ThemedNavigatorItem` class elements to allow full custom widgets to be added.

## 7.3.4

- Updated

## 7.3.3

- add `isDense` in `ThemedTimePicker`

## 7.3.2

- Added `hidePrefixSuffixActions` prop on `ThemedNumberInput` and removed unused `readonly` prop.

## 7.3.1

- Fixed behavior of `ThemedTextInput` multiple prefixes or suffixes, now will display correctly.

## 7.3.0

- Stable release

## 7.3.0-rc.2

- Removed a `debugPrint` from `ThemedSnackbarMessenger`

## 7.3.0-rc.1

- Release candidate 1

## 7.3.0-beta.12

- Added `itemExtend` to `ThemedDualListInput`, `ThemedSelectInput` and `ThemedMultiSelectInput` to set the item extend of the lists.

## 7.3.0-beta.11

- Added `ThemedAlertType.custom` to support custom colors and icons in `ThemedAlert` and `ThemedAlertIcon`.
- Added `ThemedAlertStyle.filledIcon` to support a filled icon style in `ThemedAlert`.
- Added `iconSize` on `ThemedAlert` to control the size of the icon in the alert.

## 7.3.0-beta.10

- Modified `ThemedSnackbar` to use a new format of visualization, now will be displayed the first item of a queue.
- Some changes on input styling to be more consistent with the other inputs.

## 7.3.0-beta.9

- Added `padding` prop to `ThemedChip` to handle the padding of the chip.

## 7.3.0-beta.8

- Added `ThemedChip` to display a chip with a custom message and color.

## 7.3.0-beta.7

- Added new widget `ThemedAlert` to display an alert with a custom message.
- Added new widget `ThemedAlertIcon` to display the icon using the Layrz Standard Alert styling.

## 7.3.0-beta.6

- Changes on `ThemedButton` related to `RichText` rendering.
- Changed size of `ThemedButton` to `46u` instead of `40u`.
- Fixes on `ThemedAvatar` to support `ClipRect` instead of trust on the `clipBehavior` of the `Container`.
- Modified extension `ThemedColorExtensions` to use getters with combination of the methods.

## 7.3.0-beta.5

- Updated dependencies to latest

## 7.3.0-beta.4

- Changes on shadows on `ThemedLayout`.
- Changes on `ThemedScaffoldView`.

## 7.3.0-beta.3

- Increasing the size from `35u` to `46u` on the `ThemedButton` to be more consistent with the Material 3 design.
- Increased horizontal padding from `10u` to `20u` on the `ThemedButton` to be more consistent with the Material 3 design.
- Modified `actionsPadding` on `ThemedActionsButtons` to add by default a left padding of `5u`.
- Updated `ThemedCalendar` to display the selected dates like `ThemedButtonStyle.filledTonal` instead of `ThemedButtonStyle.filled`.
- Updated row height of `ThemedTable` to `50u` due to the new button size.
- Added extension of `BuildContext` to get pre-defined text styles.

## 7.3.0-beta.2

- Updated `generateContainerElevation()` design to use `Colors.black.withValues(alpha: 0.1)` instead of shadow color.
- Modified `generateContainerElevation()` elevation visualization to be more smooth.

## 7.3.0-beta.1

- Required changes applied to support Flutter 3.32.0

## 7.2.13

- Added a way to keep the tab position when the `tabs` is resizing on `ThemedTabView`.

## 7.2.12

- Added `maximumDecimalDigits` prop to `ThemedNumberInput` to allow to increase the number of decimal digits.
- Fixed `ThemedNumberInput` cursor behaviour to improve experience when typing numbers.

## 7.2.11

- Added arrows to `ThemedTabView` to move horizontally between tabs.

## 7.2.10

- Added `customTitle` and `customContent` options to `deleteConfirmationDialog`.

## 7.2.9

- Fixed `ThemedTable` to use the correct ellipsis on `richTextBuilder`.

## 7.2.8

- Upgraded flutter_map to latest version (v8.1.1)

## 7.2.7

- Fixed use of `context.mounted` on `ThemedTable` that was causing `onMultiDelete` to not be called correctly.

## 7.2.6

- Added Color Blind modes

## 7.2.5

- Fixed `ThemedSelectInput` use of `didUpdateWidget` causing it to call the onchanged callback twice
- Fixed `ThemedTextInput` handling of `didUpdateWidget` causing the change of value to not be reflected in the widget

## 7.2.4

- Fixes Dio() response handling on `ThemedTileLayer`

## 7.2.3

- Fixed on `ThemedNumberInput` to support negative values when writing.

## 7.2.2

- add `WidgetsBinding` inside `ThemedDatePicker`

## 7.2.1

- Downgraded intl version due to a flutter_localizations incompatibility

## 7.2.0

- Flutter 3.27 update
- Final removal of @Deprecated warnings
- Removed `ThemedLicensesView` in favor of `showThemedAboutDialog` and `ThemedAboutDialog`

## 7.1.10

- Updated README.md

## 7.1.9

- Fixes related to `_focusNode.dispose()` on `ThemedSelectInput` and `ThemedMultiSelectInput` widgets.

## 7.1.8

- Fixed displayed value on `ThemedDurationInput`

## 7.1.7

- New `ThemedSnackbar` design.

## 7.1.6

- Bug fixes on multiple selects' widgets, now will display correctly the selected value.

## 7.1.5

- Added `richTextBuilder` to `ThemedColumn` to allow to build a `RichText` widget instead of a `Text` or `Widget`.

## 7.1.4

- Added `enableBreadcumb` property on `ThemedLayout` to disable globally the breadcumb on the layout
- New property `enableBreadcumb` to replace `showHeaderInSidebarMode` on `ThemedNavigatorPage` to disable the breadcumb on the page
- Marked as deprecated and scheduled to removal on version 8.0.0 the property `showHeaderInSidebarMode` on `ThemedNavigatorPage`
- Added `breadcumbPadding` on `ThemedLayout` to handle the padding of the breadcumb more accurately

## 7.1.3

- Fixed an issue with `saveFile` on Web, `dart:html` was fully removed and replaced with `package:js` to handle the file saving on Web.

## 7.1.2

- Changed `dart.library.html` to `dart.library.js_interop` to fully support WASM SharedArrayBuffer

## 7.1.1

- Changed most of `MdiIcons.*` to `LayrzIcons.*` to use the new icon library `layrz_icons`.

## 7.1.0

- Changed icon library from `material_design_icons_flutter` to `layrz_icons`
- Changed `drawAvatar()` in favor to `ThemedAvatar` on multiple utilities on `layrz_theme`
- Updated `mime` dependency to `2.0.0`
- Changed dependencies to use the `^` format instead of the constraint `>=` and `<=`
- Testings on Flutter 3.24.5
- Moved the cursor movement declared on `ThemedTextInput` used on the `ThemedNumberInput` to the right component to prevent issues with non-roman writing systems (Like Korean, Japanese, Chinese, etc.).

## 7.0.10

- Fixed `ThemedNumberInput` `maximum` and `minimum` values to react on the add and minus buttons

## 7.0.9

- Fixed `ThemedSnackbar` not visible on apps when keyboard is open

## 7.0.8

- Adjustments on `ThemedLayoutStyle.mini`, now the content will be with a `SafeArea`.

## 7.0.7

- Design adjustments of `ThemedLayout` and sub-widgets.
- Some small fixes related to the `ThemedTable`.

## 7.0.6

- New button styles `ThemedButtonStyle.outlinedTonal` and `ThemedButtonStyle.outlinedTonalFab`

## 7.0.5

- Added `decimalSeparator` and `inputRegExp` on `ThemedNumberInput` to support Brazilian decimal format.

## 7.0.4

- Changed `generateContainerElevation` to receive `elevation` as a `double` instead of `int`
- New component `ThemedAvatar` as replacement of the utility function `drawAvatar`
- Deprecated `drawAvatar` utility function in favor of `ThemedAvatar`
- Deprecated `getImage` in favor of `ThemedImage`
- Added `onTap`, `onLongTap` and `onSecondaryTap` to `ThemedAvatar` to handle tap gestures on the avatar.

## 7.0.3

- Added a swipe gestur for `ThemedSnackbar` to dismiss the snackbar
- Updated the `ThemedSnackbar` display mode, on mobile devies in portrait, will display the snackbar full width and at the bottom of the screen.

## 7.0.2

- Changed `ThemedBottomBar` background color on `Theme.of(context).brightness == Brightness.dark`, now the color of the component will be `Theme.of(context).scaffoldBackgroundColor` instead of `Theme.of(context).primaryColor`.
- Changed many utility functions to use `ThemedPlatform.is*` instead of `Platform.is*` to avoid issues with complex conditions.
- Added `ThemedPlatform.is*` that is a shortcut of `kThemedPlatform == ThemedPlatform.*`.
- Added `ThemedPlatform.isWebWasm` to check if the platform is built in WebAssembly.
- Applied same correction of `ThemedBottomBar` on `ThemedSidebar`.
- New utility function `overrideAppBarStyleWithColor` to override the app bar style with a specific color instead of use the `Theme.of(context).brightness` to determine if is dark mode or light mode and override the app bar style.

## 7.0.1

- Upgraded `flutter_map` and their dependencies to `v7`
- Added number format to `ThemedNumberInput` to format the number visually in the input field
- Disabled Google Street View on `ThemedTileLayer` due to issues with the `flutter_map` package

## 7.0.0

- web package threshold changed to `web: ^1.0.0`

## 6.0.8

- Fixed issues with `ThemedTable` on Mobile mode
- Fixed issue with app bar style (Notification tray) when the theme is changed.
- Fixed an issue related to the `ThemedBottomBar` on iOS, the `SafeArea` generates an overflow on the bottom bar.

## 6.0.7

- Fixed spelling on `searchableAttributes`

## 6.0.6

- Added `searchableAtributes` to `ThemedSelectItem`
- Changes to improve `ThemedDualListInput` search and sorting

## 6.0.5

- Add `keyboardType` as a prop with default `TextInputType.number` inside `ThemedNumberInput`

## 6.0.4

- Fixes related to some overflow on `ThemedColumn` rendering on `ThemedTable`.

## 6.0.3

- Fixed avatar tooltip orientation on the `ThemedMiniBar` and `ThemedBottomBar`

## 6.0.2

- Fixes related to paginator and automatic fit detection

## 6.0.1

- Fixed an issue with the fixed columns on `ThemedTable`

## 6.0.0

- Checkboxes' colors corrected to display white when the app is in dark mode, also changed the design of the switches
- Fixed sorting of IDs in `ThemedTable`.
- Fixes related to ID column width on `ThemedTable`.
- Changed `ThemedTable` to use the package `two_dimensional_scrollables` to handle multiple scrollables in the table.
- Added property `disablePaginator` to `ThemedTable` to disable the paginator.
- Fixed Actions column on `ThemedTable` to show the actions correctly.
- Fixed multi selection, id and the first column on `ThemedTable`, you can change it using the `fixedColumnsCount` property.
- Fixed `MainAxisAligment.spaceBetween` on `deleteConfirmationDialog`. Now will show the buttons with the correct spacing.

## 5.0.19

- Add a flag to know if the User change `_itemsPerPage` in `ThemedTable`.

## 5.0.18

- Replaced `ThemedTextInput` for a native `TextField` to display the search input when `asField` is `true` en `ThemedSearchInput`.

## 5.0.17

- Added `asField` and `inputPadding` props in `ThemedSearchInput` to change the display of the search input.
- Finally! Fixed the issue related to the `ThemedTable` and an unexpected horizontal scroll. Now, the table will not show the horizontal scroll when the content is less than the width of the table.
- Fixes on `ThemedDateRangePicker` and `ThemedDateTimeRangePicker` to focus on selection instead of today.

## 5.0.16

- Added `dialogConstraints` in `ThemedMultiSelectInput`.

## 5.0.15

- Added `ThemedDynamicConfigurableBlock` to handle dynamic blocks of credentials or dynamic fields.

## 5.0.14

- Added `onDayNextMonthTap` and `onDayPreviousMonthTap` props to `ThemedCalendar` component

## 5.0.13

- Addded `height` prop to `ThemedButton` to change the default height of the button.

## 5.0.12

- Fixed `ThemedTable` not showing the `additionalActions` when the `onShow` or `onEdit` or `onDelete` is not provided.

## 5.0.11

- Changed button style to use a new rounded style, now the styling is rouned square instead of rounded circle.
- Fixed issues with the `ThemedSnackbar` and `ThemedDynamicAvatarInput`, now should work correctly.
- Adapted design of `ThemedCalentar` to follow the Layrz design standard.

## 5.0.10

- Upgraded `flutter_map` to 6.2.1 and their dependencies.

## 5.0.9 (RETRACTED)

- Retracted due to issues with the `flutter_map` package and polygon layers.
- Upgraded `flutter_map` to 7.0.0 and their dependencies.
- Disabled (Temporarily) the `ThemedStreetViewDialog` due to the changes in the `flutter_map` package.

## 5.0.8

- Added `separatorPadding`to `ThemedTabView` to handle the padding between the `TabBar` and the `TabBarView`.

## 5.0.7

- New widget `ThemedTabView` to handle a combination of `TabBar` and `TabBarView` in a single widget.
- New prop `child` on `ThemedTab` to handle a custom child widget. Only used in the new `ThemedTabView`.

## 5.0.6

- Bug fix related to `ThemedMiniBar`, now will not show the `additionalActions` in the bar.

## 5.0.5

- Fixed an issue with `ThemedBottomBar` when does not have `items` and `persistentItems`.

## 5.0.4

- Fixes on `ThemedActionButton` to prevent unnecesary `Padding`
- Now, `ThemedActionsButtons` receives a new argument `actionsPadding` to handle the padding of the actions. By default is `EdgeInsets.zero`

## 5.0.3

- Removed `titleTextFontFamily`, `textFontFamily` and `isLocalFont` from `generateLightTheme()` and `generateDarkTheme()` in favor of `titleFont` and `bodyFont`.
- Removed deprecated class `ThemedFileInput` in favor of `ThemedFilePicker`.
- Removed all `@Deprecated` warnings in the package.
- Constant `kListViewPadding` modified to return `EdgeInsets.zero` in native platforms.
- New mobile layout mode `ThemedMobileLayoutStyle.bottomBar` (New default). The previous mobile layout design uses `ThemedMobileLayoutStyle.appBar`. You can change the mobile layout using the `mobileLayoutStyle` prop in the `ThemedLayout` widget.
- Added `isDisabled` to `ThemedActionButton` to handle disable property.
- New pre-designed buttons `ThemedActionButton.save`, `ThemedActionButton.cancel`, `ThemedActionButton.info`, `ThemedActionButton.show`, `ThemedActionButton.edit`, `ThemedActionButton.delete`
- Changed design of `onlyIcon: true` in `ThemedActionButton`, now use `ThemedButtonStyle.filledTonalFab` instead of `ThemedButtonStyle.fab`
- Fully removal of `ThemedDialog` and sub-dependencies.
- Removed `_getChildrenUrls()` from `ThemedLayout`, now each sub-layout style will handle the children URLs.

## 5.0.2

- Changed `_getChildrenUrls()` invoke in `ThemedLayout`, now use `WidgetsBinding.instance.addPostFrameCallback` to prevent issues with the `initState`.

## 5.0.1

- Moved the `ThemedDateTimeRangePicker` internal dialog to an external dialog to use in other widgets.

## 5.0.0

- Added support for Flutter 3.22.0 (Tested)
- New pre-designed buttons `ThemedButton.save`, `ThemedButton.cancel`, `ThemedButton.info`, `ThemedButton.show`, `ThemedButton.edit`, `ThemedButton.delete`
- Deprecated layout style `ThemedLayoutStyle.modern`
- Renamed `ThemedLayoutStyle.sidebar` to `ThemedLayoutStyle.dual`
- New `ThemedLayoutStyle.mini` to replace the deprecated `ThemedLayoutStyle.modern`
- Removed `ThemedAvatarInput` widget
- Design changes of `ThemedDualListInput` to unify the design with the other pickers and fields
- Changed actions buttons of `ThemedSelectInput`, `ThemedMultiSelectInput` and `ThemedColorPicker`. Now instead of using a classic `ThemedButton`, will use `ThemedButton.save` and `ThemedButton.cancel`
- Redesigned list of icons of `ThemedIconPicker` and `ThemedDynamicAvatarInput` to use `ListView.builder` instead of `GridView.builder`
- Added `SizeTransition` to `ThemedSidebar` to animate the expansion and collapse of the sidebar items

## 4.3.57

- Enabled optional field `textStyle` on `ThemedTextInput`

## 4.3.56

- Fixes in `select_input.dart` & `multiselect_input.dart`, bug in scroll function on lists

## 4.3.55

- Fixes related to `ThemedLayoutStyle.sidebar`, the Page name now will be displayed inside of a `SafeArea` widget.

## 4.3.54

- Bugfix on `ThemedImage` SVG support

## 4.3.53

- Added support for SVG images in `ThemedImage` utility.

## 4.3.52

- Changed `kLogoWidth` from `2000` to `2800`.

## 4.3.51

- Changed `favicon` to `logo` in the `ThemedDrawer`.
- Changed aspectRatio of the logos in the `ThemedLayout` and sub-widgets to use `kLogoAspectRatio`.
- Added upper constraint on flutter version from `3.19.3` to `4.0.0`.

## 4.3.50

- Fixes related to the `SystemUIOverlayStyle` to handle correctly the status bar and navigation bar colors on Android and iOS.

## 4.3.49

- Changed behavior of `disabledColor` on `ThemedButton` to change depending of the button style to allow better readability.

## 4.3.48

- Fixes on `ThemedAppBarAvatar` related to `padding` in the `OverlayEntry` used to display the actions in the avatar icon.

## 4.3.47

- Fixes on `ThemedDrawer` related to onTap action

## 4.3.46

- Add `autoFocus` inside `ThemedSearchInput`.
- Fix overFlow inside `ThemedTable` and build a new paginator to very small devices
- Update layrz_models to v2.1.11
- Update ci

## 4.3.45

- Fixes related on Android status bar and Navigation bar colors on `ThemedLayout`.
- Added shadow on `ThemedDrawer` only in mobile mode.
- Fixes related on iOS status bar color on `ThemedLayout`.

## 4.3.44

- Updated permission handler to 11.3.0

## 4.3.43

- Updated `google_fonts` package due to a issues with the previous version.
- Linter cleanup

## 4.3.42

- Added `ThemedInputBorder` to prevent rendering issues with Flutter 3.19 changes on `OutlinedInputBorder`.
- Changed `RawKeyboardListener` to `KeyboardListener` to support Flutter 3.19

## 4.3.41

- Add a prop `dialogContraints` for default it is `BoxConstraints(maxWidth: 500, maxHeight: 500)`.

## 4.3.40

- Add a sort in `ThemedDateRangePicker` .

## 4.3.39

- Changed workflow of the `layers` in `ThemedTileLayer` to prevent subdivisions in the list of selection.

## 4.3.38

- Fixed issue with `ThemedNotificationIcon` in `ThemedLayout`, now when you use `ThemedLayoutStyle.modern`, the icon should only appear in the `ThemedTaskbar`, also, in mobile mode, the icon only will appear in the `ThemedAppBar` and the `ThemedDrawer` will not have the icon.

## 4.3.37

- Updated `ThemedNotificationItem` to display the `at`.
- Updated `ThemedNotificationIcon` to use the native `Badge` widget to display an indicator.

## 4.3.36

- Added `padding` prop in `ThemedDurationInput`, `ThemedDynamicAvatarInput`, `ThemedMultiSelectInput`, `ThemedNumberInput`, `ThemedSelectInput`, `ThemedTextInput`, `ThemedDateRangePicker`, `ThemedDateTimeRangePicker`, `ThemedColorPicker`, `ThemedEmojiPicker`, `ThemedFileInput`, `ThemedIconPicker`, `ThemedMonthRangePicker`, `ThemedTimeRangePicker`.

- Defined new static getter on `ThemedTextInput` to standarize the padding on most of the inputs and pickers

## 4.3.35

- Fix overflow in `ThemedDrawer` exactly when actions are `ThemedNavigatorAction`

## 4.3.34

- Redesigned `ThemedCodeEditor` to works with other library and prevent issues with `setState` and `markNeedsBuild` when the widget is disposed.

## 4.3.33

- Fixed `persistentItems` not showing on `ThemedTaskbar` when the `ThemedLayout` is `ThemedLayoutStyle.modern`

## 4.3.32

- Adjusted design of `ThemedCalendar`

## 4.3.31

- Major improvement on `ThemedLayout` and sub-widgets.
- Added a state listener on `ThemedTooltip` to prevent sticky tooltips when the widget is disposed or unfocused.

## 4.3.30

- Added additional padding based on depth in `ThemedNavigatorItem` and subclasses on `ThemedDrawer` to improve the visual hierarchy of the items.
- Changed the paginator style from `#` to represent the page to `#/#` to represent the current page and the total pages in `ThemedTable<T>`.

## 4.3.29

- Fixed `disabled` prop on `ThemedCodeEditor`

## 4.3.28

- Added PointerInterceptor Library

- Added `PointerInterceptor` widget to improve the navigation through dialogs in `utility.dart`

## 4.3.27

- Fixed bug of fonts in `generateDarkTheme()`, now will use the `titleFont` and `bodyFont` correctly.

## 4.3.26

- Changed typography of `titleLarge`, `titleMedium` and `titleSmall` from `bodyFont` to `titleFont`

## 4.3.25

- Added `ThemedOrm` access through `BuildContext` using an extension.
- New way to load fonts over network, locally or from Google Fonts.
- Deprecation warnings over `titleTextFontFamily`, `textFontFamily` and `isLocalFont` in favor of `titleFont` and `bodyFont` in `generateLightTheme()` and `generateDarkTheme()`
- New `ThemedFontHandler` to handle `preloadFont` and `generateFont` to load fonts over network, locally or from Google Fonts.

## 4.3.24

- Added scroll to `ThemedCodeEditor`

## 4.3.23

- Fixed an issue in `ThemedCodeEditor` to prevent the cursor re-position when the widget is updated.

## 4.3.22

- Redefined the error handling on `ThemedCodeEditor` to use a local class instead of `LintError` from `layrz_models`.

## 4.3.21

- New `ThemedCodeEditor` with standarized styling.
- Removed support for `LayrzSupportedLanguage.dart`.
- Added `run` and `lint` buttons to `ThemedCodeEditor`.

## 4.3.20

- New widget `ThemedStreetViewDialog` to display a Google Street View.
- New props in `ThemedMapToolbar` and `ThemedTileLayer` to handle Google Street View.
- New event controller called `ThemedMapController` to handle events from the map. (Does not use Streams or somethnig like that)

## 4.3.19

- Fixed issue in `ThemedMapToolbar` to prevent drawing of `Divider` or `VerticalDivider` when the buttons and fixed buttons are empty.

## 4.3.18

- Updated `ThemedTileLayer.reservedAttributionHeight` to consider the spacing required by the attributions.

## 4.3.17

- Forcing Google Maps, HERE Maps and Mapbox Maps attributions by static URLs.

## 4.3.16

- Removed `headers` on `ThemedTileLayer`, only will use when the layer is Google Maps.

## 4.3.15

- Inclues changes defined in `4.3.15-preview1`
- Inclues changes defined in `4.3.15-preview2`
- Inclues changes defined in `4.3.15-preview3`

## 4.3.15-preview3

- Corrections about Attributions of Mapbox Maps in `ThemedTileLayer`.

## 4.3.15-preview2

- Optimized `ThemedTileLayer` to use `CancellableNetworkTileProvider` (from `flutter_map_cancellable_tile_provider`) to improve performance and reduce memory usage.
- Setted `panBuffer` and `keepBuffer` to 0 due a performance testing results (Is the better option for now).

## 4.3.15-preview1

- Optmized `ThemedTooltip` to use `OverlayPortal` instead of a custom `Overlay` widget.
- New widget `ThemedTileLayer`, designed to be used in `FlutterMap` widget (from `flutter_map`) to display a tile layer using the `MapLayer` model (from `layrz_models`).
- New widget `ThemedMapToolbar`, designed to be used in `FlutterMap` widget (from `flutter_map`) to display a toolbar with some actions to control the map.

## 4.3.14

- Changed `containerColor` override of `drawAvatar` utility.
- Changed `shadowColor` override of `drawAvatar` utility.

## 4.3.13

- Added `actionsOffset` on `ThemedActionButtons` to choose a custom overlay position
- Added extension `ThemedHumanizeDuration` to `Duration` to humanize the duration. This extension is based on the package `humanize_duration` but fixing some errors and adding some features.
- Undeprecated `translations` on `ThemedCalendar`

## 4.3.12

- Added `customExtensions` as a prop on `ThemedFilePicker` to support custom extensions for the file picker.
- Added `globalMimeResolver` to resolve custom mime types and extensions.

## 4.3.11

- Fixed `ThemedSearchInput` not keeping cursor position when typing, and set so themed table sets page to 0 when searching.

## 4.3.10

- Added optional prop `showCooldownRemainingDuration` to `ThemedButton` to hide the cooldown remaining duration text.

## 4.3.9

- Some corrections in `ThemedTooltip` to prevent the tooltip to be displayed when the widget is disposed.

## 4.3.8

- Adjusted visual drawing of `_drawHeader` in `ThemedTable<T>`.

## 4.3.7

- Re-enabled `onTap` from `ThemedColumn<T>` in `ThemedTable<T>`.

## 4.3.6

- Changed all part's to use uri instead
- Updated `google_fonts` and `file_picker` to newer versions
- Some improvements in `ThemedTable<T>` management to simplify the way that the translated messages are handled
- Applied the same translation logic to `ThemedCalendar`.

## 4.3.5

- Removed `LayoutBuilder` in `ThemedButton`
- New widget `ThemedDialog` to handle/standarize the dialogs in the app.

## 4.3.4

- Fixed `ThemedTable<T>` width calculation when `additionalActions` is being used.

## 4.3.3

- Changed `ThemedTable<T>` border colors, now use `Theme.of(context).dividerColor` instead of `Colors.grey.shade300`
- Some fixes related to `drawAvatar`.

## 4.3.2

- Added `context` in `ThemedSnackbar` to backward compatibility with `@Deprecated` warning.

## 4.3.1

- New `ThemedSnackbar` to show a snackbar with a custom messenger called `ThemedSnackbarMessenger`. Now you can show a snackbar from anywhere in the app only calling `ThemedSnackbarMessenger.of(context).showSnackbar(...)`.
- Deprecated void functions `showThemedSnackbar` and `setThemedSnackbarScaffoldKey` in favor of the new `ThemedSnackbarMessenger` and `ThemedSnackbar` widgets.
- Updated `ThemedDynamicCredentialsInput` to support `ThemedNumberInput` instead of `ThemedTextInput`.

## 4.3.0

- Refactorized buttons to reduce the number of `setState`s and improve the performance of the widgets.
- Refactorized table to reduce the number of `setState`s and improve the performance of the widgets.
- Removed "mobile" mode from the table, now, the table will always use the "desktop" mode, aka, the table will always use the horizontal scroll.
- Deprecated `rowAvatarBuilder`, `rowTitleBuilder`, `rowSubtitleBuilder`, `mobileRowHeight`, `initialPage`, `enablePaginator`, `itemsPerPage`, `paginatorLeading`, `paginatorTrailing`, `onPageChanged` and `shouldExpand` from the `ThemedTable<T>` widget.
- Added `rowsPerPage` and `availableRowsPerPage` to the `ThemedTable<T>` widget to control the number of rows per page.

## 4.2.10

- Fix a logic to show index of `ThemedTablet<T>`

## 4.2.9

- Added new widget to represent the first index and the last index of the items in `ThemedTable<T>`

## 4.2.8

- GitHub Actions Tests (Nothing relevant for the end-user)

## 4.2.7

- Migrated repository from GitLab to GitHub

## 4.2.6

- Added new parameter `texAlign` to `ThemedCalendarEntry` and `ThemedCalendarRangeEntry` to change alignment in the `title`

## 4.2.5

- Added optional parameter `disableBlink` to `ThemedTimePicker` and `ThemedTimeRangePicker` to disable blinking of the inputs in the dialog
- Fixed a bug on the `ThemedTimePicker` and `ThemedTimeRangePicker` dialog in which the increase and decrease buttons were not updating the state of the widget

## 4.2.4

- Removed paginator from `ThemedTable<T>` in mobile mode.

## 4.2.3

- Major change in `ThemedTable<T>` to handle dynamic columns and rows. Also, changes to horizontal scrolling inside of the table.

## 4.2.2

- Add on `ThemedCalendar` additionalButtons of `ThemedButton`.

## 4.2.1

- Fixed `ThemedMonthRangePicker` to handle one-click action to pick only one month in `consecutive` mode.

## 4.2.0

- Added suport for Flutter 3.13.5
- Fixed background color on Flutter styled Checkbox for changes in Flutter 3.13.5

## 4.1.22

- Fix `ThemedCalendar` days

## 4.1.21

- Added Linux support for `saveFile` and `pickFile`

## 4.1.20

- Updated `ThemedDualListInput` to handle `errors`
- Updated `ThemedTab` to handle `color`
- Updated `ThemedFieldDisplayError` to change the padding of the error text

## 4.1.19

- Added `errors` and `hideDetails` on some pickers

## 4.1.18

- Fixed a bug where the 12 hour date format in AM PM will display as 0

## 4.1.17

- New widget `ThemedTab`

## 4.1.16

- Fixes on `ThemedActionsButtons`, now will use `onTap ?? onPressed` instead of only `onPressed` to handle the tap gesture.

## 4.1.15

- Fixed `ScrollbarThemeData` on `generateLightTheme()` and `generateDarkTheme()` to use a specific color.

## 4.1.14

- Fixed `ThemedCalendar` whene generate a `ThemedCalendarEntry`

## 4.1.13

- Fixed `ThemedTooltip` to destroy inmediatly when the widget is disposed.

## 4.1.12

- Fixed `ThemedDualListInput` search field, the bug filters the available list instead of the selected list.

## 4.1.11

- Fixed `ThemedSelectInput` to prevent return null when is dismissed
- Added `ThemedTooltip` property `color` to overrides the color of the tooltip
- Updated position of the tooltip of the buttons in `ThemedTable` to be on the left side of the button
- Deprecation notice of `onPressed` callback in `ThemedActionButton`

## 4.1.10

- Fixes on `ThemedPageBuilder`

## 4.1.9

- Updated `ThemedPageBuilder` to supports return value from the `builder` function.

## 4.1.8

- New widget `ThemedCodeSnippet` to display snippets with an integrated copy-to-clipboard button.

## 4.1.7

- Fixed some errors with the display in the `ThemedDrawer` in nested pages.
- Expandend documentation of `ThemedTable` to explain how to use some builders and related.
- Fixed `ThemedSelectInput` update when the object from outside comes null, before, the selected value was not updated.

## 4.1.6

- Fixed conditional import for `pickFile` and `saveFile` to support web.

## 4.1.5

- Updated all pickers to support hover, splash and highlight colors' proerties when customChild is submitted.
- Updated `ThemedSelectInput` and `ThemedMultiSelectInput` to support
- Re-documented all widgets to standarize the format of the documentation.
- Updated `README.md`

## 4.1.4

- Correction on `ThemedTextInput`, now you can set the `position` of the combobox choices. By default will always display below the `ThemedTextInput` widget.

## 4.1.3

- In all Pickers, now you can submit a `customWidget` to overrides the default `ThemedTextInput`-like widget.
- New page transition `ThemedPageBuilder` to help to create a page transition with a fade animation. The main difference with `ThemedPageTransition` is that `ThemedPageBuilder` allows to use a custom `builder` to build the page, and `ThemedPageTransition` only allows to use a `child` widget, basically you can return something.
- Renamed widget `ThemedFileInput` to `ThemedFilePicker`, to backward compatibility, we added an alias to `ThemedFileInput` to `ThemedFilePicker` with a dart deprecation warning.

## 4.1.2

- Hotfix on `ThemedSelectInput` and `ThemedDualListInput`.

## 4.1.1

- New page builder called `ThemedPageTransition` to help to create a page transition with a fade animation.
- Updated `ThemedSelectInput` and `ThemedMultiSelectInput` to comply with the new schema of pickers.
- Updated `ThemedDualListInput` to comply with the new schema of apps. Also, now will append new items when is updated.

## 4.1.0

- New widget `ThemedTooltip`, basically it's an a re-invention of the `Tooltip` widget, provides the option to change the spawn position of the tooltip, and prevents the issue with the default `Tooltip` widget related to the tap gesture, allowing to use any gesture on the child widget.
- Updated the structure logic of the `ThemedLayout` and layout-related widgets, now, the shadows will overlap correctly.
- Updated `generateLightTheme()` and `generateDarkTheme()` with `Tooltip` theme.
- Replaced `Tooltip` for `ThemedTooltip` in the `ThemedButton` widget.
- Added the property `useDefaultRedirect` on the `ThemedNavigatorPage`, basically allows to push the parent page of the nested pages when is `true`, when is `false` will push the first page of the nested pages.
- Updated `ThemedColorPicker` to support multiple pickers from the package `flex_color_picker`.
- Migrated `ThemedDurationInput` from an `Overlay` to a `Dialog`.
- Updated `ThemedTextInput` to support `choices` to work like a combobox.
- New widget `ThemedNumberInput`, basically is a `ThemedTextInput` with a `num` of return.
- New widget `ThemedCalendar` and helper classes `ThemedCalendarEntry` and `ThemedCalendarRangeEntry`.
  - FYI, we only support the Monthly calendar, if you want to help us to support the other calendars, please, feel free to open a MR, help is always welcome.
- New widgets `ThemedMonthPicker` and `ThemedMonthRangePicker`.
- New widgets `ThemedDatePicker` and `ThemedDateRangePicker`.
- New widgets `ThemedTimePicker` and `ThemedTimeRangePicker`.
- Updated widgets `ThemedDateTimePicker` and `ThemedDateTimeRangePicker` to new picker format (From custom Overlay to Dialog).
- Updated widgets `ThemedAvatarPicker`, `ThemedColorPicker`, `ThemedEmojiPicker` and `ThemedIconPicker` to new picker format (From custom Overlay to Dialog).

## 4.0.25

- Fixed toggle theme on `ThemedLayout` and `additionalActions` when `ThemedLayoutStyle` is `ThemedLayoutStyle.sidebar`

## 4.0.24

- Improved UX in `ThemedDualListInput` when selecting all while searching

## 4.0.23

- Fixed `ThemedTable` table mode (Desktop) to show the dividers correctly

## 4.0.22

- Added `customSortingFunction` to `ThemedColumn` allowing to sort the values of the column using a custom function

## 4.0.21

- Changes on Layout widgets to support correctly the System UI Overlay on Android and iOS
- Added loaders to `drawAvatar` and `ThemedImage`

## 4.0.20

- Updated shadow color on the `generateLightTheme` y `generateDarkTheme` to `Colors.black.withOpacity(0.3)`
- Added `Layo`

## 4.0.19

- Improvements in `ThemedLayout` and layout-related widgets, now will consider `MediaQuery.of(context).padding` to the fixed overlays' locations.

## 4.0.18

- Some hotfixes in `ThemedLayout` and layout-related widgets

## 4.0.17

- Added `currentPath` to overrides the currentPath on Layout

## 4.0.16

- Added support on `ThemedLayout` and layout-related widgets to use different `pushNamed()` and `pop()` navigator methods. (Basically can support go_router)

## 4.0.15

- Added `elevation`, `shadowColor` and `reverse` properties to `drawAvatar()`
- Updated functionality of `color` property on `drawAvatar()`, now will apply to `dynamicAvatar`
- Updated documentation of `reverse` on `generateContainerElevation()`

## 4.0.14

- Corrections on Text size prediction in `ThemedSnackbar`, should not overflow the text.

## 4.0.13

- Updated `width` for `ThemedSnackbar`, now, for screens with width mess than `500u` will expand to the full width of the screen

## 4.0.12

- Added `disableNotifications` to `ThemedAppBar` to disable notification icon.

## 4.0.11

- New helper functions `saveFile` and `pickFile` to help in the process to save a file or get a files from the device.

## 4.0.10

- Added the option to disable `SafeArea` inside a child of the `ThemedLayout`
- Added the possibility to change the padding of the child inside of the `ThemedLayout`

## 4.0.9

- Fixed `ThemedNotificationIcon` to handle Dynamic Island (And hopefully any `SafeArea` padded segment)

## 4.0.8

- Adjusted status bar color when the `ThemedDrawer` is opened or closed.

## 4.0.7

- New function `setThemedSnackbarScaffoldKey` to set a `GlobalKey<ScaffoldState>` to the `ThemedSnackbar`.
- `ThemedSnackbar` now will use as primary context the `GlobalKey<ScaffoldState>` setted before, otherwise, will use the provided `BuildContext` in the constructor.

## 4.0.6

- Added default empty text for Notifications and reduced size of the logo on `ThemedAppBar`
- Added name of the page in the `ThemedLayoutStyle.sidebar` as a "Fake AppBar"

## 4.0.5

- Fixes on design on Android

## 4.0.4

- New widget `ThemedLayout` to unify `ThemedAppBar`, `ThemedDrawer` and `ThemedTaskbar` using a unified Layrz style
- Internal file organization updated to a sub-libraries schema

## 4.0.3

- Fixed `ThemedTable` actions having no divider
- Added shadow color to `ThemedDrawer` elements

## 4.0.2

- Modified constraints for `file`, `collection` and `google_fonts` to accomplish pub points warnings

## 4.0.1

- Fixes related to pub points
- Added new style for buttons `ThemedButtonStyle.filledFab` to accomplish the buttons of Material You

## 4.0.0

- Initial public release
