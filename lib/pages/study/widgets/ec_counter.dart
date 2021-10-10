import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wind/model/study_progress.dart';

class ECCounter extends StatelessWidget {
  final EC ec;
  final String name;

  const ECCounter(this.ec, this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            name,
          style: Theme.of(context).textTheme.subtitle1
        ),
        SizedBox(height: 10),
        CircularPercentIndicator(
          radius: 90.0,
          lineWidth: 8.0,
          percent: ec.achieved / ec.toAchieve,
          center: Text("${ec.achieved}/${ec.toAchieve}"),
          progressColor: Colors.yellow,
          backgroundColor: Theme.of(context).backgroundColor,
        )
      ],
    );
  }
}
