class StudyContent {
  int id;
  String name;
  ItemType type;
  String? url;
  String? path;

  StudyContent(
    this.id,
    this.name,
    this.type,
    this.url,
      this.path,
  );

  StudyContent.fromJson(Map<String, dynamic> json)
      : id = json["ID"],
        name = json["NAME"],
        type = getType(json["ITEMTYPE"]),
        url = json["URL"],
        path = json["PATH"];
}

enum ItemType { Folder, File, Link, Page, Assignment }

ItemType getType(int data) {
  switch (data) {
    case 0:
      return ItemType.Folder;
    case 1:
      return ItemType.Page;
    case 3:
      return ItemType.Link;
    case 9:
      return ItemType.Assignment;
    case 10:
      return ItemType.File;
    default:
      return ItemType.Folder;
  }
}
