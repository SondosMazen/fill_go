import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rubble_app/Api/Controllers/requests_controller.dart';
import 'package:rubble_app/Api/DioExceptions.dart';
import 'package:rubble_app/Helpers/DialogHelper.dart';
import '../../Model/TSite.dart';
import '../../Model/TDriver.dart';
import '../../Model/TOrder.dart';
import '../BaseResponse.dart';

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
      log('message $e');
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
      log('message $e');
      throw '$e';
    }
    return baseResponse;
  }

  Future<BaseResponse<List<TOrder>>> getOrders({
    Map<String, dynamic>? map,
  }) async {
    BaseResponse<List<TOrder>> baseResponse;
    try {
      Response response;
      response = await RequestsController.getOrders();
      log('the response don ${response.data}');
      baseResponse = BaseResponse<List<TOrder>>().fromJson(response.data);
      log('the base response don');
    } catch (e) {
      log('message $e');
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
