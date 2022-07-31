import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:wind/model/brightspace/module.dart';
import 'package:wind/model/siren/entity.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/auth/auth_manager.dart';

class Brightspace {
  static Future<Response<dynamic>> makeRequest(RequestOptions options) async {
    String token = await AuthManager.getBrightspaceToken();
    options.headers.putIfAbsent("Authorization", () => "Bearer $token");
    options.followRedirects = false;
    options.validateStatus = (status) => status! < 500;
    Response<dynamic> response = await Dio().fetch(options);

    if (response.statusCode != 200 || response.data.runtimeType == String) {
      await AuthManager.refreshBrightspace();
      String token = await AuthManager.getBrightspaceToken();
      options.headers.update("Authorization", (value) => "Bearer $token");
      response = await Dio().fetch(options);
    }
    return response;
  }

  static Future<List<CourseItem>> getCourseItems() async {
    final String url =
        "https://295785a6-7922-4ff5-b94f-71dc1e77ffc8.enrollments.api.brightspace.com/users/${prefs.brightspaceId}?excludeEnded=0&embedDepth=1&promotePins=1&pageSize=100";
    Response<dynamic> response =
        await makeRequest(RequestOptions(path: url, method: Method.GET.name));
    Entity entity = Entity.fromMap(response.data as Map<String, dynamic>);

    List<CourseItem> items = [];
    List<SubEntity> subs = entity.entities ?? [];

    items = await Future.wait(subs.map(Enrollment.fromSubEntity).map(
        (enrollment) => getCourse(enrollment.organizationUrl)
            .then((course) => CourseItem(enrollment, course))));

    return items;
  }

  static Future<Course> getCourse(String organizationUrl) async {
    Response<dynamic> response = await makeRequest(
        RequestOptions(path: organizationUrl, method: Method.GET.name));
    Entity entity = Entity.fromMap(response.data as Map<String, dynamic>);
    return Course.fromEntity(entity);
  }

  static Future<List<Module>> getCourseRoot(String id) async {
    final String url =
        "https://leren.windesheim.nl/d2l/api/le/1.41/$id/content/toc";
    Response<dynamic> response =
        await makeRequest(RequestOptions(path: url, method: Method.GET.name));
    List<Module> modules = (response.data["Modules"] as List<dynamic>)
        .map((item) => Module.fromJson(item as Map<String, dynamic>))
        .toList();
    return modules;
  }

  static Future<Response<dynamic>> executeAction(Action action) async {
    Map<String, dynamic>? body;
    if (action.fields != null) {
      body = {};
      for (Field field in action.fields!) {
        body.putIfAbsent(field.name, () => field.value);
      }
    }
    Response<dynamic> response = await makeRequest(RequestOptions(
        path: action.href!,
        method: action.method?.name ?? "GET",
        data: body == null ? null : FormData.fromMap(body)));
    return response;
  }
}

class CourseItem {
  Enrollment enrollment;
  Course course;

  CourseItem(this.enrollment, this.course);
}

class Enrollment {
  String id;

  bool pinned;

  String url;
  String organizationUrl;

  Action togglePinAction;

  Enrollment(this.id, this.pinned, this.url, this.organizationUrl,
      this.togglePinAction);

  factory Enrollment.fromSubEntity(SubEntity subEntity) {
    bool pinned = subEntity.subEntityClass?.contains("pinned") ?? false;
    String url =
        subEntity.links!.firstWhere((l) => l.rel.contains("self")).href;
    String organizationUrl = subEntity.links!
        .firstWhere((l) =>
            l.rel.contains("https://api.brightspace.com/rels/organization"))
        .href;
    String id = Uri.parse(organizationUrl).path;
    Action togglePin = subEntity.actions!.first;

    return Enrollment(id, pinned, url, organizationUrl, togglePin);
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

    var imageUrl = entity.getSubEntityWithClass("course-image")!.href!;
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
