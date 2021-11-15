import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wind/model/news_item.dart';
import 'package:wind/services/auth/auth_manager.dart';
import 'package:wind/utils/time.dart';

import 'news_tile_template.dart';

class NewsTile extends StatelessWidget {
  final NewsItem item;

  const NewsTile(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewsTileTemplate(
      image: item.imageUrl != null ? thumbnail(context) : announcement(context),
      title: Text(
        item.title,
        style:
        Theme.of(context).textTheme.headline6!.copyWith(fontSize: 16),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        Time.getFormattedDate(item.lastModify),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget announcement(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.announcement_rounded, size: 48),
              Text("Mededeling")
            ]),
      ),
    );
  }

  Widget thumbnail(BuildContext context) {
    return FutureBuilder(
      future: AuthManager.getSharepointCookie(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return const ColoredBox(color: Colors.black);
        } else {
          return CachedNetworkImage(
              memCacheHeight: 100,
              fit: BoxFit.cover,
              imageUrl: item.imageUrl!,
              httpHeaders: {'Cookie': snapshot.data!});
        }
      },
    );
  }
}
