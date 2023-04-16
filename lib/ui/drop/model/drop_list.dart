// To parse this JSON data, do
//
//     final dropOrderReceive = dropOrderReceiveFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DropOrderReceive dropOrderReceiveFromJson(String str) => DropOrderReceive.fromJson(json.decode(str));

String dropOrderReceiveToJson(DropOrderReceive data) => json.encode(data.toJson());

class DropOrderReceive {
  DropOrderReceive({
   required this.count,
   required this.next,
   required this.previous,
   required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory DropOrderReceive.fromJson(Map<String, dynamic> json) => DropOrderReceive(
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
   required this.purchaseOrderDetails,
   required this.discountScheme,
   required this.supplierName,
   required this.supplierAddress,
   required this.supplierCountryName,
   required this.createdByUserName,
   required this.refPurchaseOrderNo,
   required this.orderTypeDisplay,
   required this.createdDateAd,
   required this.createdDateBs,
   required this.deviceType,
   required this.appType,
   required this.orderNo,
   required this.orderType,
   required this.subTotal,
   required this.totalDiscount,
   required this.discountRate,
   required this.totalDiscountableAmount,
   required this.totalTaxableAmount,
   required this.totalNonTaxableAmount,
   required this.totalTax,
   required this.grandTotal,
   required this.remarks,
   required this.termsOfPayment,
   required this.shipmentTerms,
   required this.endUserName,
   required this.createdBy,
   required this.supplier,
   required this.countryCurrency,
   required this.refPurchaseOrder,
  });

  int id;
  List<PurchaseOrderDetail> purchaseOrderDetails;
  DiscountScheme? discountScheme;
  String supplierName;
  String supplierAddress;
  dynamic supplierCountryName;
  String createdByUserName;
  String refPurchaseOrderNo;
  String orderTypeDisplay;
  DateTime createdDateAd;
  DateTime createdDateBs;
  int deviceType;
  int appType;
  String orderNo;
  int orderType;
  String subTotal;
  String totalDiscount;
  String discountRate;
  String totalDiscountableAmount;
  String totalTaxableAmount;
  String totalNonTaxableAmount;
  String totalTax;
  String grandTotal;
  String remarks;
  String termsOfPayment;
  String shipmentTerms;
  String endUserName;
  int createdBy;
  int supplier;
  dynamic countryCurrency;
  int refPurchaseOrder;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    purchaseOrderDetails: List<PurchaseOrderDetail>.from(json["purchase_order_details"].map((x) => PurchaseOrderDetail.fromJson(x))),
    discountScheme: json["discount_scheme"] == null ? null : DiscountScheme.fromJson(json["discount_scheme"]),
    /*== null ? null : DiscountScheme.fromJson(json["discount_scheme"])*/
    supplierName: json["supplier_name"],
    supplierAddress: json["supplier_address"],
    supplierCountryName: json["supplier_country_name"],
    createdByUserName: json["created_by_user_name"],
    refPurchaseOrderNo: json["ref_purchase_order_no"],
    orderTypeDisplay: json["order_type_display"],
    createdDateAd: DateTime.parse(json["created_date_ad"]),
    createdDateBs: DateTime.parse(json["created_date_bs"]),
    deviceType: json["device_type"],
    appType: json["app_type"],
    orderNo: json["order_no"],
    orderType: json["order_type"],
    subTotal: json["sub_total"],
    totalDiscount: json["total_discount"],
    discountRate: json["discount_rate"],
    totalDiscountableAmount: json["total_discountable_amount"],
    totalTaxableAmount: json["total_taxable_amount"],
    totalNonTaxableAmount: json["total_non_taxable_amount"],
    totalTax: json["total_tax"],
    grandTotal: json["grand_total"],
    remarks: json["remarks"],
    termsOfPayment: json["terms_of_payment"],
    shipmentTerms: json["shipment_terms"],
    endUserName: json["end_user_name"],
    createdBy: json["created_by"],
    supplier: json["supplier"],
    countryCurrency: json["country_currency"],
    refPurchaseOrder: json["ref_purchase_order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "purchase_order_details": List<dynamic>.from(purchaseOrderDetails.map((x) => x.toJson())),
    "discount_scheme": discountScheme == null ? null : discountScheme!.toJson(),
    "supplier_name": supplierName,
    "supplier_address": supplierAddress,
    "supplier_country_name": supplierCountryName,
    "created_by_user_name": createdByUserName,
    "ref_purchase_order_no": refPurchaseOrderNo,
    "order_type_display": orderTypeDisplay,
    "created_date_ad": createdDateAd.toIso8601String(),
    "created_date_bs": "${createdDateBs.year.toString().padLeft(4, '0')}-${createdDateBs.month.toString().padLeft(2, '0')}-${createdDateBs.day.toString().padLeft(2, '0')}",
    "device_type": deviceType,
    "app_type": appType,
    "order_no": orderNo,
    "order_type": orderType,
    "sub_total": subTotal,
    "total_discount": totalDiscount,
    "discount_rate": discountRate,
    "total_discountable_amount": totalDiscountableAmount,
    "total_taxable_amount": totalTaxableAmount,
    "total_non_taxable_amount": totalNonTaxableAmount,
    "total_tax": totalTax,
    "grand_total": grandTotal,
    "remarks": remarks,
    "terms_of_payment": termsOfPayment,
    "shipment_terms": shipmentTerms,
    "end_user_name": endUserName,
    "created_by": createdBy,
    "supplier": supplier,
    "country_currency": countryCurrency,
    "ref_purchase_order": refPurchaseOrder,
  };
}

class DiscountScheme {
  DiscountScheme({
   required this.id,
   required this.name,
   required this.rate,
  });

  int id;
  String name;
  String rate;

  factory DiscountScheme.fromJson(Map<String, dynamic> json) => DiscountScheme(
    id: json["id"],
    name: json["name"],
    rate: json["rate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "rate": rate,
  };
}

class PurchaseOrderDetail {
  PurchaseOrderDetail({
   required this.id,
   required this.poPackTypeCodes,
   required this.itemName,
   required this.itemCode,
   required this.itemBasicInfo,
   required this.itemCategoryName,
   required this.packingTypeName,
   required this.packingTypeDetailItemUnitName,
   required this.itemUnitShortForm,
   required this.orderNo,
   required this.expirable,
   required this.packingTypeDetailsItemwise,
   required this.createdDateAd,
   required this.createdDateBs,
   required this.deviceType,
   required this.appType,
   required this.purchaseCost,
   required this.saleCost,
   required this.qty,
   required this.packQty,
   required this.taxable,
   required this.taxRate,
   required this.taxAmount,
   required this.discountable,
   required this.discountRate,
   required this.discountAmount,
   required this.grossAmount,
   required this.netAmount,
   required this.createdBy,
   required this.item,
   required this.itemCategory,
   required this.refPurchaseOrderDetail,
   required this.packingType,
   required this.packingTypeDetail,
  });

  int id;
  List<PoPackTypeCode> poPackTypeCodes;
  String itemName;
  String itemCode;
  String itemBasicInfo;
  String itemCategoryName;
  String packingTypeName;
  String packingTypeDetailItemUnitName;
  String itemUnitShortForm;
  String orderNo;
  bool expirable;
  List<PackingTypeDetail> packingTypeDetailsItemwise;
  DateTime createdDateAd;
  DateTime createdDateBs;
  int deviceType;
  int appType;
  String purchaseCost;
  String saleCost;
  String qty;
  String packQty;
  bool taxable;
  String taxRate;
  String taxAmount;
  bool discountable;
  String discountRate;
  String discountAmount;
  String grossAmount;
  String netAmount;
  int createdBy;
  int item;
  int itemCategory;
  int refPurchaseOrderDetail;
  PackingType packingType;
  PackingTypeDetail packingTypeDetail;

  factory PurchaseOrderDetail.fromJson(Map<String, dynamic> json) => PurchaseOrderDetail(
    id: json["id"],
    poPackTypeCodes: List<PoPackTypeCode>.from(json["po_pack_type_codes"].map((x) => PoPackTypeCode.fromJson(x))),
    itemName: json["item_name"],
    itemCode: json["item_code"],
    itemBasicInfo: json["item_basic_info"],
    itemCategoryName: json["item_category_name"],
    packingTypeName: json["packing_type_name"],
    packingTypeDetailItemUnitName: json["packing_type_detail_item_unit_name"],
    itemUnitShortForm: json["item_unit_short_form"],
    orderNo: json["order_no"],
    expirable: json["expirable"],
    packingTypeDetailsItemwise: List<PackingTypeDetail>.from(json["packing_type_details_itemwise"].map((x) => PackingTypeDetail.fromJson(x))),
    createdDateAd: DateTime.parse(json["created_date_ad"]),
    createdDateBs: DateTime.parse(json["created_date_bs"]),
    deviceType: json["device_type"],
    appType: json["app_type"],
    purchaseCost: json["purchase_cost"],
    saleCost: json["sale_cost"],
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
    item: json["item"],
    itemCategory: json["item_category"],
    refPurchaseOrderDetail: json["ref_purchase_order_detail"],
    packingType: PackingType.fromJson(json["packing_type"]),
    packingTypeDetail: PackingTypeDetail.fromJson(json["packing_type_detail"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "po_pack_type_codes": List<dynamic>.from(poPackTypeCodes.map((x) => x.toJson())),
    "item_name": itemName,
    "item_code": itemCode,
    "item_basic_info": itemBasicInfo,
    "item_category_name": itemCategoryName,
    "packing_type_name": packingTypeName,
    "packing_type_detail_item_unit_name": packingTypeDetailItemUnitName,
    "item_unit_short_form": itemUnitShortForm,
    "order_no": orderNo,
    "expirable": expirable,
    "packing_type_details_itemwise": List<dynamic>.from(packingTypeDetailsItemwise.map((x) => x.toJson())),
    "created_date_ad": createdDateAd.toIso8601String(),
    "created_date_bs": "${createdDateBs.year.toString().padLeft(4, '0')}-${createdDateBs.month.toString().padLeft(2, '0')}-${createdDateBs.day.toString().padLeft(2, '0')}",
    "device_type": deviceType,
    "app_type": appType,
    "purchase_cost": purchaseCost,
    "sale_cost": saleCost,
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
    "item": item,
    "item_category": itemCategory,
    "ref_purchase_order_detail": refPurchaseOrderDetail,
    "packing_type": packingType.toJson(),
    "packing_type_detail": packingTypeDetail.toJson(),
  };
}

class PackingType {
  PackingType({
   required this.id,
   required this.createdDateAd,
   required this.createdDateBs,
   required this.deviceType,
   required this.appType,
   required this.name,
   required this.shortName,
   required this.active,
   required this.createdBy,
  });

  int id;
  DateTime createdDateAd;
  DateTime createdDateBs;
  int deviceType;
  int appType;
  String name;
  String shortName;
  bool active;
  int createdBy;

  factory PackingType.fromJson(Map<String, dynamic> json) => PackingType(
    id: json["id"],
    createdDateAd: DateTime.parse(json["created_date_ad"]),
    createdDateBs: DateTime.parse(json["created_date_bs"]),
    deviceType: json["device_type"],
    appType: json["app_type"],
    name: json["name"],
    shortName: json["short_name"],
    active: json["active"],
    createdBy: json["created_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_date_ad": createdDateAd.toIso8601String(),
    "created_date_bs": "${createdDateBs.year.toString().padLeft(4, '0')}-${createdDateBs.month.toString().padLeft(2, '0')}-${createdDateBs.day.toString().padLeft(2, '0')}",
    "device_type": deviceType,
    "app_type": appType,
    "name": name,
    "short_name": shortName,
    "active": active,
    "created_by": createdBy,
  };
}

class PackingTypeDetail {
  PackingTypeDetail({
   required this.id,
   required this.packingTypeName,
   required this.deviceType,
   required this.appType,
   required this.packQty,
   required this.packingType,
  });

  int id;
  String packingTypeName;
  int deviceType;
  int appType;
  String packQty;
  int packingType;

  factory PackingTypeDetail.fromJson(Map<String, dynamic> json) => PackingTypeDetail(
    id: json["id"],
    packingTypeName: json["packing_type_name"],
    deviceType: json["device_type"],
    appType: json["app_type"],
    packQty: json["pack_qty"],
    packingType: json["packing_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "packing_type_name": packingTypeName,
    "device_type": deviceType,
    "app_type": appType,
    "pack_qty": packQty,
    "packing_type": packingType,
  };
}

class PoPackTypeCode {
  PoPackTypeCode({
   required this.id,
   required this.code,
   required this.location,
  });

  int id;
  String code;
  int? location;

  factory PoPackTypeCode.fromJson(Map<String, dynamic> json) => PoPackTypeCode(
    id: json["id"],
    code: json["code"],
    location: json["location"] == null ? null : json["location"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "location": location == null ? null : location,
  };
}
