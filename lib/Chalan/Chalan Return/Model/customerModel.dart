class CustomerModel {
  String? id;
  String? firstName;
  String? middleName;
  String? lastName;


  CustomerModel({this.id, this.firstName, this.middleName, this.lastName});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;

    return data;
  }
}

class ItemModal {
  int? id;
  String? name;
  String? remaining_qty;
  bool? taxable;
  double? tax_rate;
  double? item_sale_cost;


  ItemModal({this.id, this.name, this.remaining_qty,this.taxable,this.tax_rate,this.item_sale_cost});

  ItemModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    remaining_qty = json['remaining_qty'];
    taxable = json ['taxable'];
    tax_rate= json['tax_rate'];
    item_sale_cost= json['item_sale_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['remaining_qty'] = remaining_qty;
    data['taxable']= taxable;
    data['tax_rate']=tax_rate;
    data['item_sale_cost']=item_sale_cost;
    return data;
  }
}
