import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wind/model/studyroute.dart';

class StudyRouteTile extends StatelessWidget {
  final StudyRoute route;

  StudyRouteTile(this.route);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed('/studycontent', arguments: {'studyRouteId': route.id}),
      leading: route.imageUrl != null ? getThumbnailImage() : getLetterImage(),
      title: Text(route.name),
    );
  }

  Widget getLetterImage(){
    return CircleAvatar(
      backgroundColor: Colors.yellow.shade800,
      child: Text(route.name[0]),
    );
  }

  Widget getThumbnailImage(){
    return CachedNetworkImage(
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
