class HandinDetails {
  int id;
  String title;
  String descriptionUrl;
  DateTime? submitDate;
  String? submitFilename;
  String? submitUrl;
  int? plagiarism;

  HandinDetails(this.id, this.title, this.descriptionUrl, this.submitDate,
      this.submitFilename, this.submitUrl, this.plagiarism);

  HandinDetails.fromJson(Map<String, dynamic> json)
      : id = json["ID"],
        title = json["TITLE"],
        descriptionUrl = json["DESCRIPTION_DOCUMENT_URL"],
        submitDate =
            json["HANDIN_DATE"] != null ? parseDate(json["HANDIN_DATE"]) : null,
        submitFilename = json["HANDIN_NAME"],
        submitUrl = json["HANDIN_URL"],
        plagiarism = json["PLAGIARISM"];

  static DateTime parseDate(String date) {
    int timestamp = int.parse(date.substring(6, date.length - 2));
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  get hasSubmission => submitDate != null;
}
