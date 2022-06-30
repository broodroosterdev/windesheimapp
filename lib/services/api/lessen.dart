import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wind/model/les.dart';
import 'package:wind/model/schedule.dart';
import 'package:wind/services/auth/auth_manager.dart';

import '../../providers.dart';

class Lessen {
  static Future<Response<dynamic>> makeRequest(String url) async {
    Response<dynamic> response = await Dio().get(url,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
            headers: {"Authorization": "Bearer " + prefs.accessToken}));

    if (response.statusCode != 200) {
      await AuthManager.refreshApi();
      response = await Dio().get(url,
          options: Options(
              followRedirects: false,
              headers: {"Authorization": "Bearer " + prefs.accessToken}));
    }
    return response;
  }

  static Future<List<Les>> getLessen(Schedule schedule) async {
    final String url =
        "https://windesheimapi.azurewebsites.net/api/v2/${schedule.type.apiName}/${schedule.code}/Les";
    Response<dynamic> response = await makeRequest(url);

    final rawLessen = (response.data as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    final List<Les> lessen = rawLessen.map((raw) => Les.fromJson(raw)).toList();
    return lessen;
  }

  static Future<List<Schedule>> getClassCodes() async {
    const String url = "https://windesheimapi.azurewebsites.net/api/v2/Klas";
    Response<dynamic> response = await makeRequest(url);
    final codes = (response.data as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .map((e) => e['id'] as String)
        .map((code) => Schedule(code: code, type: ScheduleType.classCode))
        .toList();
    return codes;
  }

  static Future<List<Schedule>> getCourseCodes() async {
    const String url = "https://windesheimapi.azurewebsites.net/api/v2/Vak";
    Response<dynamic> response = await makeRequest(url);
    final codes = (response.data as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .map((e) => e['id'] as String)
        .map((code) => Schedule(code: code, type: ScheduleType.courseCode))
        .toList();
    return codes;
  }

  static Future<List<Schedule>> getTeacherCodes() async {
    const String url = "https://windesheimapi.azurewebsites.net/api/v2/Docent";
    Response<dynamic> response = await makeRequest(url);
    final list = response.data as List<dynamic>;
    String test = jsonEncode(list);
    print(test);
    final codes = (response.data as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .map((e) => e['id'] as String)
        .map((code) => Schedule(code: code, type: ScheduleType.teacherCode))
        .toList();
    return codes;
  }

  static Future<List<Schedule>> getCodes() async {
    final classCodes = await getClassCodes();
    final courseCodes = await getCourseCodes();
    final codes = [...classCodes, ...courseCodes];
    return codes;
  }
}
