part of '../../map.dart';

typedef ThemedMapControllerListener = void Function(ThemedMapEvent event);

class ThemedMapController {
  /// [_listeners] is a list of listeners of the controller.
  final List<ThemedMapControllerListener> _listeners = [];

  /// [addListener] adds a new listener to the controller.
  void addListener(ThemedMapControllerListener listener) {
    _listeners.add(listener);
  }

  /// [removeListener] removes a listener from the controller.
  void removeListener(ThemedMapControllerListener listener) {
    _listeners.remove(listener);
  }

  /// [notify] notifies all listeners of the controller.
  void notify(ThemedMapEvent event) {
    for (ThemedMapControllerListener listener in _listeners) {
      listener(event);
    }
  }
}
