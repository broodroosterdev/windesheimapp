import 'package:flutter/material.dart';
import 'package:wind/model/les.dart';
import 'package:wind/utils/time.dart';

import 'day_view.dart';

class WeekView extends StatelessWidget {
  final List<Les> lessen;
  final int weekNumber;

  const WeekView({
    Key? key,
    this.lessen = const [],
    this.weekNumber = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...Time.getWeek(weekNumber).map((day) {
          var list =
              lessen.where((les) => les.roosterdatum.isSameDate(day)).toList();

          return DayView(day: day, lessen: list);
        })
      ],
    );
  }
}
