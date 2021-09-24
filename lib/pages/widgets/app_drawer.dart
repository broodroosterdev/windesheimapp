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
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Wind',
              style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.black)
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Rooster'),
            onTap: () {
              navigatorKey.currentState!
                  .pushNamedAndRemoveUntil("/rooster", (_) => false);
            }
          ),
          ListTile(
              leading: Icon(Icons.book_outlined),
              title: Text('ELO'),
              onTap: () {
                navigatorKey.currentState!
                    .pushNamedAndRemoveUntil("/studyroutes", (_) => false);
              }
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Instellingen'),
            onTap: () {
              navigatorKey.currentState!
                  .pushNamedAndRemoveUntil("/settings", (_) => false);
            }
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Uitloggen'),
            onTap: () {
              AuthManager.logout();
              navigatorKey.currentState!
                  .pushNamedAndRemoveUntil("/", (r) => false);
            }
          ),
        ],
      ),
    );
  }
}
