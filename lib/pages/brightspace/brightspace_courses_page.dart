import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:wind/pages/brightspace/widgets/enrollment_tile.dart';
import 'package:wind/pages/elo/widgets/loading_indicator.dart';
import 'package:wind/pages/widgets/app_drawer.dart';
import 'package:wind/services/api/brightspace.dart';

class BrightspaceCoursesPage extends StatefulWidget {
  const BrightspaceCoursesPage({Key? key}) : super(key: key);

  @override
  _BrightspaceCoursesPageState createState() => _BrightspaceCoursesPageState();
}

class _BrightspaceCoursesPageState extends State<BrightspaceCoursesPage> {
  ScrollController scrollController = ScrollController();
  bool isLoading = true;
  late List<Enrollment> enrollments;
  late Map<String, Future<Course>> courses;

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  Future loadRoutes() async {
    setState(() => isLoading = true);
    await downloadAndSetEnrollments();
    setState(() {
      isLoading = false;
    });
  }

  Future downloadAndSetEnrollments() async {
    var response = await Brightspace.getEnrollments();
    setState(() {
      enrollments = [
        ...response.where((enrollment) => enrollment.pinned),
        ...response.where((enrollment) => !enrollment.pinned)
      ];
    });
    downloadAndSetCourses();
  }

  downloadAndSetCourses() {
    Map<String, Future<Course>> map = {};
    for (Enrollment e in enrollments) {
      setState(() {
        map.putIfAbsent(
            e.organizationUrl, () => Brightspace.getCourse(e.organizationUrl));
      });
    }
    setState(() => courses = map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Brightspace')),
      drawer: AppDrawer(),
      body: isLoading
          ? LoadingIndicator()
          : ImplicitlyAnimatedList<Enrollment>(
              controller: scrollController,
              items: enrollments,
              areItemsTheSame: (a, b) => a.url == b.url,
              itemBuilder: (context, animation, item, index) {
                return SizeFadeTransition(
                    sizeFraction: 0.7,
                    curve: Curves.easeInOut,
                    animation: animation,
                    child: EnrollmentTile(
                        item, courses[item.organizationUrl]!, () async {}));
              },
            ),
    );
  }

  /*
  Future<void> pinItem(Enrollment item) async {
    await ELO.toggleFavourite(item.id);
    showSnackbar(item.isFavorite
        ? "${item.name} verwijderd van favorieten"
        : "${item.name} toegevoegd aan favorieten");
    await downloadAndSetEnrollments();
    await scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }*/

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
