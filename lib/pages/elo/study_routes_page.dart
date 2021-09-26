import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:wind/model/studyroute.dart';
import 'package:wind/pages/elo/widgets/study_route_tile.dart';
import 'package:wind/pages/widgets/app_drawer.dart';
import 'package:wind/services/api/elo.dart';

class StudyRoutesPage extends StatefulWidget {
  StudyRoutesPage({Key? key}) : super(key: key);

  @override
  _StudyRoutesPageState createState() => _StudyRoutesPageState();
}

class _StudyRoutesPageState extends State<StudyRoutesPage> {
  ScrollController scrollController = ScrollController();
  bool isLoading = true;
  late List<StudyRoute> routes;

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  Future loadRoutes() async {
    setState(() => isLoading = true);
    var response = await ELO.getStudyRoutes();
    setState(() {
      routes = [
        ...response.where((route) => route.isFavorite),
        ...response.where((route) => !route.isFavorite)
      ];
      isLoading = false;
    });
  }

  Future refreshRoutes() async {
    var response = await ELO.getStudyRoutes();
    setState(() {
      routes = [
        ...response.where((route) => route.isFavorite),
        ...response.where((route) => !route.isFavorite)
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ELO')),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.yellow,
              ),
            )
          : ImplicitlyAnimatedList<StudyRoute>(
              controller: scrollController,
              items: routes,
              areItemsTheSame: (a, b) => a.id == b.id,
              itemBuilder: (context, animation, item, index) {
                return SizeFadeTransition(
                    sizeFraction: 0.7,
                    curve: Curves.easeInOut,
                    animation: animation,
                    child: StudyRouteTile(item, () async {
                      await toggleFavourite(item);
                    }));
              },
            ),
    );
  }

  Future<void> toggleFavourite(StudyRoute item) async {
    await ELO.toggleFavourite(item.id);
    showSnackbar(item.isFavorite ? "${item.name} verwijderd van favorieten" : "${item.name} toegevoegd aan favorieten");
    await refreshRoutes();
    await scrollController.animateTo(0.0, duration: Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black,
        content: Text(
          message,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}
