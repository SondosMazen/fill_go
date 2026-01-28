import 'dart:convert';
import 'package:fill_go/App/Constant.dart';
import 'package:fill_go/App/app.dart';
import 'package:fill_go/Model/BaseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

TUser tUserFromJson(String str) => TUser.fromJson(json.decode(str));

String tUserToJson(TUser data) => json.encode(data.toJson());

enum UserType { inspector, contractor }

class TUser extends BaseModel {
  TUser({
    this.oid,
    this.name,
    this.userName,
    this.isActive = false,
    required this.userType,
    this.token,
    this.updatedAt,
  });

  int? oid;
  String? name;
  String? userName;
  bool isActive;
  final UserType userType;
  String? token;
  String? updatedAt;

  factory TUser.fromJson(Map<String, dynamic> json) {
    return TUser(
      oid: json['oid'] != null ? int.tryParse(json['oid'].toString()) : null,
      name: json['name'],
      userName: json['user_name'],
      isActive: json['is_active']?.toString() == '1',
      userType: () {
        final type = json['user_type']?.toString();
        switch (type) {
          // المفتش
          case '1':
            return UserType.inspector;
          // المراقب
          case '2':
            return UserType.contractor;
          default:
            return UserType.contractor; // قيمة افتراضية
        }
      }(),
      token: json['token'],
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
    SharedPreferences shared = Application.sharedPreferences;
    bool isGuest = shared.getBool(Constants.USER_IS_LOGIN) ?? false;

    return isGuest;
  }
}
