import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

import 'package:cookie_jar/cookie_jar.dart';

class EloAuth {
  static String code = '';

  static Future<String> login(String username, String password) async {
    CookieJar cj = CookieJar();
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(cj));

    Response response = await dio.get('https://login.microsoftonline.com/e36377b7-70c4-4493-a338-095918d327e9/oauth2/authorize?resource=https://windesheimapi.azurewebsites.net/login/aad&client_id=7cd9c6cb-1da9-4d26-93e4-7c0beb04793f&response_type=code&haschrome=1&redirect_uri=https://localhost&client-request-id=6249263f-19c7-4e4f-b5ce-58d9eca344a9&prompt=login');

    String body = response.data;
    int jsonStart = body.indexOf('\$Config=') + '\$Config='.length;
    int jsonEnd = body.indexOf('};', jsonStart) + 1;

    String json = body.substring(jsonStart, jsonEnd);
    Map<String, dynamic> options = jsonDecode(json);
    
    String flowToken = options['sFT'] as String;
    String originalRequest = options['sCtx'] as String;

    response = await dio.post('https://login.microsoftonline.com/common/GetCredentialType?mkt=en-US', data: {
      'flowToken': flowToken,
      'username': username,
      'originalRequest': originalRequest,
    });
    String redirectUrl = (response.data['Credentials'] as Map<String, dynamic>)['FederationRedirectUrl'];

    response = await dio.post(
      redirectUrl, 
      data: {
        'UserName': username,
        'Password': password,
        'AuthMethod': 'FormsAuthentication'
      },
      options: Options(
        followRedirects: false,
        validateStatus: (status) { return status! < 500; },
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    response = await dio.get(response.headers['location']![0].toString());


    body = response.data;
    Document html = Document.html(body);
    var wresult = html.querySelector('[name=wresult]')!.attributes['value'];
    var wctx = html.querySelector('[name=wctx]')!.attributes['value'];

    response = await dio.post('https://login.microsoftonline.com/login.srf', data: {
      'wa': 'wsignin1.0',
      'wresult': wresult,
      'wctx': wctx
    },
    options: Options(
      followRedirects: false,
      validateStatus: (status) { return status! < 500; },
      contentType: Headers.formUrlEncodedContentType),
    );

    Uri codeUrl = Uri.parse(response.headers['location']![0].toString());
    print(codeUrl.queryParameters['session_state']);
    return codeUrl.queryParameters['code']!;
  }
}
