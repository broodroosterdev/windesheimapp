import 'dart:io';

import 'package:flutter/material.dart';
import 'package:windesheimapp/providers.dart';
import 'package:windesheimapp/route_generator.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initProviders();

  runApp(
    MaterialApp(
      title: 'WindesheimApp',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(255, 203, 5, 1.0),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
    ),
  );
}
