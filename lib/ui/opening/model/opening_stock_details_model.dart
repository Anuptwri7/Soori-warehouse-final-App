// To parse this JSON data, do
//
//     final openStockDetailsModel = openStockDetailsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OpenStockDetailsModel openStockDetailsModelFromJson(String str) => OpenStockDetailsModel.fromJson(json.decode(str));

String openStockDetailsModelToJson(OpenStockDetailsModel data) => json.encode(data.toJson());

class OpenStockDetailsModel {
  OpenStockDetailsModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory OpenStockDetailsModel.fromJson(Map<String, dynamic> json) => OpenStockDetailsModel(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    required this.id,
    required this.puPackTypeCodes,
    required this.itemName,
    required this.packingType,
  });

  int id;
  List<PuPackTypeCode> puPackTypeCodes;
  String itemName;
  String packingType;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    puPackTypeCodes: List<PuPackTypeCode>.from(json["pu_pack_type_codes"].map((x) => PuPackTypeCode.fromJson(x))),
    itemName: json["item_name"],
    packingType: json["packing_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "pu_pack_type_codes": List<dynamic>.from(puPackTypeCodes.map((x) => x.toJson())),
    "item_name": itemName,
    "packing_type": packingType,
  };
}

class PuPackTypeCode {
  PuPackTypeCode({
    required this.id,
    required this.location,
    required this.createdDateAd,
    required this.createdDateBs,
    required this.deviceType,
    required this.appType,
    required this.code,
    required this.createdBy,
    required this.purchaseOrderDetail,
    required this.refPackingTypeCode,
  });

  int id;
  dynamic location;
  DateTime createdDateAd;
  DateTime createdDateBs;
  int deviceType;
  int appType;
  String code;
  int createdBy;
  dynamic purchaseOrderDetail;
  dynamic refPackingTypeCode;

  factory PuPackTypeCode.fromJson(Map<String, dynamic> json) => PuPackTypeCode(
    id: json["id"],
    location: json["location"],
    createdDateAd: DateTime.parse(json["created_date_ad"]),
    createdDateBs: DateTime.parse(json["created_date_bs"]),
    deviceType: json["device_type"],
    appType: json["app_type"],
    code: json["code"],
    createdBy: json["created_by"],
    purchaseOrderDetail: json["purchase_order_detail"],
    refPackingTypeCode: json["ref_packing_type_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
    "created_date_ad": createdDateAd.toIso8601String(),
    "created_date_bs": "${createdDateBs.year.toString().padLeft(4, '0')}-${createdDateBs.month.toString().padLeft(2, '0')}-${createdDateBs.day.toString().padLeft(2, '0')}",
    "device_type": deviceType,
    "app_type": appType,
    "code": code,
    "created_by": createdBy,
    "purchase_order_detail": purchaseOrderDetail,
    "ref_packing_type_code": refPackingTypeCode,
  };
}

