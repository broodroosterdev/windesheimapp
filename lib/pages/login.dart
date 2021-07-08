import 'package:flutter/material.dart';
import 'package:windesheimapp/services/auth/elo_auth.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String username = '';
  String password = '';
  String loading = 'done';
  void changeUsername(text) {
    setState(() {
      username = text;
    });
  }

  void changePassword(text) {
    setState(() {
      password = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 18, 19, 1.0),
      body: Center(
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
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Gebruikersnaam",
              ),
              onChanged: (text) => changeUsername(text),
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.password),
                labelText: "Wachtwoord",
              ),
              onChanged: (text) => changePassword(text),
            ),
            Text(loading),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 0),
              child: SizedBox(
                width: 300,
                height: 70,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Theme.of(context).primaryColor;
                    }),
                  ),
                  onPressed: () async {
                    setState(() {
                      loading = 'Loading';
                    });
                    String code = await EloAuth.login(
                        usernameController.text, passwordController.text);
                    setState(() {
                      loading = 'done';
                    });
                    await navigatorKey.currentState!
                        .pushNamed('/login-confirm', arguments: code);
                  },
                  child: const Text(
                    "Inloggen",
                    style: TextStyle(fontSize: 33, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
