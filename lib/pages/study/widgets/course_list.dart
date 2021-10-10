import 'package:flutter/material.dart';
import 'package:wind/model/course_result.dart';
import 'package:wind/services/api/study.dart';

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
          return Column(
            children: [
              ...results.map((result) => ListTile(
                trailing: SizedBox(
                    width: 70,
                    height: 50,
                    child: Text(
                    result.result ?? result.grade ?? "-",
                  style: result.result == null ? Theme.of(context).textTheme.headline5 : Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                )),
                title: Text(result.name),
                subtitle: Text(result.code),
              )).toList()
          ]);
        }
      }
    );
  }
}