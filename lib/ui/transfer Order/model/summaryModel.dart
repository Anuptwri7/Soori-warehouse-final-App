// To parse this JSON data, do
//
//     final transferSummary = transferSummaryFromJson(jsonString);

import 'dart:convert';

TransferSummary transferSummaryFromJson(String str) => TransferSummary.fromJson(json.decode(str));

String transferSummaryToJson(TransferSummary data) => json.encode(data.toJson());

class TransferSummary {
  TransferSummary({
    this.id,
    this.createdByUserName,
    this.transferDetails,
    this.isPicked,
    this.createdDateAd,
    this.createdDateBs,
    this.deviceType,
    this.appType,
    this.transferType,
    this.transferNo,
    this.subTotal,
    this.discountRate,
    this.totalDiscountableAmount,
    this.totalTaxableAmount,
    this.totalNonTaxableAmount,
    this.totalDiscount,
    this.totalTax,
    this.grandTotal,
    this.branch,
    this.branchName,
    this.remarks,
    this.returnDropped,
    this.active,
    this.isTransferred,
    this.cancelled,
    this.createdBy,
    this.discountScheme,
    this.fiscalSessionAd,
    this.fiscalSessionBs,
    this.refTransferMaster,
    this.refTransferOrderMaster,
  });

  int? id;
  String? createdByUserName;
  List<TransferDetail> ?transferDetails;
  bool ?isPicked;
  DateTime? createdDateAd;
  DateTime ?createdDateBs;
  int ?deviceType;
  int ?appType;
  int ?transferType;
  String? transferNo;
  String ?subTotal;
  String ?discountRate;
  String ?totalDiscountableAmount;
  String ?totalTaxableAmount;
  String ?totalNonTaxableAmount;
  String ?totalDiscount;
  String ?totalTax;
  String ?grandTotal;
  int? branch;
  String? branchName;
  String ?remarks;
  bool ?returnDropped;
  bool ?active;
  bool ?isTransferred;
  bool ?cancelled;
  int ?createdBy;
  dynamic discountScheme;
  int? fiscalSessionAd;
  int ?fiscalSessionBs;
  dynamic refTransferMaster;
  dynamic refTransferOrderMaster;

  factory TransferSummary.fromJson(Map<String, dynamic> json) => TransferSummary(
    id: json["id"],
    createdByUserName: json["created_by_user_name"],
    transferDetails: List<TransferDetail>.from(json["transfer_details"].map((x) => TransferDetail.fromJson(x))),
    isPicked: json["is_picked"],
    createdDateAd: DateTime.parse(json["created_date_ad"]),
    createdDateBs: DateTime.parse(json["created_date_bs"]),
    deviceType: json["device_type"],
    appType: json["app_type"],
    transferType: json["transfer_type"],
    transferNo: json["transfer_no"],
    subTotal: json["sub_total"],
    discountRate: json["discount_rate"],
    totalDiscountableAmount: json["total_discountable_amount"],
    totalTaxableAmount: json["total_taxable_amount"],
    totalNonTaxableAmount: json["total_non_taxable_amount"],
    totalDiscount: json["total_discount"],
    totalTax: json["total_tax"],
    grandTotal: json["grand_total"],
    branch: json["branch"],
    branchName: json["branch_name"],
    remarks: json["remarks"],
    returnDropped: json["return_dropped"],
    active: json["active"],
    isTransferred: json["is_transferred"],
    cancelled: json["cancelled"],
    createdBy: json["created_by"],
    discountScheme: json["discount_scheme"],
    fiscalSessionAd: json["fiscal_session_ad"],
    fiscalSessionBs: json["fiscal_session_bs"],
    refTransferMaster: json["ref_transfer_master"],
    refTransferOrderMaster: json["ref_transfer_order_master"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_by_user_name": createdByUserName,
    "transfer_details": List<dynamic>.from(transferDetails!.map((x) => x.toJson())),
    "is_picked": isPicked,
    "created_date_ad": createdDateAd!.toIso8601String(),
    "created_date_bs": "${createdDateBs!.year.toString().padLeft(4, '0')}-${createdDateBs!.month.toString().padLeft(2, '0')}-${createdDateBs!.day.toString().padLeft(2, '0')}",
    "device_type": deviceType,
    "app_type": appType,
    "transfer_type": transferType,
    "transfer_no": transferNo,
    "sub_total": subTotal,
    "discount_rate": discountRate,
    "total_discountable_amount": totalDiscountableAmount,
    "total_taxable_amount": totalTaxableAmount,
    "total_non_taxable_amount": totalNonTaxableAmount,
    "total_discount": totalDiscount,
    "total_tax": totalTax,
    "grand_total": grandTotal,
    "branch": branch,
    "branch_name": branchName,
    "remarks": remarks,
    "return_dropped": returnDropped,
    "active": active,
    "is_transferred": isTransferred,
    "cancelled": cancelled,
    "created_by": createdBy,
    "discount_scheme": discountScheme,
    "fiscal_session_ad": fiscalSessionAd,
    "fiscal_session_bs": fiscalSessionBs,
    "ref_transfer_master": refTransferMaster,
    "ref_transfer_order_master": refTransferOrderMaster,
  };
}

class TransferDetail {
  TransferDetail({
    this.id,
    this.batchNo,
    this.itemName,
    this.itemCategoryName,
    this.packQty,
    this.transferPackingTypes,
    this.createdDateAd,
    this.createdDateBs,
    this.deviceType,
    this.appType,
    this.cost,
    this.qty,
    this.taxable,
    this.taxRate,
    this.taxAmount,
    this.discountable,
    this.discountRate,
    this.discountAmount,
    this.grossAmount,
    this.netAmount,
    this.cancelled,
    this.isPicked,
    this.createdBy,
    this.item,
    this.itemCategory,
    this.refPurchaseDetail,
    this.refTransferDetail,
    this.refTransferOrderDetail,
  });

  int? id;
  String ?batchNo;
  String ?itemName;
  String ?itemCategoryName;
  String ?packQty;
  List<TransferPackingType>? transferPackingTypes;
  DateTime? createdDateAd;
  DateTime ?createdDateBs;
  int ?deviceType;
  int ?appType;
  String? cost;
  String ?qty;
  bool ?taxable;
  String ?taxRate;
  String ?taxAmount;
  bool ?discountable;
  String? discountRate;
  String ?discountAmount;
  String ?grossAmount;
  String ?netAmount;
  bool ?cancelled;
  bool ?isPicked;
  int ?createdBy;
  int ?item;
  int ?itemCategory;
  int? refPurchaseDetail;
  dynamic? refTransferDetail;
  dynamic ?refTransferOrderDetail;

  factory TransferDetail.fromJson(Map<String, dynamic> json) => TransferDetail(
    id: json["id"],
    batchNo: json["batch_no"],
    itemName: json["item_name"],
    itemCategoryName: json["item_category_name"],
    packQty: json["pack_qty"],
    transferPackingTypes: List<TransferPackingType>.from(json["transfer_packing_types"].map((x) => TransferPackingType.fromJson(x))),
    createdDateAd: DateTime.parse(json["created_date_ad"]),
    createdDateBs: DateTime.parse(json["created_date_bs"]),
    deviceType: json["device_type"],
    appType: json["app_type"],
    cost: json["cost"],
    qty: json["qty"],
    taxable: json["taxable"],
    taxRate: json["tax_rate"],
    taxAmount: json["tax_amount"],
    discountable: json["discountable"],
    discountRate: json["discount_rate"],
    discountAmount: json["discount_amount"],
    grossAmount: json["gross_amount"],
    netAmount: json["net_amount"],
    cancelled: json["cancelled"],
    isPicked: json["is_picked"],
    createdBy: json["created_by"],
    item: json["item"],
    itemCategory: json["item_category"],
    refPurchaseDetail: json["ref_purchase_detail"],
    refTransferDetail: json["ref_transfer_detail"],
    refTransferOrderDetail: json["ref_transfer_order_detail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "batch_no": batchNo,
    "item_name": itemName,
    "item_category_name": itemCategoryName,
    "pack_qty": packQty,
    "transfer_packing_types": List<dynamic>.from(transferPackingTypes!.map((x) => x.toJson())),
    "created_date_ad": createdDateAd!.toIso8601String(),
    "created_date_bs": "${createdDateBs!.year.toString().padLeft(4, '0')}-${createdDateBs!.month.toString().padLeft(2, '0')}-${createdDateBs!.day.toString().padLeft(2, '0')}",
    "device_type": deviceType,
    "app_type": appType,
    "cost": cost,
    "qty": qty,
    "taxable": taxable,
    "tax_rate": taxRate,
    "tax_amount": taxAmount,
    "discountable": discountable,
    "discount_rate": discountRate,
    "discount_amount": discountAmount,
    "gross_amount": grossAmount,
    "net_amount": netAmount,
    "cancelled": cancelled,
    "is_picked": isPicked,
    "created_by": createdBy,
    "item": item,
    "item_category": itemCategory,
    "ref_purchase_detail": refPurchaseDetail,
    "ref_transfer_detail": refTransferDetail,
    "ref_transfer_order_detail": refTransferOrderDetail,
  };
}

class TransferPackingType {
  TransferPackingType({
    this.id,
    this.salePackingTypeDetailCode,
  });

  int? id;
  List<SalePackingTypeDetailCode>? salePackingTypeDetailCode;

  factory TransferPackingType.fromJson(Map<String, dynamic> json) => TransferPackingType(
    id: json["id"],
    salePackingTypeDetailCode: List<SalePackingTypeDetailCode>.from(json["sale_packing_type_detail_code"].map((x) => SalePackingTypeDetailCode.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sale_packing_type_detail_code": List<dynamic>.from(salePackingTypeDetailCode!.map((x) => x.toJson())),
  };
}

class SalePackingTypeDetailCode {
  SalePackingTypeDetailCode({
    this.id,
    this.code,
  });

  int? id;
  String? code;

  factory SalePackingTypeDetailCode.fromJson(Map<String, dynamic> json) => SalePackingTypeDetailCode(
    id: json["id"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
  };
}
