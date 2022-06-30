import 'package:flutter/material.dart';
import 'package:wind/pages/schedule/widgets/teacher_avatar.dart';

class TeacherName extends StatelessWidget {
  const TeacherName(this.name, {Key? key}) : super(key: key);

  final String name;
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: TeacherAvatar(name),
      label: Text(name,
        softWrap: false,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }
}
