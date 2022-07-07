import 'package:flutter/material.dart';
import 'package:wind/model/les.dart';
import 'package:wind/pages/schedule/widgets/teacher_name.dart';
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                        Text(Time.getFormattedTime(les.starttijd),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5!
                        ),
                      Text(Time.getFormattedTime(les.eindtijd),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).textTheme.headline6?.color?.withOpacity(0.5))
                      ),
                    ]),
              )),
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
              Padding(
                padding: const EdgeInsets.only(left: 3, top: 8),
                child: Text(les.leeractiviteit.replaceAll(" ,", ""),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1),
              ),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(Icons.pin_drop, color: Theme.of(context).colorScheme.primary, size: 28),
                Expanded(
                  child: Text(les.lokaal ?? "Leeg",
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(fontStyle: les.lokaal == null ? FontStyle.italic : FontStyle.normal)),
                )
              ]),
              buildTeacherRow(context)
            ]),
          ),
        ]);
  }

  Widget buildTeacherRow(BuildContext context){
    if(les.docentcode != null){
      return TeacherName(les.docentcode!);
    }

    if(les.docentnamen.length == 1){
      return TeacherName(les.docentnamen[0]);
    }

    return Row(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: TeacherName(les.docentnamen[0]),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
              child: Text("+ ${les.docentnamen.length - 1}"),
          ),
        ],
      );
    }
}
