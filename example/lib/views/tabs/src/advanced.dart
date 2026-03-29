part of '../tabs.dart';

class AdvancedTabsView extends StatefulWidget {
  const AdvancedTabsView({super.key});

  @override
  State<AdvancedTabsView> createState() => _AdvancedTabsViewState();
}

class _AdvancedTabsViewState extends State<AdvancedTabsView> {
  bool _showArrows = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Advanced Tabs Features",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Explore advanced features like arrows, additional widgets, and custom styling.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 30,
                children: [
                  // Tabs with arrows - title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tabs with Navigation Arrows",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 80,
                        child: ThemedCheckboxInput(
                          value: _showArrows,
                          onChanged: (value) {
                            setState(() => _showArrows = value);
                          },
                          labelText: 'Show arrows',
                        ),
                      ),
                    ],
                  ),

                  // Tabs with arrows - with wrap (circular navigation)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        'With Wrap Navigation (wraps around)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 280,
                        child: ThemedTabView(
                          showArrows: _showArrows,
                          wrapArrowNavigation: true,
                          style: ThemedTabStyle.filledTonal,
                          tabs: List.generate(
                            5,
                            (index) => ThemedTab(
                              labelText: 'Tab ${index + 1}',
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LayrzIcons.solarOutlineDocumentText,
                                      size: 64,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Tab ${index + 1}',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Left arrow from tab 1 goes to tab 5, right from tab 5 goes to tab 1',
                                      style: Theme.of(context).textTheme.bodySmall,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Tabs with arrows - without wrap (disabled at limits)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        'Without Wrap Navigation (arrows disabled at limits)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 280,
                        child: ThemedTabView(
                          showArrows: _showArrows,
                          wrapArrowNavigation: false,
                          style: ThemedTabStyle.filledTonal,
                          tabs: List.generate(
                            5,
                            (index) => ThemedTab(
                              labelText: 'Tab ${index + 1}',
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LayrzIcons.solarOutlineDocumentText,
                                      size: 64,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Tab ${index + 1}',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Arrows are disabled when at first or last tab',
                                      style: Theme.of(context).textTheme.bodySmall,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Tabs with additional widgets - title
                  Text(
                    "Tabs with Additional Widgets",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Tabs with additional widgets - content
                  SizedBox(
                    height: 300,
                    child: ThemedTabView(
                      style: ThemedTabStyle.filledTonal,
                      additionalWidgets: [
                        SizedBox(
                          width: 80,
                          child: ThemedButton(
                            labelText: 'Add',
                            style: ThemedButtonStyle.filledTonal,
                            color: Theme.of(context).colorScheme.primary,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Add button pressed')),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: ThemedButton(
                            labelText: 'Settings',
                            style: ThemedButtonStyle.filledTonal,
                            color: Theme.of(context).colorScheme.primary,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Settings button pressed')),
                              );
                            },
                          ),
                        ),
                      ],
                      tabs: [
                        ThemedTab(
                          labelText: 'All Items',
                          child: _buildItemsList(context, 'All Items'),
                        ),
                        ThemedTab(
                          labelText: 'Active',
                          child: _buildItemsList(context, 'Active Items'),
                        ),
                        ThemedTab(
                          labelText: 'Archived',
                          child: _buildItemsList(context, 'Archived Items'),
                        ),
                      ],
                    ),
                  ),

                  // Tabs with custom content - title
                  Text(
                    "Tabs with Form Content",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Tabs with custom content - content
                  SizedBox(
                    height: 400,
                    child: ThemedTabView(
                      style: ThemedTabStyle.filledTonal,
                      onTabIndex: (index) {
                        setState(() => _selectedIndex = index);
                      },
                      tabs: [
                        ThemedTab(
                          labelText: 'Personal Info',
                          leadingIcon: LayrzIcons.solarOutlineUser,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Column(
                                spacing: 12,
                                children: [
                                  ThemedTextInput(
                                    labelText: 'First Name',
                                    placeholder: 'Enter your first name',
                                  ),
                                  ThemedTextInput(
                                    labelText: 'Last Name',
                                    placeholder: 'Enter your last name',
                                  ),
                                  ThemedTextInput(
                                    labelText: 'Email',
                                    placeholder: 'Enter your email',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ThemedTab(
                          labelText: 'Contact',
                          leadingIcon: LayrzIcons.solarOutlinePhone,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Column(
                                spacing: 12,
                                children: [
                                  ThemedTextInput(
                                    labelText: 'Phone',
                                    placeholder: '+1 (555) 000-0000',
                                  ),
                                  ThemedTextInput(
                                    labelText: 'Address',
                                    placeholder: 'Enter your address',
                                  ),
                                  ThemedTextInput(
                                    labelText: 'City',
                                    placeholder: 'Enter your city',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ThemedTab(
                          labelText: 'Preferences',
                          leadingIcon: LayrzIcons.solarOutlineSettings,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 16,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Notifications',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: ThemedCheckboxInput(
                                          value: true,
                                          onChanged: (_) {},
                                          hideDetails: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Dark Mode',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: ThemedCheckboxInput(
                                          value: false,
                                          onChanged: (_) {},
                                          hideDetails: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Analytics',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: ThemedCheckboxInput(
                                          value: true,
                                          onChanged: (_) {},
                                          hideDetails: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Text(
                                    'Currently on tab: Preferences (index $_selectedIndex)',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tabs with trailing elements - title
                  Text(
                    "Tabs with Trailing Elements",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Tabs with trailing elements - content
                  SizedBox(
                    height: 250,
                    child: ThemedTabView(
                      style: ThemedTabStyle.filledTonal,
                      tabs: [
                        ThemedTab(
                          labelText: 'Messages',
                          leadingIcon: LayrzIcons.solarOutlineInboxIn,
                          trailingIcon: LayrzIcons.solarOutlineAltArrowRight,
                          child: Center(
                            child: Text(
                              'Messages Tab',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ThemedTab(
                          labelText: 'Notifications',
                          leadingIcon: LayrzIcons.solarOutlineBell,
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '5',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Notifications Tab',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ThemedTab(
                          labelText: 'Search',
                          leadingIcon: LayrzIcons.solarOutlineMagnifier,
                          child: Center(
                            child: Text(
                              'Search Tab',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...List.generate(
              5,
              (index) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      LayrzIcons.solarOutlineDocumentText,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            'Item ${index + 1}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Description for item ${index + 1}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
