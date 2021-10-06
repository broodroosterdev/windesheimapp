import 'package:flutter/material.dart';
import 'package:wind/model/study_progress.dart';

class ECCounter extends StatelessWidget {
  final EC ec;
  final String name;

  ECCounter(this.ec, this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            name,
          style: Theme.of(context).textTheme.subtitle1
        ),
        SizedBox(height: 10),
        SizedBox(
        height: 45,
    width: 45,
    child: CircularProgressIndicator(
          color: Colors.yellow,
          strokeWidth: 5.0,
          backgroundColor: Theme.of(context).backgroundColor,
          value: ec.achieved /
              ec.toAchieve,
        ),
        ),
        SizedBox(height: 5),
        Text(
            "${ec.achieved}/${ec.toAchieve}",
        style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}
