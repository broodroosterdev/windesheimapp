import 'package:flutter/material.dart';
import 'package:windesheimapp/pages/login.dart';
import 'package:windesheimapp/pages/login_confirm.dart';
import 'package:windesheimapp/providers.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //Get the arguments passed into the Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        if (prefs.accessToken != '') {
          return MaterialPageRoute(
              builder: (_) => const LoginConfirmPage(code: ''));
        } else {
          return MaterialPageRoute(builder: (_) => LoginPage());
        }
      case '/login-confirm':
        return MaterialPageRoute(
            builder: (_) => LoginConfirmPage(code: args as String));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
