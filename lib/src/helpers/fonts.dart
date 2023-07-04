part of helpers;

class FoundFont {
  final String titleFont;
  final String textFont;
  final TextTheme textTheme;

  FoundFont({
    required this.titleFont,
    required this.textFont,
    required this.textTheme,
  });
}

/// [getFont] is a helper function to get the font from a name.
/// Will return a [FoundFont] with the font family and the text theme.
/// It's important to note that if the font is not found, it will return the default font. of Layrz
/// - Cabin for titles (From Google Fonts)
/// - Fira Sans Condensed for texts (From Google Fonts)
FoundFont getFonts({
  /// [titleFont] is the name of the titleFont.
  required String titleFont,

  /// [textFont] is the name of the textFont.
  required String textFont,

  /// [isLocalFont] is a boolean to indicate if the font family is a local font.
  bool isLocalFont = false,

  /// [titleTextColor] is the color of the title text.
  required Color titleTextColor,

  /// [isDark] is a boolean to indicate if the theme is dark.
  bool isDark = false,
}) {
  if (isLocalFont) {
    return FoundFont(
      titleFont: titleFont,
      textFont: textFont,
      textTheme: generateTextTheme(
        isDark: isDark,
        titleFontFamily: titleFont,
        textFontFamily: textFont,
        titleTextColor: titleTextColor,
      ),
    );
  }

  try {
    return FoundFont(
      titleFont: titleFont,
      textFont: textFont,
      textTheme: generateTextTheme(
        isDark: isDark,
        titleFontFamily: GoogleFonts.getFont(titleFont).fontFamily!,
        textFontFamily: GoogleFonts.getFont(textFont).fontFamily!,
        titleTextColor: titleTextColor,
      ),
    );
  } catch (e) {
    return FoundFont(
      titleFont: GoogleFonts.cabin().fontFamily!,
      textFont: GoogleFonts.firaSansCondensed().fontFamily!,
      textTheme: generateTextTheme(
        isDark: isDark,
        titleFontFamily: GoogleFonts.cabin().fontFamily!,
        textFontFamily: GoogleFonts.firaSansCondensed().fontFamily!,
        titleTextColor: titleTextColor,
      ),
    );
  }
}

TextTheme generateTextTheme({
  /// [titleFontFamily] is the font family of the title text.
  required String titleFontFamily,

  /// [textFontFamily] is the font family of the text.
  required String textFontFamily,

  /// [titleTextColor] is the color of the title text.
  required Color titleTextColor,

  /// [isDark] is a boolean to indicate if the theme is dark.
  bool isDark = false,
}) {
  final defaultTextTheme = (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;

  return TextTheme(
    displayLarge: defaultTextTheme.displayLarge?.copyWith(
      color: isDark ? Colors.white : titleTextColor,
      fontFamily: titleFontFamily,
      fontFamilyFallback: [
        GoogleFonts.cabin().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    displayMedium: defaultTextTheme.displayMedium?.copyWith(
      color: isDark ? Colors.white : titleTextColor,
      fontFamily: titleFontFamily,
      fontFamilyFallback: [
        GoogleFonts.cabin().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    displaySmall: defaultTextTheme.displaySmall?.copyWith(
      color: isDark ? Colors.white : titleTextColor,
      fontFamily: titleFontFamily,
      fontFamilyFallback: [
        GoogleFonts.cabin().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    headlineLarge: defaultTextTheme.headlineLarge?.copyWith(
      color: isDark ? Colors.white : titleTextColor,
      fontFamily: titleFontFamily,
      fontFamilyFallback: [
        GoogleFonts.cabin().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    headlineMedium: defaultTextTheme.headlineMedium?.copyWith(
      color: isDark ? Colors.white : titleTextColor,
      fontFamily: titleFontFamily,
      fontFamilyFallback: [
        GoogleFonts.cabin().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    headlineSmall: defaultTextTheme.headlineSmall?.copyWith(
      color: isDark ? Colors.white : titleTextColor,
      fontFamily: titleFontFamily,
      fontFamilyFallback: [
        GoogleFonts.cabin().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    titleLarge: defaultTextTheme.titleLarge?.copyWith(
      fontFamily: textFontFamily,
      fontFamilyFallback: [
        GoogleFonts.firaSansCondensed().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    titleMedium: defaultTextTheme.titleMedium?.copyWith(
      fontFamily: textFontFamily,
      fontFamilyFallback: [
        GoogleFonts.firaSansCondensed().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    titleSmall: defaultTextTheme.titleSmall?.copyWith(
      fontFamily: textFontFamily,
      fontFamilyFallback: [
        GoogleFonts.firaSansCondensed().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    bodyLarge: defaultTextTheme.bodyLarge?.copyWith(
      fontFamily: textFontFamily,
      fontFamilyFallback: [
        GoogleFonts.firaSansCondensed().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    bodyMedium: defaultTextTheme.bodyMedium?.copyWith(
      fontFamily: textFontFamily,
      fontFamilyFallback: [
        GoogleFonts.firaSansCondensed().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    bodySmall: defaultTextTheme.bodySmall?.copyWith(
      fontFamily: textFontFamily,
      fontFamilyFallback: [
        GoogleFonts.firaSansCondensed().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    labelLarge: defaultTextTheme.bodySmall?.copyWith(
      fontFamily: textFontFamily,
      fontFamilyFallback: [
        GoogleFonts.firaSansCondensed().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    labelMedium: defaultTextTheme.bodySmall?.copyWith(
      fontFamily: textFontFamily,
      fontFamilyFallback: [
        GoogleFonts.firaSansCondensed().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
    labelSmall: defaultTextTheme.bodySmall?.copyWith(
      fontFamily: textFontFamily,
      fontFamilyFallback: [
        GoogleFonts.firaSansCondensed().fontFamily!,
        'Roboto',
      ],
      overflow: TextOverflow.ellipsis,
    ),
  );
}
