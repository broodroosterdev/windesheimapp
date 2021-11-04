import 'package:flutter/material.dart';

class NewsTileTemplate extends StatelessWidget {

  final Widget image;
  final Widget title;
  final Widget subtitle;

  const NewsTileTemplate({Key? key, required this.image, required this.title, required this.subtitle}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Container(
                height: 100,
                decoration: const BoxDecoration(
                    borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(5))),
                clipBehavior: Clip.antiAlias,
                child: image
          ),
          ),
          titleBox(context),
        ],
      ),
    );
  }

  Widget titleBox(BuildContext context) {
    return Expanded(
      flex: 16,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 12.0, bottom: 12.0, top: 12.0, right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            const SizedBox(height: 5),
            subtitle
          ],
        ),
      ),
    );
  }
}
