// To parse this JSON data, do
//
//     final chalanReturnDropScan = chalanReturnDropScanFromJson(jsonString);

import 'dart:convert';

ChalanReturnDropScan chalanReturnDropScanFromJson(String str) => ChalanReturnDropScan.fromJson(json.decode(str));

String chalanReturnDropScanToJson(ChalanReturnDropScan data) => json.encode(data.toJson());

class ChalanReturnDropScan {
  ChalanReturnDropScan({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int? count;
  dynamic? next;
  dynamic ?previous;
  List<Result> ?results;

  factory ChalanReturnDropScan.fromJson(Map<String, dynamic> json) => ChalanReturnDropScan(
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
    this.chalanPackingTypes,
    this.itemName,
    this.itemCategoryName,
    this.codeName,
    this.unitName,
    this.unitShortForm,
    this.batchNo,
    this.deviceType,
    this.appType,
    this.qty,
    this.saleCost,
    this.discountable,
    this.taxable,
    this.taxRate,
    this.taxAmount,
    this.discountRate,
    this.discountAmount,
    this.grossAmount,
    this.netAmount,
    this.remarks,
    this.chalanMaster,
    this.item,
    this.itemCategory,
    this.refPurchaseDetail,
    this.refOrderDetail,
  });

  int? id;
  List<ChalanPackingType>? chalanPackingTypes;
  String? itemName;
  String ?itemCategoryName;
  String ?codeName;
  String ?unitName;
  String ?unitShortForm;
  String ?batchNo;
  int? deviceType;
  int ?appType;
  String? qty;
  String ?saleCost;
  bool ?discountable;
  bool ?taxable;
  String? taxRate;
  String ?taxAmount;
  String ?discountRate;
  String ?discountAmount;
  String ?grossAmount;
  String ?netAmount;
  String ?remarks;
  int ?chalanMaster;
  int ?item;
  int ?itemCategory;
  int ?refPurchaseDetail;
  int ?refOrderDetail;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    chalanPackingTypes: List<ChalanPackingType>.from(json["chalan_packing_types"].map((x) => ChalanPackingType.fromJson(x))),
    itemName: json["item_name"],
    itemCategoryName: json["item_category_name"],
    codeName: json["code_name"],
    unitName: json["unit_name"],
    unitShortForm: json["unit_short_form"],
    batchNo: json["batch_no"],
    deviceType: json["device_type"],
    appType: json["app_type"],
    qty: json["qty"],
    saleCost: json["sale_cost"],
    discountable: json["discountable"],
    taxable: json["taxable"],
    taxRate: json["tax_rate"],
    taxAmount: json["tax_amount"],
    discountRate: json["discount_rate"],
    discountAmount: json["discount_amount"],
    grossAmount: json["gross_amount"],
    netAmount: json["net_amount"],
    remarks: json["remarks"],
    chalanMaster: json["chalan_master"],
    item: json["item"],
    itemCategory: json["item_category"],
    refPurchaseDetail: json["ref_purchase_detail"],
    refOrderDetail: json["ref_order_detail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "chalan_packing_types": List<dynamic>.from(chalanPackingTypes!.map((x) => x.toJson())),
    "item_name": itemName,
    "item_category_name": itemCategoryName,
    "code_name": codeName,
    "unit_name": unitName,
    "unit_short_form": unitShortForm,
    "batch_no": batchNo,
    "device_type": deviceType,
    "app_type": appType,
    "qty": qty,
    "sale_cost": saleCost,
    "discountable": discountable,
    "taxable": taxable,
    "tax_rate": taxRate,
    "tax_amount": taxAmount,
    "discount_rate": discountRate,
    "discount_amount": discountAmount,
    "gross_amount": grossAmount,
    "net_amount": netAmount,
    "remarks": remarks,
    "chalan_master": chalanMaster,
    "item": item,
    "item_category": itemCategory,
    "ref_purchase_detail": refPurchaseDetail,
    "ref_order_detail": refOrderDetail,
  };
}

class ChalanPackingType {
  ChalanPackingType({
    this.id,
    this.packingTypeCode,
    this.code,
    this.salePackingTypeDetailCode,
    this.customerOrderDetail,
    this.locationCode,
  });

  int? id;
  int ?packingTypeCode;
  String? code;
  List<SalePackingTypeDetailCode> ?salePackingTypeDetailCode;
  int? customerOrderDetail;
  String? locationCode;

  factory ChalanPackingType.fromJson(Map<String, dynamic> json) => ChalanPackingType(
    id: json["id"],
    packingTypeCode: json["packing_type_code"],
    code: json["code"],
    salePackingTypeDetailCode: List<SalePackingTypeDetailCode>.from(json["sale_packing_type_detail_code"].map((x) => SalePackingTypeDetailCode.fromJson(x))),
    customerOrderDetail: json["customer_order_detail"],
    locationCode: json["location_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "packing_type_code": packingTypeCode,
    "code": code,
    "sale_packing_type_detail_code": List<dynamic>.from(salePackingTypeDetailCode!.map((x) => x.toJson())),
    "customer_order_detail": customerOrderDetail,
    "location_code": locationCode,
  };
}

class SalePackingTypeDetailCode {
  SalePackingTypeDetailCode({
    this.id,
    this.packingTypeDetailCode,
    this.code,
  });

  int ?id;
  int ?packingTypeDetailCode;
  String? code;

  factory SalePackingTypeDetailCode.fromJson(Map<String, dynamic> json) => SalePackingTypeDetailCode(
    id: json["id"],
    packingTypeDetailCode: json["packing_type_detail_code"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "packing_type_detail_code": packingTypeDetailCode,
    "code": code,
  };
}
