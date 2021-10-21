import 'package:flutter/material.dart';
import 'package:wind/model/studycontent.dart';
import 'package:wind/pages/elo/widgets/study_content_tile.dart';
import 'package:wind/services/api/elo.dart';

class StudyContentPage extends StatefulWidget {
  final int studyRouteId;
  final int? parentId;
  const StudyContentPage(
      {Key? key, required this.studyRouteId, required this.parentId})
      : super(key: key);

  @override
  _StudyContentPageState createState() => _StudyContentPageState();
}

class _StudyContentPageState extends State<StudyContentPage> {
  late Future<List<StudyContent>> studyContentFuture;

  @override
  void initState() {
    super.initState();
    studyContentFuture =
        ELO.getStudyContent(widget.studyRouteId, widget.parentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('ELO')),
        body: FutureBuilder(
          future: studyContentFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<StudyContent>> snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow,
                ),
              );
            } else {
              final List<StudyContent> content = snapshot.data!;
              if (content.isNotEmpty) {
                return ListView.builder(
                  itemCount: content.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = content[index];
                    return StudyContentTile(
                        studyContent: item, studyRouteId: widget.studyRouteId);
                  },
                );
              } else {
                return emptyFolder();
              }
            }
          },
        ));
  }

  Widget emptyFolder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.folder, size: 60),
          Text("Lege map"),
        ],
      ),
    );
  }
}
