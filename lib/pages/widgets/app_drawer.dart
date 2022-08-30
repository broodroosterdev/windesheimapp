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
              leading: Icon(Icons.calendar_today),
              title: Text('Rooster'),
              onTap: () {
                navigatorKey.currentState!.popAndPushNamed("/rooster");
              }),
          ListTile(
              leading: Icon(Icons.book_outlined),
              title: Text('ELO'),
              onTap: () {
                navigatorKey.currentState!.popAndPushNamed("/studyroutes");
              }),
          ListTile(
              leading: Icon(Icons.school_outlined),
              title: Text('Studie'),
              onTap: () {
                navigatorKey.currentState!.popAndPushNamed("/study");
              }),
          ListTile(
              leading: Icon(Icons.feed_outlined),
              title: Text('Nieuws'),
              onTap: () {
                navigatorKey.currentState!.popAndPushNamed("/news");
              }),
          ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Instellingen'),
              onTap: () {
                navigatorKey.currentState!.popAndPushNamed("/settings");
              }),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Uitloggen'),
              onTap: () {
                AuthManager.logout().then((_) => navigatorKey.currentState!
                    .pushNamedAndRemoveUntil("/", (r) => false));
              }),
        ],
      ),
    );
  }
}
