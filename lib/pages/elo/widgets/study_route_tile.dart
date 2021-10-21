import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wind/model/studyroute.dart';

class StudyRouteTile extends StatelessWidget {
  final StudyRoute route;
  final Function() onFavourite;

  const StudyRouteTile(this.route, this.onFavourite, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context)
          .pushNamed('/studycontent', arguments: {'studyRouteId': route.id}),
      leading: route.imageUrl != null ? getThumbnailImage() : getLetterImage(),
      trailing: getFavouriteIcon(),
      title: Text(route.name),
    );
  }

  Widget getFavouriteIcon() {
    return IconButton(
      onPressed: onFavourite,
      icon: route.isFavorite
          ? const Icon(Icons.star)
          : const Icon(Icons.star_border_outlined),
    );
  }

  Widget getLetterImage() {
    return CircleAvatar(
      backgroundColor: Colors.yellow.shade800,
      child: Text(route.name[0]),
    );
  }

  Widget getThumbnailImage() {
    return CachedNetworkImage(
      key: Key(route.imageUrl!),
      width: 40,
      height: 40,
      imageUrl: "https://elo.windesheim.nl/" + route.imageUrl!,
      imageBuilder: (BuildContext context, ImageProvider<Object>? provider) {
        return CircleAvatar(
          backgroundImage: provider,
        );
      },
      errorWidget: (BuildContext context, url, error) {
        return getLetterImage();
      },
    );
  }
}
