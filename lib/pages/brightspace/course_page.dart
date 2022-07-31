import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:wind/pages/elo/widgets/loading_indicator.dart';
import 'package:wind/pages/widgets/page.dart';
import 'package:wind/services/api/brightspace.dart';

class CoursePage extends HookWidget {
  const CoursePage({Key? key, required CourseItem this.courseItem})
      : super(key: key);
  final CourseItem courseItem;
  @override
  Widget build(BuildContext context) {
    final modulesFuture =
        useMemoized(() => Brightspace.getCourseRoot(courseItem.enrollment.id));
    final future = useFuture(modulesFuture);

    if (!future.hasData) {
      return AppPage(title: courseItem.course.name, child: LoadingIndicator());
    }

    if (future.hasError) {
      return AppPage(
        title: 'Error',
        child: Center(
          child: Text(future.error.toString()),
        ),
      );
    }

    final modules = future.data!;
    return AppPage(
      title: courseItem.course.name,
      child: ListView.builder(
        itemCount: modules.length,
        itemBuilder: (BuildContext context, int index) {
          var module = modules[index];
          return ListTile(
            title: Text(module.title!),
            leading: Icon(
              Icons.folder,
              color: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }
}
