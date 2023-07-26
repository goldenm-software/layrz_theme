import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginExampleView extends StatefulWidget {
  final String name;

  const LoginExampleView({
    super.key,
    this.name = 'Generic View',
  });

  @override
  State<LoginExampleView> createState() => _LoginExampleViewState();
}

class _LoginExampleViewState extends State<LoginExampleView> {
  String username = "";
  String password = "";
  List<String> usernameErrors = [];
  List<String> passwordErrors = [];
  bool showPassword = false;
  bool isLoading = false;
  bool isCooldown = false;

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    return Layout(
      showDrawer: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Login interface Example',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ThemedTextInput(
              labelText: 'Username',
              value: username,
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
              prefixIcon: MdiIcons.account,
              errors: usernameErrors,
            ),
            ThemedTextInput(
              labelText: 'Password',
              value: password,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              prefixIcon: MdiIcons.lock,
              suffixIcon: showPassword ? MdiIcons.eyeOff : MdiIcons.eye,
              obscureText: !showPassword,
              onSuffixTap: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              errors: passwordErrors,
            ),
            Text("Username: $username"),
            Text("Password: $password"),
            ThemedButton(
              labelText: 'Clear',
              onTap: () {
                setState(() {
                  username = "";
                  password = "";
                  usernameErrors = [];
                  passwordErrors = [];
                });
              },
            ),
            const SizedBox(height: 10),
            ThemedButton(
              style: ThemedButtonStyle.filledTonal,
              labelText: 'Login',
              color: themeMode == ThemeMode.dark ? Colors.blue.shade400 : Colors.green.shade600,
              onTap: _login,
              isLoading: isLoading,
              isCooldown: isCooldown,
              width: 200,
              cooldownDuration: const Duration(seconds: 3),
              icon: MdiIcons.login,
            ),
            const SizedBox(height: 10),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });
    debugPrint("Login");
    passwordErrors = [];
    usernameErrors = [];

    bool isValid = true;
    if (username.isEmpty) {
      usernameErrors = ["Username is required"];
      isValid = false;
    } else if (username.length < 3) {
      usernameErrors = ["Username is too short"];
      isValid = false;
    }

    if (password.isEmpty) {
      passwordErrors = ["Password is required"];
      isValid = false;
    } else if (password.length < 6) {
      passwordErrors = ["Password is too short"];
      isValid = false;
    }

    if (!isValid) {
      setState(() {
        isCooldown = true;
        isLoading = false;
      });
      await Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isCooldown = false;
        });
      });
      return;
    }
    await Future.delayed(const Duration(seconds: 5), () {
      /// Simulando delay de una petición a un servidor
      /// logica de hacer login AQUI
      if (username == 'goldenm' && password == '123456') {
        // ScaffoldMessenger.of(context).showSnackBar(drawSnackbar(
        //   title: "Success",
        //   context: context,
        //   color: Colors.green.shade600,
        //   message: 'Login success',
        // ));
        usernameErrors = [];
        passwordErrors = [];
      } else {
        usernameErrors = ["Username or Password is not valid"];
        passwordErrors = ["Username or Password is not valid"];
        // ScaffoldMessenger.of(context).showSnackBar(drawSnackbar(
        //   title: "Error",
        //   context: context,
        //   color: Colors.red,
        //   message: 'Login failed',
        // ));
      }
    });
    setState(() {
      isLoading = false;
    });
  }
}
