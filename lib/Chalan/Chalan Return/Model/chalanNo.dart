// class ChalanNo {
//   int? count;
//   String? next;
//   Null? previous;
//   List<Results>? results;
//
//   ChalanNo({this.count, this.next, this.previous, this.results});
//
//   ChalanNo.fromJson(Map<String, dynamic> json) {
//     count = json['count'];
//     next = json['next'];
//     previous = json['previous'];
//     if (json['results'] != null) {
//       results = <Results>[];
//       json['results'].forEach((v) {
//         results!.add(new Results.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['count'] = this.count;
//     data['next'] = this.next;
//     data['previous'] = this.previous;
//     if (this.results != null) {
//       data['results'] = this.results!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class ResultsChanal {
  String? id;
  String? chalanNo;
  int? status;
  Customer? customer;
  Null? discountScheme;
  String? discountRate;
  String? totalDiscount;
  String? totalTax;
  String? subTotal;
  String? totalDiscountableAmount;
  String? totalTaxableAmount;
  String? totalNonTaxableAmount;
  int? refOrderMaster;
  String? grandTotal;
  String? remarks;
  String? createdDateAd;
  String? createdDateBs;
  String? createdByUserName;
  String? statusDisplay;
  String? orderNo;
  Null? refChalanMaster;
  bool? returnDropped;

  ResultsChanal(
      {this.id,
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
        this.createdByUserName,
        this.statusDisplay,
        this.orderNo,
        this.refChalanMaster,
        this.returnDropped});

  ResultsChanal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chalanNo = json['chalan_no'];
    status = json['status'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    discountScheme = json['discount_scheme'];
    discountRate = json['discount_rate'];
    totalDiscount = json['total_discount'];
    totalTax = json['total_tax'];
    subTotal = json['sub_total'];
    totalDiscountableAmount = json['total_discountable_amount'];
    totalTaxableAmount = json['total_taxable_amount'];
    totalNonTaxableAmount = json['total_non_taxable_amount'];
    refOrderMaster = json['ref_order_master'];
    grandTotal = json['grand_total'];
    remarks = json['remarks'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    createdByUserName = json['created_by_user_name'];
    statusDisplay = json['status_display'];
    orderNo = json['order_no'];
    refChalanMaster = json['ref_chalan_master'];
    returnDropped = json['return_dropped'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chalan_no'] = this.chalanNo;
    data['status'] = this.status;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['discount_scheme'] = this.discountScheme;
    data['discount_rate'] = this.discountRate;
    data['total_discount'] = this.totalDiscount;
    data['total_tax'] = this.totalTax;
    data['sub_total'] = this.subTotal;
    data['total_discountable_amount'] = this.totalDiscountableAmount;
    data['total_taxable_amount'] = this.totalTaxableAmount;
    data['total_non_taxable_amount'] = this.totalNonTaxableAmount;
    data['ref_order_master'] = this.refOrderMaster;
    data['grand_total'] = this.grandTotal;
    data['remarks'] = this.remarks;
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['created_by_user_name'] = this.createdByUserName;
    data['status_display'] = this.statusDisplay;
    data['order_no'] = this.orderNo;
    data['ref_chalan_master'] = this.refChalanMaster;
    data['return_dropped'] = this.returnDropped;
    return data;
  }
}

class Customer {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? panVatNo;
  String? phoneNo;
  String? address;

  Customer(
      {this.id,
        this.firstName,
        this.middleName,
        this.lastName,
        this.panVatNo,
        this.phoneNo,
        this.address});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    panVatNo = json['pan_vat_no'];
    phoneNo = json['phone_no'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['pan_vat_no'] = this.panVatNo;
    data['phone_no'] = this.phoneNo;
    data['address'] = this.address;
    return data;
  }
}