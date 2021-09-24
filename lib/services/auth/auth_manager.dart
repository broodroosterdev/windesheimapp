import 'package:dartz/dartz.dart';
import 'package:wind/internal/auth_failure.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/auth/api_auth.dart';
import 'elo_auth.dart';

class AuthManager {
  static bool get loggedIn => prefs.eloCookie != '' && prefs.accessToken != '';

  static Future<Either<AuthFailure, void>> loginElo(
      String email, String password) async {
    Either<AuthFailure, String> eloResponse =
        await EloAuth.login(email, password);
    return eloResponse.fold(
          (l) {
        print("error: " + l.message);
        return Left(l);
      },
      (r) {
        prefs.eloCookie = r;
        return const Right(null);
      },
    );
  }

  static Future<Either<AuthFailure, void>> loginApi(
      String email, String password) async {
    Either<AuthFailure, ApiTokens> apiResponse =
        await ApiAuth.login(email, password);
    return apiResponse.fold(
        (l) {
          print("error: " + l.message);
          return Left(l);
        },
        (r) {
          prefs.accessToken = r.accessToken;
          prefs.refreshToken = r.refreshToken;
          return const Right(null);
        },
    );
  }

  static Future<Either<AuthFailure, void>> refreshApi() async {
    Either<AuthFailure, ApiTokens> apiResponse = await ApiAuth.refreshToken(prefs.refreshToken);
    return apiResponse.fold(
          (l) {
        print("error: " + l.message);
        return Left(l);
      },
          (r) {
        prefs.accessToken = r.accessToken;
        prefs.refreshToken = r.refreshToken;
        return const Right(null);
      },
    );
  }

  static logout() {
    prefs.eloCookie = '';
    prefs.accessToken = '';
    prefs.refreshToken = '';
  }
}
