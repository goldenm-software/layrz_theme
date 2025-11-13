part of '../mixins.dart';

mixin VxStateUtilsMixin<T extends StatefulWidget> on State<T> {
  void genericSetState(BuildContext context, StateMutation mutation, {StateStatus? status}) {
    if (status == .success) WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }
}
