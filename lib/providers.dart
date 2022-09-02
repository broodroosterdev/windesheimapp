import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wind/preferences.dart';
import 'package:wind/services/download/download_manager.dart';

class _ProvidersSingleton {
  _ProvidersSingleton._();

  late Directory _temporaryDirectory;
  late Preferences _prefs;
  late DownloadManager _downloadManager;
  late Map<String, String> _teacherMailMap;

  static final _ProvidersSingleton instance = _ProvidersSingleton._();

  Future<void> initProviders() async {
    developer.log("starting to init",
        time: DateTime.now(), name: "initProviders");
    _temporaryDirectory = await getTemporaryDirectory();
    _prefs = Preferences();
    await _prefs.init();
    _downloadManager = DownloadManager();
    _teacherMailMap = await getTeacherMailMap();
    developer.log("finished init", time: DateTime.now(), name: "initProviders");
  }

  static List<dynamic> _decodeJson(String json) {
    return jsonDecode(json);
  }

  Future<Map<String, String>> getTeacherMailMap() async {
    developer.log("loading map from assets",
        time: DateTime.now(), name: "getTeacherMailMap");
    String jsonString =
        await rootBundle.loadString('assets/data/teachers.json');
    List<dynamic> data = await compute(
      _decodeJson,
      jsonString,
    );
    var mapList = data.map((e) => e as Map<String, dynamic>);
    Map<String, String> map = {
      for (var t in mapList) t['name']: t['email'] as String
    };
    developer.log("loading map finished",
        time: DateTime.now(), name: "getTeacherMailMap");
    return map;
  }
}

Future<void> initProviders() async =>
    _ProvidersSingleton.instance.initProviders();

Preferences get prefs => _ProvidersSingleton.instance._prefs;
Directory get tempDir => _ProvidersSingleton.instance._temporaryDirectory;
DownloadManager get downloadManager =>
    _ProvidersSingleton.instance._downloadManager;
Map<String, String> get teacherMailMap =>
    _ProvidersSingleton.instance._teacherMailMap;
