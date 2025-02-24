part of '../snackbars.dart';

class BasicSnackbarView extends StatefulWidget {
  final String name;

  const BasicSnackbarView({
    super.key,
    this.name = 'Generic View',
  });

  @override
  State<BasicSnackbarView> createState() => _BasicSnackbarViewState();
}

class _BasicSnackbarViewState extends State<BasicSnackbarView> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Normally, all apps requires some way to show notifications, that's why the snackbars exists. "
              "Snackbars are extremely useful to show information about a specific element, give a hint or show "
              "a warning. Let's see some examples:",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
              maxLines: 10,
            ),
            const SizedBox(height: 20),
            ThemedButton(
              color: Colors.blue,
              icon: LayrzIcons.solarOutlineTagHorizontal,
              labelText: 'Simple snackbar',
              onTap: () {
                ThemedSnackbarMessenger.of(context).showSnackbar(ThemedSnackbar(
                  message: 'This is a simple snackbar',
                ));
              },
            ),
            const SizedBox(height: 10),
            const Text(
              "Awesome, right? Now, let's add some properties, for example a color",
              maxLines: 10,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            ThemedButton(
              color: Colors.blue,
              icon: LayrzIcons.solarOutlineTagHorizontal,
              labelText: 'Colored snackbar',
              onTap: () {
                ThemedSnackbarMessenger.of(context).showSnackbar(ThemedSnackbar(
                  message: 'This is a colored snackbar',
                  color: Colors.green,
                ));
              },
            ),
            const SizedBox(height: 10),
            const Text(
              "Great! Now, let's add a title to the snackbar",
              maxLines: 10,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            ThemedButton(
              color: Colors.blue,
              icon: LayrzIcons.solarOutlineTagHorizontal,
              labelText: 'Titled snackbar',
              onTap: () {
                ThemedSnackbarMessenger.of(context).showSnackbar(ThemedSnackbar(
                  title: 'Title',
                  message: 'This is a snackbar with a title',
                  color: Colors.green,
                ));
              },
            ),
            const SizedBox(height: 10),
            const Text(
              "Finally, let's add an icon to the snackbar",
              maxLines: 10,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            ThemedButton(
              color: Colors.blue,
              icon: LayrzIcons.solarOutlineTagHorizontal,
              labelText: 'Icon snackbar',
              onTap: () {
                ThemedSnackbarMessenger.of(context).showSnackbar(ThemedSnackbar(
                  title: 'Title',
                  message: 'This is a snackbar with an icon',
                  color: Colors.green,
                  icon: LayrzIcons.solarOutlineTagHorizontal,
                  duration: const Duration(seconds: 10),
                ));
              },
            ),
            const SizedBox(height: 10),
            const Text(
              "What happens if we want to display a long message? Let's see it in the next example",
              maxLines: 10,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            ThemedButton(
              color: Colors.blue,
              icon: LayrzIcons.solarOutlineTagHorizontal,
              labelText: 'Long snackbar',
              onTap: () {
                ThemedSnackbarMessenger.of(context).showSnackbar(ThemedSnackbar(
                  title: 'Long snackbar',
                  message: 'This is a snackbar with a message exceeding the maximum length, if you can see, the '
                      'message is displayed in multiple lines, and also the title is displayed in bold',
                  color: Colors.green,
                  maxLines: 10,
                  icon: LayrzIcons.solarOutlineTagHorizontal,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
