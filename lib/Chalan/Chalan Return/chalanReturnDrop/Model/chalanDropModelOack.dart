
class SalePackingTypeDetailCode {
  SalePackingTypeDetailCode({
    this.id,
    this.packingTypeDetailCode,
    this.code,
  });

  int ?id;
  int ?packingTypeDetailCode;
  String? code;

  factory SalePackingTypeDetailCode.fromJson(Map<String, dynamic> json) => SalePackingTypeDetailCode(
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
