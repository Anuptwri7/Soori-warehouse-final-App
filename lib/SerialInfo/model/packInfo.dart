class SerialInfo {
  int? id;
  String? code;
  String? itemName;
  String? itemCategoryName;
  String? batchNo;
  String? packTypeCode;
  String? locationCode;

  SerialInfo(
      {this.id,
        this.code,
        this.itemName,
        this.itemCategoryName,
        this.batchNo,
        this.packTypeCode,
        this.locationCode});

  SerialInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    itemName = json['item_name'];
    itemCategoryName = json['item_category_name'];
    batchNo = json['batch_no'];
    packTypeCode = json['pack_type_code'];
    locationCode = json['location_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['item_name'] = this.itemName;
    data['item_category_name'] = this.itemCategoryName;
    data['batch_no'] = this.batchNo;
    data['pack_type_code'] = this.packTypeCode;
    data['location_code'] = this.locationCode;
    return data;
  }
}