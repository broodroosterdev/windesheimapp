import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wind/services/auth/auth_manager.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String email = '';
  String password = '';
  String? error = null;
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
      this.error = null;
    });

    //Don't try both login's at once because this will cause a rapid deactivation of your password...
    var eloResponse = await AuthManager.loginElo(email, password);

    if (eloResponse.isLeft()) {
      eloResponse.fold((error) => showError(error.message), (_) {});
      return;
    }

    var apiResponse = await AuthManager.loginApi(email, password);

    if (apiResponse.isLeft()) {
      apiResponse.fold((error) => showError(error.message), (_) {});
      return;
    }

    navigatorKey.currentState!.pushNamed("/rooster");
  }

  void showError(String error) {
    setState(() {
      this.loading = false;
      this.error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 18, 19, 1.0),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "Email",
                    // errorText: error,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (text) => changeEmail(text),
                ),
                TextField(
                  obscureText: !visiblePassword,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    labelText: "Wachtwoord",
                    suffixIcon: IconButton(
                      icon: Icon(
                        visiblePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => visiblePassword = !visiblePassword),
                    ),
                    errorText: error,
                  ),
                  onChanged: (text) => changePassword(text),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 0),
                  child: SizedBox(
                    width: 300,
                    height: 70,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) => Theme.of(context).primaryColor),
                      ),
                      onPressed: loading ? null : login,
                      child: loading
                          ? CircularProgressIndicator()
                          : const Text(
                              "Inloggen",
                              style: TextStyle(fontSize: 33, color: Colors.black),
                            ),
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
