import 'package:flutter/material.dart';

class TimeBox extends StatelessWidget {
  final String time;
  final int opacity;

  const TimeBox({
    Key? key,
    required this.time,
    required this.opacity
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 80,
        height: 50,
        color: Theme.of(context).backgroundColor.withAlpha(opacity),
        child: Align(
          alignment: Alignment.center,
          child: Text(time,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6!),
        ));
  }
}
