part of inputs;

class ButtonsView extends StatefulWidget {
  const ButtonsView({super.key});

  @override
  State<ButtonsView> createState() => _ButtonsViewState();
}

class _ButtonsViewState extends State<ButtonsView> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Buttons",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            ThemedButton(
              labelText: "Hello world!",
              onTap: () {
                showThemedSnackbar(ThemedSnackbar(
                  message: "You tapped on a button! =D",
                ));
              },
            ),
            const SizedBox(height: 10),
            Text(
              "Our buttons has different styles, check out the following examples:",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              children: [
                ...ThemedButtonStyle.values
                    .map((style) {
                      return [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Style ${style.name}"),
                            ThemedButton(
                              icon: MdiIcons.accessPoint,
                              labelText: "Style ${style.name}",
                              style: style,
                              tooltipPosition: ThemedTooltipPosition.right,
                              onTap: () {
                                showThemedSnackbar(ThemedSnackbar(
                                  message: "You tapped on a button with style ${style.name}!",
                                ));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                      ];
                    })
                    .expand((element) => element)
                    .toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
