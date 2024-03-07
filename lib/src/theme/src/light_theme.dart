part of '../theme.dart';

/// [generateLightTheme] is a helper function to generate a [ThemeData] with the
/// [Brightness.light] theme.
/// Will receive the following arguments:
ThemeData generateLightTheme({
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
  bool isIOS = !kIsWeb && Platform.isIOS;

  MaterialColor color = getThemeColor(
    theme: theme,
    color: mainColor,
  );

  TextTheme textTheme = ThemedFontHandler.generateFont(
    isDark: false,
    titleFont: titleFont,
    bodyFont: bodyFont,
    titleTextColor: Colors.black,
  );

  // isDark ? const Color(0x1FFFFFFF) : const Color(0x1F000000);
  return ThemeData.from(
    textTheme: textTheme,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: color, brightness: Brightness.light).copyWith(
      onPrimaryContainer: kLightBackgroundColor,
      onSurface: kLightBackgroundColor,
    ),
    useMaterial3: true,
  ).copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: kLightBackgroundColor,
    dialogBackgroundColor: kLightBackgroundColor,
    primaryColor: color,
    canvasColor: kLightBackgroundColor,
    shadowColor: Colors.black.withOpacity(0.3),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: color,
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
      fillColor: Colors.grey.shade200,
      border: const ThemedInputBorder(),
      labelStyle: TextStyle(
        color: Colors.grey.shade600,
      ),
      suffixIconColor: Colors.grey.shade500,
      suffixStyle: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 15,
      ),
      prefixIconColor: Colors.grey.shade500,
      prefixStyle: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 15,
      ),
    ),

    // Tab Bar
    tabBarTheme: TabBarTheme(
      labelColor: color,
      unselectedLabelColor: Colors.grey.shade700,
    ),

    dialogTheme: const DialogTheme(
      backgroundColor: kLightBackgroundColor,
      surfaceTintColor: kLightBackgroundColor,
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
        statusBarColor: color,
        statusBarIconBrightness: isIOS
            ? Brightness.light
            : useBlack(color: color)
                ? Brightness.dark
                : Brightness.light,
        statusBarBrightness: isIOS
            ? Brightness.light
            : useBlack(color: color)
                ? Brightness.dark
                : Brightness.light,

        // Changes the navigation bar colors and buttons
        systemNavigationBarColor: color,
        systemNavigationBarDividerColor: color,
        systemNavigationBarIconBrightness: isIOS
            ? Brightness.light
            : useBlack(color: color)
                ? Brightness.dark
                : Brightness.light,
      ),
      color: kLightBackgroundColor,
      surfaceTintColor: kLightBackgroundColor,
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
    dividerColor: Colors.black.withOpacity(0.1),
    dividerTheme: DividerThemeData(
      color: Colors.black.withOpacity(0.1),
      thickness: 1,
      space: 3,
      indent: 0,
      endIndent: 0,
    ),
    scrollbarTheme: ScrollbarThemeData(
      trackVisibility: MaterialStateProperty.all(true),
      thumbVisibility: MaterialStateProperty.all(true),
      thumbColor: MaterialStateColor.resolveWith((states) {
        return Colors.black.withOpacity(0.4);
      }),
      trackColor: MaterialStateProperty.all(Colors.transparent),
      trackBorderColor: MaterialStateProperty.all(Colors.transparent),
      thickness: MaterialStateProperty.all(7),
    ),

    // Inputs
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return color;
        }
        return Colors.grey.shade700;
      }),
      checkColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return validateColor(color: color);
        }
        return Colors.transparent;
      }),
      mouseCursor: MaterialStateMouseCursor.clickable,
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return color.withOpacity(0.7);
        }
        return Colors.grey.shade500;
      }),
      thumbColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return color;
        }
        return Colors.grey.shade300;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return color;
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
      color: kLightBackgroundColor,
      surfaceTintColor: kLightBackgroundColor,
    ),
    dataTableTheme: const DataTableThemeData(
      decoration: BoxDecoration(
        boxShadow: [],
        borderRadius: BorderRadius.zero,
      ),
    ),
  );
}
