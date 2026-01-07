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
  List? errors;
  T? data;
  Map<String, dynamic>? pagination;
  T? msg;
  T? items;

  // List<TCurrentCouncil>? tCurrentCouncils;
  // List<TCouncilMembers>? tCouncilMembers;

  // String baseResponseToJson(BaseResponse data) => json.encode(data.toJson());

  BaseResponse<T> fromJson(LinkedHashMap<String, dynamic> json) {
    // log('${json['data']['per_page']}');

    return BaseResponse(
      status: json["status"],
      message: json["message"],
      pagination: json["pagination"],
      // ??
      //     {
      //       'per_page': json['data']['per_page'],
      //       'next_page_url': json['data']['next_page_url']
      //     }
      errors: json["errors"],
      data: checkAllList(json),
      msg: json["msg"] == null ? null : genericCheck(json["msg"]) as T?,
      items: json["items"] == null ? null : genericCheck(json["items"]) as T?,
      // items: json["items"] == null ? null : genericCheck(json["items"]) as T?,
      // tCurrentCouncils: json["currentCouncils"] == null
      //     ? null
      //     : getCurrentCouncil(json["currentCouncils"]),
      // tCouncilMembers: json["councilMembers"] == null
      //     ? null
      //     : getCouncilMember(json["councilMembers"]),
    );
  }

  BaseResponse baseResponseFromJson(String str) => fromJson(json.decode(str));

  dynamic genericCheck(dynamic json) {
    log('the genericChick json ${json.runtimeType} $T');
    log('the genericChick json $json');
    // if (json is Map<String, dynamic>) {
    //   // if (T == List<TESApps>) {
    //   //   List<TESApps> list = List.empty(growable: true);
    //   //   for (int count = 0; count < json['data'].length; count++) {
    //   //     list.add(TESApps.fromJson(json['data'][count]));
    //   //   }
    //   //   return list;
    //   // }

    //   // if (T == List<TApps>) {
    //   //   List<TApps> list = List.empty(growable: true);
    //   //   for (int count = 0; count < json['data'].length; count++) {
    //   //     list.add(TApps.fromJson(json['data'][count]));
    //   //   }
    //   //   return list;
    //   // }

    //   if (T == String) {
    //     return json;
    //   } else {
    //     return null;
    //   }
    // } else if (json is List) {
    //   // if (T == TESApps) {
    //   //   return json
    //   //       .map((data) =>
    //   //           TESApps.fromJson({'data': data, 'pagination': pagination}))
    //   //       .toList();
    //   // }
    //   // if (T == List<TNewsList>) {
    //   //   return json.map((treatment) => TNewsList.fromJson(treatment)).toList();
    //   // }
    //   // if (T == List<BuildingDocuments>) {
    //   //   return json.map((doc) {
    //   //     return BuildingDocuments.fromJson(doc);
    //   //   }).toList();
    //   // }
    //   // if (T == List<TUnit>) {
    //   //   return json.map((uint) => TUnit.fromJson(uint)).toList();
    //   // }
    // }

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




// {
//     "status": true,
//     "message": "تم جلب   المعاملات بنجاح",
//     "data": {
//         "current_page": 1,
//         "data": [...],
//         "first_page_url": "https://cs.mogaza.org/api/citizen/get_apps?page=1",
//         "from": 1,
//         "last_page": 7,
//         "last_page_url": "https://cs.mogaza.org/api/citizen/get_apps?page=7",
//         "links": [...],
//         "next_page_url": "https://cs.mogaza.org/api/citizen/get_apps?page=2",
//         "path": "https://cs.mogaza.org/api/citizen/get_apps",
//         "per_page": 10,
//         "prev_page_url": null,
//         "to": 10,
//         "total": 70
//     }
// }



// {
//     "status": true,
//     "message": "Success",
//     "data": [...],
//     "pagination": {
//         "current_page": 1,
//         "first_page_url": "https://gaza-city.org/MServices/AllMobileAds?page=1",
//         "from": 1,
//         "last_page": 180,
//         "last_page_url": "https://gaza-city.org/MServices/AllMobileAds?page=180",
//         "links": [...],
//         "next_page_url": "https://gaza-city.org/MServices/AllMobileAds?page=2",
//         "path": "https://gaza-city.org/MServices/AllMobileAds",
//         "per_page": 5,
//         "prev_page_url": null,
//         "to": 5,
//         "total": 900
//     }
// }