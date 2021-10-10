import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:wind/model/schedule.dart';
import 'package:wind/pages/settings/widgets/add_rooster_tile.dart';
import 'package:wind/pages/settings/widgets/rooster_tile.dart';
import 'package:wind/pages/widgets/app_drawer.dart';
import 'package:wind/services/auth/elo_auth.dart';

import '../../preferences.dart';
import '../../providers.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instellingen')),
      drawer: AppDrawer(),
      backgroundColor: const Color.fromRGBO(17, 18, 19, 1.0),
      body: ChangeNotifierProvider.value(
        value: prefs,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                "Roosters",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 10),
              child: Consumer<Preferences>(
                  builder: (BuildContext context, Preferences model, _) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...buildRoosterTiles(context, model.schedules),
                      AddRoosterTile()
                    ]);
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                "Weergave",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 10),
              child: Consumer<Preferences>(
                builder: (BuildContext context, Preferences model, _) {
                  return DropdownButton(
                    value: prefs.roosterView,
                    items: [
                      DropdownMenuItem(
                        value: "day",
                        child: Text("Dag"),
                      ),
                      DropdownMenuItem(
                        value: "week",
                        child: Text("Week"),
                      ),
                    ],
                    onChanged: (value) {
                      prefs.roosterView = value as String;
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                "Debug",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: ElevatedButton(onPressed: () {
              prefs.eloCookie = '';
            }, child: Text("Remove ELO cookie"),),
      ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildRoosterTiles(
      BuildContext context, List<Schedule> schedules) {
    List<Widget> widgets = [];
    for (int i = 0; i < schedules.length; i++) {
      widgets.add(RoosterTile(
          schedule: schedules[i],
          onDelete: () => deleteRooster(i),
          onEdit: () => editRooster(i)));
    }
    return widgets;
  }

  void deleteRooster(int index) {
    List<Schedule> schedules = prefs.schedules;
    schedules.removeAt(index);
    prefs.schedules = schedules;
  }

  void editRooster(int index) {
    const availableColors = [
      Colors.blue,
      Colors.blueAccent,
      Colors.yellow,
      Colors.yellowAccent,
      Colors.red,
      Colors.redAccent,
      Colors.green,
      Colors.greenAccent,
      Colors.purple,
      Colors.purpleAccent,
      Colors.white
    ];
    Schedule schedule = prefs.schedules[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: schedule.color,
              availableColors: availableColors,
              onColorChanged: (color) => schedule.color = color,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Opslaan'),
              onPressed: () {
                final List<Schedule> schedules = prefs.schedules;
                schedules[index] = schedule;
                prefs.schedules = schedules;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
