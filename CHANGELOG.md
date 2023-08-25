# Changelog

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
