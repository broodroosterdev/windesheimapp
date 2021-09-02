import 'package:flutter/material.dart';
import 'package:wind/model/les.dart';
import 'package:wind/pages/schedule/widgets/time_box.dart';

class LesTile extends StatelessWidget {
  final Les les;
  final Color color;

  const LesTile({
    Key? key,
    required this.les,
    required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      color: Theme.of(context).backgroundColor.withAlpha(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
            flex: 1,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TimeBox(
                time: "${les.starttijd.hour}:${les.starttijd.minute}",
                opacity: 100,
              ),
              TimeBox(
                time: "${les.eindtijd.hour}:${les.eindtijd.minute}",
                opacity: 50,
              ),
            ])),
        Container(
          decoration: BoxDecoration(
            color: color
          ),
          width: 8, height: 100,
          margin: EdgeInsets.only(right: 8),
        ),
        Expanded(
          flex: 4,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(les.leeractiviteit.replaceAll(" ,", ""),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Visibility(
                child: Icon(Icons.pin_drop, color: Colors.yellow[800]),
                visible: les.lokaal != "",
              ),
              Expanded(
                child: Text(les.lokaal,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Theme.of(context).textTheme.subtitle2),
              )
            ]),
            SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Icon(Icons.person, color: Colors.yellow[800]),
              Expanded(
                child: Text(les.docentcode ?? les.docentnamen.join(", "),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Theme.of(context).textTheme.subtitle2),
              )
            ])
          ]),
        ),
      ]),
    );
  }
}
