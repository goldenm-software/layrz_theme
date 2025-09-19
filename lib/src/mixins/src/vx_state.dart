part of '../mixins.dart';

mixin VxStateUtilsMixin<T extends StatefulWidget> on State<T> {
  void genericSetState(BuildContext context, VxMutation mutation, {VxStatus? status}) {
    if (status == VxStatus.success) WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }
}
