import 'dart:developer';

import 'package:fill_go/Model/BaseModel.dart';

class TDriver extends BaseModel {
  int? oid;
  String? name;
  String? mobileNum;
  String? notes;

  TDriver({this.oid, this.name, this.mobileNum, this.notes});
  factory TDriver.fromJson(Map<String, dynamic> json) {
    return TDriver(
      oid: json['oid'],
      name: json['name'],
      mobileNum: json['mobile_num'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['name'] = name;
    data['mobile_num'] = mobileNum;
    data['notes'] = notes;
   
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) => TDriver.fromJson(json);
}
