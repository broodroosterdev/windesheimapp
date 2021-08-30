import 'package:flutter/material.dart';
import 'package:windesheimapp/pages/login.dart';
import 'package:windesheimapp/pages/login_confirm.dart';
import 'package:windesheimapp/pages/schedule/rooster.dart';
import 'package:windesheimapp/pages/settings/add_schedule_page.dart';
import 'package:windesheimapp/pages/settings/settings_page.dart';
import 'package:windesheimapp/providers.dart';
import 'package:windesheimapp/services/auth/auth_manager.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //Get the arguments passed into the Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
          if(AuthManager.loggedIn) {
            return MaterialPageRoute(builder: (_) => SchedulePage());
          } else {
            return MaterialPageRoute(builder: (_) => LoginPage());
          }
      case '/login-confirm':
        final arguments = args as Map<String, String>;
        return MaterialPageRoute(
            builder: (_) => LoginConfirmPage(email: arguments['email']!, password: arguments['password']!));
      case '/rooster':
        return MaterialPageRoute(
          builder: (_) => SchedulePage());
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => SettingsPage());
      case '/add-schedule':
        return MaterialPageRoute(
          builder: (_) => AddSchedulePage());
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
