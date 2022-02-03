import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:wind/model/news_item.dart';
import 'package:wind/pages/news/widgets/elements/file_embed_element_part.dart';
import 'package:wind/pages/news/widgets/elements/image_embed_element_part.dart';
import 'package:wind/pages/news/widgets/elements/link_embed_element_part.dart';
import 'package:wind/pages/news/widgets/elements/text_element_part.dart';
import 'package:wind/services/auth/auth_manager.dart';
import 'package:wind/utils/html_transform.dart';
import 'package:wind/utils/time.dart';

class NewsItemPage extends StatefulWidget {
  final NewsItem newsItem;

  const NewsItemPage(this.newsItem, {Key? key}) : super(key: key);

  @override
  _NewsItemPageState createState() => _NewsItemPageState();
}

class _NewsItemPageState extends State<NewsItemPage> {
  late ScrollController _scrollController;
  List<HtmlElement> elements = [];
  double titleOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    if (widget.newsItem.type == NewsType.announcement) {
      elements.add(HtmlTransform.parseAsText(widget.newsItem.content));
    } else {
      elements = HtmlTransform.parseElements(widget.newsItem.content);
    }
  }

  double getTitleOpacityFromOffset() {
    if (!_scrollController.position.hasContentDimensions ||
        _scrollController.position.maxScrollExtent < 150) {
      return 0.0;
    }

    if (_scrollController.offset < 150) {
      return _scrollController.offset / 150;
    }

    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildArticleView(context));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildArticleView(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          title: buildTitle(),
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: buildFlexibleSpace(),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Bron: ${widget.newsItem.source}\n"
                "Laatst bijgewerkt: ${Time.getFormattedDate(widget.newsItem.lastModify)} om ${Time.getFormattedTime(widget.newsItem.lastModify)}",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            ...elements.map((element) => buildElement(context, element)),
            const SizedBox(height: 20),
          ]),
        ),
      ],
    );
  }

  Widget buildTitle() {
    double maxWidth = MediaQuery.of(context).size.width - 50;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: getTitleOpacityFromOffset(),
            child: Text(
              widget.newsItem.title,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
          );
        },
      ),
    );
  }

  Widget buildFlexibleSpace() {
    var textStyle = Theme.of(context).textTheme.headline6!.copyWith(
        color: widget.newsItem.type == NewsType.announcement
        ? Theme.of(context).textTheme.headline6!.color
        : Colors.white
    );

    return FlexibleSpaceBar(
      background: Stack(
        children: [
          Positioned.fill(
            child: buildImage(context),
          ),
          Positioned(
            bottom: 16,
            left: 9,
            right: 9,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 16),
              child: Text(
                widget.newsItem.title,
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    return widget.newsItem.imageUrl != null
        ? FutureBuilder(
            future: AuthManager.getSharepointCookie(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) {
                return const ColoredBox(color: Colors.black);
              } else {
                return CachedNetworkImage(
                    memCacheWidth: MediaQuery.of(context).size.width.toInt(),
                    color: Colors.black.withOpacity(0.5),
                    colorBlendMode: BlendMode.dstATop,
                    fit: BoxFit.fitWidth,
                    imageUrl: widget.newsItem.imageUrl!.replaceAll(
                        "https://liveadminwindesheim.sharepoint.com/_layouts/15/getpreview.ashx?path=",
                        "https://liveadminwindesheim.sharepoint.com/"),
                    httpHeaders: {'Cookie': snapshot.data!});
              }
            },
          )
        : DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.announcement_rounded, size: 54),
                  ]),
            ),
          );
  }

  Widget buildElement(BuildContext context, HtmlElement element) {
    switch (element.type) {
      case ElementType.text:
        TextElement textElement = element as TextElement;
        return TextElementPart(textElement);

      case ElementType.embed:
        EmbedElement embedElement = element as EmbedElement;
        switch (embedElement.embedType) {
          case EmbedType.link:
            return LinkEmbedElementPart(embedElement as LinkEmbedElement);
          case EmbedType.file:
            return FileEmbedElementPart(embedElement as FileEmbedElement);
          case EmbedType.image:
            return ImageEmbedElementPart(embedElement as ImageEmbedElement);
        }
    }
  }
}
