// To parse this JSON data, do
//
//     final pickUpVerificationModel = pickUpVerificationModelFromJson(jsonString);

import 'dart:convert';

PickUpVerificationModel pickUpVerificationModelFromJson(String str) =>
    PickUpVerificationModel.fromJson(json.decode(str));

String pickUpVerificationModelToJson(PickUpVerificationModel data) =>
    json.encode(data.toJson());

class PickUpVerificationModel {
  PickUpVerificationModel({
    this.id,
    this.orderDetails,
    this.orderNo,
    this.createdByUserName,
    this.statusDisplay,
    this.customer,
    this.totalDiscount,
    this.discountScheme,
    this.status,
    this.totalTax,
    this.subTotal,
    this.deliveryDateAd,
    this.deliveryDateBs,
    this.deliveryLocation,
    this.grandTotal,
    this.remarks,
    this.createdDateAd,
    this.createdDateBs,
    this.byBatch,
  });

  int? id;
  List<OrderDetail>? orderDetails;
  String? orderNo;
  String? createdByUserName;
  String? statusDisplay;
  Customer? customer;
  String? totalDiscount;
  String? discountScheme;
  int? status;
  String? totalTax;
  String? subTotal;
  String? deliveryDateAd;
  String? deliveryDateBs;
  String? deliveryLocation;
  String? grandTotal;
  String? remarks;
  DateTime? createdDateAd;
  DateTime? createdDateBs;
  bool? byBatch;

  factory PickUpVerificationModel.fromJson(Map<String, dynamic> json) =>
      PickUpVerificationModel(
        id: json["id"],
        orderDetails: List<OrderDetail>.from(
            json["order_details"].map((x) => OrderDetail.fromJson(x))),
        orderNo: json["order_no"],
        createdByUserName: json["created_by_user_name"],
        statusDisplay: json["status_display"],
        customer: Customer.fromJson(json["customer"]),
        totalDiscount: json["total_discount"],
        discountScheme: json["discount_scheme"],
        status: json["status"],
        totalTax: json["total_tax"],
        subTotal: json["sub_total"],
        deliveryDateAd: json["delivery_date_ad"],
        deliveryDateBs: json["delivery_date_bs"],
        deliveryLocation: json["delivery_location"],
        grandTotal: json["grand_total"],
        remarks: json["remarks"],
        createdDateAd: DateTime.parse(json["created_date_ad"]),
        createdDateBs: DateTime.parse(json["created_date_bs"]),
        byBatch: json["by_batch"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_details":
            List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
        "order_no": orderNo,
        "created_by_user_name": createdByUserName,
        "status_display": statusDisplay,
        "customer": customer!.toJson(),
        "total_discount": totalDiscount,
        "discount_scheme": discountScheme,
        "status": status,
        "total_tax": totalTax,
        "sub_total": subTotal,
        "delivery_date_ad": deliveryDateAd,
        "delivery_date_bs": deliveryDateBs,
        "delivery_location": deliveryLocation,
        "grand_total": grandTotal,
        "remarks": remarks,
        "created_date_ad": createdDateAd,
        "created_date_bs":
            "${createdDateBs!.year.toString().padLeft(4, '0')}-${createdDateBs!.month.toString().padLeft(2, '0')}-${createdDateBs!.day.toString().padLeft(2, '0')}",
        "by_batch": byBatch,
      };
}

class Customer {
  Customer({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
  });

  int? id;
  String? firstName;
  String? middleName;
  String? lastName;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
      };
}

class OrderDetail {
  OrderDetail({
    this.id,
    this.customerPackingTypes,
    this.item,
    this.createdDateAd,
    this.createdDateBs,
    this.deviceType,
    this.appType,
    this.qty,
    this.purchaseCost,
    this.saleCost,
    this.discountable,
    this.taxable,
    this.taxRate,
    this.taxAmount,
    this.discountRate,
    this.discountAmount,
    this.grossAmount,
    this.netAmount,
    this.cancelled,
    this.picked,
    this.remarks,
    this.createdBy,
    this.itemCategory,
    this.purchaseDetail,
  });

  int? id;
  List<CustomerPackingType>? customerPackingTypes;
  Item? item;
  DateTime? createdDateAd;
  DateTime? createdDateBs;
  int? deviceType;
  int? appType;
  String? qty;
  String? purchaseCost;
  String? saleCost;
  bool? discountable;
  bool? taxable;
  String? taxRate;
  String? taxAmount;
  String? discountRate;
  String? discountAmount;
  String? grossAmount;
  String? netAmount;
  bool? cancelled;
  bool? picked;
  String? remarks;
  int? createdBy;
  int? itemCategory;
  int? purchaseDetail;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["id"],
        customerPackingTypes: List<CustomerPackingType>.from(
            json["customer_packing_types"]
                .map((x) => CustomerPackingType.fromJson(x))),
        item: Item.fromJson(json["item"]),
        createdDateAd: DateTime.parse(json["created_date_ad"]),
        createdDateBs: DateTime.parse(json["created_date_bs"]),
        deviceType: json["device_type"],
        appType: json["app_type"],
        qty: json["qty"],
        purchaseCost: json["purchase_cost"],
        saleCost: json["sale_cost"],
        discountable: json["discountable"],
        taxable: json["taxable"],
        taxRate: json["tax_rate"],
        taxAmount: json["tax_amount"],
        discountRate: json["discount_rate"],
        discountAmount: json["discount_amount"],
        grossAmount: json["gross_amount"],
        netAmount: json["net_amount"],
        cancelled: json["cancelled"],
        picked: json["picked"],
        remarks: json["remarks"],
        createdBy: json["created_by"],
        itemCategory: json["item_category"],
        purchaseDetail: json["purchase_detail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_packing_types":
            List<dynamic>.from(customerPackingTypes!.map((x) => x.toJson())),
        "item": item!.toJson(),
        "created_date_ad": createdDateAd,
        "created_date_bs":
            "${createdDateBs!.year.toString().padLeft(4, '0')}-${createdDateBs!.month.toString().padLeft(2, '0')}-${createdDateBs!.day.toString().padLeft(2, '0')}",
        "device_type": deviceType,
        "app_type": appType,
        "qty": qty,
        "purchase_cost": purchaseCost,
        "sale_cost": saleCost,
        "discountable": discountable,
        "taxable": taxable,
        "tax_rate": taxRate,
        "tax_amount": taxAmount,
        "discount_rate": discountRate,
        "discount_amount": discountAmount,
        "gross_amount": grossAmount,
        "net_amount": netAmount,
        "cancelled": cancelled,
        "picked": picked,
        "remarks": remarks,
        "created_by": createdBy,
        "item_category": itemCategory,
        "purchase_detail": purchaseDetail,
      };
}

class CustomerPackingType {
  CustomerPackingType({
    this.id,
    this.locationCode,
    this.location,
    this.code,
    this.saleDetail,
    this.packingTypeCode,
    this.salePackingTypeDetailCode,
  });

  int? id;
  String? locationCode;
  int? location;
  String? code;
  String? saleDetail;
  int? packingTypeCode;
  List<SalePackingTypeDetailCode>? salePackingTypeDetailCode;

  factory CustomerPackingType.fromJson(Map<String, dynamic> json) =>
      CustomerPackingType(
        id: json["id"],
        locationCode: json["location_code"],
        location: json["location"],
        code: json["code"],
        saleDetail: json["sale_detail"],
        packingTypeCode: json["packing_type_code"],
        salePackingTypeDetailCode: List<SalePackingTypeDetailCode>.from(
            json["sale_packing_type_detail_code"]
                .map((x) => SalePackingTypeDetailCode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location_code": locationCode,
        "location": location,
        "code": code,
        "sale_detail": saleDetail,
        "packing_type_code": packingTypeCode,
        "sale_packing_type_detail_code": List<dynamic>.from(
            salePackingTypeDetailCode!.map((x) => x.toJson())),
      };
}

class SalePackingTypeDetailCode {
  SalePackingTypeDetailCode({
    this.id,
    this.packingTypeDetailCode,
    this.code,
  });

  int? id;
  int? packingTypeDetailCode;
  String? code;

  factory SalePackingTypeDetailCode.fromJson(Map<String, dynamic> json) =>
      SalePackingTypeDetailCode(
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

class Item {
  Item({
    this.id,
    this.name,
    this.code,
  });

  int? id;
  String? name;
  String? code;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
      };
}
