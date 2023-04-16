// To parse this JSON data, do
//
//     final openingStockListModel = openingStockListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OpeningStockListModel openingStockListModelFromJson(String str) => OpeningStockListModel.fromJson(json.decode(str));

String openingStockListModelToJson(OpeningStockListModel data) => json.encode(data.toJson());

class OpeningStockListModel {
  OpeningStockListModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory OpeningStockListModel.fromJson(Map<String, dynamic> json) => OpeningStockListModel(
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
    required this.payTypeDisplay,
    required this.purchaseTypeDisplay,
    required this.supplierName,
    required this.discountSchemeName,
    required this.createdByUserName,
    required this.createdByFirstName,
    required this.createdDateAd,
    required this.createdDateBs,
    required this.deviceType,
    required this.appType,
    required this.purchaseNo,
    required this.purchaseType,
    required this.payType,
    required this.subTotal,
    required this.totalDiscount,
    required this.discountRate,
    required this.totalDiscountableAmount,
    required this.totalTaxableAmount,
    required this.totalNonTaxableAmount,
    required this.totalTax,
    required this.grandTotal,
    required this.roundOffAmount,
    required this.billNo,
    required this.billDateAd,
    required this.billDateBs,
    required this.chalanNo,
    required this.dueDateAd,
    required this.dueDateBs,
    required this.remarks,
    required this.createdBy,
    required this.discountScheme,
    required this.supplier,
    required this.countryCurrency,
    required this.fiscalSessionAd,
    required this.fiscalSessionBs,
    required this.refPurchase,
    required this.refPurchaseOrder,
  });

  int id;
  String payTypeDisplay;
  String purchaseTypeDisplay;
  dynamic supplierName;
  dynamic discountSchemeName;
  String createdByUserName;
  String createdByFirstName;
  DateTime createdDateAd;
  DateTime createdDateBs;
  int deviceType;
  int appType;
  String purchaseNo;
  int purchaseType;
  int payType;
  String subTotal;
  String totalDiscount;
  String discountRate;
  String totalDiscountableAmount;
  String totalTaxableAmount;
  String totalNonTaxableAmount;
  String totalTax;
  String grandTotal;
  String roundOffAmount;
  String billNo;
  dynamic billDateAd;
  String billDateBs;
  String chalanNo;
  dynamic dueDateAd;
  String dueDateBs;
  String remarks;
  int createdBy;
  dynamic discountScheme;
  dynamic supplier;
  dynamic countryCurrency;
  int fiscalSessionAd;
  int fiscalSessionBs;
  dynamic refPurchase;
  dynamic refPurchaseOrder;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    payTypeDisplay: json["pay_type_display"],
    purchaseTypeDisplay: json["purchase_type_display"],
    supplierName: json["supplier_name"],
    discountSchemeName: json["discount_scheme_name"],
    createdByUserName: json["created_by_user_name"],
    createdByFirstName: json["created_by_first_name"],
    createdDateAd: DateTime.parse(json["created_date_ad"]),
    createdDateBs: DateTime.parse(json["created_date_bs"]),
    deviceType: json["device_type"],
    appType: json["app_type"],
    purchaseNo: json["purchase_no"],
    purchaseType: json["purchase_type"],
    payType: json["pay_type"],
    subTotal: json["sub_total"],
    totalDiscount: json["total_discount"],
    discountRate: json["discount_rate"],
    totalDiscountableAmount: json["total_discountable_amount"],
    totalTaxableAmount: json["total_taxable_amount"],
    totalNonTaxableAmount: json["total_non_taxable_amount"],
    totalTax: json["total_tax"],
    grandTotal: json["grand_total"],
    roundOffAmount: json["round_off_amount"],
    billNo: json["bill_no"],
    billDateAd: json["bill_date_ad"],
    billDateBs: json["bill_date_bs"],
    chalanNo: json["chalan_no"],
    dueDateAd: json["due_date_ad"],
    dueDateBs: json["due_date_bs"],
    remarks: json["remarks"],
    createdBy: json["created_by"],
    discountScheme: json["discount_scheme"],
    supplier: json["supplier"],
    countryCurrency: json["country_currency"],
    fiscalSessionAd: json["fiscal_session_ad"],
    fiscalSessionBs: json["fiscal_session_bs"],
    refPurchase: json["ref_purchase"],
    refPurchaseOrder: json["ref_purchase_order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "pay_type_display": payTypeDisplay,
    "purchase_type_display": purchaseTypeDisplay,
    "supplier_name": supplierName,
    "discount_scheme_name": discountSchemeName,
    "created_by_user_name": createdByUserName,
    "created_by_first_name": createdByFirstName,
    "created_date_ad": createdDateAd.toIso8601String(),
    "created_date_bs": "${createdDateBs.year.toString().padLeft(4, '0')}-${createdDateBs.month.toString().padLeft(2, '0')}-${createdDateBs.day.toString().padLeft(2, '0')}",
    "device_type": deviceType,
    "app_type": appType,
    "purchase_no": purchaseNo,
    "purchase_type": purchaseType,
    "pay_type": payType,
    "sub_total": subTotal,
    "total_discount": totalDiscount,
    "discount_rate": discountRate,
    "total_discountable_amount": totalDiscountableAmount,
    "total_taxable_amount": totalTaxableAmount,
    "total_non_taxable_amount": totalNonTaxableAmount,
    "total_tax": totalTax,
    "grand_total": grandTotal,
    "round_off_amount": roundOffAmount,
    "bill_no": billNo,
    "bill_date_ad": billDateAd,
    "bill_date_bs": billDateBs,
    "chalan_no": chalanNo,
    "due_date_ad": dueDateAd,
    "due_date_bs": dueDateBs,
    "remarks": remarks,
    "created_by": createdBy,
    "discount_scheme": discountScheme,
    "supplier": supplier,
    "country_currency": countryCurrency,
    "fiscal_session_ad": fiscalSessionAd,
    "fiscal_session_bs": fiscalSessionBs,
    "ref_purchase": refPurchase,
    "ref_purchase_order": refPurchaseOrder,
  };
}
