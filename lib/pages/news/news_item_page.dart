import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:wind/model/news_item.dart';
import 'package:wind/pages/news/widgets/elements/file_embed_element_part.dart';
import 'package:wind/pages/news/widgets/elements/link_embed_element_part.dart';
import 'package:wind/pages/news/widgets/elements/text_element_part.dart';
import 'package:wind/services/auth/auth_manager.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:wind/utils/html_transform.dart';

class NewsItemPage extends StatefulWidget {
  final NewsItem newsItem;

  const NewsItemPage(this.newsItem, {Key? key}) : super(key: key);

  @override
  _NewsItemPageState createState() => _NewsItemPageState();
}

class _NewsItemPageState extends State<NewsItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.newsItem.title)),
        body: buildArticleView(context));
  }

  Widget buildArticleView(BuildContext context) {
    List<HtmlElement> elements = [];
    if (widget.newsItem.type == NewsType.announcement) {
      elements.add(HtmlTransform.parseAsText(widget.newsItem.content));
    } else {
      elements = HtmlTransform.parseElements(widget.newsItem.content);
    }

    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        widget.newsItem.imageUrl != null
            ? FutureBuilder(
                future: AuthManager.getSharepointCookie(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.yellow,
                      ),
                    );
                  } else {
                    return ClipRect(
                        child: Align(
                      alignment: Alignment.center,
                      heightFactor: 0.3,
                      child: SizedBox(
                        height: 400,
                        child: CachedNetworkImage(
                            fit: BoxFit.fitWidth,
                            imageUrl: widget.newsItem.imageUrl!.replaceAll(
                                "https://liveadminwindesheim.sharepoint.com/_layouts/15/getpreview.ashx?path=",
                                "https://liveadminwindesheim.sharepoint.com/"),
                            httpHeaders: {'Cookie': snapshot.data!}),
                      ),
                    ));
                  }
                },
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.newsItem.title,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.start,
          ),
        ),
        ...elements.map((element) => buildElement(context, element))
      ]),
    );
  }

  Widget buildElement(BuildContext context, HtmlElement element) {
    switch (element.type) {
      case ElementType.text:
        TextElement textElement = element as TextElement;
        return TextElementPart(textElement);

      case ElementType.embed:
        EmbedElement embedElement = element as EmbedElement;
        switch(embedElement.embedType){

          case EmbedType.link:
            return LinkEmbedElementPart(embedElement as LinkEmbedElement);
          case EmbedType.file:
            return FileEmbedElementPart(embedElement as FileEmbedElement);
        }
    }
  }
}
