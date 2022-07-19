import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:wind/model/siren/entity.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/auth/auth_manager.dart';

class Brightspace {
  static Future<Response<dynamic>> makeRequest(String url) async {
    String token = await AuthManager.getBrightspaceToken();
    Response<dynamic> response = await Dio().get(url,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
            headers: {"Authorization": "Bearer $token"}));

    if (response.statusCode != 200 || response.data.runtimeType == String) {
      await AuthManager.refreshBrightspace();
      String token = await AuthManager.getBrightspaceToken();
      response = await Dio().get(url,
          options: Options(
              followRedirects: false,
              validateStatus: (status) => status! < 500,
              headers: {"Authorization": "Bearer=$token"}));
    }
    return response;
  }

  static Future<List<Enrollment>> getEnrollments() async {
    final String url =
        "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.enrollments.api.brightspace.com/users/${prefs.brightspaceId}?excludeEnded=0&embedDepth=1&promotePins=1&pageSize=100";
    Response<dynamic> response = await makeRequest(url);
    Entity entity = Entity.fromMap(response as Map<String, dynamic>);
    List<Enrollment> enrollments =
        entity.entities?.map((e) => Enrollment.fromSubEntity(e)).toList() ?? [];
    return enrollments;
  }

  static Future<Course> getCourse(String organizationUrl) async {
    Response<dynamic> response = await makeRequest(organizationUrl);
    Entity entity = Entity.fromMap(response as Map<String, dynamic>);
    return Course.fromEntity(entity);
  }
}

class Enrollment {
  bool pinned;
  String url;
  String organizationUrl;

  Enrollment(this.pinned, this.url, this.organizationUrl);

  factory Enrollment.fromSubEntity(SubEntity subEntity) {
    bool pinned = subEntity.subEntityClass?.contains("pinned") ?? false;
    String url = subEntity.href;
    String organizationUrl = subEntity.links!
        .firstWhere((l) =>
            l.rel.contains("https://api.brightspace.com/rels/organization"))
        .href;
    return Enrollment(pinned, url, organizationUrl);
  }
}

class Course {
  String name;
  String code;
  DateTime? startDate;
  DateTime? endDate;
  bool isActive;
  Color color;
  String imageUrl;

  Course(this.name, this.code, this.startDate, this.endDate, this.isActive,
      this.color, this.imageUrl);

  factory Course.fromEntity(Entity entity) {
    var props = entity.properties!;

    var startDate =
        props["startDate"] == null ? null : DateTime.parse(props["startDate"]);
    var endDate =
        props["endDate"] == null ? null : DateTime.parse(props["endDate"]);

    var colorString =
        entity.getSubEntityWithClass("color")!.properties!["hexString"];
    var color = HexColor.fromHex(colorString);

    var imageUrl = entity.getSubEntityWithClass("course-image")!.href;
    return Course(props["name"], props["code"], startDate, endDate,
        props["isActive"], color, imageUrl);
  }
}

/// Taken from https://stackoverflow.com/a/50081214
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
