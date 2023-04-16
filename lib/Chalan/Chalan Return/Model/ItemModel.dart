class AddItemModel {
  int? id;
  String? name;
  double? quantity;
  double? price;
  double? amount;
  double? discount;
  double? discountAmt;
  double? totalAfterDiscount;
  String? deliveryLocation;
  String? deliveryDate;
  bool? action;
  int? itemcategory;
  String? remarks;

  AddItemModel(
      {this.id,
        this.name,
        this.quantity,
        this.amount,
        this.discount,
        this.deliveryDate,
        this.deliveryLocation,
        this.price,
        this.discountAmt,
        this.totalAfterDiscount,
        this.action,
        this.itemcategory,
        this.remarks});
}
