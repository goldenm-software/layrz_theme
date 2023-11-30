part of '../snackbar.dart';

typedef ThemedSnackbarCallback = bool Function();

class ThemedSnackbarMessenger extends StatefulWidget {
  final Widget child;
  const ThemedSnackbarMessenger({
    super.key,
    required this.child,
  });

  @override
  State<ThemedSnackbarMessenger> createState() => ThemedSnackbarMessengerState();

  static ThemedSnackbarMessengerState of(BuildContext context) {
    assert(debugCheckHasThemedSnackbarMessenger(context));
    final _ThemedSnackbarScope? scope = context.findAncestorWidgetOfExactType<_ThemedSnackbarScope>();
    return scope!.state;
  }

  static ThemedSnackbarMessengerState? maybeOf(BuildContext context) {
    final _ThemedSnackbarScope? scope = context.findAncestorWidgetOfExactType<_ThemedSnackbarScope>();
    return scope?.state;
  }
}

class ThemedSnackbarMessengerState extends State<ThemedSnackbarMessenger> with TickerProviderStateMixin {
  /// [visibleSnackbars] is a list of snackbars that are currently visible.
  final List<ThemedSnackbar> snackbars = [];

  /// [showSnackbar] is called to show a snackbar.
  ///
  /// To use it, call `ThemedSnackbarMessenger.of(context).showSnackbar(snackbar)`.
  /// Also, you need to set this in your `MaterialApp`:`
  /// ```dart
  /// MaterialApp(
  ///   ...
  ///   builder: (context, child) {
  ///     return ThemedSnackbarMessenger(
  ///       child: child ?? const SizedBox(),
  ///     );
  ///   },
  /// );
  /// ```
  /// Without the builder, you cannot invoke `ThemedSnackbarMessenger.of(context)`.
  void showSnackbar(ThemedSnackbar snackbar) {
    snackbar.state = this;
    snackbars.add(snackbar);
    setState(() {});
  }

  /// [removeSnackbar] is called to remove a snackbar.
  void removeSnackbar(Key key) {
    snackbars.removeWhere((snackbar) => snackbar.key == key);
    heights.removeWhere((height) => height['key'] == key);
    listeners.remove(key);

    for (final entry in listeners.entries) {
      final listener = entry.value;
      final res = listener.call();
      if (res == false) {
        listeners.remove(entry.key);
      }
    }

    setState(() {});
  }

  /// [heights] is a map of the heights of the snackbars.
  List<Map<String, dynamic>> heights = [];

  /// [registerHeight] is called to register the height of a snackbar.
  /// It is called by the snackbar itself.
  void registerHeight(Key key, double height) {
    heights.add({
      'key': key,
      'height': height,
    });
  }

  /// [listeners] is a map of listeners for the snackbars.`
  final Map<Key, ThemedSnackbarCallback> listeners = {};

  /// [registerListener] is called to register a listener for a snackbar.
  /// It is called by the snackbar itself.
  void registerListener(Key key, ThemedSnackbarCallback listener) {
    listeners[key] = listener;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _ThemedSnackbarScope(
      state: this,
      child: Stack(
        children: [
          widget.child,
          ...snackbars,
        ],
      ),
    );
  }
}

class _ThemedSnackbarScope extends InheritedWidget {
  final ThemedSnackbarMessengerState state;

  const _ThemedSnackbarScope({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ThemedSnackbarScope old) => true;
}
