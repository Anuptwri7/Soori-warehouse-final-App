// To parse this JSON data, do
//
//     final transferDetail = transferDetailFromJson(jsonString);

import 'dart:convert';

TransferDetail transferDetailFromJson(String str) => TransferDetail.fromJson(json.decode(str));

String transferDetailToJson(TransferDetail data) => json.encode(data.toJson());

class TransferDetail {
  TransferDetail({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int? count;
  dynamic next;
  dynamic previous;
  List<Result>? results;

  factory TransferDetail.fromJson(Map<String, dynamic> json) => TransferDetail(
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
    this.code,
    this.purchaseDetail,
    this.locationCode,
    this.batchNo,
    this.itemId,
    this.itemName,
  });

  int? id;
  String? code;
  int? purchaseDetail;
  String? locationCode;
  String? batchNo;
  int? itemId;
  String ?itemName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    code: json["code"],
    purchaseDetail: json["purchase_detail"],
    locationCode: json["location_code"],
    batchNo: json["batch_no"],
    itemId: json["item_id"],
    itemName: json["item_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "purchase_detail": purchaseDetail,
    "location_code": locationCode,
    "batch_no": batchNo,
    "item_id": itemId,
    "item_name": itemName,
  };
}
