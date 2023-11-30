part of avatars;

class DynamicAvatarsView extends StatefulWidget {
  const DynamicAvatarsView({super.key});

  @override
  State<DynamicAvatarsView> createState() => _DynamicAvatarsViewState();
}

class _DynamicAvatarsViewState extends State<DynamicAvatarsView> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "What is a dynamic avatar?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "It's similar as the static avatar, but using an model entity (from layrz_models) "
              "to generate the avatar. This dynamic avatar is used in some of the other components and is our "
              "standard avatar.",
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            Text(
              "How to use it?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "Like the static avatar, to generate an avatar, you will use an utility function drawAvatar, "
              "here is an example:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const ThemedCodeSnippet(
              code: "drawAvatar(context: context, size: 30, dynamicAvatar: Avatar(type: AvatarType.url, "
                  "url: 'https://cdn.layrz.com/resources/layo/layo2.png'))",
            ),
            const SizedBox(height: 10),
            Text(
              "Result:",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            drawAvatar(
              context: context,
              size: 30,
              dynamicAvatar: const Avatar(
                type: AvatarType.url,
                url: 'https://cdn.layrz.com/resources/layo/layo2.png',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Look at this examples:",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "Our functions offers inline documentation, so you can see all the arguments and their types.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 10),
              children: [
                ListTile(
                  leading: drawAvatar(
                    context: context,
                    size: 30,
                    name: 'Example',
                    dynamicAvatar: const Avatar(type: AvatarType.none),
                  ),
                  title: const Text("Type none"),
                  trailing: ThemedButton(
                    icon: MdiIcons.contentCopy,
                    labelText: "Get the code",
                    onTap: () {
                      Clipboard.setData(const ClipboardData(
                        text: "drawAvatar(context: context, size: 30, name: 'Example', "
                            "dynamicAvatar: const Avatar(type: AvatarType.none))",
                      ));
                      // showThemedSnackbar(ThemedSnackbar(
                      //   context: context,
                      //   message: "Copied to clipboard",
                      //   icon: MdiIcons.clipboardCheckOutline,
                      //   color: Colors.green,
                      // ));
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                ListTile(
                  leading: drawAvatar(
                    context: context,
                    size: 30,
                    name: 'Example',
                    dynamicAvatar: const Avatar(
                      type: AvatarType.url,
                      url: 'https://cdn.layrz.com/resources/layo/layo2.png',
                    ),
                  ),
                  title: const Text("Type url"),
                  trailing: ThemedButton(
                    icon: MdiIcons.contentCopy,
                    labelText: "Get the code",
                    onTap: () {
                      Clipboard.setData(const ClipboardData(
                        text: "drawAvatar(context: context, size: 30, name: 'Example', dynamicAvatar: "
                            "const Avatar(type: AvatarType.url, url: 'https://cdn.layrz.com/resources/layo/"
                            "layo2.png'))",
                      ));
                      // showThemedSnackbar(ThemedSnackbar(
                      //   context: context,
                      //   message: "Copied to clipboard",
                      //   icon: MdiIcons.clipboardCheckOutline,
                      //   color: Colors.green,
                      // ));
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                ListTile(
                  leading: drawAvatar(
                    context: context,
                    size: 30,
                    name: 'Example',
                    dynamicAvatar: Avatar(
                      type: AvatarType.icon,
                      icon: MdiIcons.clipboard,
                    ),
                  ),
                  title: const Text("Type icon"),
                  trailing: ThemedButton(
                    icon: MdiIcons.contentCopy,
                    labelText: "Get the code",
                    onTap: () {
                      Clipboard.setData(const ClipboardData(
                        text: "drawAvatar(context: context, size: 30, name: 'Example', dynamicAvatar: "
                            "Avatar(type: AvatarType.icon, icon: MdiIcons.clipboard))",
                      ));
                      // showThemedSnackbar(ThemedSnackbar(
                      //   context: context,
                      //   message: "Copied to clipboard",
                      //   icon: MdiIcons.clipboardCheckOutline,
                      //   color: Colors.green,
                      // ));
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                ListTile(
                  leading: drawAvatar(
                    context: context,
                    size: 30,
                    name: 'Example',
                    dynamicAvatar: const Avatar(
                      type: AvatarType.emoji,
                      emoji: '👍',
                    ),
                  ),
                  title: const Text("Type emoji"),
                  trailing: ThemedButton(
                    icon: MdiIcons.contentCopy,
                    labelText: "Get the code",
                    onTap: () {
                      Clipboard.setData(const ClipboardData(
                        text: "drawAvatar(context: context, size: 30, name: 'Example', dynamicAvatar: "
                            "const Avatar(type: AvatarType.emoji, emoji: '👍'))",
                      ));
                      // showThemedSnackbar(ThemedSnackbar(
                      //   context: context,
                      //   message: "Copied to clipboard",
                      //   icon: MdiIcons.clipboardCheckOutline,
                      //   color: Colors.green,
                      // ));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
