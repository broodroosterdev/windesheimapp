import 'package:flutter/material.dart';

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
              Navigator.of(context)
                  ..pop()
                  ..pushNamed("/rooster");
            }
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Instellingen'),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushNamed("/settings");
            }
          ),
        ],
      ),
    );
  }
}
