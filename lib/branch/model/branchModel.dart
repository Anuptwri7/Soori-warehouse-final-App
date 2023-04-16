// To parse this JSON data, do
//
//     final branch = branchFromJson(jsonString);

import 'dart:convert';

Branch branchFromJson(String str) => Branch.fromJson(json.decode(str));

String branchToJson(Branch data) => json.encode(data.toJson());

class Branch {
  Branch({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int? count;
  dynamic next;
  dynamic previous;
  List<Result> ?results;

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.id,
    this.name,
    this.schemaName,
    this.subDomain,
    this.active,
  });

  int? id;
  String ?name;
  String ?schemaName;
  String ?subDomain;
  bool ?active;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    schemaName: json["schema_name"],
    subDomain: json["sub_domain"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "schema_name": schemaName,
    "sub_domain": subDomain,
    "active": active,
  };
}
