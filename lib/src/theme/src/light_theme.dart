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
  MaterialColor color = getThemeColor(theme: theme, color: mainColor);

  TextTheme textTheme = ThemedFontHandler.generateFont(
    isDark: false,
    titleFont: titleFont,
    bodyFont: bodyFont,
    titleTextColor: Colors.black,
  );

  // isDark ? const Color(0x1FFFFFFF) : const Color(0x1F000000);
  return ThemeData.from(
    textTheme: textTheme,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: color,
      brightness: .light,
    ).copyWith(onPrimaryContainer: kLightBackgroundColor, onSurface: kLightBackgroundColor),
    useMaterial3: true,
  ).copyWith(
    brightness: .light,
    scaffoldBackgroundColor: kLightBackgroundColor,
    primaryColor: color,
    canvasColor: kLightBackgroundColor,
    shadowColor: Colors.black.withValues(alpha: 0.3),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: color,
        borderRadius: .circular(5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 5, offset: const Offset(0, 3))],
      ),
      textStyle: textTheme.bodySmall?.copyWith(color: kLightBackgroundColor, fontSize: 12),
    ),
    // Input
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const .all(10),
      filled: true,
      fillColor: Colors.grey.shade200,
      border: const ThemedInputBorder(),
      labelStyle: TextStyle(color: Colors.grey.shade600),
      suffixIconColor: Colors.grey.shade500,
      suffixStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
      prefixIconColor: Colors.grey.shade500,
      prefixStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
    ),

    // Tab Bar
    tabBarTheme: TabBarThemeData(
      labelColor: color,
      unselectedLabelColor: Colors.grey.shade700,
      dividerColor: Colors.transparent,
    ),

    dialogTheme: const DialogThemeData(
      backgroundColor: kLightBackgroundColor,
      surfaceTintColor: kLightBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: .all(.circular(10))),
    ),

    // Header / AppBar
    secondaryHeaderColor: color,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: kLightSystemUiOverlayStyle,
      backgroundColor: kLightBackgroundColor,
      surfaceTintColor: kLightBackgroundColor,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
    ),

    // Bottom Navigation Bar / Bottom sheet theme
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: .vertical(top: .circular(20))),
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
      trackVisibility: .all(true),
      thumbVisibility: .all(true),
      thumbColor: .resolveWith((states) {
        return Colors.black.withValues(alpha: 0.4);
      }),
      trackColor: .all(Colors.transparent),
      trackBorderColor: .all(Colors.transparent),
      thickness: .all(7),
    ),

    // Slider
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.grey.shade700,
      inactiveTrackColor: Colors.grey.shade300,
      thumbColor: color,
      overlayColor: color.withValues(alpha: 0.1),
      valueIndicatorColor: color,
      valueIndicatorTextStyle: textTheme.bodySmall,
      trackHeight: 2,
      trackShape: const RectangularSliderTrackShape(),
      thumbShape: RoundedRectangleSeekbarShape(),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 17),
    ),

    // Inputs
    checkboxTheme: CheckboxThemeData(
      visualDensity: .compact,
      shape: RoundedRectangleBorder(borderRadius: .circular(5)),
      fillColor: .resolveWith((states) {
        if (states.contains(WidgetState.selected)) return color;
        return Colors.transparent;
      }),
      checkColor: .resolveWith((states) {
        if (states.contains(WidgetState.selected)) return validateColor(color: color);
        return Colors.transparent;
      }),
      overlayColor: .resolveWith((states) {
        if (states.contains(WidgetState.hovered)) return Colors.grey.shade200;
        return Colors.transparent;
      }),
      mouseCursor: WidgetStateMouseCursor.clickable,
      side: BorderSide(color: Colors.grey.shade500, width: 2),
    ),
    switchTheme: SwitchThemeData(
      thumbIcon: .resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Icon(LayrzIcons.solarOutlineCheckCircle);
        return Icon(LayrzIcons.solarOutlineCloseCircle);
      }),
      trackOutlineWidth: const WidgetStatePropertyAll(1),
      trackColor: .resolveWith((states) {
        return Colors.transparent;
      }),
      thumbColor: .resolveWith((states) {
        if (states.contains(WidgetState.selected)) return color;
        return Colors.grey;
      }),
      trackOutlineColor: .resolveWith((states) {
        if (states.contains(WidgetState.selected)) return color;
        return Colors.grey;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: .resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return color;
        }
        return Colors.grey.shade700;
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: color, elevation: 0)),
    listTileTheme: ListTileThemeData(selectedTileColor: color.withValues(alpha: 0.3), selectedColor: color),
    cardTheme: const CardThemeData(color: kLightBackgroundColor, surfaceTintColor: kLightBackgroundColor),
    dataTableTheme: const DataTableThemeData(
      decoration: BoxDecoration(boxShadow: [], borderRadius: .zero),
    ),
  );
}
