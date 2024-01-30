part of '../../map.dart';

/// [ThemedMapEvent] is the base class for all events in the map.
abstract class ThemedMapEvent {}

class StartGoogleStreetView extends ThemedMapEvent {
  /// [StartGoogleStreetView] is the event that starts the drag marker animation
  /// to set the street view position.
  StartGoogleStreetView();

  @override
  String toString() => 'ThemedMapEvent/StartGoogleStreetView()';
}

class StopGoogleStreetView extends ThemedMapEvent {
  /// [StopGoogleStreetView] is the event that stops the drag marker animation
  /// to set the street view position.
  StopGoogleStreetView();

  @override
  String toString() => 'ThemedMapEvent/StopGoogleStreetView()';
}
