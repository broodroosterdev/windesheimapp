import 'package:dio/dio.dart';
import 'package:wind/model/news_item.dart';
import 'package:wind/services/auth/auth_manager.dart';

import '../../providers.dart';

class News {
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
        "https://windesheimapi.azurewebsites.net/api/v2/Persons/s1144816/NewsItems"
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
