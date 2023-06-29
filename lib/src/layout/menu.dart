part of layrz_theme;

class TaskbarMenu extends StatefulWidget {
  final double width;
  final double height;
  final String userName;
  final String? userAvatar;
  final Avatar? userDynamicAvatar;
  final bool enableAbout;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogoutTap;
  final String appTitle;
  final String companyName;
  final AppThemedAsset logo;
  final AppThemedAsset favicon;
  final String? version;
  final List<SearchEntity> entities;
  final void Function(SearchEntity)? onEntityTap;
  final VoidCallback onHideTap;

  const TaskbarMenu({
    super.key,
    required this.width,
    required this.height,
    required this.userName,
    this.userAvatar,
    this.userDynamicAvatar,
    this.enableAbout = true,
    this.onSettingsTap,
    this.onProfileTap,
    this.onLogoutTap,
    required this.appTitle,
    required this.companyName,
    required this.logo,
    required this.favicon,
    this.version,
    this.entities = const [],
    this.onEntityTap,
    required this.onHideTap,
  });

  @override
  State<TaskbarMenu> createState() => _TaskbarMenuState();
}

class _TaskbarMenuState extends State<TaskbarMenu> {
  double get width => widget.width;
  double get height => widget.height;
  Duration get duration => const Duration(milliseconds: 200);
  double get bottomBarHeight => 50.0;
  int get maxEntitiesPerRow => 5;
  double get entityCardSize => (width - 20) / maxEntitiesPerRow;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  // buttons
  bool isAboutHover = false;
  bool isSettingsHover = false;
  bool isProfileHover = false;
  bool isLogoutHover = false;

  // Search
  String searchText = "";
  Map<SearchEntity, bool> hoveredEntities = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);
    Color bottomBarColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    Color bottomBarHoverColor = isDark ? Colors.grey.shade600 : Colors.grey.shade200;

    List<SearchEntity> entities = widget.entities.where((e) {
      if (searchText.isEmpty) return true;

      bool c1 = e.name.toLowerCase().contains(searchText.toLowerCase());
      String type = i18n?.t('layrz.taskbar.types.${e.type.name}') ?? e.type.name;
      bool c2 = type.toLowerCase().contains(searchText.toLowerCase());

      return c1 || c2;
    }).toList();

    return Container(
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(maxHeight: height),
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.entities.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10).add(const EdgeInsets.only(top: 10)),
              child: Actions(
                actions: {
                  DismissIntent: CallbackAction<DismissIntent>(
                    onInvoke: (action) {
                      _focusNode.unfocus();
                      return true;
                    },
                  ),
                },
                child: TextField(
                  focusNode: _focusNode,
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: i18n?.t('layrz.taskbar.search') ?? "Search",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    isDense: true,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: width,
              constraints: BoxConstraints(
                maxHeight: height - bottomBarHeight - 120,
              ),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: entities.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(i18n?.t('layrz.taskbar.no_results') ?? "No results found"),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: entities.length,
                      itemBuilder: (context, index) {
                        SearchEntity entity = entities[index];
                        Color cardColor =
                            hoveredEntities[entity] == true ? bottomBarHoverColor : Theme.of(context).cardColor;
                        return InkWell(
                          onTap: () {
                            widget.onHideTap.call();
                            widget.onEntityTap?.call(entity);
                          },
                          onHover: (value) {
                            setState(() {
                              hoveredEntities[entity] = value;
                            });
                          },
                          child: AnimatedContainer(
                            duration: duration,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                if (entity.icon != null) ...[
                                  Icon(
                                    entity.icon,
                                    color: validateColor(color: cardColor),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        entity.name,
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              color: validateColor(color: bottomBarHoverColor),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                      ),
                                      Text(
                                        i18n?.t('layrz.taskbar.types.${entity.type.name}') ?? entity.type.name,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: validateColor(color: bottomBarHoverColor),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
          Container(
            height: bottomBarHeight + (widget.version != null ? 50 : 20),
            color: bottomBarColor,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.version != null) ...[
                  const SizedBox(height: 10),
                  Opacity(
                    opacity: 0.4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "v${widget.version}",
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Tooltip(
                          message: i18n?.t('layrz.taskbar.profile') ?? "Edit profile",
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () {
                                widget.onHideTap.call();
                                widget.onProfileTap?.call();
                              },
                              onHover: (value) {
                                if (widget.onProfileTap != null) {
                                  setState(() => isProfileHover = value);
                                }
                              },
                              child: AnimatedContainer(
                                duration: duration,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: isProfileHover ? bottomBarHoverColor : bottomBarColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    if (widget.userAvatar != null || widget.userDynamicAvatar != null) ...[
                                      drawAvatar(
                                        context: context,
                                        avatar: widget.userAvatar,
                                        dynamicAvatar: widget.userDynamicAvatar,
                                        size: bottomBarHeight - 20,
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                    Expanded(
                                      child: Text(
                                        widget.userName,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: validateColor(color: bottomBarColor),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (widget.enableAbout) ...[
                        const SizedBox(width: 10),
                        Tooltip(
                          message: i18n?.t('layrz.taskbar.about') ?? "About",
                          child: InkWell(
                            onHover: (value) {
                              setState(() => isAboutHover = value);
                            },
                            child: AnimatedContainer(
                              duration: duration,
                              width: bottomBarHeight - 20,
                              height: bottomBarHeight - 20,
                              decoration: BoxDecoration(
                                color: isAboutHover ? bottomBarHoverColor : bottomBarColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                MdiIcons.informationOutline,
                                color: validateColor(color: bottomBarColor),
                                size: 20,
                              ),
                            ),
                            onTap: () {
                              widget.onHideTap.call();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ThemedLicensesView(
                                    companyName: widget.companyName,
                                    logo: widget.logo,
                                    version: widget.version,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      if (widget.onSettingsTap != null) ...[
                        const SizedBox(width: 10),
                        Tooltip(
                          message: i18n?.t('layrz.taskbar.settings') ?? "Settings",
                          child: InkWell(
                            onHover: (value) {
                              setState(() => isSettingsHover = value);
                            },
                            child: AnimatedContainer(
                              duration: duration,
                              width: bottomBarHeight - 20,
                              height: bottomBarHeight - 20,
                              decoration: BoxDecoration(
                                color: isSettingsHover ? bottomBarHoverColor : bottomBarColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                MdiIcons.cogOutline,
                                color: validateColor(color: bottomBarColor),
                                size: 20,
                              ),
                            ),
                            onTap: () {
                              widget.onHideTap.call();
                              widget.onSettingsTap?.call();
                            },
                          ),
                        ),
                      ],
                      if (widget.onLogoutTap != null) ...[
                        const SizedBox(width: 10),
                        Tooltip(
                          message: i18n?.t('layrz.taskbar.logout') ?? "Logout",
                          child: InkWell(
                            onHover: (value) {
                              setState(() => isLogoutHover = value);
                            },
                            child: AnimatedContainer(
                              duration: duration,
                              width: bottomBarHeight - 20,
                              height: bottomBarHeight - 20,
                              decoration: BoxDecoration(
                                color: isLogoutHover ? bottomBarHoverColor : bottomBarColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                MdiIcons.logoutVariant,
                                color: validateColor(color: bottomBarColor),
                                size: 20,
                              ),
                            ),
                            onTap: () {
                              widget.onHideTap.call();
                              widget.onLogoutTap?.call();
                            },
                          ),
                        ),
                      ],
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
