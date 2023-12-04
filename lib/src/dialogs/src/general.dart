part of '../dialogs.dart';

class ThemedDialog extends StatefulWidget {
  /// [title] is the title of the dialog.
  /// If [title] is null, [titleText] will be used instead.
  final Widget? title;

  /// [titleText] is the title of the dialog.
  /// Avoid using this property if [title] is not null.
  final String? titleText;

  /// [body] is the content of the dialog.
  final Widget body;

  /// [actions] is the list of actions of the dialog.
  final List<ThemedDialogAction> actions;

  /// [constraints] is the constraints of the dialog.
  final BoxConstraints constraints;

  /// [padding] is the padding of the dialog.
  final EdgeInsetsGeometry padding;

  /// [dismiss] is the dismiss action of the dialog.
  final ThemedDialogAction? dismiss;

  /// [ThemedDialog] is a dialog with a theme.
  const ThemedDialog({
    super.key,
    this.title,
    this.titleText,
    required this.body,
    required this.actions,
    this.constraints = const BoxConstraints(maxWidth: 600),
    this.padding = const EdgeInsets.all(20),
    this.dismiss,
  }) : assert(title != null || titleText != null);

  @override
  State<ThemedDialog> createState() => _ThemedDialogState();
}

class _ThemedDialogState extends State<ThemedDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: widget.constraints,
        padding: widget.padding,
        decoration: generateContainerElevation(context: context, elevation: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: widget.title ??
                      Text(
                        widget.titleText ?? '',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                ),
                const SizedBox(width: 10),
                if (widget.dismiss != null)
                  ThemedButton(
                    style: ThemedButtonStyle.fab,
                    icon: MdiIcons.close,
                    color: Colors.red,
                    labelText: widget.dismiss!.labelText,
                    label: widget.dismiss!.label,
                    isLoading: widget.dismiss!.isLoading,
                    isCooldown: widget.dismiss!.isCooldown,
                    onCooldownFinish: widget.dismiss!.onCooldown,
                    isDisabled: widget.dismiss!.isDisabled,
                    onTap: widget.dismiss!.onTap,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            widget.body,
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.dismiss != null) widget.dismiss!,
                ...widget.actions,
              ].map((action) {
                return ThemedButton(
                  style: action.style,
                  color: action.color,
                  labelText: action.labelText,
                  label: action.label,
                  isLoading: action.isLoading,
                  isCooldown: action.isCooldown,
                  onCooldownFinish: action.onCooldown,
                  isDisabled: action.isDisabled,
                  icon: action.icon,
                  onTap: action.onTap,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
