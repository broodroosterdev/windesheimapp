import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:wind/model/course_result.dart';
import 'package:wind/services/api/study.dart';

import '../study_details_page.dart';

class CourseList extends StatefulWidget {
  String code;

  CourseList(this.code, {Key? key}) : super(key: key);

  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Study.getCourseResults(widget.code),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.yellow,
              ),
            );
          } else {
            List<CourseResult> results = snapshot.data;
            return Column(children: [...results.map(buildTile).toList()]);
          }
        });
  }

  Widget buildTile(CourseResult result) {
    return OpenContainer(
      closedShape: const BeveledRectangleBorder(),
      openShape: const BeveledRectangleBorder(),
      closedColor: Theme.of(context).scaffoldBackgroundColor,
      middleColor: Theme.of(context).scaffoldBackgroundColor,
      openColor: const Color.fromRGBO(17, 18, 19, 1.0),
      closedBuilder: (BuildContext context, VoidCallback open) {
        return Card(
          child: ListTile(
            onTap: open,
            trailing: SizedBox(
                width: 100,
                height: 50,
                child: Center(
                  child: Text(
                    result.result ?? result.grade ?? "-",
                    style: result.result == null
                        ? Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.white)
                        : Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                )),
            title: Text(result.name),
            subtitle: Text("${result.code} - ${result.ec} EC"),
          ),
        );
      },
      openBuilder: (BuildContext context, VoidCallback open) {
        return StudyDetailsPage(result, widget.code);
      },
    );
  }
}
