# Changelog

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
  * FYI, we only support the Monthly calendar, if you want to help us to support the other calendars, please, feel free to open a MR, help is always welcome.
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
