import 'package:result_type/result_type.dart';
import 'package:wind/internal/auth_failure.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/auth/api_auth.dart';
import 'package:wind/services/auth/sharepoint_auth.dart';

import 'elo_auth.dart';

class AuthManager {
  static bool get loggedIn => prefs.apiAccess != '';

  static Future<Result<void, AuthFailure>> refreshElo() async {
    Result<String, AuthFailure> eloResponse =
        await EloAuth.login(prefs.email, prefs.password);

    if (eloResponse.isFailure) {
      print("error: ${eloResponse.failure.message}");
      return Failure(eloResponse.failure);
    } else {
      await prefs.setEloCookie(eloResponse.success);
      return Success(null);
    }
  }

  static Future<Result<void, AuthFailure>> loginApi(
      String email, String password) async {
    Result<ApiTokens, AuthFailure> apiResponse =
        await ApiAuth.login(email, password);

    if (apiResponse.isFailure) {
      print("error: " + apiResponse.failure.message);
      return Failure(apiResponse.failure);
    } else {
      await prefs.setEmail(email);
      await prefs.setPassword(password);
      await prefs.setApiAccess(apiResponse.success.accessToken);
      await prefs.setApiRefresh(apiResponse.success.refreshToken);
      return Success(null);
    }
  }

  static Future<Result<void, AuthFailure>> refreshApi() async {
    Result<ApiTokens, AuthFailure> apiResponse =
        await ApiAuth.refreshToken(prefs.apiRefresh);
    if (apiResponse.isFailure) {
      print("error: " + apiResponse.failure.message);
      return Failure(apiResponse.failure);
    } else {
      await prefs.setApiAccess(apiResponse.success.accessToken);
      await prefs.setApiRefresh(apiResponse.success.refreshToken);
      return Success(null);
    }
  }

  static Future<String> getSharepointCookie() async {
    if (DateTime.fromMillisecondsSinceEpoch(prefs.sharepointExpiry)
        .isBefore(DateTime.now())) {
      await refreshSharepoint();
    }
    return prefs.sharepointCookie;
  }

  static Future refreshSharepoint() async {
    final cookie = await SharepointAuth.login(prefs.email, prefs.password);
    prefs.setSharepointCookie(cookie.cookie);
    prefs.sharepointExpiry = cookie.expiresAt;
  }

  static Future logout() async {
    await prefs.clear();
  }
}
