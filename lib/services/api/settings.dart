import 'package:dio/dio.dart';
import 'package:wind/model/schedule.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/api/study.dart';
import 'package:wind/services/auth/auth_manager.dart';
import 'package:wind/utils/windesheim_api.dart';

class Settings {
  static Future<Map<String, dynamic>> getSettings() async{
    final String url = "https://windesheimapi.azurewebsites.net/api/v2/Persons/${Study.studentCode}/SettingsAll";
    final Response response = await WindesheimApi.makeRequest(url);
    final raw = (response.data as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList();
    Map<String, dynamic> settings = {};
    for(var setting in raw){
      settings.putIfAbsent(setting['key'], () => setting['value']);
    }
    return settings;
  }
}