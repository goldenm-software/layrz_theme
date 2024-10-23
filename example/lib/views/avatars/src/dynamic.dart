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
              code: "ThemedAvatar(size: 30, dynamicAvatar: Avatar(type: AvatarType.url, "
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
            const ThemedAvatar(
              size: 30,
              name: 'Example',
              dynamicAvatar: Avatar(
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
                _buildExampleRow(
                  avatar: const Avatar(type: AvatarType.none),
                  codeExample: "ThemedAvatar(size: 30, name: 'Example', "
                      "dynamicAvatar: const Avatar(type: AvatarType.none))",
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                _buildExampleRow(
                  avatar: const Avatar(type: AvatarType.url, url: 'https://cdn.layrz.com/resources/layo/layo2.png'),
                  codeExample: "ThemedAvatar(size: 30, name: 'Example', dynamicAvatar: "
                      "const Avatar(type: AvatarType.url, url: 'https://cdn.layrz.com/resources/layo/"
                      "layo2.png'))",
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                _buildExampleRow(
                  avatar: Avatar(type: AvatarType.icon, icon: MdiIcons.clipboard),
                  codeExample: "ThemedAvatar(size: 30, name: 'Example', dynamicAvatar: "
                      "Avatar(type: AvatarType.icon, icon: MdiIcons.clipboard))",
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                _buildExampleRow(
                  avatar: const Avatar(type: AvatarType.emoji, emoji: '👍'),
                  codeExample: "ThemedAvatar(size: 30, name: 'Example', dynamicAvatar: "
                      "const Avatar(type: AvatarType.emoji, emoji: '👍'))",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleRow({
    required Avatar avatar,
    required String codeExample,
  }) {
    return Row(
      children: [
        ThemedAvatar(
          size: 30,
          name: 'Example',
          dynamicAvatar: avatar,
          onTap: () {
            debugPrint("Tapped on ${avatar.type}");
          },
          onLongTap: () {
            debugPrint("Long tapped on ${avatar.type}");
          },
          onSecondaryTap: () {
            debugPrint("Secondary tapped on ${avatar.type}");
          },
        ),
        const SizedBox(width: 5),
        Expanded(child: Text("Type ${avatar.type}")),
        const SizedBox(width: 5),
        ThemedButton(
          icon: MdiIcons.contentCopy,
          color: Colors.blue,
          labelText: "Get the code",
          onTap: () {
            Clipboard.setData(ClipboardData(text: codeExample));
            ThemedSnackbarMessenger.of(context).showSnackbar(ThemedSnackbar(
              message: "Copied to clipboard",
              icon: MdiIcons.clipboardCheckOutline,
              color: Colors.green,
            ));
          },
        )
      ],
    );
  }
}
