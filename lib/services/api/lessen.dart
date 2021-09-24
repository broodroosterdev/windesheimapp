import 'package:dio/dio.dart';
import 'package:wind/model/les.dart';
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

  static Future<List<Les>> getLessen(String code) async {
    final String url =
        "https://windesheimapi.azurewebsites.net/api/v2/Klas/$code/Les";
    Response<dynamic> response = await makeRequest(url);

    final rawLessen = (response.data as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    final List<Les> lessen = rawLessen.map((raw) => Les.fromJson(raw)).toList();
    return lessen;
  }

  static Future<List<String>> getCodes() async {
    const String url =
        "https://windesheimapi.azurewebsites.net/api/v2/Klas";
    Response<dynamic> response = await makeRequest(url);
    final codes = (response.data as List<dynamic>).map((e) => e as Map<String,dynamic>).map((e) => e['id'] as String).toList();
    return codes;
  }
}