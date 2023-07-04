part of inputs;

class ThemedAvatarInput extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final String? value;
  final void Function(String?)? onChanged;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;

  const ThemedAvatarInput({
    super.key,
    this.label,
    this.value,
    this.labelText,
    this.onChanged,
    this.disabled = false,
    this.errors = const [],
    this.hideDetails = false,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedAvatarInput> createState() => _ThemedAvatarInputState();
}

class _ThemedAvatarInputState extends State<ThemedAvatarInput> with SingleTickerProviderStateMixin {
  late String? _value;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _value = widget.value ?? "";

    if (_value?.isNotEmpty ?? false) {
      _controller.animateTo(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.label ?? Text(widget.labelText ?? ""),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Center(
                child: Stack(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: widget.disabled
                          ? null
                          : () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                allowCompression: true,
                                allowMultiple: false,
                                withData: true,
                                type: FileType.image,
                              );

                              if (result != null) {
                                PlatformFile file = result.files.first;

                                Map<String, String>? b64 = await compute(parseFileToBase64, file);

                                if (b64 != null) {
                                  String image = "data:${b64['mimeType']};base64,${b64['base64']}";
                                  setState(() => _value = image);
                                  widget.onChanged?.call(image);

                                  _controller.animateTo(1);
                                }
                              }
                            },
                      child: drawAvatar(
                        context: context,
                        icon: MdiIcons.cloudUpload,
                        avatar: _value,
                        size: 100,
                      ),
                    ),
                    widget.disabled
                        ? const SizedBox()
                        : Positioned(
                            right: 0,
                            top: 0,
                            child: FadeTransition(
                              opacity: CurvedAnimation(
                                parent: _controller,
                                curve: Curves.easeInOut,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                child: ClipOval(
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    color: Colors.red.shade800,
                                    child: Icon(MdiIcons.close,
                                        size: 15, color: validateColor(color: Colors.red.shade800)),
                                  ),
                                ),
                                onTap: () {
                                  setState(() => _value = null);
                                  widget.onChanged?.call(null);
                                  _controller.animateTo(0);
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            ThemedFieldDisplayError(errors: widget.errors, hideDetails: widget.hideDetails),
          ],
        ));
  }
}
