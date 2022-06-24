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
        Text(name, style: Theme.of(context).textTheme.subtitle1),
        SizedBox(height: 7),
        CircularPercentIndicator(
          radius: 70.0,
          lineWidth: 12.0,
          percent: ec.achieved / ec.toAchieve,
          center: Text("${ec.achieved}/${ec.toAchieve}", style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).colorScheme.secondary),),
          progressColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).cardColor,
        )
      ],
    );
  }
}
