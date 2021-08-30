import 'package:flutter/material.dart';
import 'package:windesheimapp/utils/time.dart';

class DateSeparator extends StatelessWidget {
  final DateTime day;

  const DateSeparator({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
      child: Text(
        "${Time.getWeekdayName(day.weekday)} ${day.day} ${Time.getMonthName(day.month)}",
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );;
  }
}
