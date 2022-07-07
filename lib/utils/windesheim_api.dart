import 'package:dio/dio.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/auth/auth_manager.dart';

class WindesheimApi {
  static Future<Response<dynamic>> makeRequest(String url) async {
    Response<dynamic> response = await Dio().get(url,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
            headers: {"Authorization": "Bearer ${prefs.apiAccess}"}));
    if (response.statusCode != 200) {
      await AuthManager.refreshApi();
      response = await Dio().get(url,
          options: Options(
              followRedirects: false,
              headers: {"Authorization": "Bearer ${prefs.apiAccess}"}));
    }
    return response;
  }
}