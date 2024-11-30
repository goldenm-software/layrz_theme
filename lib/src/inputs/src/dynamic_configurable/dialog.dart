part of '../../inputs.dart';

class ThemedDynamicConfigurableDialog extends StatefulWidget {
  final List<String> choices;

  const ThemedDynamicConfigurableDialog({
    super.key,
    required this.choices,
  });

  @override
  State<ThemedDynamicConfigurableDialog> createState() => _ThemedDynamicConfigurableDialogState();
}

class _ThemedDynamicConfigurableDialogState extends State<ThemedDynamicConfigurableDialog> {
  LayrzAppLocalizations get i18n => LayrzAppLocalizations.of(context);
  late List<String> _choices;
  late List<String> _filteredChoices;
  String _search = '';

  bool get _shouldAdd {
    return _search.isNotEmpty && !_choices.contains(_search);
  }

  @override
  void initState() {
    super.initState();
    _choices = widget.choices;
    _filteredChoices = _choices;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: generateContainerElevation(
          context: context,
          elevation: 5,
        ),
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              i18n.t('requiredFields.choices.edit'),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            ThemedTextInput(
              labelText: i18n.t('requiredFields.choices.filter'),
              value: _search,
              onChanged: (value) {
                _search = value;

                if (_search.isNotEmpty) {
                  _filteredChoices = _choices.where((element) {
                    return element.toLowerCase().contains(_search.toLowerCase());
                  }).toList();
                } else {
                  _filteredChoices = _choices;
                }

                setState(() {});
              },
              dense: true,
              prefixIcon: LayrzIcons.solarOutlineMagnifier,
            ),
            if (_shouldAdd) ...[
              const SizedBox(height: 10),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    setState(() {
                      _choices.add(_search);
                      _search = '';

                      _filteredChoices = _choices;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          LayrzIcons.solarOutlineAddSquare,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: RichText(
                            text: _buildRichText(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Center(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredChoices.length,
                  itemBuilder: (context, index) {
                    final choice = _filteredChoices[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          ThemedAvatar(
                            name: (index + 1).toString().padLeft(2, '0'),
                            size: 25,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(choice),
                          ),
                          const SizedBox(width: 10),
                          ThemedButton(
                            style: ThemedButtonStyle.filledTonalFab,
                            icon: LayrzIcons.solarOutlineTrashBinMinimalistic2,
                            labelText: i18n.t('requiredFields.choices.remove'),
                            color: Colors.red,
                            onTap: () {
                              setState(() {
                                _choices.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ThemedButton(
                  style: ThemedButtonStyle.filledTonalFab,
                  icon: LayrzIcons.solarOutlineCloseSquare,
                  labelText: i18n.t('requiredFields.choices.discard'),
                  color: Colors.red,
                  onTap: () {
                    Navigator.of(context).pop(null);
                  },
                ),
                ThemedButton(
                  style: ThemedButtonStyle.filledTonalFab,
                  icon: LayrzIcons.solarOutlineInboxIn,
                  labelText: i18n.t('requiredFields.choices.save'),
                  color: Colors.green,
                  onTap: () {
                    Navigator.of(context).pop(_choices);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _buildRichText() {
    final text = i18n.t('requiredFields.choices.addOption');
    List<String> parts = text.split('{option}');
    List<TextSpan> richText = [];

    TextStyle? baseStyle = Theme.of(context).textTheme.bodyMedium;

    for (int i = 0; i < parts.length; i++) {
      richText.add(TextSpan(text: parts[i], style: baseStyle));

      if (i < parts.length - 1) {
        richText.add(TextSpan(
          text: _search,
          style: baseStyle?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ));
      }
    }

    return TextSpan(children: richText);
  }
}
