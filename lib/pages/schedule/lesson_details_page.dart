import 'package:flutter/material.dart';
import 'package:wind/model/les.dart';
import 'package:wind/pages/schedule/widgets/time_box.dart';

class LessonDetailsPage extends StatefulWidget {
  Les lesson;
  Color color;

  LessonDetailsPage({Key? key, required this.lesson, required this.color})
      : super(key: key);

  @override
  _LessonDetailsPageState createState() => _LessonDetailsPageState();
}

class _LessonDetailsPageState extends State<LessonDetailsPage> {
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
          padding: EdgeInsets.only(left: 20, top: 10, right: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(
              widget.lesson.leeractiviteit.replaceAll(" ,", ""),
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 10,
            ),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 36,
                        color: Theme.of(context).primaryColor),
                    SizedBox(width: 5,),
                    Text("${widget.lesson.starttijd.hour}:${widget.lesson.starttijd.minute}-${widget.lesson.eindtijd.hour}:${widget.lesson.eindtijd.minute}",
                      style: Theme.of(context).textTheme.subtitle1,)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
            Row(
              children: [
                Icon(Icons.pin_drop_outlined,
                    size: 36,
                    color: Theme.of(context).primaryColor),
                SizedBox(width: 5,),
                Text(widget.lesson.lokaal,
                style: Theme.of(context).textTheme.subtitle1,)
              ],
            ),
                SizedBox(
                  height: 10,
                ),
                ...widget.lesson.docentnamen.map((docent) {
                  return Row(
                    children: [
                      Icon(Icons.person_outline,
                          size: 36,
                          color: Theme.of(context).primaryColor),
                      Text(docent,
                        style: Theme.of(context).textTheme.subtitle1,)
                    ],
                  );
                }),
                SizedBox(height: 20,),
                Text("Deze les is ook online te volgen via de volgende link: https://teams.microsoft.com/meeting?id=552dadad-31277aa-4663dd-43463346",
                style: Theme.of(context).textTheme.bodyText2,),
                SizedBox(height: 20,),
                Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        'https://teams.microsoft.com/favicon.ico',
                    )),
                    title: Text('Teams joinen'),
                    subtitle: Text('Volg deze link om teams te joinen'),
                    trailing: Icon(Icons.open_in_new),
                  )
                )

          ]),
        ),
      ),
    );
  }
}
