import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wind/pages/elo/widgets/document_view.dart';

import '../../providers.dart';

class StudyDocumentPage extends StatefulWidget {
  final String url;
  final String name;
  StudyDocumentPage(this.url, this.name, {Key? key}) : super(key: key);

  @override
  _StudyDocumentPageState createState() => _StudyDocumentPageState();
}

class _StudyDocumentPageState extends State<StudyDocumentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.name)),
        body: DocumentView(widget.url)
    );
  }


}