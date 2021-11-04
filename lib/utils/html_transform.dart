import 'dart:convert';
import 'package:html/dom.dart';

class HtmlTransform {
  static List<HtmlElement> parseElements(String html){
    var document = Document.html(html);
    var children = document.body!.firstChild!.children;
    List<HtmlElement> elements = [];

    for(var child in children){
      var element = parseElement(child);
      if(element != null){
        elements.add(element);
      }
    }
    return elements;
  }

  static HtmlElement parseAsText(String html){
    return TextElement(html);
  }

  static HtmlElement? parseElement(Element child){
    final Map<String, dynamic> data = jsonDecode(child.attributes['data-sp-controldata']!);
    switch(data['controlType'] as int){
      case 3:
        var rawJson = child.firstChild!.attributes['data-sp-webpartdata']!;
        rawJson = rawJson.substring(0, rawJson.indexOf(",\"properties\"")) + "}";
        Map<String, dynamic> data = jsonDecode(rawJson);
        if(data['dataVersion'] == '1.2'){
          rawJson = child.firstChild!.attributes['data-sp-webpartdata']!;
          rawJson = rawJson.substring(rawJson.indexOf("{\"embedCode\""), rawJson.indexOf(",\"cachedEmbedCode\":")) + "}";
          data = jsonDecode(rawJson);
          if(!data.containsKey("embedCode")) {
            return null;
          }
          return LinkEmbedElement(data['embedCode'], data['thumbnailUrl']);
        }

        if(data['dataVersion'] == '1.4'){
          rawJson = child.firstChild!.attributes['data-sp-webpartdata']!;
          data = jsonDecode(rawJson);
          return FileEmbedElement(data['properties']['file'], data['serverProcessedContent']['searchablePlainTexts']['title']);
        }

        return null;

      case 4:
        return TextElement(child.children[0].innerHtml);
      default:
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
  String thumbnailUrl;

  LinkEmbedElement(String url, this.thumbnailUrl) : super(url, EmbedType.link);
}

class FileEmbedElement extends EmbedElement {
  String filename;

  FileEmbedElement(String url, this.filename) : super(url, EmbedType.file);
}



enum EmbedType {
  link,
  file
}



class TextElement extends HtmlElement {
  String html;

  TextElement(this.html) : super(ElementType.text);
}

enum ElementType {
  text,
  embed
}