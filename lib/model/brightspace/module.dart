class Module {
  Description? description;
  String? parentModuleId;
  DateTime? moduleDueDate;
  List<Structure>? structure;
  DateTime? moduleStartDate;
  DateTime? moduleEndDate;
  bool? isHidden;
  bool? isLocked;
  String? id;
  String? title;
  String? shortTitle;
  String? type;
  String? lastModifiedDate;

  Module(
      {this.description,
        this.parentModuleId,
        this.moduleDueDate,
        this.structure,
        this.moduleStartDate,
        this.moduleEndDate,
        this.isHidden,
        this.isLocked,
        this.id,
        this.title,
        this.shortTitle,
        this.type,
        this.lastModifiedDate});

  Module.fromJson(Map<String, dynamic> json) {
    description = json['Description'] != null
        ? Description.fromJson(json['Description'])
        : null;
    parentModuleId = json['ParentModuleId'];
    moduleDueDate = json['ModuleDueDate'];
    if (json['Structure'] != null) {
      structure = <Structure>[];
      json['Structure'].forEach((v) {
        structure!.add(Structure.fromJson(v));
      });
    }
    moduleStartDate = json['ModuleStartDate'];
    moduleEndDate = json['ModuleEndDate'];
    isHidden = json['IsHidden'];
    isLocked = json['IsLocked'];
    id = json['Id'];
    title = json['Title'];
    shortTitle = json['ShortTitle'];
    type = json['Type'];
    lastModifiedDate = json['LastModifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (description != null) {
      data['Description'] = description!.toJson();
    }
    data['ParentModuleId'] = parentModuleId;
    data['ModuleDueDate'] = moduleDueDate;
    if (structure != null) {
      data['Structure'] = structure!.map((v) => v.toJson()).toList();
    }
    data['ModuleStartDate'] = moduleStartDate;
    data['ModuleEndDate'] = moduleEndDate;
    data['IsHidden'] = isHidden;
    data['IsLocked'] = isLocked;
    data['Id'] = id;
    data['Title'] = title;
    data['ShortTitle'] = shortTitle;
    data['Type'] = type;
    data['LastModifiedDate'] = lastModifiedDate;
    return data;
  }
}

class Description {
  String? text;
  String? html;

  Description({this.text, this.html});

  Description.fromJson(Map<String, dynamic> json) {
    text = json['Text'];
    html = json['Html'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Text'] = text;
    data['Html'] = html;
    return data;
  }
}

class Structure {
  int? id;
  String? title;
  String? shortTitle;
  int? type;
  String? lastModifiedDate;

  Structure(
      {this.id, this.title, this.shortTitle, this.type, this.lastModifiedDate});

  Structure.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    shortTitle = json['ShortTitle'];
    type = json['Type'];
    lastModifiedDate = json['LastModifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Id'] = id;
    data['Title'] = title;
    data['ShortTitle'] = shortTitle;
    data['Type'] = type;
    data['LastModifiedDate'] = lastModifiedDate;
    return data;
  }
}