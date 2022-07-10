import 'package:flutter/material.dart';
import 'package:wind/model/schedule.dart';
import 'package:wind/services/api/lessen.dart';

import '../../providers.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({Key? key}) : super(key: key);

  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final TextEditingController _controller = TextEditingController();
  Future<List<Schedule>> codesFuture = Lessen.getCodes();
  String? filterText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Rooster toevoegen')),
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    filterText = text;
                  });
                },
                controller: _controller,
              )),
          Expanded(
              flex: 1,
              child: FutureBuilder(
                future: codesFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Schedule>> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    List<Schedule> codes = snapshot.data!;
                    if (filterText != null && filterText != "") {
                      codes = codes.where((code) {
                        return code
                            .code
                            .toLowerCase()
                            .contains(filterText!.toLowerCase());
                      }).toList();
                    }
                    return ListView.builder(
                        itemCount: codes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final code = codes[index];
                          return ListTile(
                              onTap: () {
                                print("Pressed code: $code");
                                selectCode(code);
                              },
                              title: Text("${code.code} (${code.type.apiName})"));
                        });
                  } else {
                    return const Text("Laden...");
                  }
                },
              ))
        ]));
  }

  void selectCode(Schedule selected) {
    final schedule = selected;
    List<Schedule> schedules = prefs.schedules;
    schedules.add(schedule);
    prefs.schedules = schedules;
    Navigator.of(context).pop();
  }
}
