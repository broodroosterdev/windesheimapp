import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wind/utils/html_transform.dart';

class LinkEmbedElementPart extends StatelessWidget {
  final LinkEmbedElement element;

  const LinkEmbedElementPart(this.element, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          if (await canLaunch(element.url)) {
            await launch(element.url);
          }
        },
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                    borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(5))),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: element.thumbnailUrl,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Link openen",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    element.url,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Theme.of(context).textTheme.caption!.color),
                  ),
                ],
              ),
            ),
            const Expanded(flex: 1, child: Icon(Icons.open_in_new))
          ],
        ),
      ),
    );
  }
}
