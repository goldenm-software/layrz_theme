import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/store/store.dart';

class NotFoundView extends StatefulWidget {
  const NotFoundView({super.key});

  @override
  State<NotFoundView> createState() => _NotFoundViewState();
}

class _NotFoundViewState extends State<NotFoundView> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "404",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Page not found",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "The page you are looking for does not exist.",
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 5,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            ThemedButton(
              labelText: "Go home",
              style: ThemedButtonStyle.text,
              icon: Icons.home,
              color: Colors.blue,
              onTap: () {
                context.go('/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
