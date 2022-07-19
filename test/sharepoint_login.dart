import 'package:dotenv/dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wind/services/auth/brightspace_auth.dart';
import 'package:wind/services/auth/sharepoint_auth.dart';

void main() {
  test("Login into sharepoint", () async {
    var env = DotEnv(includePlatformEnvironment: true)..load();
    await SharepointAuth.login(env['EMAIL']!, env['PASSWORD']!);
  });

  test("Brightspace login", () async {
    var env = DotEnv(includePlatformEnvironment: true)..load();
    var result = await BrightspaceAuth.login(env['EMAIL']!, env['PASSWORD']!);
    assert(result.isSuccess);
  });
}
