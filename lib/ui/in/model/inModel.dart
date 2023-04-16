
import 'dart:convert';

PendingOrder packTypeListFromJson(String str) =>
    PendingOrder.fromJson(json.decode(str));

String PendingOrderToJson(PendingOrder data) => json.encode(data.toJson());
class PendingOrder {
  int? count;
  String? next;
  Null? previous;
  List<Results>? results;

  PendingOrder({this.count, this.next, this.previous, this.results});

  PendingOrder.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  String? orderNo;
  String? createdDateBs;
  String? createdDateAd;
  String? subTotal;
  String? totalDiscount;
  String? totalTax;
  String? grandTotal;
  String? createdByUserName;
  Supplier? supplier;
  String? status;
  String? remarks;
  List<PurchaseOrderDocuments>? purchaseOrderDocuments;
  int? currency;

  Results(
      {this.id,
        this.orderNo,
        this.createdDateBs,
        this.createdDateAd,
        this.subTotal,
        this.totalDiscount,
        this.totalTax,
        this.grandTotal,
        this.createdByUserName,
        this.supplier,
        this.status,
        this.remarks,
        this.purchaseOrderDocuments,
        this.currency});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    createdDateBs = json['created_date_bs'];
    createdDateAd = json['created_date_ad'];
    subTotal = json['sub_total'];
    totalDiscount = json['total_discount'];
    totalTax = json['total_tax'];
    grandTotal = json['grand_total'];
    createdByUserName = json['created_by_user_name'];
    supplier = json['supplier'] != null
        ? new Supplier.fromJson(json['supplier'])
        : null;
    status = json['status'];
    remarks = json['remarks'];
    if (json['purchase_order_documents'] != null) {
      purchaseOrderDocuments = <PurchaseOrderDocuments>[];
      json['purchase_order_documents'].forEach((v) {
        purchaseOrderDocuments!.add(new PurchaseOrderDocuments.fromJson(v));
      });
    }
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_no'] = this.orderNo;
    data['created_date_bs'] = this.createdDateBs;
    data['created_date_ad'] = this.createdDateAd;
    data['sub_total'] = this.subTotal;
    data['total_discount'] = this.totalDiscount;
    data['total_tax'] = this.totalTax;
    data['grand_total'] = this.grandTotal;
    data['created_by_user_name'] = this.createdByUserName;
    if (this.supplier != null) {
      data['supplier'] = this.supplier!.toJson();
    }
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    if (this.purchaseOrderDocuments != null) {
      data['purchase_order_documents'] =
          this.purchaseOrderDocuments!.map((v) => v.toJson()).toList();
    }
    data['currency'] = this.currency;
    return data;
  }
}

class Supplier {
  int? id;
  String? name;

  Supplier({this.id, this.name});

  Supplier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class PurchaseOrderDocuments {
  int? id;
  String? title;
  int? documentType;
  String? documentUrl;
  String? remarks;
  String? createdDateAd;
  String? createdDateBs;
  String? createdByName;
  String? documentTypeName;

  PurchaseOrderDocuments(
      {this.id,
        this.title,
        this.documentType,
        this.documentUrl,
        this.remarks,
        this.createdDateAd,
        this.createdDateBs,
        this.createdByName,
        this.documentTypeName});

  PurchaseOrderDocuments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    documentType = json['document_type'];
    documentUrl = json['document_url'];
    remarks = json['remarks'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    createdByName = json['created_by_name'];
    documentTypeName = json['document_type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['document_type'] = this.documentType;
    data['document_url'] = this.documentUrl;
    data['remarks'] = this.remarks;
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['created_by_name'] = this.createdByName;
    data['document_type_name'] = this.documentTypeName;
    return data;
  }
}
