import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:wind/model/les.dart';
import 'package:wind/pages/schedule/lesson_details_page.dart';
import 'package:wind/pages/schedule/widgets/date_separator.dart';
import 'package:wind/pages/schedule/widgets/les_tile.dart';

class DayElement extends StatelessWidget {
  final List<Les> lessen;
  final DateTime day;
  final bool showDate;

  const DayElement({
    Key? key,
    this.lessen = const [],
    required this.day,
    this.showDate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDate) DateSeparator(day: day),
        ...lessen.map((e) => _LesElement(les: e)),
      ],
    );
  }
}

class _LesElement extends StatelessWidget {
  final Les les;
  final Color defaultColor;

  const _LesElement({
    Key? key,
    required this.les,
    this.defaultColor = Colors.green,
  }) : super(key: key);

  Color get color {
    return les.schedule?.color ?? defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        color: Theme.of(context).backgroundColor.withAlpha(40),
        child: OpenContainer(
          closedColor: Theme.of(context).backgroundColor.withAlpha(40),
          closedBuilder: (BuildContext context, VoidCallback open) => LesTile(
            les: les,
            color: color,
            // color: getColorFromLesson(schedules, les),
          ),
          openBuilder: (BuildContext context, _) => LessonDetailsPage(
            lesson: les,
            color: color,
            // color: getColorFromLesson(schedules, les),
          ),
        ),
      ),
    );
  }
}
