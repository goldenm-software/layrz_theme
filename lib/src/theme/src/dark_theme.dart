part of '../theme.dart';

/// [generateDarkTheme] is a helper function to generate a [ThemeData] with the
/// [Brightness.dark] theme.
/// Will receive the following arguments:
ThemeData generateDarkTheme({
  /// [theme] is the theme of the app. The supported colors comes from Layrz API.
  /// By default, it is `"CUSTOM"`.
  String theme = "CUSTOM",

  /// [mainColor] is the primary color of the app. Only used if [theme] is `"CUSTOM"`.
  /// By default, it is [kPrimaryColor].
  Color mainColor = kPrimaryColor,

  /// [titleTextFontFamily] is the font family of the title text.
  /// By default, it is Cabin. (Google Font)
  /// To use a local font (Any other different to any available in Google Fonts), you should change the
  /// argument [isLocalFont] to `true`.
  @Deprecated('This property will not work, use `titleFont` instead') String titleTextFontFamily = "Cabin",

  /// [textFontFamily] is the font family of the text.
  /// By default, it is Fira Sans Condensed. (Google Font)
  /// To use a local font (Any other different to any available in Google Fonts), you should change the
  /// argument [isLocalFont] to `true`.
  @Deprecated('This property will not work, use `bodyFont` instead') String textFontFamily = "Fira Sans Condensed",

  /// [isLocalFont] is a boolean to indicate if the font family is a local font.
  /// By default, it is `false`.
  @Deprecated('This property will not work, check out `titleFont` and `bodyFont`') bool isLocalFont = false,

  /// [titleFont] is the font of the title text.
  /// By default, uses `Cabin` from `Google Fonts`.
  /// If your source is different than Google Fonts, you should use `preloadFont` to load the font.
  /// For example: ```dart
  /// void main() async {
  ///   await preloadFont(AppFont()); // Repeat this line for both title and body fonts
  /// }
  /// ```
  AppFont? titleFont,

  /// [bodyFont] is the font of the text.
  /// By default, uses `Fira Sans Condensed` from `Google Fonts`.
  /// If your source is different than Google Fonts, you should use `preloadFont` to load the font.
  /// For example: ```dart
  /// void main() async {
  ///   await preloadFont(AppFont()); // Repeat this line for both title and body fonts
  /// }
  /// ```
  AppFont? bodyFont,
}) {
  MaterialColor color = getThemeColor(
    theme: theme,
    color: mainColor,
  );
  TextTheme textTheme = ThemedFontHandler.generateFont(
    isDark: true,
    titleFont: titleFont,
    bodyFont: bodyFont,
    titleTextColor: Colors.white,
  );

  return ThemeData.from(
    textTheme: textTheme,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: color, brightness: Brightness.dark).copyWith(
      primary: Colors.white,
      onPrimary: kDarkBackgroundColor,
      surface: kDarkBackgroundColor,
      onSurface: Colors.white,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  ).copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kDarkBackgroundColor,
    dialogBackgroundColor: kDarkBackgroundColor,
    primaryColor: color,
    canvasColor: kDarkBackgroundColor,
    shadowColor: Colors.black.withOpacity(0.3),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: kDarkBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      textStyle: textTheme.bodySmall?.copyWith(
        color: kLightBackgroundColor,
        fontSize: 12,
      ),
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: Colors.grey.shade800,
      border: const ThemedInputBorder(),
      labelStyle: TextStyle(
        color: Colors.grey.shade400,
      ),
      suffixIconColor: Colors.grey.shade300,
      suffixStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 15,
      ),
      prefixIconColor: Colors.grey.shade300,
      prefixStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 15,
      ),
    ),

    // Tab Bar
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey.shade500,
    ),

    // Dialog
    dialogTheme: const DialogTheme(
      backgroundColor: kDarkBackgroundColor,
      surfaceTintColor: kDarkBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),

    // Header / AppBar
    secondaryHeaderColor: color,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        // Changes the status bar colors and buttons (Top)
        statusBarColor: kDarkBackgroundColor, // Android Only
        statusBarIconBrightness: Brightness.light, // Android Only
        statusBarBrightness: Brightness.dark, // iOS Only

        // Changes the navigation bar colors and buttons
        systemNavigationBarColor: kDarkBackgroundColor, // Android only
        systemNavigationBarDividerColor: kDarkBackgroundColor, // Android only
        systemNavigationBarIconBrightness: Brightness.light, // Android only
      ),
      color: kDarkBackgroundColor,
      surfaceTintColor: kDarkBackgroundColor,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
    ),

    // Bottom Navigation Bar / Bottom sheet theme
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    ),

    // Divider
    dividerColor: Colors.grey.shade800,
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade800,
      thickness: 1,
      space: 3,
      indent: 0,
      endIndent: 0,
    ),
    scrollbarTheme: ScrollbarThemeData(
      trackVisibility: MaterialStateProperty.all(true),
      thumbVisibility: MaterialStateProperty.all(true),
      thumbColor: MaterialStateColor.resolveWith((states) {
        return Colors.grey.shade500.withOpacity(0.4);
      }),
      trackColor: MaterialStateProperty.all(Colors.transparent),
      trackBorderColor: MaterialStateProperty.all(Colors.transparent),
      thickness: MaterialStateProperty.all(7),
    ),

    // Inputs
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return Colors.grey.shade700;
      }),
      checkColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.black;
        }
        return Colors.transparent;
      }),
      mouseCursor: MaterialStateMouseCursor.clickable,
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white.withOpacity(0.7);
        }
        return Colors.grey.shade500;
      }),
      thumbColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return Colors.grey.shade300;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return Colors.grey.shade700;
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
      ),
    ),
    listTileTheme: ListTileThemeData(
      selectedTileColor: color.withOpacity(0.3),
      selectedColor: color,
    ),
    cardTheme: const CardTheme(
      color: kDarkBackgroundColor,
      surfaceTintColor: kDarkBackgroundColor,
    ),
    dataTableTheme: const DataTableThemeData(
      decoration: BoxDecoration(
        boxShadow: [],
        borderRadius: BorderRadius.zero,
      ),
    ),
  );
}
