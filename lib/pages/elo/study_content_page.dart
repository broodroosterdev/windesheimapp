import 'package:flutter/material.dart';
import 'package:wind/model/studycontent.dart';
import 'package:wind/pages/elo/widgets/loading_indicator.dart';
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
              return LoadingIndicator();
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
                return emptyFolder(context);
              }
            }
          },
        ),
    );
  }

  Widget emptyFolder(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder, size: 60, color: Theme.of(context).colorScheme.primary),
          const Text("Lege map"),
        ],
      ),
    );
  }
}
