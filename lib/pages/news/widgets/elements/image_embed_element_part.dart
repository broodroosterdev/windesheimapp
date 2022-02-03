import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wind/pages/elo/widgets/loading_indicator.dart';
import 'package:wind/services/auth/auth_manager.dart';
import 'package:wind/utils/html_transform.dart';

class ImageEmbedElementPart extends StatelessWidget {
  final ImageEmbedElement element;

  const ImageEmbedElementPart(this.element, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: element.needsAuth ? AuthManager.getSharepointCookie() : Future.value(""),
      builder:
          (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicator();
        } else {
          return SizedBox(
            width: double.infinity,
              child: CachedNetworkImage(
                      height: 300,
                      fit: BoxFit.contain,
                      imageUrl: element.url,
                      httpHeaders: element.needsAuth ? {'Cookie': snapshot.data!} : null
              ),
          );
        }
      },
    );
  }
}
