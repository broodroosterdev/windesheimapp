import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wind/model/les.dart';

void main() {
  test("parse les", () {
    const jsonString =
        '{"id":"d6753626-8ec0-462d-869e-0067c6a243d9","lokaal":"C1.92;T2.19;T2.20","starttijd":1630938600000,"eindtijd":1630945800000,"changed":false,"docentcode":null,"roosterdatum":"2021-09-06T00:00:00Z","commentaar":"QSD Kick-off ,","leeractiviteit":"QSD Kick-off ,","publicatietekst":"","status":false,"roostercode":"Class-ICTQSDa","groepcode":"ICTQSDa, ICTQSDb, ICTQSDc, ICTQSDd","vaknaam":"MH.ICT.QSD.V21","vakcode":"MH.ICT.QSD.V21","docentnamen":["M.J. Schegget, ter","TSA Boose","E.R. Bolt","M Krop","ECR Roden, van","EJ Voorhoeve","M.D.J. Witsenburg"]}';
    final Les les = Les.fromJson(jsonDecode(jsonString));
    expect(les.id, "d6753626-8ec0-462d-869e-0067c6a243d9");
  });

  test("parse lessen list", () {

  });
}