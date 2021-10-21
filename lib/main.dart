import 'package:flutter/material.dart';
import 'package:wind/providers.dart';
import 'package:wind/route_generator.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initProviders();

  runApp(
    MaterialApp(
      title: 'wind',
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white))),
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.yellow, brightness: Brightness.dark),
        primaryColor: const Color.fromRGBO(255, 203, 5, 1.0),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
    ),
  );
}
