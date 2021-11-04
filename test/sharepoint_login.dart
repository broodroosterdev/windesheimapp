import 'package:flutter_test/flutter_test.dart';
import 'package:dotenv/dotenv.dart' show load, env;
import 'package:wind/services/auth/sharepoint_auth.dart';

void main(){
  test("Login into sharepoint", () async {
    load();
    await SharepointAuth.login(env['EMAIL']!, env['PASSWORD']!);
  });
}