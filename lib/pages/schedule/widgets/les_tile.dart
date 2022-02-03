import 'package:flutter/material.dart';
import 'package:wind/model/les.dart';
import 'package:wind/pages/schedule/widgets/time_box.dart';
import 'package:wind/utils/time.dart';

class LesTile extends StatelessWidget {
  final Les les;
  final Color color;

  const LesTile({
    Key? key,
    required this.les,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TimeBox(
                      time: Time.getFormattedTime(les.starttijd),
                      opacity: 40,
                    ),
                    TimeBox(
                      time: Time.getFormattedTime(les.eindtijd),
                      opacity: 20,
                    ),
                  ])),
          Container(
            decoration: BoxDecoration(color: color),
            width: 6,
            height: 100,
            margin: const EdgeInsets.only(right: 8),
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
                Icon(Icons.pin_drop, color: Theme.of(context).colorScheme.primary),
                Expanded(
                  child: Text(les.lokaal,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: Theme.of(context).textTheme.subtitle2),
                )
              ]),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                Expanded(
                  child: Text(les.docentcode ?? les.docentnamen.join(", "),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: Theme.of(context).textTheme.subtitle2),
                )
              ])
            ]),
          ),
        ]);
  }
}
