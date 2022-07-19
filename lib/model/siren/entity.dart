/// Derived from https://github.com/kevinswiber/siren/blob/master/siren.schema.json
/// Using https://app.quicktype.io/?l=dart (Modified by hand)
import 'dart:convert';

Entity entityFromMap(String str) => Entity.fromMap(json.decode(str));

String entityToMap(Entity data) => json.encode(data.toMap());

/// An Entity is a URI-addressable resource that has properties and actions associated with
/// it. It may contain sub-entities and navigational links.
class Entity {
  Entity({
    required this.actions,
    required this.entityClass,
    required this.entities,
    required this.links,
    required this.properties,
    required this.title,
  });

  final List<Action>? actions;
  final List<String>? entityClass;
  final List<SubEntity>? entities;
  final List<Link>? links;
  final Map<String, dynamic>? properties;
  final String? title;

  SubEntity? getSubEntityWithClass(String className) {
    int index = entities?.indexWhere(
            (e) => e.subEntityClass?.contains(className) ?? false) ??
        -1;
    if (index == -1) {
      return null;
    }
    return entities![index];
  }

  factory Entity.fromMap(Map<String, dynamic> json) => Entity(
        actions: json["actions"] == null
            ? null
            : List<Action>.from(json["actions"].map((x) => Action.fromMap(x))),
        entityClass: json["class"] == null
            ? null
            : List<String>.from(json["class"].map((x) => x)),
        entities: json["entities"] == null
            ? null
            : List<SubEntity>.from(
                json["entities"].map((x) => SubEntity.fromMap(x))),
        links: json["links"] == null
            ? null
            : List<Link>.from(json["links"].map((x) => Link.fromMap(x))),
        properties: json["properties"] == null
            ? null
            : Map.from(json["properties"])
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "actions": actions == null
            ? null
            : List<dynamic>.from(actions!.map((x) => x.toMap())),
        "class": entityClass == null
            ? null
            : List<dynamic>.from(entityClass!.map((x) => x)),
        "entities": entities == null
            ? null
            : List<dynamic>.from(entities!.map((x) => x.toMap())),
        "links": links == null
            ? null
            : List<dynamic>.from(links!.map((x) => x.toMap())),
        "properties": properties == null
            ? null
            : Map.from(properties!)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "title": title,
      };
}

/// Actions show available behaviors an entity exposes.
class Action {
  Action({
    required this.actionClass,
    required this.fields,
    required this.href,
    required this.method,
    required this.name,
    required this.title,
    required this.type,
  });

  final List<String>? actionClass;
  final List<Field>? fields;
  final String? href;
  final Method? method;
  final String name;
  final String? title;
  final String? type;

  factory Action.fromMap(Map<String, dynamic> json) => Action(
        actionClass: json["class"] == null
            ? null
            : List<String>.from(json["class"].map((x) => x)),
        fields: json["fields"] == null
            ? null
            : List<Field>.from(json["fields"].map((x) => Field.fromMap(x))),
        href: json["href"],
        method:
            json["method"] == null ? null : methodValues.map[json["method"]],
        name: json["name"],
        title: json["title"],
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "class": actionClass == null
            ? null
            : List<dynamic>.from(actionClass!.map((x) => x)),
        "fields": fields == null
            ? null
            : List<dynamic>.from(fields!.map((x) => x.toMap())),
        "href": href,
        "method": method == null ? null : methodValues.reverse[method],
        "name": name,
        "title": title,
        "type": type,
      };
}

/// Fields represent controls inside of actions.
class Field {
  Field({
    required this.name,
    required this.title,
    required this.type,
    required this.value,
  });

  final String name;
  final String? title;
  final Type? type;
  final dynamic value;

  factory Field.fromMap(Map<String, dynamic> json) => Field(
        name: json["name"],
        title: json["title"],
        type: json["type"] == null ? null : typeValues.map[json["type"]],
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "title": title,
        "type": type == null ? null : typeValues.reverse[type],
        "value": value,
      };
}

/// The input type of the field. This is a subset of the input types specified by HTML5.
enum Type {
  hidden,
  text,
  search,
  tel,
  url,
  email,
  password,
  datetime,
  date,
  month,
  week,
  time,
  datetimeLocal,
  number,
  range,
  color,
  checkbox,
  radio,
  file
}

final typeValues = EnumValues({
  "checkbox": Type.checkbox,
  "color": Type.color,
  "date": Type.date,
  "datetime": Type.datetime,
  "datetime-local": Type.datetimeLocal,
  "email": Type.email,
  "file": Type.file,
  "hidden": Type.hidden,
  "month": Type.month,
  "number": Type.number,
  "password": Type.password,
  "radio": Type.radio,
  "range": Type.range,
  "search": Type.search,
  "tel": Type.tel,
  "text": Type.text,
  "time": Type.time,
  "url": Type.url,
  "week": Type.week
});

/// Value objects represent multiple selectable field values. Use in conjunction with field
/// `"type" = "radio"` and `"type" = "checkbox"` to express that zero, one or many out of
/// several possible values may be sent back to the server.
class FieldValueObject {
  FieldValueObject({
    required this.selected,
    required this.title,
    required this.value,
  });

  final bool selected;
  final String title;
  final dynamic value;

  factory FieldValueObject.fromMap(Map<String, dynamic> json) =>
      FieldValueObject(
        selected: json["selected"],
        title: json["title"],
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "selected": selected,
        "title": title,
        "value": value,
      };
}

/// An enumerated attribute mapping to a protocol method. For HTTP, these values may be GET,
/// PUT, POST, DELETE, or PATCH. As new methods are introduced, this list can be extended. If
/// this attribute is omitted, GET should be assumed.
enum Method { DELETE, GET, PATCH, POST, PUT }

final methodValues = EnumValues({
  "DELETE": Method.DELETE,
  "GET": Method.GET,
  "PATCH": Method.PATCH,
  "POST": Method.POST,
  "PUT": Method.PUT
});

/// An Entity is a URI-addressable resource that has properties and actions associated with
/// it. It may contain sub-entities and navigational links.
class SubEntity {
  SubEntity({
    required this.subEntityClass,
    required this.href,
    required this.rel,
    required this.title,
    required this.type,
    required this.actions,
    required this.entities,
    required this.links,
    required this.properties,
  });

  final List<String>? subEntityClass;
  final String? href;
  final List<String> rel;
  final String? title;
  final String? type;
  final List<Action>? actions;
  final List<SubEntity>? entities;
  final List<Link>? links;
  final Map<String, dynamic>? properties;

  factory SubEntity.fromMap(Map<String, dynamic> json) => SubEntity(
        subEntityClass: json["class"] == null
            ? null
            : List<String>.from(json["class"].map((x) => x)),
        href: json["href"],
        rel: List<String>.from(json["rel"].map((x) => x)),
        title: json["title"],
        type: json["type"],
        actions: json["actions"] == null
            ? null
            : List<Action>.from(json["actions"].map((x) => Action.fromMap(x))),
        entities: json["entities"] == null
            ? null
            : List<SubEntity>.from(
                json["entities"].map((x) => SubEntity.fromMap(x))),
        links: json["links"] == null
            ? null
            : List<Link>.from(json["links"].map((x) => Link.fromMap(x))),
        properties: json["properties"] == null
            ? null
            : Map.from(json["properties"])
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
      );

  Map<String, dynamic> toMap() => {
        "class": subEntityClass == null
            ? null
            : List<dynamic>.from(subEntityClass!.map((x) => x)),
        "href": href,
        "rel": List<dynamic>.from(rel.map((x) => x)),
        "title": title,
        "type": type,
        "actions": actions == null
            ? null
            : List<dynamic>.from(actions!.map((x) => x.toMap())),
        "entities": entities == null
            ? null
            : List<dynamic>.from(entities!.map((x) => x.toMap())),
        "links": links == null
            ? null
            : List<dynamic>.from(links!.map((x) => x.toMap())),
        "properties": properties == null
            ? null
            : Map.from(properties!)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

/// Links represent navigational transitions.
class Link {
  Link({
    required this.linkClass,
    required this.href,
    required this.rel,
    required this.title,
    required this.type,
  });

  final List<String>? linkClass;
  final String href;
  final List<String> rel;
  final String? title;
  final String? type;

  factory Link.fromMap(Map<String, dynamic> json) => Link(
        linkClass: json["class"] == null
            ? null
            : List<String>.from(json["class"].map((x) => x)),
        href: json["href"],
        rel: List<String>.from(json["rel"].map((x) => x)),
        title: json["title"],
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "class": linkClass == null
            ? null
            : List<dynamic>.from(linkClass!.map((x) => x)),
        "href": href,
        "rel": List<dynamic>.from(rel.map((x) => x)),
        "title": title,
        "type": type,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverse;

  EnumValues(this.map) {
    reverse = map.map((k, v) => MapEntry(v, k));
  }
}
