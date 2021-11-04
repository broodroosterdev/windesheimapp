import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:wind/providers.dart';

import 'model/les.dart';
import 'model/schedule.dart';

class Preferences extends ChangeNotifier {
  String _accessToken = sharedPrefs.accessToken;

  String get accessToken => _accessToken;

  set accessToken(String value) {
    _accessToken = value;
    sharedPrefs.accessToken = value;
    notifyListeners();
  }

  String _refreshToken = sharedPrefs.refreshToken;

  String get refreshToken => _refreshToken;

  set refreshToken(String value) {
    _refreshToken = value;
    sharedPrefs.refreshToken = value;
    notifyListeners();
  }

  String _eloCookie = sharedPrefs.eloCookie;

  String get eloCookie => _eloCookie;

  set eloCookie(String value) {
    _eloCookie = value;
    sharedPrefs.eloCookie = value;
    notifyListeners();
  }

  String _schedules = sharedPrefs.schedules;

  List<Schedule> get schedules {
    List<Map<String, dynamic>> jsonList =
        (jsonDecode(_schedules) as List<dynamic>)
            .map((data) => data as Map<String, dynamic>)
            .toList();
    return jsonList.map((json) => Schedule.fromJson(json)).toList();
  }

  set schedules(List<Schedule> value) {
    final String json = jsonEncode(value);
    _schedules = json;
    sharedPrefs.schedules = json;
    notifyListeners();
  }

  int _lastSynced = sharedPrefs.lastSynced;

  DateTime get lastSynced => DateTime.fromMillisecondsSinceEpoch(_lastSynced);

  set lastSynced(DateTime value) {
    int timestamp = value.millisecondsSinceEpoch;
    _lastSynced = timestamp;
    sharedPrefs.lastSynced = timestamp;
    notifyListeners();
  }

  String _lessonsCache = sharedPrefs.lessonsCache;

  Map<String, List<Les>> get lessonsCache {
    Map<String, dynamic> jsonMap =
        (jsonDecode(_lessonsCache) as Map<String, dynamic>);
    Map<String, List<Les>> result = {};
    jsonMap.forEach((key, value) {
      result[key] = [];
      value.forEach((json) {
        result[key]!.add(Les.fromJson(json));
      });
    });
    return result;
  }

  set lessonsCache(Map<String, List<Les>> value) {
    final String json = jsonEncode(value);
    _lessonsCache = json;
    sharedPrefs.lessonsCache = json;
    notifyListeners();
  }

  String _roosterView = sharedPrefs.roosterView;

  String get roosterView => _roosterView;

  set roosterView(String value) {
    _roosterView = value;
    sharedPrefs.roosterView = value;
    notifyListeners();
  }

  String _email = sharedPrefs.email;

  String get email => _email;

  set email(String value) {
    _email = value;
    sharedPrefs.email = value;
    notifyListeners();
  }

  String _password = sharedPrefs.password;

  String get password => _password;

  set password(String value) {
    _password = value;
    sharedPrefs.password = value;
    notifyListeners();
  }

  String _sharepointCookie = sharedPrefs.sharepointCookie;

  String get sharepointCookie => _sharepointCookie;

  set sharepointCookie(String value){
    _sharepointCookie = value;
    sharedPrefs.sharepointCookie = value;
    notifyListeners();
  }

  int _sharepointExpiry = sharedPrefs.sharepointExpiry;

  int get sharepointExpiry => _sharepointExpiry;

  set sharepointExpiry(int value){
    _sharepointExpiry = value;
    sharedPrefs.sharepointExpiry = value;
    notifyListeners();
  }
}
