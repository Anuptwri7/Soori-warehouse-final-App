// To parse this JSON data, do
//
//     final saleReturnDrop = saleReturnDropFromJson(jsonString);

import 'dart:convert';

SaleReturnDrop saleReturnDropFromJson(String str) => SaleReturnDrop.fromJson(json.decode(str));

String saleReturnDropToJson(SaleReturnDrop data) => json.encode(data.toJson());

class SaleReturnDrop {
  SaleReturnDrop({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int ?count;
  dynamic next;
  dynamic previous;
  List<Result>? results;

  factory SaleReturnDrop.fromJson(Map<String, dynamic> json) => SaleReturnDrop(
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
    this.saleAdditionalCharges,
    this.paymentDetails,
    this.customerFirstName,
    this.customerMiddleName,
    this.customerLastName,
    this.customerAddress,
    this.customerPhoneNo,
    this.createdByUserName,
    this.saleTypeDisplay,
    this.payTypeDisplay,
    this.orderNo,
    this.createdDateAd,
    this.createdDateBs,
    this.deviceType,
    this.appType,
    this.saleNo,
    this.saleType,
    this.subTotal,
    this.discountRate,
    this.totalDiscountableAmount,
    this.totalTaxableAmount,
    this.totalNonTaxableAmount,
    this.totalDiscount,
    this.totalTax,
    this.grandTotal,
    this.payType,
    this.refBy,
    this.remarks,
    this.returnDropped,
    this.syncedWithIrd,
    this.realTimeUpload,
    this.active,
    this.createdBy,
    this.discountScheme,
    this.customer,
    this.fiscalSessionAd,
    this.fiscalSessionBs,
    this.refSaleMaster,
    this.refOrderMaster,
    this.refChalanMaster,
  });

  int? id;
  List<dynamic>? saleAdditionalCharges;
  List<dynamic> ?paymentDetails;
  String ?customerFirstName;
  String ?customerMiddleName;
  String ?customerLastName;
  String ?customerAddress;
  String ?customerPhoneNo;
  String ?createdByUserName;
  String ?saleTypeDisplay;
  String ?payTypeDisplay;
  String ?orderNo;
  DateTime ?createdDateAd;
  DateTime ?createdDateBs;
  int ?deviceType;
  int? appType;
  String ?saleNo;
  int ?saleType;
  String? subTotal;
  String ?discountRate;
  String ?totalDiscountableAmount;
  String ?totalTaxableAmount;
  String ?totalNonTaxableAmount;
  String ?totalDiscount;
  String ?totalTax;
  String ?grandTotal;
  int ?payType;
  String ?refBy;
  String? remarks;
  bool? returnDropped;
  bool ?syncedWithIrd;
  bool? realTimeUpload;
  bool? active;
  int ?createdBy;
  dynamic ?discountScheme;
  int ?customer;
  int ?fiscalSessionAd;
  int? fiscalSessionBs;
  int ?refSaleMaster;
  int ?refOrderMaster;
  dynamic? refChalanMaster;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    saleAdditionalCharges: List<dynamic>.from(json["sale_additional_charges"].map((x) => x)),
    paymentDetails: List<dynamic>.from(json["payment_details"].map((x) => x)),
    customerFirstName: json["customer_first_name"],
    customerMiddleName: json["customer_middle_name"],
    customerLastName: json["customer_last_name"],
    customerAddress: json["customer_address"],
    customerPhoneNo: json["customer_phone_no"],
    createdByUserName: json["created_by_user_name"],
    saleTypeDisplay: json["sale_type_display"],
    payTypeDisplay: json["pay_type_display"],
    orderNo: json["order_no"],
    createdDateAd: DateTime.parse(json["created_date_ad"]),
    createdDateBs: DateTime.parse(json["created_date_bs"]),
    deviceType: json["device_type"],
    appType: json["app_type"],
    saleNo: json["sale_no"],
    saleType: json["sale_type"],
    subTotal: json["sub_total"],
    discountRate: json["discount_rate"],
    totalDiscountableAmount: json["total_discountable_amount"],
    totalTaxableAmount: json["total_taxable_amount"],
    totalNonTaxableAmount: json["total_non_taxable_amount"],
    totalDiscount: json["total_discount"],
    totalTax: json["total_tax"],
    grandTotal: json["grand_total"],
    payType: json["pay_type"],
    refBy: json["ref_by"],
    remarks: json["remarks"],
    returnDropped: json["return_dropped"],
    syncedWithIrd: json["synced_with_ird"],
    realTimeUpload: json["real_time_upload"],
    active: json["active"],
    createdBy: json["created_by"],
    discountScheme: json["discount_scheme"],
    customer: json["customer"],
    fiscalSessionAd: json["fiscal_session_ad"],
    fiscalSessionBs: json["fiscal_session_bs"],
    refSaleMaster: json["ref_sale_master"],
    refOrderMaster: json["ref_order_master"],
    refChalanMaster: json["ref_chalan_master"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sale_additional_charges": List<dynamic>.from(saleAdditionalCharges!.map((x) => x)),
    "payment_details": List<dynamic>.from(paymentDetails!.map((x) => x)),
    "customer_first_name": customerFirstName,
    "customer_middle_name": customerMiddleName,
    "customer_last_name": customerLastName,
    "customer_address": customerAddress,
    "customer_phone_no": customerPhoneNo,
    "created_by_user_name": createdByUserName,
    "sale_type_display": saleTypeDisplay,
    "pay_type_display": payTypeDisplay,
    "order_no": orderNo,
    "created_date_ad": createdDateAd!.toIso8601String(),
    "created_date_bs": "${createdDateBs!.year.toString().padLeft(4, '0')}-${createdDateBs!.month.toString().padLeft(2, '0')}-${createdDateBs!.day.toString().padLeft(2, '0')}",
    "device_type": deviceType,
    "app_type": appType,
    "sale_no": saleNo,
    "sale_type": saleType,
    "sub_total": subTotal,
    "discount_rate": discountRate,
    "total_discountable_amount": totalDiscountableAmount,
    "total_taxable_amount": totalTaxableAmount,
    "total_non_taxable_amount": totalNonTaxableAmount,
    "total_discount": totalDiscount,
    "total_tax": totalTax,
    "grand_total": grandTotal,
    "pay_type": payType,
    "ref_by": refBy,
    "remarks": remarks,
    "return_dropped": returnDropped,
    "synced_with_ird": syncedWithIrd,
    "real_time_upload": realTimeUpload,
    "active": active,
    "created_by": createdBy,
    "discount_scheme": discountScheme,
    "customer": customer,
    "fiscal_session_ad": fiscalSessionAd,
    "fiscal_session_bs": fiscalSessionBs,
    "ref_sale_master": refSaleMaster,
    "ref_order_master": refOrderMaster,
    "ref_chalan_master": refChalanMaster,
  };
}
