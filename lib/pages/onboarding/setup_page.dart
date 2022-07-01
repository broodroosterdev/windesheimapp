import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wind/model/schedule.dart';
import 'package:wind/pages/elo/widgets/loading_indicator.dart';
import 'package:wind/pages/settings/settings_page.dart';
import 'package:wind/pages/settings/widgets/rooster_tile.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/api/Settings.dart';
import 'package:wind/utils/schedule_helper.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  bool loading = true;
  List<Schedule> schedules = [];
  int currentPage = 0;

  Future<void> getSchedules() async {
    setState(() {
      loading = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    final Map<String, dynamic> settings = await Settings.getSettings();
    final List<dynamic> rawSchedules = jsonDecode(settings['Setting_Activity_selected']);

    var list = rawSchedules
        .map((e) => e as Map<String, dynamic>)
        .map((e) {
          String type = e['type'];
          String id = e['id'];
          String colorString = settings["Setting_Activity_activityColor_$type-$id"] ?? "whgray";
          print(colorString);
          return Schedule(code: id, type: Schedule.parseScheduleTypeFromWip(type)!, color: ScheduleHelper.parseColorFromWIP(colorString));
        })
        .toList();
    print(list);
    setState(() {schedules = list;});
    setState(() {
      loading = false;
    });
  }

  void onChange(int pageNumber) {
    setState(() => {
      currentPage = pageNumber
    });

    if(pageNumber == 1){
      print("new schedules");
      getSchedules();
    }
  }

  List<Widget> buildScheduleTiles(){
    List<Widget> tiles = [];
    schedules.asMap().forEach((key, value) {
      Schedule schedule = value;
      tiles.add(
          RoosterTile(
            schedule: schedule,
            onDelete: () {
              setState(() => schedules.remove(schedule));
            },
            onEdit: () => {
              ScheduleHelper.editScheduleColor(context, schedule, (schedule) {
                setState(() {
                  schedules[schedules.indexWhere((e) => e.apiCode == schedule.apiCode)] = schedule;
                });
              })
            },
          )
      );
    });
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
        onChange: onChange,
        pages: [
          PageViewModel(
            title: "Importeer je gegevens",
            body: "Je roosters kunnen worden opgehaald van WIP, zodat je gelijk aan de slag kunt. Wil je niks importeren, druk dan op sla over.",
              image: SvgPicture.asset("assets/server.svg", height: MediaQuery.of(context).size.height / 3,)
          ),
          PageViewModel(
            decoration: const PageDecoration(imageFlex: 1, bodyFlex: 2),
            title: "Je opgehaalde rooster(s)",
            bodyWidget:
                loading ?
                  LoadingIndicator()
                :
                  Column(
                    children: [
                      ...buildScheduleTiles(),
                    ],
                  ),
              footer: ElevatedButton(onPressed: () {
                prefs.schedules = schedules;
                Navigator.pushNamedAndRemoveUntil(context, "/rooster", (route) => false);
              }, child: const Text("Importeer")),
              image: SvgPicture.asset("assets/download.svg", height: MediaQuery.of(context).size.height / 5,)
          ),
          PageViewModel(
            title: "Zelf je roosters aanpassen?",
            body: "Als je rooster wil toevoegen of aanpassen, kun je dit doen in het tabje 'Instellingen'.",
              image: SvgPicture.asset("assets/settings.svg", height: MediaQuery.of(context).size.height / 3,)
          )
        ],
      skip: const Text("Sla over"),
      next: const Icon(Icons.arrow_forward_rounded),
      done: const Text("Okay"),
      onDone: () => Navigator.pushNamedAndRemoveUntil(context, "/settings", (route) => false),
      showSkipButton: true,
      showDoneButton: true,
      showNextButton: currentPage != 1,
    );
  }
}
