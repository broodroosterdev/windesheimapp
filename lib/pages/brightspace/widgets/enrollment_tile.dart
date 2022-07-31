import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/api/brightspace.dart';

class EnrollmentTile extends StatelessWidget {
  final CourseItem item;
  final Function() onPin;
  const EnrollmentTile(this.item, this.onPin, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.of(context).pushNamed('/course', arguments: {'item': item}),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            CachedNetworkImage(
              height: 170,
              imageUrl:
                  "${item.course.imageUrl}/tile-high-density-mid-size.jpg",
              httpHeaders: {"Authorization": prefs.brightspaceAccess},
            ),
            ListTile(
              title: Text(item.course.name),
              subtitle: Text(item.course.code),
              trailing: pinIcon(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget pinIcon(BuildContext context) {
    return IconButton(
      icon: Icon(
          item.enrollment.pinned ? Icons.push_pin : Icons.push_pin_outlined,
          color:
              item.enrollment.pinned ? null : Theme.of(context).primaryColor),
      onPressed: onPin,
    );
  }
}
