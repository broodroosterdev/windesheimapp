import 'package:flutter/material.dart';
import 'package:wind/model/studyroute.dart';
import 'package:wind/pages/widgets/app_drawer.dart';
import 'package:wind/services/api/elo.dart';

import '../../providers.dart';


class StudyRoutesPage extends StatefulWidget {
  StudyRoutesPage({Key? key}) : super(key: key);

  @override
  _StudyRoutesPageState createState() => _StudyRoutesPageState();
}

class _StudyRoutesPageState extends State<StudyRoutesPage> {
  late Future<List<StudyRoute>> studyRouteFuture;

  @override
  void initState() {
    super.initState();
    studyRouteFuture = ELO.getStudyRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('ELO')),
        drawer: AppDrawer(),
        backgroundColor: const Color.fromRGBO(17, 18, 19, 1.0),
        body: FutureBuilder(
          future: studyRouteFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<StudyRoute>> snapshot) {
            if (!snapshot.hasData || snapshot.data == null)
              return Text("Loading");
            else {
              final List<StudyRoute> routes = snapshot.data!;
              return ListView.builder(
                itemCount: routes.length,
                itemBuilder: (BuildContext context, int index) {
                  final route = routes[index];
                  return ListTile(
                    onTap: () => Navigator.of(context).pushNamed('/studycontent', arguments: {'studyRouteId': route.id}),
                    leading: route.imageUrl != null ? CircleAvatar(backgroundImage: NetworkImage("https://elo.windesheim.nl/" + route.imageUrl!))
                        :  Icon(Icons.book),
                    title: Text(route.name),
                  );
                },
              );
            }
          },
        )
    );
  }
}