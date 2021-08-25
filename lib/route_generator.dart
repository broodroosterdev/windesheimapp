import 'package:flutter/material.dart';
import 'package:windesheimapp/pages/login.dart';
import 'package:windesheimapp/pages/login_confirm.dart';
import 'package:windesheimapp/pages/rooster.dart';
import 'package:windesheimapp/providers.dart';
import 'package:windesheimapp/services/auth/auth_manager.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //Get the arguments passed into the Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
          if(AuthManager.loggedIn) {
            return MaterialPageRoute(builder: (_) => RoosterPage());
          } else {
            return MaterialPageRoute(builder: (_) => LoginPage());
          }
      case '/login-confirm':
        final arguments = args as Map<String, String>;
        return MaterialPageRoute(
            builder: (_) => LoginConfirmPage(email: arguments['email']!, password: arguments['password']!));
      case '/rooster':
        return MaterialPageRoute(
          builder: (_) => RoosterPage());
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
