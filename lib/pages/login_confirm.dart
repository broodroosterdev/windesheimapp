import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';
import '../preferences.dart';
import '../providers.dart';

class LoginConfirmPage extends StatefulWidget {
  final String code;

  const LoginConfirmPage({Key? key, required this.code}) : super(key: key);

  @override
  _LoginConfirmPageState createState() => new _LoginConfirmPageState();
}

class _LoginConfirmPageState extends State<LoginConfirmPage> {
  @override
  void initState() {
    super.initState();
    if (widget.code != '') {
      doLogin();
    }
  }

  void doLogin() async {
    final response = await http.post(
        Uri.parse(
            "https://login.microsoftonline.com/e36377b7-70c4-4493-a338-095918d327e9/oauth2/token"),
        body: {
          'resource': "https://windesheimapi.azurewebsites.net/login/aad",
          'client_id': "7cd9c6cb-1da9-4d26-93e4-7c0beb04793f",
          'grant_type': "authorization_code",
          'code': widget.code,
          'redirect_uri': "https://localhost"
        });
    print(response.body);
    Map<String, dynamic> json = jsonDecode(response.body);
    print(json.keys);
    prefs.accessToken = json['access_token'];
    prefs.refreshToken = json['refresh_token'];
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
            ChangeNotifierProvider.value(
              value: prefs,
              child:
                  Consumer<Preferences>(builder: (context, preferences, child) {
                if (preferences.accessToken != '') {
                  final String data = preferences.accessToken.split('.')[1];
                  final String payload =
                      utf8.decode(base64Url.decode(base64Url.normalize(data)));
                  final payloadMap = json.decode(payload);
                  return Text('Welkom ' + payloadMap['given_name']);
                } else {
                  return const CircularProgressIndicator();
                }
              }),
            ),
            ElevatedButton(
                onPressed: () {
                  prefs.accessToken = '';
                  prefs.refreshToken = '';
                  navigatorKey.currentState!
                      .pushNamedAndRemoveUntil("/", (r) => false);
                },
                child: Text('Uitloggen'))
          ],
        ),
      ),
    );
  }
}
