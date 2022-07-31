import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:wind/model/siren/entity.dart';
import 'package:wind/pages/brightspace/widgets/enrollment_tile.dart';
import 'package:wind/pages/elo/widgets/loading_indicator.dart';
import 'package:wind/services/api/brightspace.dart';
import 'package:wind/pages/widgets/page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  ScrollController scrollController = ScrollController();
  bool isLoading = true;
  late List<CourseItem> items;

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  Future loadRoutes() async {
    setState(() => isLoading = true);
    var response = await Brightspace.getCourseItems();
    response.sort((a, b) => a.course.name.compareTo(b.course.name));
    setState(() => items = response);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Brightspace',
      child: isLoading
          ? LoadingIndicator()
          : ImplicitlyAnimatedList<CourseItem>(
              controller: scrollController,
              items: [
                ...items.where((item) => item.enrollment.pinned),
                ...items.where((item) => !item.enrollment.pinned)
              ],
              areItemsTheSame: (a, b) => a.course.code == b.course.code,
              itemBuilder: (context, animation, item, index) {
                return SizeFadeTransition(
                    sizeFraction: 0.7,
                    curve: Curves.easeInOut,
                    animation: animation,
                    child: EnrollmentTile(item, () => pinItem(item)));
              },
            ),
    );
  }

  Future<void> pinItem(CourseItem item) async {
    var response =
        await Brightspace.executeAction(item.enrollment.togglePinAction);
    if (response.statusCode != 200) {
      showSnackbar(
          "Kon het vak niet ${item.enrollment.pinned ? "losmaken" : "vastzetten"}");
      return;
    }

    SubEntity entity = SubEntity.fromMap(response.data as Map<String, dynamic>);
    var enrollment = Enrollment.fromSubEntity(entity);
    var index = items.indexWhere((i) => i.course.code == item.course.code);

    setState(() {
      items[index].enrollment = enrollment;
    });

    await scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        content: Text(
          message,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}
