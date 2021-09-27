import 'package:dio/dio.dart';
import 'package:wind/model/handin_details.dart';
import 'package:wind/model/studycontent.dart';
import 'package:wind/model/studyroute.dart';

import '../../providers.dart';

class ELO {
  static Future<Response<dynamic>> makeRequest(String url) async {
    //await EloAuth.refresh();
    Response<dynamic> response = await Dio().get(url,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
            headers: {"Cookie": "N%40TCookie=${prefs.eloCookie}"}));

    if (response.statusCode != 200) {
      throw "Cookie timed out pls help";
      response = await Dio().get(url,
          options: Options(
              followRedirects: false,
              headers: {"Authorization": "Bearer " + prefs.accessToken}));
    }
    return response;
  }

  static Future<List<StudyRoute>> getStudyRoutes() async {
    final String url = 'https://elo.windesheim.nl/services/Studyroutemobile.asmx/LoadStudyroutes?start=0&length=100&filter=0&search=';
    Response<dynamic> response = await makeRequest(url);

    final rawRoutes = (response.data['STUDYROUTES'] as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    final List<StudyRoute> routes = rawRoutes.map((raw) => StudyRoute.fromJson(raw)).toList();
    return routes;
  }

  static Future<List<StudyContent>> getStudyContent(int studyRouteId, int? parentId) async {
    final String url = "https://elo.windesheim.nl/services/studyroutemobile.asmx/LoadStudyrouteContent?studyrouteid=${studyRouteId}&parentid=${parentId ?? -1}&start=0&length=100";
    Response<dynamic> response = await makeRequest(url);
    final rawContent = (response.data['STUDYROUTE_CONTENT'] as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    final List<StudyContent> content = rawContent.map((raw) => StudyContent.fromJson(raw)).toList();
    return content;
  }

  static Future<HandinDetails> getHandinDetails(int resourceId) async {
    final String url = "https://elo.windesheim.nl/services/Studyroutemobile.asmx/LoadUserHandinDetails?studyRouteResourceId=${resourceId}";
    Response<dynamic> response = await makeRequest(url);
    final rawContent = ((response.data['STUDYROUTE_USER_HANDINDETAILS'] as List<dynamic>)[0]) as Map<String, dynamic>;
    final HandinDetails details = HandinDetails.fromJson(rawContent);
    return details;
  }

  static Future<void> toggleFavourite(int studyRouteId) async {
    final String url = "https://elo.windesheim.nl/Home/StudyRoute/StudyRoute/ToggleFavorite";
    Response<dynamic> response = await Dio().post(url,
        data: {
          'studyrouteId': studyRouteId
        },
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
            headers: {"Cookie": "N%40TCookie=${prefs.eloCookie}"},
            contentType: Headers.formUrlEncodedContentType
        ));
  }

  static Future<bool> downloadFile(String url, String path, CancelToken token, void Function(int, int)? progressCallback) async {
    try {
      var response = await Dio().download(
          url,
          path,
          onReceiveProgress: progressCallback,
          cancelToken: token,
          options: Options(
              headers: {"Cookie": "N%40TCookie=${prefs.eloCookie}"}
          )
      );
      return response.statusCode == null ? false : response.statusCode! < 400;
    } catch(e) {
      return false;
    }
  }
}