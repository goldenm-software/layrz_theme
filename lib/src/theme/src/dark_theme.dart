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
      dividerColor: Colors.transparent,
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
      systemOverlayStyle: kDarkSystemUiOverlayStyle,
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
      trackVisibility: WidgetStateProperty.all(true),
      thumbVisibility: WidgetStateProperty.all(true),
      thumbColor: WidgetStateColor.resolveWith((states) {
        return Colors.grey.shade500.withOpacity(0.4);
      }),
      trackColor: WidgetStateProperty.all(Colors.transparent),
      trackBorderColor: WidgetStateProperty.all(Colors.transparent),
      thickness: WidgetStateProperty.all(7),
    ),

    // Inputs
    checkboxTheme: CheckboxThemeData(
      visualDensity: VisualDensity.compact,
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return Colors.transparent;
      }),
      checkColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return Colors.transparent;
      }),
      overlayColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) return Colors.grey.shade200;
        return Colors.transparent;
      }),
      mouseCursor: WidgetStateMouseCursor.clickable,
      side: const BorderSide(color: Colors.grey, width: 2),
    ),
    switchTheme: SwitchThemeData(
      thumbIcon: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Icon(LayrzIcons.solarOutlineCheckSquare, color: color);
        return Icon(LayrzIcons.solarOutlineCloseSquare, color: color);
      }),
      trackColor: WidgetStateColor.resolveWith((states) {
        return Colors.transparent;
      }),
      thumbColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return Colors.grey;
      }),
      trackOutlineColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return Colors.grey;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
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
