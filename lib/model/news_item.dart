class NewsItem {
  String id;
  NewsType type;
  String title;
  String content;
  String source;
  DateTime lastModify;

  String? lead;
  String? url;
  String? imageUrl;

  NewsItem(
      this.id,
      this.type,
      this.title,
      this.content,
      this.source,
      this.lastModify,
      this.lead,
      this.url,
      this.imageUrl,
      );

  NewsItem.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      type = parseNewsType(json['WH_messagetype']),
      title = json['title'],
      content = json['content'],
      source = json['WH_source'],
      lastModify = DateTime.parse('2021-10-28T14:42:42Z'),
      lead = json['WH_lead'] != "" ? json['WH_lead'] : null,
      url = json['url'] != "" ? json['url'] : null,
      imageUrl = json['image'] != "" ? json['image'] : null;
}

enum NewsType {
  announcement,
  newsMessage
}

NewsType parseNewsType(String type){
  switch(type){
    case "Nieuwsbericht":
      return NewsType.newsMessage;
    default:
      return NewsType.announcement;
  }
}
