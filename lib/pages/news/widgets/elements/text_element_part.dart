import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wind/utils/html_transform.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:markdown/markdown.dart' as md;

import 'image_embed_element_part.dart';

class TextElementPart extends StatelessWidget {
  final TextElement element;
  late final String markdown;

  TextElementPart(this.element, {Key? key}) : super(key: key) {
    var html = element.html.replaceAll("&nbsp;", " ");
    markdown = html2md.convert(html);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MarkdownBody(
        extensionSet: md.ExtensionSet.none,
        data: markdown,
        onTapLink: (text, url, title) async {
          if(url == null) {
            return;
          }

          String usableUrl = url;
          if(!Uri.parse(url).isAbsolute){
            usableUrl = "https://liveadminwindesheim.sharepoint.com" + url;
          }

          if (await canLaunch(usableUrl)) {
            await launch(usableUrl);
          }
        },
        imageBuilder: (Uri uri, String? title, String? alt) {
          late String url;
          if(!uri.isAbsolute){
            url = "https://liveadminwindesheim.sharepoint.com" + uri.toString();
          } else {
            url = uri.toString();
          }

          return ImageEmbedElementPart(ImageEmbedElement(url, !uri.isAbsolute));
        },
      ),
    );
  }
}
