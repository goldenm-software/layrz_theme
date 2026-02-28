import 'package:flutter/foundation.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzl;
import 'package:flutter_timezone/flutter_timezone.dart';

export 'package:timezone/standalone.dart' show Location;

/// [initializeTimeZone] is a stub that should be implemented in platform-specific code to initialize the timezone data.
Future<void> initializeTimeZone() async {
  debugPrint('layrz_utils/timezone: Initializing timezone data');
  try {
    await tz.initializeTimeZone('https://cdn.layrz.com/resources/utils/timezones-2025.tzf');
  } catch (err) {
    debugPrint(
      'layrz_utils/timezone: Error initializing timezone data from Layrz CDN, falling back to built-in data',
    );
    tzl.initializeTimeZones();
  }
  return Future.value();
}

/// [getTimezone] is a stub that should be implemented in platform-specific code to get the current timezone.
Future<tz.Location> getTimezone() async {
  debugPrint('layrz_utils/timezone: Getting current timezone');
  final tzinfo = await FlutterTimezone.getLocalTimezone();
  return tz.getLocation(tzinfo.identifier);
}

/// [setTimezone] is a stub that should be implemented in platform-specific code to set the timezone.
Future<void> setTimezone(tz.Location timezone) {
  final pre = DateTime.now().toIso8601String();
  tz.setLocalLocation(timezone);
  final post = tz.TZDateTime.now(timezone).toIso8601String();
  debugPrint('layrz_utils/timezone: Timezone changed from $pre to $post');
  return Future.value();
}

/// [castTimezone] converts a timezone string to a [Location] object. If the input is null or invalid,
/// it defaults to the device's timezone.
Future<tz.Location> castTimezone(String? timezone) async {
  if (timezone == null) return await getTimezone();
  try {
    return tz.getLocation(timezone);
  } catch (e) {
    debugPrint('layrz_utils/timezone: Invalid timezone "$timezone", defaulting to browser timezone');
    return await getTimezone();
  }
}

/// [getTimezones] gets the list of available timezones
List<tz.Location> getTimezones() => tz.timeZoneDatabase.locations.values.toList();
