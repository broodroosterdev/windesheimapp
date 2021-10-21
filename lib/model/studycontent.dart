class StudyContent {
  int id;
  String name;
  ItemType type;
  String? url;
  String? path;
  int? resourceId;

  StudyContent(
      this.id, this.name, this.type, this.url, this.path, this.resourceId);

  StudyContent.fromJson(Map<String, dynamic> json)
      : id = json["ID"],
        name = json["NAME"],
        type = getType(json["ITEMTYPE"]),
        url = json["URL"],
        path = json["PATH"],
        resourceId = json["STUDYROUTE_RESOURCE_ID"] == -1
            ? null
            : json["STUDYROUTE_RESOURCE_ID"];
}

enum ItemType { folder, file, link, page, handin }

ItemType getType(int data) {
  switch (data) {
    case 0:
      return ItemType.folder;
    case 1:
      return ItemType.page;
    case 3:
      return ItemType.link;
    case 9:
      return ItemType.handin;
    case 10:
      return ItemType.file;
    default:
      return ItemType.folder;
  }
}
