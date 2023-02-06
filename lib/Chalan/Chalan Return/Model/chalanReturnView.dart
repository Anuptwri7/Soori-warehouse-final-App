class ChalanReturnView {
  int? count;
  String? next;
  Null? previous;
  List<Results>? results;

  ChalanReturnView({this.count, this.next, this.previous, this.results});

  ChalanReturnView.fromJson(Map<String, dynamic> json) {
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
  int? item;
  int? itemCategory;
  String? qty;
  String? saleCost;
  bool? discountable;
  bool? taxable;
  String? taxRate;
  String? taxAmount;
  String? discountRate;
  String? discountAmount;
  String? grossAmount;
  String? netAmount;
  int? refOrderDetail;
  int? refPurchaseDetail;
  String? itemCategoryName;
  String? itemName;
  String? remarks;

  Results(
      {this.id,
        this.item,
        this.itemCategory,
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
        this.refOrderDetail,
        this.refPurchaseDetail,
        this.itemCategoryName,
        this.itemName,
        this.remarks});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    item = json['item'];
    itemCategory = json['item_category'];
    qty = json['qty'];
    saleCost = json['sale_cost'];
    discountable = json['discountable'];
    taxable = json['taxable'];
    taxRate = json['tax_rate'];
    taxAmount = json['tax_amount'];
    discountRate = json['discount_rate'];
    discountAmount = json['discount_amount'];
    grossAmount = json['gross_amount'];
    netAmount = json['net_amount'];
    refOrderDetail = json['ref_order_detail'];
    refPurchaseDetail = json['ref_purchase_detail'];
    itemCategoryName = json['item_category_name'];
    itemName = json['item_name'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item'] = this.item;
    data['item_category'] = this.itemCategory;
    data['qty'] = this.qty;
    data['sale_cost'] = this.saleCost;
    data['discountable'] = this.discountable;
    data['taxable'] = this.taxable;
    data['tax_rate'] = this.taxRate;
    data['tax_amount'] = this.taxAmount;
    data['discount_rate'] = this.discountRate;
    data['discount_amount'] = this.discountAmount;
    data['gross_amount'] = this.grossAmount;
    data['net_amount'] = this.netAmount;
    data['ref_order_detail'] = this.refOrderDetail;
    data['ref_purchase_detail'] = this.refPurchaseDetail;
    data['item_category_name'] = this.itemCategoryName;
    data['item_name'] = this.itemName;
    data['remarks'] = this.remarks;
    return data;
  }
}