import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wind/services/auth/auth_manager.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({this.redirectRoute = "/rooster", Key? key})
      : super(key: key);

  final String redirectRoute;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String email = '';
  String password = '';
  String? error;
  bool loading = false;
  bool visiblePassword = false;

  void changeEmail(text) {
    setState(() {
      email = text;
    });
  }

  void changePassword(text) {
    setState(() {
      password = text;
    });
  }

  void login() async {
    setState(() {
      loading = true;
      error = null;
    });

    var apiResponse = await AuthManager.loginApi(email, password);

    if (apiResponse.isFailure) {
      showError(apiResponse.failure.message);
      return;
    }

    await navigatorKey.currentState!.pushNamed(widget.redirectRoute);
  }

  void showError(String error) {
    setState(() {
      loading = false;
      this.error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutofillGroup(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(image: AssetImage('assets/logo.png')),
                const Text("Windesheim",
                    style: TextStyle(
                        color: Color.fromRGBO(255, 203, 5, 1.0),
                        fontFamily: 'Noto Sans',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontSize: 36)),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextField(
                    autofillHints: const [
                      AutofillHints.email,
                      AutofillHints.username
                    ],
                    controller: usernameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      labelText: "Email",
                      errorText: error,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) => changeEmail(text),
                  ),
                ),
                TextField(
                  autofillHints: const [AutofillHints.password],
                  obscureText: !visiblePassword,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password),
                    labelText: "Wachtwoord",
                    suffixIcon: IconButton(
                      icon: Icon(
                        visiblePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => visiblePassword = !visiblePassword),
                    ),
                    errorText: error != null ? '' : null,
                  ),
                  onChanged: (text) => changePassword(text),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: loading ? null : login,
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Inloggen",
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
