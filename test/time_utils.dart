import 'package:flutter_test/flutter_test.dart';
import 'package:wind/utils/time.dart';

void main() {
  test("getTodayDate is at 0:00", () {
    final today = Time.getTodayDate();
    expect(today.hour, 0);
    expect(today.minute, 0);
  });

  test("getWeek returns dates from Monday till Sunday", () {
    final week = Time.getWeek(0);
    expect(week[0].weekday, 1);
    expect(week[6].weekday, 7);
  });
}