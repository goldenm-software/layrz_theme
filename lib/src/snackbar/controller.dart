part of layrz_theme;

class ThemedSnackbarController {
  /// [ThemedSnackbarController] is the controller for the [ThemedSnackbar].
  /// It is used to add and hide [ThemedSnackbar]s.
  /// This controller is only for internal use of the library, to display
  /// snackbars, please use the helper function [showThemedSnackbar]
  ThemedSnackbarController();

  /// [scaffoldKey] is the key to get the current [ScaffoldState].
  /// Is used as main key to display the snackbars. As fallback it will use
  /// the [BuildContext] provided by the [ThemedSnackbar].
  static GlobalKey<ScaffoldState>? scaffoldKey;

  /// [_snackbars] is the list of snackbars to be displayed.
  /// It is a private list, to add snackbars, please use the [add] method.
  /// To remove snackbars, please use the [remove] method.
  /// To clear the list, please use the [clear] method.
  final Map<Key, ThemedSnackbar> _snackbars = {};

  /// [add] is the method to add a [ThemedSnackbar] to the list.
  /// It will notify the listeners to rebuild the UI.
  /// It will also call the [remove] method after the duration of the
  /// [ThemedSnackbar] has passed.
  /// If the [ThemedSnackbar] is already in the list, it will not be added.
  void add(ThemedSnackbar item) {
    Key key = UniqueKey();
    _snackbars[key] = item;
    item.show(this, key);
    Future.delayed(item.duration, () {
      remove(item);
    });
  }

  /// [remove] is the method to remove a [ThemedSnackbar] from the list.
  /// It will notify the listeners to rebuild the UI.
  /// If the [ThemedSnackbar] is not in the list, it will not be removed.
  /// If the [ThemedSnackbar] is the last item in the list, it will also
  /// notify the listeners to rebuild the UI.
  void remove(ThemedSnackbar item) {
    if (_snackbars.containsKey(item.key)) {
      _snackbars.remove(item.key);
      item.hide(this);
    }
  }

  /// [clear] is the method to clear the list of [ThemedSnackbar]s.
  /// It will notify the listeners to rebuild the UI.
  void clear() {
    for (ThemedSnackbar item in _snackbars.values) {
      item.hide(this);
    }
    _snackbars.clear();
  }

  /// [usedHeight] is the height of the snackbars that are currently displayed.
  /// It is used to calculate the position of the snackbars.
  double get usedHeight {
    double height = 0;
    for (ThemedSnackbar item in _snackbars.values) {
      height += item.effectiveHeight + item.spacing;
    }

    return height;
  }

  @override
  String toString() {
    return 'ThemedSnackbarController{snackbars: ${_snackbars.length}}';
  }
}
