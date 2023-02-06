class BranchesModel {
  BranchesModel({
    this.id,
    this.name,
    this.schemaName,
    this.subDomain,
    this.active,
  });

  BranchesModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    schemaName = json['schema_name'];
    subDomain = json['sub_domain'];
    active = json['active'];
  }
  int? id;
  String? name;
  String? schemaName;
  String? subDomain;
  bool? active;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['schema_name'] = schemaName;
    map['sub_domain'] = subDomain;
    map['active'] = active;
    return map;
  }
}
