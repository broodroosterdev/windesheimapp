import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/les.dart';
import 'model/schedule.dart';

enum Preference {
  apiAccess,
  apiRefresh,
  eloCookie,
  email,
  password,
  sharepointCookie,
  brightspaceAccess,
  brightspaceId,
  //Non secured preferences
  brightspaceExpiry,
  sharepointExpiry,
  schedules,
  lastSynced,
  lessonsCache,
  roosterView
}

class Preferences extends ChangeNotifier {
  late final SharedPreferences sharedPrefs;
  late final FlutterSecureStorage securePrefs;

  Future<String?> getSecureString(Preference preference) async {
    return await securePrefs.read(key: preference.name);
  }

  Future setSecureString(Preference preference, String string) async {
    await securePrefs.write(key: preference.name, value: string);
  }

  String? getString(Preference preference) {
    return sharedPrefs.getString(preference.name);
  }

  void setString(Preference preference, String value) {
    sharedPrefs.setString(preference.name, value);
  }

  int? getInt(Preference preference) {
    return sharedPrefs.getInt(preference.name);
  }

  void setInt(Preference preference, int value) {
    sharedPrefs.setInt(preference.name, value);
  }

  Future clear() async {
    await sharedPrefs.clear();
    await securePrefs.deleteAll();
    await initData();
  }

  Future init() async {
    sharedPrefs = await SharedPreferences.getInstance();
    securePrefs = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
    await initData();
  }

  Future initData() async {
    _apiAccess = await getSecureString(Preference.apiAccess) ?? '';
    _apiRefresh = await getSecureString(Preference.apiRefresh) ?? '';
    _eloCookie = await getSecureString(Preference.eloCookie) ?? '';
    _email = await getSecureString(Preference.email) ?? '';
    _password = await getSecureString(Preference.password) ?? '';
    _sharepointCookie =
        await getSecureString(Preference.sharepointCookie) ?? '';
    _brightspaceAccess =
        await getSecureString(Preference.brightspaceAccess) ?? '';
    _brightspaceId = await getSecureString(Preference.brightspaceId) ?? '';
    _sharepointExpiry = getInt(Preference.sharepointExpiry) ?? 0;
    _brightspaceExpiry = getInt(Preference.brightspaceExpiry) ?? 0;
    _schedules = parseSchedules(getString(Preference.schedules) ?? '[]');
    _lastSynced =
        DateTime.fromMillisecondsSinceEpoch(getInt(Preference.lastSynced) ?? 0);
    _lessonsCache =
        parseLessonsCache(getString(Preference.lessonsCache) ?? '{}');
    _roosterView = getString(Preference.roosterView) ?? 'week';

    if (kDebugMode) {
      print("Secure prefs:");
      var allSecure = await securePrefs.readAll();
      for (var k in allSecure.keys) {
        print("'$k': ${allSecure[k]}");
      }

      print("Unsecured prefs:");
      var all = sharedPrefs.getKeys();
      for (var k in all) {
        print("'$k': ${sharedPrefs.get(k)}");
      }
    }
  }

  List<Schedule> parseSchedules(String json) {
    List<Map<String, dynamic>> jsonList = (jsonDecode(json) as List<dynamic>)
        .map((data) => data as Map<String, dynamic>)
        .toList();
    return jsonList.map((json) => Schedule.fromJson(json)).toList();
  }

  Map<String, List<Les>> parseLessonsCache(String json) {
    Map<String, dynamic> jsonMap = (jsonDecode(json) as Map<String, dynamic>);
    Map<String, List<Les>> result = {};
    jsonMap.forEach((key, value) {
      result[key] = [];
      value.forEach((json) {
        result[key]!.add(Les.fromJson(json));
      });
    });
    return result;
  }

  late String _apiAccess;

  String get apiAccess => _apiAccess;

  Future setApiAccess(String value) async {
    _apiAccess = value;
    await setSecureString(Preference.apiAccess, value);
    notifyListeners();
  }

  late String _apiRefresh;

  String get apiRefresh => _apiRefresh;

  Future setApiRefresh(String value) async {
    _apiRefresh = value;
    await setSecureString(Preference.apiRefresh, value);
    notifyListeners();
  }

  late String _eloCookie;

  String get eloCookie => _eloCookie;

  Future setEloCookie(String value) async {
    _eloCookie = value;
    await setSecureString(Preference.eloCookie, value);
    notifyListeners();
  }

  late String _email;

  String get email => _email;

  Future setEmail(String value) async {
    _email = value;
    await setSecureString(Preference.email, value);
    notifyListeners();
  }

  late String _password;

  String get password => _password;

  Future setPassword(String value) async {
    _password = value;
    await setSecureString(Preference.password, value);
    notifyListeners();
  }

  late String _sharepointCookie;

  String get sharepointCookie => _sharepointCookie;

  Future setSharepointCookie(String value) async {
    _sharepointCookie = value;
    await setSecureString(Preference.sharepointCookie, value);
    notifyListeners();
  }

  late int _sharepointExpiry;

  int get sharepointExpiry => _sharepointExpiry;

  set sharepointExpiry(int value) {
    _sharepointExpiry = value;
    setInt(Preference.sharepointExpiry, value);
    notifyListeners();
  }

  late String _brightspaceAccess;

  String get brightspaceAccess => _brightspaceAccess;

  Future setBrightspaceAccess(String value) async {
    _brightspaceAccess = value;
    await setSecureString(Preference.brightspaceAccess, value);
    notifyListeners();
  }

  late String _brightspaceId;
  String get brightspaceId => _brightspaceId;
  Future setBrightspaceId(String value) async {
    _brightspaceId = value;
    await setSecureString(Preference.brightspaceId, value);
    notifyListeners();
  }

  late int _brightspaceExpiry;

  int get brightspaceExpiry => _brightspaceExpiry;

  set brightspaceExpiry(int value) {
    _brightspaceExpiry = value;
    setInt(Preference.brightspaceExpiry, value);
    notifyListeners();
  }

  late List<Schedule> _schedules;

  List<Schedule> get schedules => _schedules;

  set schedules(List<Schedule> value) {
    _schedules = value;
    notifyListeners();
    final String json = jsonEncode(value);
    setString(Preference.schedules, json);
  }

  late DateTime _lastSynced;

  DateTime get lastSynced => _lastSynced;

  set lastSynced(DateTime value) {
    int timestamp = value.millisecondsSinceEpoch;
    _lastSynced = value;
    setInt(Preference.lastSynced, timestamp);
    notifyListeners();
  }

  late Map<String, List<Les>> _lessonsCache;

  Map<String, List<Les>> get lessonsCache => _lessonsCache;

  set lessonsCache(Map<String, List<Les>> value) {
    final String json = jsonEncode(value);
    _lessonsCache = value;
    setString(Preference.lessonsCache, json);
    notifyListeners();
  }

  late String _roosterView;

  String get roosterView => _roosterView;

  set roosterView(String value) {
    _roosterView = value;
    setString(Preference.roosterView, value);
    notifyListeners();
  }
}
