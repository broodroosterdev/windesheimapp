import 'package:flex_color_scheme/flex_color_scheme.dart';
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
      theme: FlexThemeData.light(scheme: FlexScheme.bigStone, surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold, blendLevel: 18),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.bigStone, surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold, blendLevel: 18),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
    ),
  );
}
