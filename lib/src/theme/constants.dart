part of layrz_theme;

/// [kExtraSmallGrid] is the extra small grid size.
const double kExtraSmallGrid = 600;

/// [kSmallGrid] is the small grid size.
const double kSmallGrid = 960;

/// [kMediumGrid] is the medium grid size.
const double kMediumGrid = 1264;

/// [kLargeGrid] is the large grid size.
const double kLargeGrid = 1904;

/// [kPrimaryColor] is the main color of Layrz branding.
const Color kPrimaryColor = Color(0xff001e60);

/// [kAccentColor] is the accent/alternative color of Layrz branding.
const Color kAccentColor = Color(0xffFF8200);

/// [kLightBackgroundColor] is the background color of the app when [Brightness.light].
const Color kLightBackgroundColor = Color(0xffFCFCFC);

/// [kDarkBackgroundColor] is the background color of the app when [Brightness.dark].
const Color kDarkBackgroundColor = Color.fromARGB(255, 40, 40, 40);

/// [kAppTitle] is the title of the app.
const String kAppTitle = "Layrz";

/// [kHoverDuration] is the standard duration for animations.
const kHoverDuration = Duration(milliseconds: 100);

/// [kListViewPadding] is the suggested padding of the [ListView] widget.
/// Corrects the padding for iOS
EdgeInsets? get kListViewPadding {
  if (kIsWeb) return null;
  if (Platform.isIOS) return EdgeInsets.zero;
  return null;
}
