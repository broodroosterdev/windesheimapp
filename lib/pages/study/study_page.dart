import 'package:flutter/material.dart';
import 'package:wind/model/study_progress.dart';
import 'package:wind/pages/study/widgets/course_list.dart';
import 'package:wind/pages/study/widgets/ec_counter.dart';
import 'package:wind/pages/widgets/app_drawer.dart';
import 'package:wind/services/api/study.dart';

class StudyPage extends StatefulWidget {
  StudyPage({Key? key}) : super(key: key);

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  bool isLoading = true;
  late Future<StudyProgress> future;

  @override
  void initState() {
    super.initState();
    future = Study.getStudyProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Study')),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: future,
            builder: (context, AsyncSnapshot<StudyProgress> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow,
                  ),
                );
              } else {
                StudyProgress progress = snapshot.data!;
                return SingleChildScrollView(
                    child: Column(children: [
                  SizedBox(height: 10),
                  Text(
                      progress.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ECCounter(progress.propedeuse, "Propedeuse"),
                      SizedBox(width: 30),
                      ECCounter(progress.study, "Complete study"),
                    ],
                  ),
                  SizedBox(height: 20),
                  CourseList(progress.code)
                ]));
              }
            }),
    );
  }
}