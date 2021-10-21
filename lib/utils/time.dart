import 'package:intl/intl.dart';

class Time {
  static DateTime getTodayDate() {
    DateTime newDate = DateTime.now();
    return newDate.subtract(Duration(
      hours: newDate.hour,
      minutes: newDate.minute,
      seconds: newDate.second,
      milliseconds: newDate.millisecond,
      microseconds: newDate.microsecond,
    ));
  }

  static String getFormattedTime(DateTime date) {
    DateFormat timeFormat = DateFormat.Hm();
    return timeFormat.format(date);
  }

  static String getFormattedDate(DateTime date) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    return dateFormat.format(date);
  }

  //Get a whole week from monday till sunday
  //Week 0 being this week
  static List<DateTime> getWeek(int weekOffset) {
    final today = getTodayDate();
    final monday = today
        .subtract(Duration(days: today.weekday - 1))
        .add(Duration(days: 7 * weekOffset));

    List<DateTime> days = [];
    days.add(monday);
    for (int i = 1; i <= 6; i++) {
      days.add(monday.add(Duration(days: i)));
    }
    return days;
  }

  static String getWeekdayName(int weekday) {
    const dagen = [
      "Maandag",
      "Dinsdag",
      "Woensdag",
      "Donderdag",
      "Vrijdag",
      "Zaterdag",
      "Zondag"
    ];
    return dagen[weekday - 1];
  }

  static String getMonthName(int month) {
    const maanden = [
      "Januari",
      "Februari",
      "Maart",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Augustus",
      "September",
      "Oktober",
      "November",
      "December"
    ];
    return maanden[month - 1];
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String toDateString() {
    final now = DateTime.now();
    int daysTill = difference(now).inDays;
    if (daysTill == 0 && day == now.day) {
      return "Vandaag";
    } else if (daysTill == 0) {
      return "Morgen";
    } else {
      return "${Time.getWeekdayName(weekday)} $day ${Time.getMonthName(month)}";
    }
  }
}
