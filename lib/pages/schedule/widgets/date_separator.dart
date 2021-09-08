import 'package:flutter/material.dart';
import 'package:wind/utils/time.dart';

class DateSeparator extends StatelessWidget {
  final DateTime day;

  const DateSeparator({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String text;
    final now = DateTime.now();
    int daysTill = day.difference(now).inDays;
    if(daysTill == 0 && day.day == now.day){
      text = "Vandaag";
    } else if(daysTill == 0){
      text = "Morgen";
    } else {
      text = "${Time.getWeekdayName(day.weekday)} ${day.day} ${Time.getMonthName(day.month)}";
    }
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
