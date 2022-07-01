import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
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
        future: element.needsAuth
            ? AuthManager.getSharepointCookie()
            : Future.value(""),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) {
            return LoadingIndicator();
          } else {
            return GestureDetector(
              onTap: () => showImageViewer(
                  context,
                  CachedNetworkImageProvider(element.url, headers: element.needsAuth ? {'Cookie': snapshot.data!} : null),
                  immersive: false,
                  useSafeArea: true),
              child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: element.url,
                      httpHeaders:
                          element.needsAuth ? {'Cookie': snapshot.data!} : null),
                ),
            );
          }
        },
    );
  }
}
