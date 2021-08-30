import 'dart:ui';

class Schedule {
  final String code;
  Color color;

  Schedule({
    required this.code,
    required this.color
  });

  Schedule.fromJson(Map<String, dynamic> json)
    : code = json["code"],
      color = Color(json["color"] as int);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['code'] = code;
    json['color'] = color.value;
    return json;
  }

}