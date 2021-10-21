import 'package:flutter/material.dart';
import 'package:wind/model/course_result.dart';
import 'package:wind/pages/study/widgets/result_list.dart';

class StudyDetailsPage extends StatefulWidget {
  final CourseResult result;
  final String studyCode;

  const StudyDetailsPage(this.result, this.studyCode, {Key? key})
      : super(key: key);

  @override
  _StudyDetailsPageState createState() => _StudyDetailsPageState();
}

class _StudyDetailsPageState extends State<StudyDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.result.name)),
      body: Padding(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 10, child: buildStudyInfo(context)),
                  Expanded(
                    flex: 5,
                    child: buildAverage(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ResultList(widget.studyCode, widget.result.code),
          ],
        )),
        padding: const EdgeInsets.only(top: 15),
      ),
    );
  }

  Widget buildAverage(BuildContext context) {
    bool isGrade = widget.result.result == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.result.result ?? widget.result.grade ?? "-",
            style: isGrade
                ? Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Colors.white)
                : Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white)),
        Visibility(
            visible: isGrade,
            child: Text(
              "Eindcijfer",
              style: Theme.of(context).textTheme.caption,
            ))
      ],
    );
  }

  Widget buildStudyInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.result.name,
          style: Theme.of(context).textTheme.headline5,
          overflow: TextOverflow.clip,
        ),
        Text(
          widget.result.code,
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          "${widget.result.ec} EC",
          style: Theme.of(context).textTheme.subtitle1,
        )
      ],
    );
  }
}
