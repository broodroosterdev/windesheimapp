import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final SharedPreferences prefs;

  SharedPrefs._(this.prefs);

  static Future<SharedPrefs> newInstance() async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    return SharedPrefs._(instance);
  }

  String get accessToken {
    return prefs.getString('access-token') ?? '';
  }

  set accessToken(String accessToken) {
    setString('access-token', accessToken);
  }

  String get refreshToken {
    return prefs.getString('refresh-token') ?? '';
  }

  set refreshToken(String refreshToken) {
    setString('refresh-token', refreshToken);
  }

  String get eloCookie {
    return prefs.getString('elo-cookie') ?? '';
  }

  set eloCookie(String eloCookie) {
    setString('elo-cookie', eloCookie);
  }

  String get schedules {
    return prefs.getString('schedules') ?? '[]';
  }

  set schedules(String value) {
    setString('schedules', value);
  }

  int get lastSynced {
    return prefs.getInt('last-synced') ?? 0;
  }

  set lastSynced(int value) {
    prefs.setInt('last-synced', value);
  }

  String get lessonsCache {
    return prefs.getString('lessons-cache') ?? '{}';
  }

  set lessonsCache(String value) {
    setString('lessons-cache', value);
  }

  String get roosterView {
    return prefs.getString('rooster-view') ?? 'week';
  }

  set roosterView(String value) {
    setString('rooster-view', value);
  }

  void setString(String key, String? value) {
    prefs.setString(key, value ?? '');
  }
}
