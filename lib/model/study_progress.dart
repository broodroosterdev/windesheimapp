class StudyProgress {
  String name;
  EC propedeuse;
  EC study;

  StudyProgress(this.name, this.propedeuse, this.study);

  StudyProgress.fromJson(Map<String, dynamic> json)
  : name = json['WH_study']['description'],
    propedeuse = EC(json['WH_studyProgress']['ectsBehaaldPropedeuse'], json['WH_studyProgress']['ectsTeBehalenPropedeuse']),
    study = EC(json['WH_studyProgress']['ectsBehaald'], json['WH_studyProgress']['ectsTeBehalen']);
}

class EC {
  int achieved;
  int toAchieve;

  EC(this.achieved, this.toAchieve);
}