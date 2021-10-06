class CourseResult {
  String name;
  String code;
  int ec;

  bool passed;
  DateTime? testDate;
  String? grade;
  String? result;

  CourseResult(this.name, this.code, this.ec, this.passed, this.testDate, this.grade);
}