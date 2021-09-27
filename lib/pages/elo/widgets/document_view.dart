import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../providers.dart';

class DocumentView extends StatefulWidget {
  final String url;
  DocumentView(this.url, {Key? key}) : super(key: key);

  @override
  _DocumentViewState createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPage(),
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
    );
  }

  Future<String> getPage() async{
    final response = await Dio().get('https://elo.windesheim.nl' + widget.url,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
            headers: {"Cookie": "N%40TCookie=${prefs.eloCookie}"}));
    return response.data;
  }
}