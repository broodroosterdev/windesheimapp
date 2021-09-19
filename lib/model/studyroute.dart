class StudyRoute {
  int id;
  String name;
  String? imageUrl;
  bool isFavorite;


  StudyRoute(
      this.id,
      this.name,
      this.imageUrl,
      this.isFavorite
      );

  StudyRoute.fromJson(Map<String, dynamic> json)
      : id = json["ID"],
        name = json["NAME"],
        imageUrl = json["IMAGEURL_24"],
        isFavorite = json["IS_FAVORITE"];

}