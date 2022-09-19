import 'package:flutter/material.dart';
import 'package:wind/services/auth/auth_manager.dart';

import '../../main.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset("assets/launcher_icon_transparent.png"),
          ),
          ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Rooster'),
              onTap: () {
                navigatorKey.currentState!.popAndPushNamed("/rooster");
              }),
          ListTile(
              leading: const Icon(Icons.school_outlined),
              title: const Text('Studie'),
              onTap: () {
                navigatorKey.currentState!.popAndPushNamed("/study");
              }),
          ListTile(
              leading: const Icon(Icons.feed_outlined),
              title: const Text('Nieuws'),
              onTap: () {
                navigatorKey.currentState!.popAndPushNamed("/news");
              }),
          ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Instellingen'),
              onTap: () {
                navigatorKey.currentState!.popAndPushNamed("/settings");
              }),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Uitloggen'),
              onTap: () {
                AuthManager.logout().then((_) => navigatorKey.currentState!
                    .pushNamedAndRemoveUntil("/", (r) => false));
              }),
        ],
      ),
    );
  }
}
