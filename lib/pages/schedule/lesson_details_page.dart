import 'package:flutter/material.dart';
import 'package:wind/model/les.dart';
import 'package:wind/pages/schedule/widgets/link_preview.dart';
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
      ),
      backgroundColor: const Color.fromRGBO(17, 18, 19, 1.0),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(
              widget.lesson.leeractiviteit.replaceAll(" ,", ""),
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(
              height: 10,
            ),
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
                  widget.lesson.lokaal,
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ...widget.lesson.docentnamen.map((docent) {
              return Row(
                children: [
                  Icon(Icons.person_outline,
                      size: 36, color: Theme.of(context).primaryColor),
                  Text(
                    docent,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              );
            }),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.lesson.publicatietekst,
              style: Theme.of(context).textTheme.bodyText2,
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
