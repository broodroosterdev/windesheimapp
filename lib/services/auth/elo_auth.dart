import 'package:cookie_jar/cookie_jar.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:html/dom.dart';
import 'package:wind/internal/auth_failure.dart';
import 'package:wind/providers.dart';

class EloAuth {
  static void removeCookie() {
    prefs.eloCookie = '';
  }

  static Future<Either<AuthFailure, String>> login(
      String username, String password) async {
    CookieJar jar = CookieJar();
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(jar));

    Response response = await dio.get(
        'https://elo.windesheim.nl/Security/SAML2/Login.aspx?redirectUrl=https://elo.windesheim.nl/Start.aspx');

    String body = response.data;
    Document doc = Document.html(body);
    String samlToken =
        doc.querySelector('[name=SAMLRequest]')!.attributes['value']!;
    String relayState =
        doc.querySelector('[name=RelayState]')!.attributes['value']!;

    response = await dio.post(
      'https://engine.surfconext.nl/authentication/idp/single-sign-on',
      data: {'SAMLRequest': samlToken, 'RelayState': relayState},
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    response = await dio.get(response.headers['location']![0].toString());

    body = response.data;
    doc = Document.html(body);

    String loginUrl = doc.querySelector('#loginForm')!.attributes['action']!;

    response = await dio.post(
      'https://sts.windesheim.nl$loginUrl',
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

    if (response.headers['location'] == null) {
      return Left(AuthFailure("Incorrect email or password"));
    }
    response = await dio.get(response.headers['location']![0]);

    body = response.data;
    doc = Document.html(body);

    String samlResponse =
        doc.querySelector('[name=SAMLResponse]')!.attributes['value']!;

    response = await dio.post(
      'https://engine.surfconext.nl:443/authentication/sp/consume-assertion',
      data: {
        'SAMLResponse': samlResponse,
      },
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    body = response.data;
    doc = Document.html(body);
    samlResponse =
        doc.querySelector('[name=SAMLResponse]')!.attributes['value']!;
    relayState = doc.querySelector('[name=RelayState]')!.attributes['value']!;

    response = await dio.post(
      'https://elo.windesheim.nl/Security/SAML2/AssertionConsumerService.aspx',
      data: {'SAMLResponse': samlResponse, 'RelayState': relayState},
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    var cookies =
        await jar.loadForRequest(Uri.parse('https://elo.windesheim.nl'));

    return Right(cookies[0].value);
  }
}
