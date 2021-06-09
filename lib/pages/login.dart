import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final MyInAppBrowser browser = new MyInAppBrowser();

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String access = "";
  String refresh = "";
  var options = InAppBrowserClassOptions(
      crossPlatform: InAppBrowserOptions(hideUrlBar: false),
      inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(javaScriptEnabled: true)));

  @override
  void initState() {
    super.initState();
    _loadTokens();
  }

  void _loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      access = prefs.getString('access-token') ?? '';
      refresh = prefs.getString('refresh-token') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Windesheim App'),
      ),
      body: ListView(children: [
        ElevatedButton(
            onPressed: () {
              widget.browser.openUrlRequest(
                  urlRequest: URLRequest(
                      url: Uri.parse(
                          "https://login.microsoftonline.com/e36377b7-70c4-4493-a338-095918d327e9/oauth2/authorize?resource=https%3A%2F%2Fwindesheimapi.azurewebsites.net%2Flogin%2Faad&client_id=7cd9c6cb-1da9-4d26-93e4-7c0beb04793f&response_type=code&haschrome=1&redirect_uri=https%3A%2F%2Flocalhost&client-request-id=6249263f-19c7-4e4f-b5ce-58d9eca344a9&prompt=login&x-client-SKU=PCL.Android&x-client-Ver=3.14.1.10")),
                  options: options);
            },
            child: Text("Open InAppBrowser")),
        Text(access),
        Text(refresh)
      ]),
    );
  }
}

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    //print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    if (url != null && url.host.contains("localhost")) {
      print(url);
      print(url.queryParameters);
      final response = await http.post(
          Uri.parse(
              "https://login.microsoftonline.com/e36377b7-70c4-4493-a338-095918d327e9/oauth2/token"),
          body: {
            'resource': "https://windesheimapi.azurewebsites.net/login/aad",
            'client_id': "7cd9c6cb-1da9-4d26-93e4-7c0beb04793f",
            'grant_type': "authorization_code",
            'code': url.queryParameters['code'],
            'redirect_uri': "https://localhost"
          });
      print(response.body);
      Map<String, dynamic> json = jsonDecode(response.body);
      print(json.keys);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('access-token', json['access_token']);
      prefs.setString('refresh-token', json['refresh_token']);
      print(response.body);

      close();
    }
    //print("Stopped $url");
  }

  @override
  void onLoadError(url, code, message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    //print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser closed!");
  }
}
