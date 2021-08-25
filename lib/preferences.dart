import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:windesheimapp/providers.dart';

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
}
