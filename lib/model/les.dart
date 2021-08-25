class Les {
  //UUID v4: "d6753626-8ec0-462d-869e-0067c6a243d9"
  String id;

  //Lokaal nummer, ; separated: "C1.92;T2.19;T2.20"
  String lokaal;

  //Timestamp in milliseconds (GMT is correcte tijd)
  DateTime starttijd;
  DateTime eindtijd;

  //Whether the lesson has changed
  bool changed;

  // Docentcode, vaak null
  String? docentcode;

  // Date with timezone offset: "2021-09-06T00:00:00Z"
  DateTime roosterdatum;

  // Description
  String commentaar;

  // Name of lesson: "Theoretische Informatica College ,"
  String leeractiviteit;

  // Geen idee
  String publicatietekst;

  // Geen idee
  bool status;

  // Roostercode: "Class-ICTQSDa"
  String roostercode;

  // Groepcode: "ICTQSDa, ICTQSDb, ICTQSDc, ICTQSDd"
  String groepcode;

  // Vaknaam: "MH.ICT.QSD.V21"
  String vaknaam;

  // Vakcode: "MH.ICT.QSD.V21"
  String vakcode;

  // Lijst met namen van docenten: [ "M.J. Schegget, ter", "TSA Boose", "E.R. Bolt", "M Krop", "ECR Roden, van", "EJ Voorhoeve", "M.D.J. Witsenburg" ]
  List<String> docentnamen;

  Les(this.id, this.lokaal, this.starttijd, this.eindtijd, this.changed,
      this.docentcode, this.roosterdatum, this.commentaar,
      this.leeractiviteit, this.publicatietekst, this.status,
      this.roostercode, this.groepcode, this.vaknaam,
      this.vakcode, this.docentnamen);

  Les.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        lokaal = json["lokaal"],
        //starttijd = DateTime.fromMillisecondsSinceEpoch(json["starttijd"]).add(DateTime.parse(json["roosterdatum"]).timeZoneOffset),
        starttijd = DateTime.fromMillisecondsSinceEpoch(json["starttijd"], isUtc: true),
        eindtijd = DateTime.fromMillisecondsSinceEpoch(json["eindtijd"], isUtc: true),
        changed = json["changed"],
        docentcode = json["docentcode"],
        roosterdatum = DateTime.parse(json["roosterdatum"]),
        commentaar = json["commentaar"],
        leeractiviteit = json["leeractiviteit"],
        publicatietekst = json["publicatietekst"],
        status = json["status"],
        roostercode = json["roostercode"],
        groepcode = json["groepcode"],
        vaknaam = json["vaknaam"],
        vakcode = json["vakcode"],
        docentnamen = List.from(json["docentnamen"]);
}