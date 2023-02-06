// To parse this JSON data, do
//
//     final chalanReturnDrop = chalanReturnDropFromJson(jsonString);

import 'dart:convert';

ChalanReturnDrop chalanReturnDropFromJson(String str) => ChalanReturnDrop.fromJson(json.decode(str));

String chalanReturnDropToJson(ChalanReturnDrop data) => json.encode(data.toJson());

class ChalanReturnDrop {
  ChalanReturnDrop({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int ?count;
  String ?next;
  dynamic? previous;
  List<Result>? results;

  factory ChalanReturnDrop.fromJson(Map<String, dynamic> json) => ChalanReturnDrop(
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
    this.chalanNo,
    this.status,
    this.customer,
    this.discountScheme,
    this.discountRate,
    this.totalDiscount,
    this.totalTax,
    this.subTotal,
    this.totalDiscountableAmount,
    this.totalTaxableAmount,
    this.totalNonTaxableAmount,
    this.refOrderMaster,
    this.grandTotal,
    this.remarks,
    this.createdDateAd,
    this.createdDateBs,
    this.orderNo,
    this.refChalanMaster,
    this.returnDropped,
  });

  int? id;
  String? chalanNo;
  int ?status;
  Customer? customer;
  dynamic ?discountScheme;
  String? discountRate;
  String ?totalDiscount;
  String ?totalTax;
  String? subTotal;
  String ?totalDiscountableAmount;
  String ?totalTaxableAmount;
  String ?totalNonTaxableAmount;
  dynamic ?refOrderMaster;
  String ?grandTotal;
  String? remarks;
  DateTime ?createdDateAd;
  String? createdDateBs;
  dynamic ?orderNo;
  int ?refChalanMaster;
  bool ?returnDropped;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    chalanNo: json["chalan_no"],
    status: json["status"],
    customer: Customer.fromJson(json["customer"]),
    discountScheme: json["discount_scheme"],
    discountRate: json["discount_rate"],
    totalDiscount: json["total_discount"],
    totalTax: json["total_tax"],
    subTotal: json["sub_total"],
    totalDiscountableAmount: json["total_discountable_amount"],
    totalTaxableAmount: json["total_taxable_amount"],
    totalNonTaxableAmount: json["total_non_taxable_amount"],
    refOrderMaster: json["ref_order_master"],
    grandTotal: json["grand_total"],
    remarks: json["remarks"],
    createdDateAd: DateTime.parse(json["created_date_ad"]),
    createdDateBs: json["created_date_bs"],
    orderNo: json["order_no"],
    refChalanMaster: json["ref_chalan_master"],
    returnDropped: json["return_dropped"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "chalan_no": chalanNo,
    "status": status,
    "customer": customer!.toJson(),
    "discount_scheme": discountScheme,
    "discount_rate": discountRate,
    "total_discount": totalDiscount,
    "total_tax": totalTax,
    "sub_total": subTotal,
    "total_discountable_amount": totalDiscountableAmount,
    "total_taxable_amount": totalTaxableAmount,
    "total_non_taxable_amount": totalNonTaxableAmount,
    "ref_order_master": refOrderMaster,
    "grand_total": grandTotal,
    "remarks": remarks,
    "created_date_ad": createdDateAd!.toIso8601String(),
    "created_date_bs": createdDateBs,
    "order_no": orderNo,
    "ref_chalan_master": refChalanMaster,
    "return_dropped": returnDropped,
  };
}



class Customer {
  Customer({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.panVatNo,
    this.phoneNo,
    this.address,
  });

  int? id;
  String? firstName;
  String ?middleName;
  String? lastName;
  String ?panVatNo;
  String ?phoneNo;
  String? address;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    firstName: json["first_name"],
    middleName: json["middle_name"],
    lastName: json["last_name"],
    panVatNo: json["pan_vat_no"],
    phoneNo: json["phone_no"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "middle_name": middleName,
    "last_name": lastName,
    "pan_vat_no": panVatNo,
    "phone_no": phoneNo,
    "address": address,
  };
}



