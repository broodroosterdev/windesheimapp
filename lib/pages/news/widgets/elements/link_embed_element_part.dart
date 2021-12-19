import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
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
                child: image(),
              ),
            ),
            const SizedBox(width: 10),
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

  Widget image(){
    if(element.thumbnailUrl != null){
      return CachedNetworkImage(
        imageUrl: element.thumbnailUrl!,
        height: 70,
        fit: BoxFit.cover,
      );
    } else {
      return FutureBuilder(
        future: LinkPreview.scrapeFromURL(element.url),
        builder: (BuildContext context, AsyncSnapshot<WebInfo> snapshot) {
          if(!snapshot.hasData){
            return const ColoredBox(color: Colors.black);
          } else {
            if(snapshot.data!.image != ""){
              return CachedNetworkImage(
                imageUrl: snapshot.data!.image,
                height: 70,
                fit: BoxFit.cover,
              );
            } else {
              return const Icon(Icons.link, size: 30);
            }
          }
        }
      );
    }
  }
}
