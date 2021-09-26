import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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
        body: FutureBuilder(
          future: getDocument(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow,
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Html(
                  data: snapshot.data
                )
              );
            }
          },

        )
    );
  }

  Future<String> getDocument() async{
    final response = await Dio().get(widget.url,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
            headers: {"Cookie": "N%40TCookie=${prefs.eloCookie}"}));
    return response.data;
  }
}