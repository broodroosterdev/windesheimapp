import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../main.dart';

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
                  onPressed: () {
                    widget.browser.openUrlRequest(
                        urlRequest: URLRequest(
                            url: Uri.parse(
                                "https://login.microsoftonline.com/e36377b7-70c4-4493-a338-095918d327e9/oauth2/authorize?resource=https%3A%2F%2Fwindesheimapi.azurewebsites.net%2Flogin%2Faad&client_id=7cd9c6cb-1da9-4d26-93e4-7c0beb04793f&response_type=code&haschrome=1&redirect_uri=https%3A%2F%2Flocalhost&client-request-id=6249263f-19c7-4e4f-b5ce-58d9eca344a9&prompt=login&x-client-SKU=PCL.Android&x-client-Ver=3.14.1.10")),
                        options: options);
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

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    if (url != null && url.host.contains("localhost")) {
      hide();
      navigatorKey.currentState!
          .pushNamed('/login-confirm', arguments: url.queryParameters['code']);
    }
    //print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    if (url != null && url.host.contains("localhost")) {
      close();
    }
    //print("Stopped $url");
  }

  @override
  void onLoadError(url, code, message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onExit() {
    print("Browser closed!");
  }
}
