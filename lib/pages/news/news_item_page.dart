import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as html;
import 'package:skeletons/skeletons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wind/model/news_item.dart';
import 'package:wind/services/api/news.dart';
import 'package:wind/services/auth/auth_manager.dart';

class NewsItemPage extends StatefulWidget {
  final NewsItem newsItem;

  NewsItemPage(this.newsItem, {Key? key}) : super(key: key);

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
    var document = html.Document.html(widget.newsItem.content);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          children: [
        widget.newsItem.imageUrl != null ? FutureBuilder(
            future: AuthManager.getSharepointCookie(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                    heightFactor: 0.4,
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
          ) : Container(),
        Html.fromDom(
          document: document,
          onLinkTap: (String? url, RenderContext context,
              Map<String, String> attributes, _) async {
            if (url != null && await canLaunch(url)) {
              await launch(url);
            }
          },
        ),
      ]),
    );
  }
}
