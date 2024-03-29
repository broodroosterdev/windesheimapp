import 'package:flutter/material.dart';
import 'package:wind/model/les.dart';
import 'package:wind/pages/schedule/widgets/link_preview.dart';
import 'package:wind/pages/schedule/widgets/teacher_tile.dart';
import 'package:wind/utils/time.dart';

class LessonDetailsPage extends StatefulWidget {
  final Les lesson;
  final Color color;

  const LessonDetailsPage({Key? key, required this.lesson, required this.color})
      : super(key: key);

  @override
  _LessonDetailsPageState createState() => _LessonDetailsPageState();
}

class _LessonDetailsPageState extends State<LessonDetailsPage> {
  List<String> getUrlsFromDescription() {
    RegExp urlRegex = RegExp(
        r"[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?");
    String text = widget.lesson.publicatietekst;
    Iterable<RegExpMatch> matches = urlRegex.allMatches(text);
    return matches
        .map((match) => text.substring(match.start, match.end))
        .where((url) {
      try {
        Uri.parse(url);
        return true;
      } catch (_) {
        return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.color,
        title: Text(widget.lesson.leeractiviteit.replaceAll(" ,", "")),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
          child:
              ListView(children: [
            Row(
              children: [
                Icon(Icons.access_time,
                    size: 36, color: Theme.of(context).primaryColor),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "${Time.getFormattedTime(widget.lesson.starttijd)}-${Time.getFormattedTime(widget.lesson.eindtijd)}",
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(Icons.pin_drop_outlined,
                    size: 36, color: Theme.of(context).primaryColor),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  widget.lesson.lokaal ?? "Geen",
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(fontStyle: widget.lesson.lokaal == null ? FontStyle.italic : FontStyle.normal),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Docent",
              style: Theme.of(context).textTheme.headline6,
            ),
            ...widget.lesson.docentnamen.map((docent) {
              return TeacherTile(docent);
            }),
            const SizedBox(
              height: 20,
            ),
            Text("Beschrijving",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.lesson.publicatietekst.isEmpty ? "Geen" : widget.lesson.publicatietekst,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(fontStyle: widget.lesson.lokaal == null ? FontStyle.italic : FontStyle.normal),
            ),
            const SizedBox(
              height: 20,
            ),
            ...getUrlsFromDescription().map((e) => LinkPreviewTile(url: e))
          ]),
        ),
      ),
    );
  }
}
