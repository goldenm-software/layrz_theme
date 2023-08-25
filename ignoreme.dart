/* 
switch (widget.style) {
      case ThemedLayoutStyle.sidebar:
        String? pageName;
        IconData? pageIcon;

        String currentPath = widget.currentPath ?? ModalRoute.of(context)?.settings.name ?? '';

        final match = widget.items.whereType<ThemedNavigatorPage>().firstWhereOrNull((page) {
          return currentPath.startsWith(page.path);
        });

        if (match != null) {
          pageName = match.labelText;
          pageIcon = match.icon;

          if (match.label is Text) {
            pageName = (match.label as Text).data;
          }

          if (match.children.isNotEmpty) {
            final submatch = match.children.whereType<ThemedNavigatorPage>().firstWhereOrNull((page) {
              return currentPath.startsWith(page.path);
            });

            if (submatch != null) {
              String? subpageName = submatch.labelText;
              pageIcon = submatch.icon;

              if (submatch.label is Text) {
                subpageName = (submatch.label as Text).data;
              }

              if (subpageName != null) {
                pageName = '$pageName - $subpageName';
              }
            }
          }
        }

        content = Row(
          children: [
            ThemedDrawer(
              scaffoldKey: _scaffoldKey,
              items: [
                ...widget.items,
                if (widget.persistentItems.isNotEmpty) ...[
                  ThemedNavigatorSeparator(type: ThemedSeparatorType.dots),
                  ...widget.persistentItems,
                ],
              ],
              appTitle: widget.appTitle,
              companyName: widget.companyName,
              logo: widget.logo,
              favicon: widget.favicon,
              version: widget.version,
              userName: widget.userName,
              userDynamicAvatar: widget.userDynamicAvatar,
              enableAbout: widget.enableAbout,
              onSettingsTap: widget.onSettingsTap,
              onProfileTap: widget.onProfileTap,
              onLogoutTap: widget.onLogoutTap,
              additionalActions: widget.additionalActions,
              onNavigatorPop: widget.onNavigatorPop,
              onNavigatorPush: widget.onNavigatorPush,
              currentPath: widget.currentPath,
              onThemeSwitchTap: widget.onThemeSwitchTap,
            ),
            Expanded(
              child: Column(
                children: [
                  if (pageName != null) ...[
                    Container(
                      height: ThemedAppBar.size.height,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (pageIcon != null) ...[
                            Icon(
                              pageIcon,
                              color: isDark ? Colors.white : Theme.of(context).primaryColor,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                          ],
                          Expanded(
                            child: Text(
                              pageName,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Theme.of(context).primaryColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        );
        break;
    }
 */