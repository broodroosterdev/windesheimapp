import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wind/utils/html_transform.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:markdown/markdown.dart' as md;

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
          if (url != null && await canLaunch(url)) {
            await launch(url);
          }
        },
      ),
    );
  }
}
