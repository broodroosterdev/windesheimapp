class CourseResult {
  String name;
  String code;
  int ec;

  bool passed;
  DateTime? testDate;
  String? grade;
  String? result;

  CourseResult(
      this.name, this.code, this.ec, this.passed, this.testDate, this.grade);

  CourseResult.fromJson(Map<String, dynamic> json)
      : name = json['course']['name'],
        code = json['course']['abbr'],
        ec = json['course']['ects'],
        passed = json['passed'],
        testDate = json['WH_testdate'] != null
            ? DateTime.parse(json['WH_testdate'])
            : null,
        grade = json['grade'] != "" ? json['grade'] : null,
        result = json['result'] != "" ? json['result'] : null;
}
