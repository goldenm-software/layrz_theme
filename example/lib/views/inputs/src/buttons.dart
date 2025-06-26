part of '../inputs.dart';

class ButtonsView extends StatefulWidget {
  const ButtonsView({super.key});

  @override
  State<ButtonsView> createState() => _ButtonsViewState();
}

class _ButtonsViewState extends State<ButtonsView> {
  bool _isLoading = false;
  bool _isCooldown = false;
  bool _isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Buttons",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Our buttons has different styles, check out the following examples:",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Our favorite style is the filledTonal, take a look:",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Style filledTonal (Default)",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                _factorButton(
                                  style: ThemedButtonStyle.filledTonal,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                            height: 50,
                            child: VerticalDivider(),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Style filledTonalFab",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                _factorButton(
                                  style: ThemedButtonStyle.filledTonalFab,
                                  tooltipPosition: ThemedTooltipPosition.right,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Need a more elevated style? We have it!",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Style elevated",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                _factorButton(
                                  style: ThemedButtonStyle.elevated,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                            height: 50,
                            child: VerticalDivider(),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Style elevatedFab",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                _factorButton(
                                  style: ThemedButtonStyle.elevatedFab,
                                  tooltipPosition: ThemedTooltipPosition.left,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Classic buttons? Take a look at the filled styles:",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Style filled",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                _factorButton(style: ThemedButtonStyle.filled),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                            height: 50,
                            child: VerticalDivider(),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Style filledFab",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                _factorButton(
                                  style: ThemedButtonStyle.filledFab,
                                  tooltipPosition: ThemedTooltipPosition.top,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Do you like outlined buttons? We have them too!",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Style outlined",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                _factorButton(
                                  style: ThemedButtonStyle.outlined,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                            height: 50,
                            child: VerticalDivider(),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Style outlinedFab",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                _factorButton(
                                  style: ThemedButtonStyle.outlinedFab,
                                  tooltipPosition: ThemedTooltipPosition.bottom,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "A combination of Outlined and Filled tonal? No problem!",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Style outlinedTonal",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                _factorButton(
                                  style: ThemedButtonStyle.outlinedTonal,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                            height: 50,
                            child: VerticalDivider(),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Style outlinedTonalFab",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                _factorButton(
                                  style: ThemedButtonStyle.outlinedTonalFab,
                                  tooltipPosition: ThemedTooltipPosition.bottom,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Do you don't like the styles avobe? You can use the plain styles:",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Style text",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                _factorButton(style: ThemedButtonStyle.text),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                            height: 50,
                            child: VerticalDivider(),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Style fab",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                _factorButton(
                                  style: ThemedButtonStyle.fab,
                                ),
                              ],
                            ),
                          ),
                          ThemedActionsButtons(
                            forceMobileMode: true,
                            // actionsOffset: const Offset(20, 20),
                            actions: [
                              ThemedActionButton.cancel(
                                isMobile: true,
                                labelText: 'Cancel',
                                onTap: () => {},
                              ),
                              ThemedActionButton.save(
                                isMobile: true,
                                labelText: 'Save',
                                onTap: () => {},
                              ),
                              ThemedActionButton.info(
                                isMobile: true,
                                labelText: 'Info',
                                isDisabled: true,
                                onTap: () => {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "Tools",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ThemedButton(
                        style: ThemedButtonStyle.filledTonal,
                        labelText: "Toggle loading state",
                        icon: LayrzIcons.mdiLoading,
                        color: Colors.orange,
                        hintText: 'Toggles the loading state of the buttons',
                        tooltipPosition: ThemedTooltipPosition.top,
                        onTap: () => setState(() => _isLoading = !_isLoading),
                      ),
                      const SizedBox(width: 5),
                      ThemedButton(
                        style: ThemedButtonStyle.filledTonal,
                        labelText: "Toggle cooldown state",
                        icon: LayrzIcons.mdiTimerSandEmpty,
                        color: Colors.red,
                        hintText:
                            'Toggles the cooldown state of the buttons, '
                            'when the cooldown is active, the button will be disabled and '
                            'will be enabled again when the cooldown is finished',
                        tooltipPosition: ThemedTooltipPosition.top,
                        onTap: () => setState(() => _isCooldown = !_isCooldown),
                      ),
                      const SizedBox(width: 5),
                      ThemedButton(
                        style: ThemedButtonStyle.filledTonal,
                        labelText: "Toggle disabled state",
                        icon: LayrzIcons.mdiCloseCircleOutline,
                        color: Colors.grey,
                        hintText: 'Toggles the disabled state of the buttons',
                        tooltipPosition: ThemedTooltipPosition.top,
                        onTap: () => setState(() => _isDisabled = !_isDisabled),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _factorButton({
    required style,
    ThemedTooltipPosition tooltipPosition = ThemedTooltipPosition.right,
  }) {
    return ThemedButton(
      icon: LayrzIcons.mdiAccessPoint,
      cooldownDuration: const Duration(seconds: 4),
      labelText: "Button",
      style: style,
      isLoading: _isLoading,
      isCooldown: _isCooldown,
      // showCooldownRemainingDuration: false,
      isDisabled: _isDisabled,
      // cooldownDuration: const Duration(seconds: 10),
      onCooldownFinish: () => setState(() => _isCooldown = false),
      tooltipPosition: tooltipPosition,
      onTap: () {
        // context.go('/inputs/text');
        ThemedSnackbarMessenger.of(context).showSnackbar(
          ThemedSnackbar(
            icon: LayrzIcons.mdiAccessPoint,
            color: Colors.red,
            title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            message:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ut nulla sit amet "
                    "tellus dictum molestie in sit amet ligula. Nullam pulvinar risus eu sapien dictum blandit." *
                2,
          ),
        );
      },
    );
  }
}
