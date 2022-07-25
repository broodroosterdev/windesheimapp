import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/api/brightspace.dart';

class EnrollmentTile extends StatelessWidget {
  final Enrollment enrollment;
  final Course course;
  final Function() onPin;
  const EnrollmentTile(this.enrollment, this.course, this.onPin, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          CachedNetworkImage(
            height: 170,
            imageUrl:
            "${course.imageUrl}/tile-high-density-mid-size.jpg",
            httpHeaders: {"Authorization": prefs.brightspaceAccess},
          ),
          ListTile(
            title: Text(course.name),
            subtitle: Text(course.code),
            trailing: pinIcon(context),
          ),
        ],
      ),
    );
  }

  Widget pinIcon(BuildContext context) {
    return IconButton(
      icon: Icon(
          enrollment.pinned ? Icons.push_pin : Icons.push_pin_outlined,
          color:
          enrollment.pinned ? null : Theme.of(context).primaryColor),
      onPressed: onPin,
    );
  }

}