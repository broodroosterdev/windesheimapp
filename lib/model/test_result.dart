class TestResult {
  String description;

  bool passed;
  bool isFinal;
  DateTime? testDate;
  String? grade;
  String? result;

  TestResult(this.description, this.passed, this.isFinal, this.testDate,
      this.grade, this.result);

  TestResult.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        passed = json['passed'],
        isFinal = json['WH_final'],
        testDate =
            json['testdate'] != null ? DateTime.parse(json['testdate']) : null,
        grade = json['grade'] != "" ? json['grade'] : null,
        result = json['result'] != "" ? json['result'] : null;
}
