import 'package:flutter/material.dart';
import 'package:wind/utils/time.dart';

class DateSeparator extends StatelessWidget {
  final DateTime day;

  const DateSeparator({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = day.toDateString();

    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
