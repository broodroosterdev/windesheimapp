import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:wind/model/schedule.dart';

class ScheduleHelper {
  static void editScheduleColor(BuildContext context, Schedule schedule, Function(Schedule) onSave){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kies een kleur'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: schedule.color,
              availableColors: Schedule.availableColors,
              onColorChanged: (color) => schedule.color = color,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuleren'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Opslaan'),
              onPressed: () {
                onSave(schedule);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static const availableColors = [
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

  static Color parseColorFromWIP(String color){
    switch(color){
      case "whdarkblue": return Colors.blueAccent;
      case "whlightblue": return Colors.blue;
      case "whyellow": return Colors.yellowAccent;
      case "whred": return Colors.redAccent;
      case "whgreen": return Colors.green;
      case "whpurple": return Colors.purpleAccent;
      case "whgray": return Colors.white;
      default: return Colors.white;
    }
  }
}