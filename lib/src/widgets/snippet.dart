part of layrz_theme;

class ThemedCodeSnippet extends StatelessWidget {
  /// The code to display
  final String code;

  /// The text to display when the code is copied to the clipboard
  final String copyToClipboardText;

  /// The text to display in the tooltip of the copy to clipboard button
  final String copyToClipboardTooltip;

  /// The maximum number of lines to display
  final int maxLines;

  /// [ThemedCodeSnippet] is a widget that displays a code snippet with a copy to clipboard button.
  const ThemedCodeSnippet({
    super.key,
    required this.code,
    this.copyToClipboardText = 'Copied to clipboard',
    this.copyToClipboardTooltip = 'Copy to clipboard',
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              code,
              maxLines: maxLines,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(width: 10),
          ThemedTooltip(
            message: copyToClipboardTooltip,
            position: ThemedTooltipPosition.left,
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: code));
                showThemedSnackbar(ThemedSnackbar(
                  context: context,
                  message: copyToClipboardText,
                  icon: MdiIcons.clipboardCheckOutline,
                  color: Colors.green,
                ));
              },
              child: Icon(
                MdiIcons.contentCopy,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
