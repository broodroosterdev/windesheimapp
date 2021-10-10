import 'package:dio/dio.dart';
import 'package:wind/model/course_result.dart';
import 'package:wind/model/study_progress.dart';
import 'package:wind/services/auth/auth_manager.dart';

import '../../providers.dart';

class Study {
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

  static Future<StudyProgress> getStudyProgress() async {
    final String studentCode = prefs.email.replaceAll('@student.windesheim.nl', '');
    final String url = "https://windesheimapi.azurewebsites.net/api/v1/Persons/$studentCode/Study?onlydata=true&culture=EN";
    Response<dynamic> response = await makeRequest(url);
    final rawContent = (response.data as List<dynamic>)[0] as Map<String, dynamic>;
    final StudyProgress progress = StudyProgress.fromJson(rawContent);
    return progress;
  }

  static Future<List<CourseResult>> getCourseResults(String code) async {
    final String url = 'https://windesheimapi.azurewebsites.net/api/v1/Persons/s1144816/Study/$code/CourseResults?onlyCurrent=false&onlydata=true&culture=EN&\$orderby=lastmodified desc,course/name';
    Response<dynamic> response = await makeRequest(url);
    final rawContent = (response.data as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    final List<CourseResult> results = rawContent.map((raw) => CourseResult.fromJson(raw)).toList();
    return results;
  }

}