// To parse this JSON data, do
//
//     final saleReturnView = saleReturnViewFromJson(jsonString);

import 'dart:convert';

SaleReturnView saleReturnViewFromJson(String str) => SaleReturnView.fromJson(json.decode(str));

String saleReturnViewToJson(SaleReturnView data) => json.encode(data.toJson());

class SaleReturnView {
  SaleReturnView({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int? count;
  dynamic? next;
  dynamic ?previous;
  List<Result>? results;

  factory SaleReturnView.fromJson(Map<String, dynamic> json) => SaleReturnView(
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
    this.saleNo,
    this.itemName,
    this.unitName,
    this.unitShortForm,
    this.itemCategoryName,
    this.packingTypeName,
    this.createdDateAd,
    this.createdDateBs,
    this.deviceType,
    this.appType,
    this.dispatched,
    this.cost,
    this.qty,
    this.packQty,
    this.taxable,
    this.taxRate,
    this.taxAmount,
    this.discountable,
    this.discountRate,
    this.discountAmount,
    this.grossAmount,
    this.netAmount,
    this.createdBy,
    this.saleMaster,
    this.item,
    this.itemCategory,
    this.refPurchaseDetail,
    this.refSaleDetail,
    this.refOrderDetail,
    this.refChalanDetail,
  });

  int? id;
  String ?saleNo;
  String? itemName;
  String ?unitName;
  String ?unitShortForm;
  String ?itemCategoryName;
  dynamic ?packingTypeName;
  DateTime ?createdDateAd;
  DateTime ?createdDateBs;
  int ?deviceType;
  int ?appType;
  bool ?dispatched;
  String ?cost;
  String ?qty;
  String ?packQty;
  bool ?taxable;
  String? taxRate;
  String ?taxAmount;
  bool ?discountable;
  String? discountRate;
  String ?discountAmount;
  String ?grossAmount;
  String ?netAmount;
  int? createdBy;
  int ?saleMaster;
  int ?item;
  int ?itemCategory;
  int ?refPurchaseDetail;
  int ?refSaleDetail;
  int ?refOrderDetail;
  dynamic refChalanDetail;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    saleNo: json["sale_no"],
    itemName: json["item_name"],
    unitName: json["unit_name"],
    unitShortForm: json["unit_short_form"],
    itemCategoryName: json["item_category_name"],
    packingTypeName: json["packing_type_name"],
    createdDateAd: DateTime.parse(json["created_date_ad"]),
    createdDateBs: DateTime.parse(json["created_date_bs"]),
    deviceType: json["device_type"],
    appType: json["app_type"],
    dispatched: json["dispatched"],
    cost: json["cost"],
    qty: json["qty"],
    packQty: json["pack_qty"],
    taxable: json["taxable"],
    taxRate: json["tax_rate"],
    taxAmount: json["tax_amount"],
    discountable: json["discountable"],
    discountRate: json["discount_rate"],
    discountAmount: json["discount_amount"],
    grossAmount: json["gross_amount"],
    netAmount: json["net_amount"],
    createdBy: json["created_by"],
    saleMaster: json["sale_master"],
    item: json["item"],
    itemCategory: json["item_category"],
    refPurchaseDetail: json["ref_purchase_detail"],
    refSaleDetail: json["ref_sale_detail"],
    refOrderDetail: json["ref_order_detail"],
    refChalanDetail: json["ref_chalan_detail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sale_no": saleNo,
    "item_name": itemName,
    "unit_name": unitName,
    "unit_short_form": unitShortForm,
    "item_category_name": itemCategoryName,
    "packing_type_name": packingTypeName,
    "created_date_ad": createdDateAd!.toIso8601String(),
    "created_date_bs": "${createdDateBs!.year.toString().padLeft(4, '0')}-${createdDateBs!.month.toString().padLeft(2, '0')}-${createdDateBs!.day.toString().padLeft(2, '0')}",
    "device_type": deviceType,
    "app_type": appType,
    "dispatched": dispatched,
    "cost": cost,
    "qty": qty,
    "pack_qty": packQty,
    "taxable": taxable,
    "tax_rate": taxRate,
    "tax_amount": taxAmount,
    "discountable": discountable,
    "discount_rate": discountRate,
    "discount_amount": discountAmount,
    "gross_amount": grossAmount,
    "net_amount": netAmount,
    "created_by": createdBy,
    "sale_master": saleMaster,
    "item": item,
    "item_category": itemCategory,
    "ref_purchase_detail": refPurchaseDetail,
    "ref_sale_detail": refSaleDetail,
    "ref_order_detail": refOrderDetail,
    "ref_chalan_detail": refChalanDetail,
  };
}
