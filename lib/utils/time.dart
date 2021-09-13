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

  //Get a whole week from monday till sunday
  //Week 0 being this week
  static List<DateTime> getWeek(int weekNumber) {
    final today = getTodayDate();
    final monday = today
        .subtract(Duration(days: today.weekday - 1))
        .add(Duration(days: 7 * weekNumber));

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
    return this.year == other.year && this.month == other.month
        && this.day == other.day;
  }
}
