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

  void setString(String key, String? value) {
    prefs.setString(key, value ?? '');
  }
}
