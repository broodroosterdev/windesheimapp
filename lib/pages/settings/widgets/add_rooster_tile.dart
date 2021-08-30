import 'package:flutter/material.dart';

class AddRoosterTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/add-schedule');
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(children: [
          const Icon(Icons.add),
          const SizedBox(width: 10),
          Text(
            "Add new rooster",
            style: Theme.of(context).textTheme.subtitle1,
          )
        ]),
      ),
    );
  }
}
