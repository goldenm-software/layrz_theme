part of layrz_theme;

class ThemedFileInput extends StatefulWidget {
  /// [labelText] is the label of the input. Avoid using this if you are using [label] instead.
  final String? labelText;

  /// [label] is the label of the input. Avoid using this if you are using [labelText] instead.
  final Widget? label;

  /// [value] is the value of the input.
  final String? value;

  /// [onChanged] is the callback when the input value changes.
  /// The first parameter is the base64 of the file.
  /// The second parameter is the byte array of the file.
  final void Function(String, List<int>)? onChanged;

  /// [multiple] is the flag to allow multiple files to be selected.
  final bool multiple;

  /// [acceptedTypes] is the type of files that can be selected.
  final FileType acceptedTypes;

  /// [disabled] is the flag to disable the input.
  final bool disabled;

  /// [errors] is the list of errors to be displayed.
  final List<String> errors;

  /// [hideDetails] is the flag to hide the details of the input.
  final bool hideDetails;

  /// [isRequired] is the flag to mark the input as required.
  final bool isRequired;

  /// [customWidget] is the custom widget to be displayed.
  /// Replaces the [ThemedTextInput] widget.
  final Widget? customWidget;

  /// [ThemedFileInput] is the input for file selection.
  /// It uses [ThemedTextInput] as the base.
  const ThemedFileInput({
    super.key,
    this.label,
    this.value,
    this.labelText,
    this.onChanged,
    @Deprecated('This property will be removed soon') this.multiple = false,
    this.disabled = false,
    this.acceptedTypes = FileType.any,
    this.errors = const [],
    this.hideDetails = false,
    this.isRequired = false,
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: false,
      withData: true,
      type: widget.acceptedTypes,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
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
