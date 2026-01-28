import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import '../Model/TOrder.dart';
import '../Model/TSite.dart';
import '../Model/TUser.dart';

import '../Model/TDriver.dart';

class BaseResponse<T> {
  BaseResponse({
    this.status,
    this.message,
    this.errors,
    this.data,
    this.msg,
    this.items,
    this.pagination,
  });

  bool? status;
  bool isNestedEmpPhone = true;

  String? message;
  dynamic errors;
  T? data;
  Map<String, dynamic>? pagination;
  T? msg;
  T? items;

  BaseResponse<T> fromJson(LinkedHashMap<String, dynamic> json) {
    return BaseResponse(
      status: json["status"],
      message: json["message"],
      pagination: json["pagination"],

      errors: json["errors"],
      data: checkAllList(json),
      msg: json["msg"] == null ? null : genericCheck(json["msg"]) as T?,
      items: json["items"] == null ? null : genericCheck(json["items"]) as T?,
    );
  }

  BaseResponse baseResponseFromJson(String str) => fromJson(json.decode(str));

  dynamic genericCheck(dynamic json) {
    log('the genericChick json ${json.runtimeType} $T');
    log('the genericChick json $json');

    if (json is Map<String, dynamic>) {
      if (T == TUser) {
        return TUser.fromJson(json);
      }
    } else if (json is List) {
      if (T == List<TOrder>) {
        return json.map((uint) => TOrder.fromJson(uint)).toList();
      }
      if (T == List<TDriver>) {
        return json.map((uint) => TDriver.fromJson(uint)).toList();
      }
      if (T == List<TSite>) {
        return json.map((uint) => TSite.fromJson(uint)).toList();
      }
    } else {
      return json;
    }
  }

  T? checkAllList(dynamic json) {
    log('go to chick type');
    T? data;
    for (String keyName in listNames) {
      if (json.keys.contains(keyName)) {
        data = genericCheck(json[keyName]);
        break;
      }
    }

    return data;
  }

  var listNames = ["data", "items"];
}
