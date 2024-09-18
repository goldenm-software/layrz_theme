# Changelog

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
