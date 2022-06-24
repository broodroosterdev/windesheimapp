import 'package:flutter/material.dart';
import 'package:wind/model/study_progress.dart';
import 'package:wind/pages/elo/widgets/loading_indicator.dart';
import 'package:wind/pages/study/widgets/course_list.dart';
import 'package:wind/pages/study/widgets/ec_counter.dart';
import 'package:wind/pages/widgets/app_drawer.dart';
import 'package:wind/services/api/study.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({Key? key}) : super(key: key);

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
      appBar: AppBar(title: const Text('Studie')),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: future,
          builder: (context, AsyncSnapshot<StudyProgress> snapshot) {
            if (!snapshot.hasData) {
              return LoadingIndicator();
            } else {
              StudyProgress progress = snapshot.data!;
              return SingleChildScrollView(
                  child: Column(children: [
                const SizedBox(height: 10),
                Text(
                  progress.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ECCounter(progress.propedeuse, "Propedeuse"),
                    const SizedBox(width: 30),
                    ECCounter(progress.study, "Complete studie"),
                  ],
                ),
                SizedBox(height: 15),
                SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 8, bottom: 8),
                      child: Text(
                        "Vakken",
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.start,
                      ),
                    )),
                CourseList(progress.code)
              ]));
            }
          }),
    );
  }
}
