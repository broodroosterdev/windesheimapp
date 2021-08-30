import 'package:flutter/material.dart';
import 'package:windesheimapp/model/schedule.dart';

class RoosterTile extends StatelessWidget {
  final Schedule schedule;
  final void Function() onEdit;
  final void Function() onDelete;

  const RoosterTile({Key? key, required this.schedule, required this.onEdit, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(schedule.code, style: Theme.of(context).textTheme.subtitle1),
          ],
        ),
        Row(children: [
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: schedule.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          TextButton(onPressed: onEdit, child: const Icon(Icons.edit, size: 24)),
          TextButton(onPressed: onDelete, child: const Icon(Icons.delete, size: 24))
        ]),
      ],
    );
  }
}
