import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:wind/providers.dart';
import 'package:wind/services/api/brightspace.dart';

class EnrollmentTile extends StatefulWidget {
  final Enrollment enrollment;
  final Future<Course> courseFuture;
  final Function() onPin;

  const EnrollmentTile(this.enrollment, this.courseFuture, this.onPin,
      {Key? key})
      : super(key: key);

  @override
  _EnrollmentTileState createState() => _EnrollmentTileState();
}

class _EnrollmentTileState extends State<EnrollmentTile> {
  Course? course;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() => isLoading = true);
    widget.courseFuture.then(setCourse);
  }

  void setCourse(Course c) {
    if (!mounted) {
      return;
    }

    setState(() {
      course = c;
      isLoading = false;
    });
  }

  Widget pinIcon() {
    return IconButton(
      icon: Icon(
          widget.enrollment.pinned ? Icons.push_pin : Icons.push_pin_outlined,
          color:
              widget.enrollment.pinned ? null : Theme.of(context).primaryColor),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          isLoading
              ? const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      padding: EdgeInsets.zero,
                      randomHeight: false,
                      randomWidth: false,
                      width: double.infinity,
                      height: 170,
                      borderRadius: BorderRadius.only()),
                )
              : CachedNetworkImage(
                  height: 170,
                  imageUrl:
                      "${course!.imageUrl}/tile-high-density-mid-size.jpg",
                  httpHeaders: {"Authorization": prefs.brightspaceAccess},
                ),
          isLoading
              ? SkeletonListTile(
                  hasLeading: false,
                  hasSubtitle: true,
                  trailing: pinIcon(),
                )
              : ListTile(
                  title: Text(course!.name),
                  subtitle: Text(course!.code),
                  trailing: IconButton(
                    icon: pinIcon(),
                    onPressed: () {},
                  ),
                ),
        ],
      ),
    );
  }
}
