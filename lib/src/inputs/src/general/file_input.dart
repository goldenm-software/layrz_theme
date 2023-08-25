part of inputs;

class ThemedFileInput extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final String? value;
  final void Function(String, List<int>)? onChanged;
  final FileType acceptedTypes;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final bool isRequired;
  final Widget? customWidget;

  /// [ThemedFileInput] is the input for file selection.
  /// It uses [ThemedTextInput] as the base.
  const ThemedFileInput({
    super.key,

    /// [labelText] is the label of the input. Avoid using this if you are using [label] instead.
    this.labelText,

    /// [label] is the label of the input. Avoid using this if you are using [labelText] instead.
    this.label,

    /// [value] is the value of the input.
    this.value,

    /// [onChanged] is the callback when the input value changes.
    /// The first parameter is the base64 of the file.
    /// The second parameter is the byte array of the file.
    this.onChanged,

    /// [disabled] is the flag to disable the input.
    this.disabled = false,

    /// [errors] is the list of errors to be displayed.
    this.errors = const [],

    /// [hideDetails] is the flag to hide the details of the input.
    this.hideDetails = false,

    /// [isRequired] is the flag to mark the input as required.
    this.isRequired = false,

    /// [acceptedTypes] is the type of files that can be selected.
    this.acceptedTypes = FileType.any,

    /// [customWidget] is the custom widget to be displayed.
    /// Replaces the [ThemedTextInput] widget.
    this.customWidget,
  });

  @override
  State<ThemedFileInput> createState() => _ThemedFileInputState();
}

class _ThemedFileInputState extends State<ThemedFileInput> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();

  String _value = "";

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? "";
    _controller.text = _value;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customWidget != null) {
      return InkWell(
        onTap: widget.disabled ? null : _requestFile,
        child: widget.customWidget,
      );
    }
    return ThemedTextInput(
      value: _value,
      label: widget.label,
      labelText: widget.labelText,
      prefixIcon: MdiIcons.file,
      suffixIcon: _value.isNotEmpty ? MdiIcons.paperclipOff : MdiIcons.paperclip,
      disabled: widget.disabled,
      readonly: true,
      onChanged: (String value) {
        setState(() {
          _value = value;
        });
      },
      onTap: _requestFile,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      controller: _controller,
    );
  }

  Future<void> _requestFile() async {
    if (_value.isNotEmpty) {
      _controller.clear();
      setState(() => _value = "");
      widget.onChanged?.call("", []);
      return;
    }
    final files = await pickFile(
      allowMultiple: false,
      type: widget.acceptedTypes,
    );

    if (files != null) {
      ThemedFile file = files.first;
      _controller.text = file.name;
      List<int> byteArray = await compute(parseFileToByteArray, file);
      Map<String, String>? b64 = await compute(parseFileToBase64, file);

      if (b64 != null) {
        String image = "data:${b64['mimeType']};base64,${b64['base64']}";
        setState(() => _value = file.name);
        widget.onChanged?.call(image, byteArray);
      }
    }
  }
}
