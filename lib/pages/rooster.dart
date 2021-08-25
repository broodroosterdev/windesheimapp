import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:windesheimapp/model/les.dart';
import 'package:windesheimapp/providers.dart';
import 'package:windesheimapp/services/auth/auth_manager.dart';

class RoosterPage extends StatefulWidget {
  @override
  _RoosterPageState createState() => new _RoosterPageState();
}

class _RoosterPageState extends State<RoosterPage> {
  DateTime? lastDate;

  Future<List<Les>> _getLessen() async {
    const String url =
        "https://windesheimapi.azurewebsites.net/api/v2/Klas/ICTQSDa/Les";
    Response<dynamic> response = await Dio().get(url,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
            headers: {"Authorization": "Bearer " + prefs.accessToken}));
    print(response.statusCode);

    if (response.statusCode != 200) {
      await AuthManager.refreshApi();
      response = await Dio().get(url,
          options: Options(
              followRedirects: false,
              headers: {"Authorization": "Bearer " + prefs.accessToken}));
    }

    final rawLessen = (response.data as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    final List<Les> lessen = rawLessen.map((raw) => Les.fromJson(raw)).toList();
    return lessen;
  }

  List<Widget> buildRooster(BuildContext context, List<Les> lessen) {
    List<Widget> widgets = [];
    DateTime? lastDate;
    for (Les les in lessen) {
      if (lastDate == null || lastDate.day != les.roosterdatum.day) {
        lastDate = les.roosterdatum;
        widgets.add(
          Padding(
            padding: EdgeInsets.only(left: 15, top: 20, bottom: 10),
            child: Text(
              getWeekday(lastDate.weekday),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          )
        );
      }
      widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 8, left: 15, right: 15),
              child: ListTile(
        tileColor: Theme.of(context).backgroundColor.withAlpha(10),
        leading: Text(
            "${les.starttijd.hour}:${les.starttijd.minute} - ${les.eindtijd.hour}:${les.eindtijd.minute}"),
        title: Text(les.leeractiviteit),
        subtitle: Text(les.lokaal),
        isThreeLine: false,
      )));
    }
    return widgets;
  }

  String getWeekday(int weekday) {
    const dagen = [
      "Maandag",
      "Dinsdag",
      "Woensdag",
      "Donderdag",
      "Vrijdag",
      "Zaterdag",
      "Zondag"
    ];
    return dagen[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(17, 18, 19, 1.0),
        body: FutureBuilder<List<Les>>(
          future: _getLessen(),
          builder: (BuildContext context, AsyncSnapshot<List<Les>> lessen) {
            if (lessen.hasData && lessen.data != null) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 30),
                    child: Text(
                      "Lessen",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  ...buildRooster(context, lessen.data!),
                ]),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30, top: 40),
                    child: Text("Lessen",
                        style: Theme.of(context).textTheme.headline2),
                  )
                ],
              );
            }
          },
        ));
  }
}
