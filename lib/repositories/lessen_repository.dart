import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wind/model/les.dart';
import 'package:wind/model/schedule.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/api/lessen.dart';

class LessenRepository {
  static Future<List<Les>> getLessen({bool forceSync = false}) async {
    Map<String, List<Les>> lessonsCache = prefs.lessonsCache;
    List<Schedule> schedules = prefs.schedules;
    List<Les> lessons = [];
    bool updated = false;
    for (Schedule schedule in schedules) {
      if (prefs.lastSynced.millisecondsSinceEpoch == 0 ||
          forceSync ||
          !lessonsCache.containsKey(schedule.code)) {
        if (await InternetConnectionChecker().hasConnection) {
          final data = await Lessen.getLessen(schedule.code);
          lessons.addAll(data);
          lessonsCache[schedule.code] = data;
          updated = true;
        } else {
          throw "No connection available";
        }
      } else {
        lessons.addAll(lessonsCache[schedule.code]!);
      }
    }
    if (updated) {
      prefs.lessonsCache = lessonsCache;
      prefs.lastSynced = DateTime.now();
    }
    lessons.sort((item1, item2) => item1.starttijd.compareTo(item2.starttijd));
    return lessons;
  }
}
