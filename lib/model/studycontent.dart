class StudyContent {
  int id;
  String name;
  ItemType type;
  String? url;
  String? path;
  int? resourceId;

  StudyContent(
    this.id,
    this.name,
    this.type,
    this.url,
    this.path,
    this.resourceId
  );

  StudyContent.fromJson(Map<String, dynamic> json)
      : id = json["ID"],
        name = json["NAME"],
        type = getType(json["ITEMTYPE"]),
        url = json["URL"],
        path = json["PATH"],
        resourceId = json["STUDYROUTE_RESOURCE_ID"] == -1 ? null : json["STUDYROUTE_RESOURCE_ID"];
}

enum ItemType { Folder, File, Link, Page, Handin }

ItemType getType(int data) {
  switch (data) {
    case 0:
      return ItemType.Folder;
    case 1:
      return ItemType.Page;
    case 3:
      return ItemType.Link;
    case 9:
      return ItemType.Handin;
    case 10:
      return ItemType.File;
    default:
      return ItemType.Folder;
  }
}
