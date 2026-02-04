import 'dart:convert';
import 'package:rubble_app/App/Constant.dart';
import 'package:rubble_app/App/app.dart';
import 'package:rubble_app/Model/BaseModel.dart';
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
    this.rubbleSiteName,
  });

  int? oid;
  String? name;
  String? userName;
  bool isActive;
  final UserType userType;
  String? token;
  String? updatedAt;
  String? rubbleSiteName;

  factory TUser.fromJson(Map<String, dynamic> json) {
    return TUser(
      oid: json['oid'] != null ? int.tryParse(json['oid'].toString()) : null,
      name: json['name'],
      userName: json['user_name'],
      isActive: json['is_active']?.toString() == '1',
      userType: () {
        final type = json['user_type']?.toString();
        if (type == '1' || type.toString().contains('inspector')) {
          return UserType.inspector;
        } else if (type == '2' || type.toString().contains('contractor')) {
          return UserType.contractor;
        }
        return UserType.contractor; // Default
      }(),
      token: json['token'],
      rubbleSiteName: json['rubble_site_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'user_name': userName,
    'is_active': isActive,
    // Serialize enum to '1' or '2' matching the API/internal logic to ensure consistency
    'user_type': userType == UserType.inspector ? '1' : '2',
    'token': token,
    'updated_at': updatedAt,
    'oid': oid,
    'rubble_site_name': rubbleSiteName,
  };

  @override
  fromJson(Map<String, dynamic> json) => TUser.fromJson(json);

  static Future<bool> isUserGuest() async {
    SharedPreferences shared = Application.sharedPreferences;
    bool isGuest = shared.getBool(Constants.USER_IS_LOGIN) ?? false;

    return isGuest;
  }
}
