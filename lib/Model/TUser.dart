// To parse this JSON data, do
//
//     final tUser = tUserFromJson(jsonString);

import 'dart:convert';

import 'package:fill_go/App/Constant.dart';
import 'package:fill_go/App/app.dart';
import 'package:fill_go/Model/BaseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

TUser tUserFromJson(String str) => TUser.fromJson(json.decode(str));

String tUserToJson(TUser data) => json.encode(data.toJson());

class TUser extends BaseModel {
  TUser({
    this.name,
    this.userName,
    this.isActive,
    this.userType,
    this.token,
    this.updatedAt,
    this.oid,
  });

  String? name;
  String? userName;
  String? isActive;
  String? userType;
  String? token;
  String? updatedAt;
  int? oid;

  factory TUser.fromJson(Map<String, dynamic> json) {
    if (json["oid"] is String) {
      TUser(oid: int.parse(json["oid"]));
    } else {
      TUser(oid: json["oid"]);
    }

    return TUser(
      name: json['name'],
      userName: json['user_name'],
      isActive: json['is_active'],
      userType: json['user_type'],
      token: json['token'],
      updatedAt: json['updated_at'],
      oid: json['oid'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'user_name': userName,
    'is_active': isActive,
    'user_type': userType,
    'token': token,
    'updated_at': updatedAt,
    'oid': oid,
  };

  @override
  fromJson(Map<String, dynamic> json) => TUser.fromJson(json);

  static Future<bool> isUserGuest() async {
    SharedPreferences shared = await Application.sharedPreferences;
    bool isGuest = shared.getBool(Constants.USER_IS_LOGIN) ?? false;

    return isGuest;
  }
}
