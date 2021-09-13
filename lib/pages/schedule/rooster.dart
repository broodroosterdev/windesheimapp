import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:wind/model/les.dart';
import 'package:wind/model/schedule.dart';
import 'package:wind/pages/schedule/views/week_view.dart';
import 'package:wind/pages/schedule/widgets/bottom_navigator.dart';
import 'package:wind/pages/widgets/app_drawer.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/api/lessen.dart';

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

  static Future<List<Les>> getLessen({bool forceSync = false}) async {
    Map<String, List<Les>> lessonsCache = prefs.lessonsCache;
    List<Schedule> schedules = prefs.schedules;
    List<Les> lessons = [];
    bool updated = false;
    for (Schedule schedule in schedules) {
      if (prefs.lastSynced.millisecondsSinceEpoch == 0 ||
          forceSync ||
          !lessonsCache.containsKey(schedule.code)) {
        if (await InternetConnectionChecker().hasConnection) {
          final data = await Lessen.getLessen(schedule.code);
          lessons.addAll(data);
          lessonsCache[schedule.code] = data;
          updated = true;
        } else {
          throw "No connection available";
        }
      } else {
        lessons.addAll(lessonsCache[schedule.code]!);
      }
    }
    if (updated) {
      prefs.lessonsCache = lessonsCache;
      prefs.lastSynced = DateTime.now();
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
                          return RefreshIndicator(
                              onRefresh: () async {
                                try {
                                  var lessen = await getLessen(forceSync: true);
                                  setState(() {
                                    lessenFuture = Future.value(lessen);
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Theme.of(context)
                                        .backgroundColor
                                        .withAlpha(40),
                                    margin: EdgeInsets.only(bottom: 60),
                                    content: Text(e.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                  ));
                                }
                              },
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: dataReady
                                    ? WeekView(
                                        lessen: lessen.data!, weekNumber: index)
                                    : const Text("Loading"),
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
}
