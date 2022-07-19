import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:html/dom.dart';
import 'package:result_type/result_type.dart';
import 'package:wind/internal/auth_failure.dart';

class BrightspaceAuth {
  static Future<Result<BrightSpaceToken, AuthFailure>> login(
      String username, String password) async {
    CookieJar jar = CookieJar();
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(jar));

    // Go to site to trigger login redirect
    var response = await dio.get('https://leren.windesheim.nl/');

    // Enter credentials on microsoft login page
    response = await dio.post(
      response.realUri.toString(),
      data: {
        'UserName': username,
        'Password': password,
        'AuthMethod': 'FormsAuthentication'
      },
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    // When location header isnt set, it means you are still at the same login page.
    if (response.headers['location'] == null) {
      return Failure(AuthFailure("Incorrect email or password"));
    }

    // Proceed with login to get SAMLResponse
    response = await dio.get(response.headers['location']![0].toString());

    var body = response.data;
    var doc = Document.html(body);

    String samlResponse =
        doc.querySelector('[name=SAMLResponse]')!.attributes['value']!;

    // Give SAMLResponse to D2L to recieve session cookies
    response = await dio.post(
      "https://leren.windesheim.nl/d2l/lp/auth/login/samlLogin.d2l",
      data: {'SAMLResponse': samlResponse},
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    // Go to home page to get CSRF token
    response = await dio.get("https://leren.windesheim.nl/d2l/home");
    var html = response.data as String;
    var csrfToken = findBetween("'XSRF.Token','", "'", html);
    var userId = findBetween("'Session.UserId','", "'", html);

    jar.saveFromResponse(Uri.parse("https://leren.windesheim.nl/"),
        List.of([Cookie("SameSite", "none")]));

    response = await dio.post(
      'https://leren.windesheim.nl/d2l/lp/auth/oauth2/token',
      data: {'scope': '*:*:*'},
      options: Options(
        headers: {
          'X-Csrf-Token': csrfToken,
          'User-Agent':
              'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)',
        },
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    var expires = response.data['expires_at'];
    var accessToken = response.data['access_token'];
    return Success(BrightSpaceToken(expires, accessToken, userId));
  }

  static String findBetween(String start, String end, String data) {
    var tokenStart = data.indexOf(start) + start.length;
    var tokenEnd = data.indexOf(end, tokenStart);
    return data.substring(tokenStart, tokenEnd);
  }
}

class BrightSpaceToken {
  int expiresAt;
  String token;
  String userId;

  BrightSpaceToken(this.expiresAt, this.token, this.userId);
}
