part of '../tabs.dart';

class BasicTabsView extends StatefulWidget {
  const BasicTabsView({super.key});

  @override
  State<BasicTabsView> createState() => _BasicTabsViewState();
}

class _BasicTabsViewState extends State<BasicTabsView> {
  int _selectedTabIndex = 0;
  final List<bool> _settingsValues = [true, false, true, false, true];

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Tabs",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "ThemedTabView provides a customizable tab widget with multiple styles and features.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic tabs with filledTonal style
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Basic Tabs (filledTonal)",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300,
                        child: ThemedTabView(
                          style: ThemedTabStyle.filledTonal,
                          onTabIndex: (index) {
                            setState(() => _selectedTabIndex = index);
                          },
                          tabs: [
                            ThemedTab(
                              labelText: 'Overview',
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Overview Tab',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'This is the overview tab. Currently on tab index: $_selectedTabIndex',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primary.withAlpha(30),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'ThemedTabView is a stateful widget that manages tab switching with smooth animations.',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ThemedTab(
                              labelText: 'Settings',
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Settings Tab',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ...List.generate(
                                        5,
                                        (index) => Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: ThemedCheckboxInput(
                                            value: _settingsValues[index],
                                            labelText: 'Setting ${index + 1}',
                                            onChanged: (value) {
                                              setState(() => _settingsValues[index] = value);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ThemedTab(
                              labelText: 'Details',
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Details Tab',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Features:',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...[
                                        'Smooth tab transitions with customizable animation duration',
                                        'Multiple tab styles (filledTonal, underline)',
                                        'Support for icons, leading/trailing widgets',
                                        'Tab position persistence across resizes',
                                        'Arrow navigation for scrollable tabs',
                                        'Custom callbacks on tab change',
                                      ].map(
                                        (feature) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Row(
                                            children: [
                                              Icon(
                                                LayrzIcons.solarOutlineCheckCircle,
                                                size: 18,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  feature,
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Tabs with underline style
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tabs with Underline Style",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: ThemedTabView(
                          style: ThemedTabStyle.underline,
                          tabs: [
                            ThemedTab(
                              labelText: 'Tab 1',
                              child: Center(
                                child: Text(
                                  'Content for Tab 1',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            ThemedTab(
                              labelText: 'Tab 2',
                              child: Center(
                                child: Text(
                                  'Content for Tab 2',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Tabs with icons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tabs with Icons",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: ThemedTabView(
                          style: ThemedTabStyle.filledTonal,
                          tabs: [
                            ThemedTab(
                              labelText: 'Dashboard',
                              leadingIcon: LayrzIcons.solarOutlineHome,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LayrzIcons.solarOutlineHome,
                                      size: 64,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Dashboard',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ThemedTab(
                              labelText: 'Users',
                              leadingIcon: LayrzIcons.solarOutlineUsersGroupRounded,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LayrzIcons.solarOutlineUsersGroupRounded,
                                      size: 64,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Users',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ThemedTab(
                              labelText: 'Settings',
                              leadingIcon: LayrzIcons.solarOutlineSettings,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LayrzIcons.solarOutlineSettings,
                                      size: 64,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Settings',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
