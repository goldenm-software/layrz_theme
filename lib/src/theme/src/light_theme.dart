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
    primaryColor: color,
    canvasColor: kLightBackgroundColor,
    shadowColor: Colors.black.withValues(alpha: 0.3),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
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
      dividerColor: Colors.transparent,
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
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: kLightSystemUiOverlayStyle,
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
    dividerColor: Colors.black.withValues(alpha: 0.1),
    dividerTheme: DividerThemeData(
      color: Colors.black.withValues(alpha: 0.1),
      thickness: 1,
      space: 3,
      indent: 0,
      endIndent: 0,
    ),
    scrollbarTheme: ScrollbarThemeData(
      trackVisibility: WidgetStateProperty.all(true),
      thumbVisibility: WidgetStateProperty.all(true),
      thumbColor: WidgetStateColor.resolveWith((states) {
        return Colors.black.withValues(alpha: 0.4);
      }),
      trackColor: WidgetStateProperty.all(Colors.transparent),
      trackBorderColor: WidgetStateProperty.all(Colors.transparent),
      thickness: WidgetStateProperty.all(7),
    ),

    // Slider
    sliderTheme: SliderThemeData(
      activeTrackColor: color,
      inactiveTrackColor: Colors.grey.shade300,
      thumbColor: color,
      overlayColor: color.withValues(alpha: 0.3),
      valueIndicatorColor: color,
      valueIndicatorTextStyle: textTheme.bodySmall?.copyWith(
        color: kLightBackgroundColor,
      ),
      trackHeight: 2,
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 10,
      ),
      overlayShape: const RoundSliderOverlayShape(
        overlayRadius: 20,
      ),
    ),

    // Inputs
    checkboxTheme: CheckboxThemeData(
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return color;
        return Colors.transparent;
      }),
      checkColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return validateColor(color: color);
        return Colors.transparent;
      }),
      overlayColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) return Colors.grey.shade200;
        return Colors.transparent;
      }),
      mouseCursor: WidgetStateMouseCursor.clickable,
      side: BorderSide(
        color: Colors.grey.shade500,
        width: 2,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbIcon: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Icon(LayrzIcons.solarOutlineCheckCircle);
        return Icon(LayrzIcons.solarOutlineCloseCircle);
      }),
      trackOutlineWidth: const WidgetStatePropertyAll(1),
      trackColor: WidgetStateColor.resolveWith((states) {
        return Colors.transparent;
      }),
      thumbColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return color;
        return Colors.grey;
      }),
      trackOutlineColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return color;
        return Colors.grey;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
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
      selectedTileColor: color.withValues(alpha: 0.3),
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
