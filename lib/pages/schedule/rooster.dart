import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wind/model/les.dart';
import 'package:wind/pages/schedule/views/day/day_view.dart';
import 'package:wind/pages/schedule/views/week/week_view.dart';
import 'package:wind/pages/widgets/app_drawer.dart';
import 'package:wind/repositories/lessen_repository.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<List<Les>?> lessenFuture;
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    lessenFuture = load();
  }

  Future<List<Les>?> load({bool forceSync = false}) async {
    try {
      var lessen = await LessenRepository.getLessen(forceSync: forceSync);
      setState(() => lessenFuture = Future.value(lessen));
      return lessen;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).backgroundColor.withAlpha(40),
          margin: EdgeInsets.only(bottom: 60),
          content: Text(
            e.toString(),
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      );
      return null;
    }
  }

  Future<void> refresh() async {
    await load(forceSync: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lessen')),
      drawer: AppDrawer(),
      backgroundColor: const Color.fromRGBO(17, 18, 19, 1.0),
      body: FutureBuilder<List<Les>?>(
        future: lessenFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Les>?> lessen) {
          return WeekView(
            onRefresh: refresh,
            lessen: lessen.data,
          );
        },
      ),
    );
  }
}
