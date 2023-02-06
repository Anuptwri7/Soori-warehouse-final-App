// To parse this JSON data, do
//
//     final pickUpSerialNoModel = pickUpSerialNoModelFromJson(jsonString);

import 'dart:convert';

PickUpSerialNoModel pickUpSerialNoModelFromJson(String str) =>
    PickUpSerialNoModel.fromJson(json.decode(str));

String pickUpSerialNoModelToJson(PickUpSerialNoModel data) =>
    json.encode(data.toJson());

class PickUpSerialNoModel {
  PickUpSerialNoModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int? count;
  String? next;
  String? previous;
  List<Result>? results;

  factory PickUpSerialNoModel.fromJson(Map<String, dynamic> json) =>
      PickUpSerialNoModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
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
    this.code,
  });

  int? id;
  String? code;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
      };
}
