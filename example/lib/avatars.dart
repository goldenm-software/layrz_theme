import 'dart:async';

import 'package:flutter/material.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AvatarsView extends StatefulWidget {
  final String name;

  const AvatarsView({
    super.key,
    this.name = 'Generic View',
  });

  @override
  State<AvatarsView> createState() => _AvatarsViewState();
}

class _AvatarsViewState extends State<AvatarsView> {
  List<int> selected = [];
  List<ThemedSelectItem<int>> get choices => [];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      debugPrint("Tick on AvatarsView");
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      showDrawer: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dynamic Avatar [AvatarType.none]",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(6, (i) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: drawAvatar(
                          context: context,
                          dynamicAvatar: const Avatar(type: AvatarType.none),
                          name: 'John Doe',
                          size: (30 + (15 * i)).toDouble(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Dynamic avatar [AvatarType.url] [Background transparent]",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    ...List.generate(6, (i) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: drawAvatar(
                          context: context,
                          color: Colors.grey.shade300,
                          dynamicAvatar: const Avatar(
                            type: AvatarType.url,
                            url: 'https://cdn.layrz.com/avatars/Kenny Phone.png',
                          ),
                          elevation: 1,
                          name: 'John Doe',
                          size: (30 + (15 * i)).toDouble(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Text(
                "Dynamic avatar [AvatarType.url] [Background solid]",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    ...List.generate(6, (i) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: drawAvatar(
                          context: context,
                          dynamicAvatar: const Avatar(
                            type: AvatarType.url,
                            url: 'https://layrz-development.s3-us-west-2.amazonaws.com/avatars/Golden M.jpg',
                          ),
                          elevation: 1,
                          name: 'John Doe',
                          size: (30 + (15 * i)).toDouble(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Dynamic avatar [AvatarType.icon]",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    ...List.generate(6, (i) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: drawAvatar(
                          context: context,
                          color: Colors.white,
                          dynamicAvatar: Avatar(type: AvatarType.icon, icon: MdiIcons.account),
                          elevation: 1,
                          name: 'John Doe',
                          size: (30 + (15 * i)).toDouble(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Dynamic avatar [AvatarType.emoji]",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    ...List.generate(6, (i) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: drawAvatar(
                          context: context,
                          color: Colors.white,
                          dynamicAvatar: const Avatar(type: AvatarType.emoji, emoji: '👨‍🦰'),
                          elevation: 1,
                          name: 'John Doe',
                          size: (30 + (15 * i)).toDouble(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
