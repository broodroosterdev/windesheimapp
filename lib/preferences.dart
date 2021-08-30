import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:windesheimapp/providers.dart';

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
  List<Schedule> get schedules{
    List<Map<String, dynamic>> jsonList = (jsonDecode(_schedules) as List<dynamic>).map((data) => data as Map<String, dynamic>).toList();
    return jsonList.map((json) => Schedule.fromJson(json)).toList();
  }
  set schedules(List<Schedule> value) {
    final String json = jsonEncode(value);
    _schedules = json;
    sharedPrefs.schedules = json;
    notifyListeners();
  }
}
