import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import 'news_tile_template.dart';

class SkeletonNewsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NewsTileTemplate(
      image: const SkeletonAvatar(
        style: SkeletonAvatarStyle(
            padding: EdgeInsets.zero,
            randomHeight: false,
            randomWidth: false,
            width: 100,
            height: 140,
            borderRadius: BorderRadius.only()),
      ),
      title: SkeletonParagraph(
        style: const SkeletonParagraphStyle(
            padding: EdgeInsets.zero,
            lines: 3,
            spacing: 3,
            lineStyle: SkeletonLineStyle(height: 16, randomLength: true)),
      ),
      subtitle: const SkeletonLine(
        style: SkeletonLineStyle(
          padding: EdgeInsets.only(top: 2),
          randomLength: false,
          width: 80,
          height: 15,
        ),
      ),
    );
  }
}
