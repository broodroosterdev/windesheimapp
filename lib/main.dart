import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:wind/providers.dart';
import 'package:wind/route_generator.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
  FlutterNativeSplash.remove();
}
