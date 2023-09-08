part of theme;

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
  String titleTextFontFamily = "Cabin",

  /// [textFontFamily] is the font family of the text.
  /// By default, it is Fira Sans Condensed. (Google Font)
  /// To use a local font (Any other different to any available in Google Fonts), you should change the
  /// argument [isLocalFont] to `true`.
  String textFontFamily = "Fira Sans Condensed",

  /// [isLocalFont] is a boolean to indicate if the font family is a local font.
  /// By default, it is `false`.
  bool isLocalFont = false,
}) {
  bool isIOS = !kIsWeb && Platform.isIOS;
  MaterialColor color = getThemeColor(
    theme: theme,
    color: mainColor,
  );
  FoundFont fonts = getFonts(
    titleFont: titleTextFontFamily,
    textFont: textFontFamily,
    isLocalFont: isLocalFont,
    titleTextColor: Colors.white,
    isDark: true,
  );

  return ThemeData.from(
    textTheme: fonts.textTheme,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: color, brightness: Brightness.dark).copyWith(
      primary: Colors.white,
      onPrimary: kDarkBackgroundColor,
      surface: kDarkBackgroundColor,
      onSurface: Colors.white,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  ).copyWith(
    useMaterial3: true,
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
      textStyle: fonts.textTheme.bodySmall?.copyWith(
        color: kLightBackgroundColor,
        fontSize: 12,
      ),
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: Colors.grey.shade800,
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
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
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        // Changes the status bar colors and buttons (Top)
        statusBarColor: kDarkBackgroundColor,
        statusBarIconBrightness: isIOS ? Brightness.dark : Brightness.light,
        statusBarBrightness: isIOS ? Brightness.dark : Brightness.light,

        // Changes the navigation bar colors and buttons
        systemNavigationBarColor: kDarkBackgroundColor,
        systemNavigationBarDividerColor: kDarkBackgroundColor,
        systemNavigationBarIconBrightness: isIOS ? Brightness.dark : Brightness.light,
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
      thumbColor: MaterialStateColor.resolveWith((states) {
        return Colors.grey.shade700.withOpacity(0.4);
      }),
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
