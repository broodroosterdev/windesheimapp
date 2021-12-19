import 'dart:convert';
import 'package:html/dom.dart';

class HtmlTransform {
  static List<HtmlElement> parseElements(String html) {
    var document = Document.html(html);
    var children = document.body!.firstChild!.children;
    List<HtmlElement> elements = [];

    for (var child in children) {
      var element = parseElement(child);
      if (element != null) {
        elements.add(element);
      }
    }
    return elements;
  }

  static HtmlElement parseAsText(String html) {
    return TextElement(html);
  }

  static HtmlElement? parseElement(Element child) {
    final Map<String, dynamic> data =
        jsonDecode(child.attributes['data-sp-controldata']!);
    switch (data['controlType'] as int) {
      case 3:
        var rawJson = child.firstChild!.attributes['data-sp-webpartdata']!;
        rawJson =
            rawJson.substring(0, rawJson.indexOf(",\"properties\"")) + "}";
        Map<String, dynamic> data = jsonDecode(rawJson);

        //Parse link embed
        if (data['dataVersion'] == '1.2') {
          rawJson = child.firstChild!.attributes['data-sp-webpartdata']!;
          rawJson = "{" +
              rawJson.substring(rawJson.indexOf("\"embedCode\""),
                  rawJson.indexOf(",\"cachedEmbedCode\":")) +
              "}";
          var embedData = jsonDecode(rawJson);
          if (!embedData.containsKey("embedCode")) {
            return null;
          }

          if(!embedData.containsKey("thumbnailUrl")){
            var iframe = Document.html(embedData["embedCode"]).querySelector('iframe')!;
            var url = iframe.attributes['src'];
            return LinkEmbedElement(url.toString(), null);
          }

          if(embedData["thumbnailUrl"].contains("bing") || embedData["thumbnailUrl"].contains("sharepoint")){
            return LinkEmbedElement(embedData['embedCode'], null);
          }

          return LinkEmbedElement(embedData['embedCode'], embedData['thumbnailUrl']);
        }

        //Parse file embed
        if (data['dataVersion'] == '1.4') {
          rawJson = child.firstChild!.attributes['data-sp-webpartdata']!;
          data = jsonDecode(rawJson);
          return FileEmbedElement(data['properties']['file'],
              data['serverProcessedContent']['searchablePlainTexts']['title']);
        }

        //Parse image embed
        if(data['dataVersion'] == '1.9') {
          rawJson = child.firstChild!.attributes['data-sp-webpartdata']!;
          data = jsonDecode(rawJson);
          String url = data['serverProcessedContent']['imageSources']['imageSource'];

          bool needsAuth = false;

          if(url.startsWith("/")){
            needsAuth = true;
            url = "https://liveadminwindesheim.sharepoint.com" + url;
          }

          return ImageEmbedElement(url, needsAuth);
        }
        //print("missing embed for data version: ${data['dataVersion']}");
        return null;

      case 4:
        return TextElement(child.children[0].innerHtml);

      case 0:
        return null;

      default:
        //print("missing for: ${data['controlType']}");
        return null;
    }
  }
}

abstract class HtmlElement {
  ElementType type;

  HtmlElement(this.type);
}

abstract class EmbedElement extends HtmlElement {
  String url;
  EmbedType embedType;

  EmbedElement(this.url, this.embedType) : super(ElementType.embed);
}

class LinkEmbedElement extends EmbedElement {
  String? thumbnailUrl;

  LinkEmbedElement(String url, this.thumbnailUrl) : super(url, EmbedType.link);
}

class FileEmbedElement extends EmbedElement {
  String filename;

  FileEmbedElement(String url, this.filename) : super(url, EmbedType.file);
}

class ImageEmbedElement extends EmbedElement {
  bool needsAuth;

  ImageEmbedElement(String url, this.needsAuth) : super(url, EmbedType.image);
}

enum EmbedType { link, file, image }

class TextElement extends HtmlElement {
  String html;

  TextElement(this.html) : super(ElementType.text);
}

enum ElementType { text, embed }
