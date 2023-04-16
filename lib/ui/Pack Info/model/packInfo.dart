// To parse this JSON data, do
//
//     final packInfo = packInfoFromJson(jsonString);

import 'dart:convert';


class PackInfoGet {
  PackInfoGet({
    this.id,
    this.code,
    this.locationCode,
    this.itemName,
    this.packTypeDetailCodes,
    this.batchNo,
    this.supplierName
  });

  int? id;
  String? code;
  String ?locationCode;
  String? itemName;
  List<PackTypeDetailCode>? packTypeDetailCodes;
  String? batchNo;
  String? supplierName;

  factory PackInfoGet.fromJson(Map<String, dynamic> json) => PackInfoGet(
    id: json["id"],
    code: json["code"],
    locationCode: json["location_code"],
    itemName: json["item_name"],
    packTypeDetailCodes: List<PackTypeDetailCode>.from(json["pack_type_detail_codes"].map((x) => PackTypeDetailCode.fromJson(x))),
    batchNo: json["batch_no"],
    supplierName: json["supplier_name"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "location_code": locationCode,
    "item_name": itemName,
    "pack_type_detail_codes": List<dynamic>.from(packTypeDetailCodes!.map((x) => x.toJson())),
    "batch_no": batchNo,
    "supplier_name": supplierName
  };
}

class PackTypeDetailCode {
  PackTypeDetailCode({
    this.id,
    this.code,
  });

  int? id;
  String? code;

  factory PackTypeDetailCode.fromJson(Map<String, dynamic> json) => PackTypeDetailCode(
    id: json["id"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
  };
}
