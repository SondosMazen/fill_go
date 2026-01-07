import '../Model/BaseModel.dart';

class TSite extends BaseModel {
  int? oid;
  String? name;
  String? location;
  String? storageCapacity;
  String? notes;

  TSite({this.oid, this.name, this.location, this.storageCapacity, this.notes});

  factory TSite.fromJson(Map<String, dynamic> json) {
    return TSite(
      oid : json['oid'],
      name : json['name'],
      location : json['location'],
      storageCapacity : json['storage_capacity'],
      notes : json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oid'] = this.oid;
    data['name'] = this.name;
    data['location'] = this.location;
    data['storage_capacity'] = this.storageCapacity;
    data['notes'] = this.notes;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) => TSite.fromJson(json);
}
