import 'package:flutter/material.dart';
import 'package:wind/pages/elo/widgets/document_view.dart';

class StudyDocumentPage extends StatefulWidget {
  final String url;
  final String name;
  const StudyDocumentPage(this.url, this.name, {Key? key}) : super(key: key);

  @override
  _StudyDocumentPageState createState() => _StudyDocumentPageState();
}

class _StudyDocumentPageState extends State<StudyDocumentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.name)),
        body: DocumentView(widget.url));
  }
}
