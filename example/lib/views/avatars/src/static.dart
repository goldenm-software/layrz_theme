part of '../avatars.dart';

class StaticAvatarsView extends StatefulWidget {
  const StaticAvatarsView({super.key});

  @override
  State<StaticAvatarsView> createState() => _StaticAvatarsViewState();
}

class _StaticAvatarsViewState extends State<StaticAvatarsView> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "What is a static avatar?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "It's simple, avatars using static images or icons are static avatars (In the Layrz philosophy).",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              "How to use it?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "To generate an avatar, you will use an utility function drawAvatar, here is an example:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const ThemedCodeSnippet(
              code: "ThemedAvatar(size: 30)",
            ),
            const SizedBox(height: 10),
            Text(
              "Result:",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const ThemedAvatar(size: 30),
            const SizedBox(height: 10),
            Text(
              "You can also change the color of the avatar using the argument color:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const ThemedCodeSnippet(
              code: "ThemedAvatar(size: 30, color: Colors.red)",
            ),
            const SizedBox(height: 10),
            Text(
              "Result:",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const ThemedAvatar(size: 30, color: Colors.red),
            const SizedBox(height: 10),
            Text(
              "Look this other examples:",
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
                  name: 'Using an image',
                  avatar: 'https://cdn.layrz.com/resources/layo/layo2.png',
                  codeExample:
                      "ThemedAvatar(size: 50, avatar: "
                      "'https://cdn.layrz.com/resources/layo/layo2.png')",
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                _buildExampleRow(
                  name: 'Using an icon w/ a color',
                  icon: LayrzIcons.mdiAccount,
                  color: Colors.green,
                  codeExample: "ThemedAvatar(size: 50, icon: LayrzIcons.mdiAccount, color: Colors.green)",
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                _buildExampleRow(
                  name: 'Changing the border radius and elevation',
                  avatar: 'https://cdn.layrz.com/resources/layo/layo2.png',
                  radius: 10,
                  elevation: 3,
                  codeExample:
                      "ThemedAvatar(size: 50, avatar: "
                      "'https://cdn.layrz.com/resources/layo/layo2.png', radius: 10, elevation: 3)",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleRow({
    required String name,
    String? avatar,
    IconData? icon,
    required String codeExample,
    Color? color,
    double? radius,
    double? elevation,
  }) {
    return Row(
      children: [
        ThemedAvatar(
          size: 30,
          name: 'Example',
          avatar: avatar,
          icon: icon,
          color: color,
          radius: radius ?? 30,
          elevation: elevation ?? 1,
          onTap: () {
            debugPrint("Tapped on $name");
          },
          onLongTap: () {
            debugPrint("Long tapped on $name");
          },
          onSecondaryTap: () {
            debugPrint("Secondary tapped on $name");
          },
        ),
        const SizedBox(width: 5),
        Expanded(child: Text(name)),
        const SizedBox(width: 5),
        ThemedButton(
          icon: LayrzIcons.mdiContentCopy,
          color: Colors.blue,
          labelText: "Get the code",
          onTap: () {
            Clipboard.setData(ClipboardData(text: codeExample));
            ThemedSnackbarMessenger.of(context).showSnackbar(
              ThemedSnackbar(
                message: "Copied to clipboard",
                icon: LayrzIcons.mdiClipboardCheckOutline,
                color: Colors.green,
              ),
            );
          },
        ),
      ],
    );
  }
}
