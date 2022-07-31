import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:wind/pages/widgets/app_drawer.dart';

class AppPage extends HookWidget {
  final String title;
  final Widget child;
  final bool withDrawer;

  const AppPage(
      {Key? key,
      required this.title,
      required this.child,
      this.withDrawer = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: withDrawer ? AppDrawer() : null,
      body: child,
    );
  }
}
