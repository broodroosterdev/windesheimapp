import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:windesheimapp/model/les.dart';
import 'package:windesheimapp/model/schedule.dart';
import 'package:windesheimapp/pages/schedule/widgets/bottom_navigator.dart';
import 'package:windesheimapp/pages/schedule/widgets/date_separator.dart';
import 'package:windesheimapp/pages/schedule/widgets/les_tile.dart';
import 'package:windesheimapp/pages/widgets/app_drawer.dart';
import 'package:windesheimapp/providers.dart';
import 'package:windesheimapp/services/api/lessen.dart';
import 'package:windesheimapp/services/auth/auth_manager.dart';
import 'package:windesheimapp/utils/time.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int pageNumber = 0;
  Future<List<Les>> lessenFuture = getLessen();
  final GlobalKey<RefreshIndicatorState> refreshkey =
      GlobalKey<RefreshIndicatorState>();
  final PageController _pageController = PageController();

  static Future<List<Les>> getLessen() async {
    List<Schedule> schedules = prefs.schedules;
    List<Les> lessons = [];
    for(Schedule schedule in schedules){
      lessons.addAll(await Lessen.getLessen(schedule.code));
    }
    lessons.sort((item1, item2) => item1.starttijd.compareTo(item2.starttijd));
    return lessons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Lessen')),
        drawer: AppDrawer(),
        backgroundColor: const Color.fromRGBO(17, 18, 19, 1.0),
        body: FutureBuilder<List<Les>>(
          future: lessenFuture,
          builder: (BuildContext context, AsyncSnapshot<List<Les>> lessen) {
            final bool dataReady = lessen.hasData && lessen.data != null;
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PageView.builder(
                          itemCount: 5,
                          controller: _pageController,
                          onPageChanged: (value) {
                            setState(() {
                              pageNumber = value;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return
                              RefreshIndicator(
                                onRefresh: () async {
                              var lessen = await getLessen();
                              setState(() {
                                lessenFuture = Future.value(lessen);
                              });
                            },
                              child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: dataReady
                                    ? buildRooster(context, lessen.data!, index)
                                    : [const Text("Loading")],
                              ),
                            ));
                          }),
                    ),
                  ChangeNotifierProvider.value(
                    value: _pageController,
                    child: BottomNavigator(
                        onBack: () {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.fastOutSlowIn);
                        },
                        onForward: () {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.fastOutSlowIn);
                        },
                        text: "Week ${pageNumber + 1}/5"),
                  ),
                ]);
          },
        ));
  }

  List<Widget> buildRooster(
      BuildContext context, List<Les> lessen, int weekNummer) {
    List<Widget> widgets = [];
    List<DateTime> week = Time.getWeek(weekNummer);
    List<Schedule> schedules = prefs.schedules;

    for (DateTime day in week) {
      widgets.add(DateSeparator(day: day));

      for (Les les in lessen) {
        if (les.roosterdatum.day != day.day ||
            les.roosterdatum.month != day.month) {
          continue;
        }
        widgets.add(LesTile(les: les, color: getColorFromLesson(schedules, les)));

        widgets.add(const SizedBox(height: 10));
      }
    }
    return widgets;
  }

  Color getColorFromLesson(List<Schedule> schedules, Les lesson){
    return schedules
        .firstWhere((schedule) => "Class-${schedule.code}" == lesson.roostercode)
        .color;
  }
}
