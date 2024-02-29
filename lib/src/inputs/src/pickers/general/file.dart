part of '../../../inputs.dart';

class ThemedFileInput extends StatelessWidget {
  final String? labelText;
  final Widget? label;
  final String? value;
  final void Function(String, List<int>)? onChanged;
  final FileType acceptedTypes;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final bool isRequired;
  final Widget? customChild;
  final Widget? customWidget;

  /// [ThemedFileInput] is the input for file selection.
  /// It uses [ThemedTextInput] as the base.
  @Deprecated('Use `ThemedFilePicker` instead')
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

    /// [customChild] is the custom widget to be displayed.
    /// Replaces the [ThemedTextInput] widget.
    this.customChild,

    /// [customWidget] is the custom widget to be displayed.
    /// Replaces the [ThemedTextInput] widget.
    @Deprecated('Use `customChild` instead') this.customWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedFilePicker(
      labelText: labelText,
      label: label,
      value: value,
      onChanged: onChanged,
      acceptedTypes: acceptedTypes,
      disabled: disabled,
      errors: errors,
      hideDetails: hideDetails,
      isRequired: isRequired,
      customChild: customChild,
      // ignore: deprecated_member_use_from_same_package
      customWidget: customWidget,
    );
  }
}

class ThemedFilePicker extends StatefulWidget {
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

  /// [disabled] is the flag to disable the input.
  final bool disabled;

  /// [errors] is the list of errors to be displayed.
  final List<String> errors;

  /// [hideDetails] is the flag to hide the details of the input.
  final bool hideDetails;

  /// [isRequired] is the flag to mark the input as required.
  final bool isRequired;

  /// [acceptedTypes] is the type of files that can be selected.
  final FileType acceptedTypes;

  /// [customChild] is the custom widget to be displayed.
  /// Replaces the [ThemedTextInput] widget.
  final Widget? customChild;

  /// [customWidget] is the custom widget to be displayed.
  /// Replaces the [ThemedTextInput] widget.
  final Widget? customWidget;

  /// [hoverColor] is the hover color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color hoverColor;

  /// [focusColor] is the focus color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color focusColor;

  /// [splashColor] is the splash color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color splashColor;

  /// [highlightColor] is the highlight color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color highlightColor;

  /// [borderRadius] is the border radius of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `BorderRadius.circular(10)`.
  final BorderRadius borderRadius;

  /// [allowedExtensions] is the list of allowed extensions. Only will work when [acceptedTypes] is [FileType.custom].
  final List<String>? allowedExtensions;

  /// [padding] is the padding of the input.
  final EdgeInsets? padding;

  /// [ThemedFilePicker] is the input for file selection.
  /// It uses [ThemedTextInput] as the base.
  const ThemedFilePicker({
    super.key,
    this.labelText,
    this.label,
    this.value,
    this.onChanged,
    this.disabled = false,
    this.errors = const [],
    this.hideDetails = false,
    this.isRequired = false,
    this.acceptedTypes = FileType.any,
    this.customChild,
    @Deprecated('Use `customChild` instead') this.customWidget,
    this.hoverColor = Colors.transparent,
    this.focusColor = Colors.transparent,
    this.splashColor = Colors.transparent,
    this.highlightColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.allowedExtensions,
    this.padding,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedFilePicker> createState() => _ThemedFilePickerState();
}

class _ThemedFilePickerState extends State<ThemedFilePicker> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  Widget? get customChild => widget.customChild ?? widget.customWidget;

  String _value = "";

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? "";
    _controller.text = _value;
  }

  @override
  Widget build(BuildContext context) {
    if (customChild != null) {
      return InkWell(
        hoverColor: widget.hoverColor,
        focusColor: widget.focusColor,
        splashColor: widget.splashColor,
        highlightColor: widget.highlightColor,
        borderRadius: widget.borderRadius,
        onTap: widget.disabled ? null : _requestFile,
        child: customChild!,
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
      padding: widget.padding,
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
      allowedExtensions: widget.allowedExtensions,
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
