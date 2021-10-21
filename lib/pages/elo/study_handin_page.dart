import 'package:flutter/material.dart';
import 'package:wind/model/handin_details.dart';
import 'package:wind/pages/elo/widgets/document_view.dart';
import 'package:wind/pages/elo/widgets/handin_tile.dart';
import 'package:wind/services/api/elo.dart';

class StudyHandinPage extends StatefulWidget {
  final int resourceId;
  final String name;
  const StudyHandinPage(this.resourceId, this.name, {Key? key})
      : super(key: key);

  @override
  _StudyHandinPageState createState() => _StudyHandinPageState();
}

class _StudyHandinPageState extends State<StudyHandinPage> {
  late Future<HandinDetails> details;

  @override
  void initState() {
    super.initState();
    details = ELO.getHandinDetails(widget.resourceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.name)),
        body: FutureBuilder(
            future: details,
            builder:
                (BuildContext context, AsyncSnapshot<HandinDetails> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow,
                  ),
                );
              } else {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DocumentView(snapshot.data!.descriptionUrl),
                      HandinTile(snapshot.data!),
                    ]);
              }
            }));
  }
}
