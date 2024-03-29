import 'package:dio/dio.dart';
import 'package:wind/model/news_item.dart';
import 'package:wind/services/auth/auth_manager.dart';

import '../../providers.dart';

class News {
  static String get studentCode =>
      prefs.email.replaceAll('@student.windesheim.nl', '');

  static Future<Response<dynamic>> makeRequest(String url) async {
    Response<dynamic> response = await Dio().get(url,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
            headers: {"Authorization": "Bearer " + prefs.apiAccess}));

    if (response.statusCode != 200) {
      await AuthManager.refreshApi();
      response = await Dio().get(url,
          options: Options(
              followRedirects: false,
              headers: {"Authorization": "Bearer " + prefs.apiAccess}));
    }
    return response;
  }

  static Future<Response<dynamic>> makeSharepointRequest(String url) async {
    Response<dynamic> response = await Dio().get(url,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
            headers: {"Cookie": await AuthManager.getSharepointCookie()}));

    if (response.statusCode != 200) {
      await AuthManager.refreshSharepoint();
      response = await Dio().get(url,
          options: Options(
              followRedirects: false,
              headers: {"Cookie": await AuthManager.getSharepointCookie()}));
    }
    return response;
  }

  static Future<List<NewsItem>> getNewsItems() async {
    final String url =
        "https://windesheimapi.azurewebsites.net/api/v2/Persons/$studentCode/NewsItems"
        "?onlydata=true&culture=NL&onlyNotExpired=true&\$orderby=WH_lastmodified desc"
        "&\$filter=WH_endDate ge datetime'${DateTime.now().toIso8601String()}'";
    final Response response = await makeRequest(url);
    final raw = (response.data as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    final List<NewsItem> items = raw.map((raw) => NewsItem.fromJson(raw)).toList();
    return items;
  }

  static Future<String> getNewsItem(String url) async {
    final Response response = await makeSharepointRequest(url);
    return response.data;
  }
}
