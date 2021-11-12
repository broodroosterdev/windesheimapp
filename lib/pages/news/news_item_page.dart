import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:wind/model/news_item.dart';
import 'package:wind/pages/news/widgets/elements/file_embed_element_part.dart';
import 'package:wind/pages/news/widgets/elements/image_embed_element_part.dart';
import 'package:wind/pages/news/widgets/elements/link_embed_element_part.dart';
import 'package:wind/pages/news/widgets/elements/text_element_part.dart';
import 'package:wind/services/auth/auth_manager.dart';
import 'package:html2md/html2md.dart' as html2md;
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
    _scrollController = ScrollController()
      ..addListener(() {
        //print("offset = ${_scrollController.offset}");
        double newOpacity = 1.0;
        if(_scrollController.offset < 150){
          newOpacity = _scrollController.offset / 150;
        }

        if(titleOpacity != newOpacity){
          setState(() {
            titleOpacity = newOpacity;
          });
        }
        //print("titleOpacity is now ${titleOpacity}");
      });
    if (widget.newsItem.type == NewsType.announcement) {
      elements.add(HtmlTransform.parseAsText(widget.newsItem.content));
    } else {
      elements = HtmlTransform.parseElements(widget.newsItem.content);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(title: Text(widget.newsItem.title)),
        body: buildArticleView(context));
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
          title: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 50),
            child: Opacity(
              opacity: titleOpacity,
              child: Text(
                  widget.newsItem.title,
                  style: Theme.of(context).textTheme.subtitle1,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
              ),
          ),
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                Positioned.fill(
                  child: buildImage(context),
                ),
                Positioned(
                  bottom: 16,
                  left: 18,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 16),
                    child: Text(
                      widget.newsItem.title,
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Bron: ${widget.newsItem.source}\n"
                  "Laatst bijgewerkt: ${Time.getFormattedDate(widget.newsItem.lastModify)} om ${Time.getFormattedTime(widget.newsItem.lastModify)}",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            ...elements.map((element) => buildElement(context, element)),
            const SizedBox(height: 10),

            const SizedBox(height: 10),
          ]),
        )
        //...elements.map((element) => buildElement(context, element)),
      ],
    );
  }

  Widget buildImage(BuildContext context) {
    return widget.newsItem.imageUrl != null
        ? FutureBuilder(
            future: AuthManager.getSharepointCookie(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow,
                  ),
                );
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
              color: Theme.of(context).backgroundColor,
            ),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.announcement_rounded, size: 54),
                    Text("Mededeling",
                        style: Theme.of(context).textTheme.subtitle1)
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
