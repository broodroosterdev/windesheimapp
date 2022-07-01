import 'dart:ui';

import 'package:flutter/material.dart';

class Schedule {
  final String code;
  final ScheduleType type;
  Color color;

  String get apiCode {
    return "${type.codeName}-$code";
  }

  Schedule({required this.code, required this.type, this.color = Colors.green});

  Schedule.fromJson(Map<String, dynamic> json)
      : code = json["code"],
        color = Color(json["color"] as int),
        type = parseScheduleType(json["type"]) ?? ScheduleType.classCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['code'] = code;
    json['color'] = color.value;
    json['type'] = type.toString();
    return json;
  }

  static ScheduleType? parseScheduleType(String? value){
    for(ScheduleType type in ScheduleType.values){
      if(type.toString() == value){
        return type;
      }
    }
  }

  static ScheduleType? parseScheduleTypeFromWip(String? value){
    for(ScheduleType type in ScheduleType.values){
      if(type.codeName == value){
        return type;
      }
    }
  }

  static const availableColors = [
    Colors.blue,
    Colors.blueAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.red,
    Colors.redAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.white
  ];
}

enum ScheduleType {
  classCode,
  courseCode,
  teacherCode
}

extension Names on ScheduleType {
  String get codeName {
    switch(this){
      case ScheduleType.classCode: return "Class";
      case ScheduleType.courseCode: return "Course";
      case ScheduleType.teacherCode: return "Teacher";
    }
  }

  String get apiName {
    switch(this){
      case ScheduleType.classCode: return "Klas";
      case ScheduleType.courseCode: return "Vak";
      case ScheduleType.teacherCode: return "Docent";
    }
  }
}



