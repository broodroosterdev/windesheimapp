import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wind/internal/shared_prefs.dart';
import 'package:wind/preferences.dart';
import 'package:wind/services/download/download_manager.dart';

class _ProvidersSingleton {
  _ProvidersSingleton._();

  late SharedPrefs _sharedPrefs;
  late Directory _temporaryDirectory;
  late Preferences _prefs;
  late DownloadManager _downloadManager;
  late Map<String, String> _teacherMailMap;

  static final _ProvidersSingleton instance = _ProvidersSingleton._();

  Future<void> initProviders() async {
    _sharedPrefs = await SharedPrefs.newInstance();
    _temporaryDirectory = await getTemporaryDirectory();
    _prefs = Preferences();
    _downloadManager = DownloadManager();
    _teacherMailMap = await getTeacherMailMap();
  }

  Future<Map<String, String>> getTeacherMailMap() async {
    String json = await rootBundle.loadString('assets/data/teachers.json');
    List<dynamic> data = jsonDecode(json);
    var mapList = data.map((e) => e as Map<String, dynamic>);
    return Map.fromIterable(mapList, key: (t) => t['name'], value: (t) => t['email'] as String);
    }
}

Future<void> initProviders() async =>
    _ProvidersSingleton.instance.initProviders();

Preferences get prefs => _ProvidersSingleton.instance._prefs;
SharedPrefs get sharedPrefs => _ProvidersSingleton.instance._sharedPrefs;
Directory get tempDir => _ProvidersSingleton.instance._temporaryDirectory;
DownloadManager get downloadManager =>
    _ProvidersSingleton.instance._downloadManager;
Map<String, String> get teacherMailMap => _ProvidersSingleton.instance._teacherMailMap;
