import 'package:flutter/material.dart';
import 'package:wind/pages/schedule/widgets/teacher_avatar.dart';

class TeacherTile extends StatelessWidget {
  const TeacherTile(this.name, {Key? key}) : super(key: key);

  final String name;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: TeacherAvatar(name, size: 42),
      title: Text(name),
    );
  }
}
