import 'dart:collection';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fill_go/Api/Controllers/requests_controller.dart';
import 'package:fill_go/Api/DioExceptions.dart';
import 'package:fill_go/Helpers/DialogHelper.dart';
import '../../Model/TSite.dart';
import '../../Model/TDriver.dart';
import '../../Model/TOrder.dart';
import '../../Model/TSite.dart';

import '../BaseResponse.dart';
import '../Controllers/requests_controller.dart';

class RequestsRepo {
  static var instance = RequestsRepo();

  Future<BaseResponse<List<TSite>>> getSites({
    Map<String, dynamic>? map,
  }) async {
    BaseResponse<List<TSite>> baseResponse;
    try {
      Response response;
      response = await RequestsController.getSites(body: map);
      baseResponse = BaseResponse<List<TSite>>().fromJson(response.data);
      log('the base response don ${baseResponse.data}');
    } catch (e) {
      // DialogHelper.hideLoading();
      log('message $e');
      // final errorMessage = DioExceptions.fromDioException('$e').toString();
      throw '$e';
    }
    return baseResponse;
  }

  Future<BaseResponse<List<TDriver>>> getDrivers({
    Map<String, dynamic>? map,
  }) async {
    BaseResponse<List<TDriver>> baseResponse;
    try {
      Response response;
      response = await RequestsController.getDrivers(body: map);
      baseResponse = BaseResponse<List<TDriver>>().fromJson(response.data);
      log('the base response don ${baseResponse.data}');
    } catch (e) {
      // DialogHelper.hideLoading();
      log('message $e');
      // final errorMessage = DioExceptions.fromDioException('$e').toString();
      throw '$e';
    }
    return baseResponse;
  }

  Future<BaseResponse<List<TOrder>>> getOrders({
    Map<String, dynamic>? map,
  }) async {
    BaseResponse<List<TOrder>> baseResponse;
    try {
      // Map<String, dynamic> temp = {
      //   "status": true,
      //   "message": "تم جلب الطلبات بنجاح",
      //   "data": [
      //     {
      //       "oid": 43,
      //       "location": "غزة",
      //       "car_num": "1999",
      //       "car_type": "تيوتا",
      //       "rubble_site_oid": "1",
      //       "entry_user_oid": "1",
      //       "process_user_oid": null,
      //       "entry_notes": "طلب تجريبي",
      //       "process_notes": null,
      //       "order_num": "6",
      //       "entry_date": "2026-01-04",
      //       "process_date": null,
      //       "driver_oid": "1",
      //       "site": {
      //         "oid": 1,
      //         "name": "مكب 1",
      //         "location": "غزة",
      //         "area": "100 م",
      //         "storage_capacity": "500",
      //       },
      //       "entry_user": {"oid": 1, "name": "عمر ابوراس"},
      //       "process_user": null,
      //     },
      //     {
      //       "oid": 44,
      //       "location": "غزة النصر",
      //       "car_num": "1999",
      //       "car_type": "تيوتا",
      //       "rubble_site_oid": "1",
      //       "entry_user_oid": "1",
      //       "process_user_oid": null,
      //       "entry_notes": "طلب تجريبي",
      //       "process_notes": null,
      //       "order_num": "7",
      //       "entry_date": "2026-01-04",
      //       "process_date": null,
      //       "driver_oid": "1",
      //       "site": {
      //         "oid": 1,
      //         "name": "مكب 1",
      //         "location": "غزة",
      //         "area": "100 م",
      //         "storage_capacity": "500",
      //       },
      //       "entry_user": {"oid": 1, "name": "عمر ابوراس"},
      //       "process_user": null,
      //     },
      //     {
      //       "oid": 42,
      //       "location": "غزة",
      //       "car_num": "1999",
      //       "car_type": "تيوتا",
      //       "rubble_site_oid": "1",
      //       "entry_user_oid": "1",
      //       "process_user_oid": "1",
      //       "entry_notes": "طلب تجريبي",
      //       "process_notes": "1111",
      //       "order_num": "5",
      //       "entry_date": "2026-01-04",
      //       "process_date": "2026-01-04",
      //       "driver_oid": "1",
      //       "site": {
      //         "oid": 1,
      //         "name": "مكب 1",
      //         "location": "غزة",
      //         "area": "100 م",
      //         "storage_capacity": "500",
      //       },
      //       "entry_user": {"oid": 1, "name": "عمر ابوراس"},
      //       "process_user": {"oid": 1, "name": "عمر ابوراس"},
      //     },
      //   ],
      // };

      Response response;
      response = await RequestsController.getOrders(body: map);
      log('the response don ${response.data}');
      baseResponse = BaseResponse<List<TOrder>>().fromJson(response.data);
      log('the base response don');
    } catch (e) {
      // DialogHelper.hideLoading();
      log('message $e');
      // final errorMessage = DioExceptions.fromDioException('$e').toString();
      throw '$e';
    }
    return baseResponse;
  }

  Future<BaseResponse<String>> postProcessOrder({
    required Map<String, dynamic> body,
  }) async {
    BaseResponse<String> baseResponse;
    try {
      Response response = await RequestsController.postProcessOrder(body: body);

      baseResponse = BaseResponse<String>().fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw errorMessage;
    }
    return baseResponse;
  }

  Future<BaseResponse> postStoreOrder({
    required Map<String, dynamic> body,
  }) async {
    BaseResponse<String> baseResponse;
    try {
      Response response = await RequestsController.postStoreOrder(body: body);

      baseResponse = BaseResponse<String>().fromJson(response.data);
    } on DioException catch (e) {
      DialogHelper.hideLoading();
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw errorMessage;
    }
    return baseResponse;
  }
}
