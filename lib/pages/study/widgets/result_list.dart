import 'package:flutter/material.dart';
import 'package:wind/model/test_result.dart';
import 'package:wind/pages/elo/widgets/loading_indicator.dart';
import 'package:wind/services/api/study.dart';
import 'package:wind/utils/time.dart';

class ResultList extends StatefulWidget {
  final String studyCode;
  final String courseCode;
  ResultList(this.studyCode, this.courseCode, {Key? key}) : super(key: key);

  @override
  _ResultListState createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getResults(),
      builder:
          (BuildContext context, AsyncSnapshot<List<TestResult>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicator();
        } else {
          final List<TestResult> results = snapshot.data!;
          return Column(
            children:
                results.map((result) => buildTile(context, result)).toList(),
          );
        }
      },
    );
  }

  Widget buildTile(BuildContext context, TestResult result) {
    return Card(
        child: ListTile(
      trailing: SizedBox(
          width: 100,
          height: 50,
          child: Center(
            child: Text(
              result.result ?? result.grade ?? "-",
              style: result.result == null
                  ? Theme.of(context)
                  .textTheme
                  .headline4!.copyWith(color: Theme.of(context).colorScheme.secondary)
                  : Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          )),
      title: Text(result.description),
      subtitle: buildSubtitle(result)
    ));
  }

  Widget buildSubtitle(TestResult result){
    if(result.testDate == null){
      return const Text("");
    }

    return Row(
          children: [
            Text("${Time.getFormattedDate(result.testDate!)} - "),
            Text(result.isFinal ? "Definitief" : "Voorlopig"),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                  result.isFinal ? Icons.verified : Icons.hourglass_bottom, size: 15),
            ),
          ],
        );
  }

  Future<List<TestResult>> getResults() async {
    return Study.getTestResults(widget.studyCode, widget.courseCode);
  }
}
