

import 'dart:convert';

LocationShiftingGetModel locationShiftingGetModelFromJson(String str) => LocationShiftingGetModel.fromJson(json.decode(str));

String locationShiftingGetModelToJson(LocationShiftingGetModel data) => json.encode(data.toJson());

class LocationShiftingGetModel {
  LocationShiftingGetModel({
    this.id,
    this.code,
    this.location,
    this.locationCode,
  });

  int? id;
  String? code;
  int ?location;
  String? locationCode;

  factory LocationShiftingGetModel.fromJson(Map<String, dynamic> json) => LocationShiftingGetModel(
    id: json["id"],
    code: json["code"],
    location: json["location"],
    locationCode: json["location_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "location": location,
    "location_code": locationCode,
  };
}
