import 'dart:developer';

import 'package:fill_go/Model/BaseModel.dart';

class TOrder extends BaseModel {
  int? oid;
  String? location;
  String? carNum;
  String? carType;
  String? rubbleSiteOid;
  String? entryUserOid;
  String? processUserOid;
  String? entryNotes;
  String? processNotes;
  String? orderNum;
  String? entryDate;
  String? processDate;
  String? driverOid;
  Site? site;
  EntryUser? entryUser;
  EntryUser? processUser;

  TOrder({
    this.oid,
    this.location,
    this.carNum,
    this.carType,
    this.rubbleSiteOid,
    this.entryUserOid,
    this.processUserOid,
    this.entryNotes,
    this.processNotes,
    this.orderNum,
    this.entryDate,
    this.processDate,
    this.driverOid,
    this.site,
    this.entryUser,
    this.processUser,
  });
  factory TOrder.fromJson(Map<String, dynamic> json) {
    log('in Torder json');
    return TOrder(
      oid: json['oid'],
      location: json['location'],
      carNum: json['car_num'],
      carType: json['car_type'],
      rubbleSiteOid: json['rubble_site_oid'],
      entryUserOid: json['entry_user_oid'],
      processUserOid: json['process_user_oid'],
      entryNotes: json['entry_notes'],
      processNotes: json['process_notes'],
      orderNum: json['order_num'],
      entryDate: json['entry_date'],
      processDate: json['process_date'],
      driverOid: json['driver_oid'],
      site: json['site'] != null ? Site.fromJson(json['site']) : null,
      entryUser: json['entry_user'] != null
          ? EntryUser.fromJson(json['entry_user'])
          : null,
      processUser: json['process_user'] != null
          ? EntryUser.fromJson(json['process_user'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['location'] = location;
    data['car_num'] = carNum;
    data['car_type'] = carType;
    data['rubble_site_oid'] = rubbleSiteOid;
    data['entry_user_oid'] = entryUserOid;
    data['process_user_oid'] = processUserOid;
    data['entry_notes'] = entryNotes;
    data['process_notes'] = processNotes;
    data['order_num'] = orderNum;
    data['entry_date'] = entryDate;
    data['process_date'] = processDate;
    data['driver_oid'] = driverOid;
    if (site != null) {
      data['site'] = site!.toJson();
    }
    if (entryUser != null) {
      data['entry_user'] = entryUser!.toJson();
    }
    if (processUser != null) {
      data['process_user'] = processUser!.toJson();
    }
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) => TOrder.fromJson(json);
}

class Site {
  int? oid;
  String? name;
  String? location;
  String? area;
  String? storageCapacity;

  Site({this.oid, this.name, this.location, this.area, this.storageCapacity});

  Site.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    name = json['name'];
    location = json['location'];
    area = json['area'];
    storageCapacity = json['storage_capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['name'] = name;
    data['location'] = location;
    data['area'] = area;
    data['storage_capacity'] = storageCapacity;
    return data;
  }
}

class EntryUser {
  int? oid;
  String? name;

  EntryUser({this.oid, this.name});

  EntryUser.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['name'] = name;
    return data;
  }
}
