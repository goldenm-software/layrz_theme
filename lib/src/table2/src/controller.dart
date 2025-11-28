part of '../table2.dart';

typedef ThemedTable2ControllerListener = void Function(ThemedTable2Event event);

class ThemedTable2Controller<T> {
  ThemedTable2Controller();

  final List<ThemedTable2ControllerListener> _listeners = [];

  void addListener(ThemedTable2ControllerListener listener) {
    _listeners.add(listener);
  }

  void removeListener(ThemedTable2ControllerListener listener) {
    _listeners.remove(listener);
  }

  void clearListeners() {
    _listeners.clear();
  }

  void sort({
    int columnIndex = 0,
    bool ascending = true,
  }) {
    for (var listener in _listeners) {
      listener(ThemedTable2SortEvent<T>(columnIndex: columnIndex, ascending: ascending));
    }
  }

  void refresh() {
    for (var listener in _listeners) {
      listener(ThemedTable2RefreshEvent());
    }
  }

  void dispose() {
    clearListeners();
  }
}
