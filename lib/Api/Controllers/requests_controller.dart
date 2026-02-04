import 'package:dio/dio.dart';
import '../DioHelper.dart';

class RequestsController {
  static Future<Response> getSites({
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) {
    return DioHelperApi().get('api/rubble/get_sites', queryParameters: query);
  }

  static Future<Response> getStatistics({Map<String, dynamic>? query}) {
    return DioHelperApi().get('api/rubble/statistic', queryParameters: query);
  }

  static Future<Response> getOrders({
    // Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) {
    return DioHelperApi().get("api/rubble/get_orders", queryParameters: query);
  }

  static Future<Response> getDrivers({
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) {
    return DioHelperApi().get("api/rubble/get_drivers", queryParameters: query);
  }

  static Future<Response> postProcessOrder({
    required Map<String, dynamic> body,
    Map<String, dynamic>? query,
  }) {
    return DioHelperApi().post(
      "api/rubble/process_order",
      data: body,
      queryParameters: query,
    );
  }

  static Future<Response> postStoreOrder({
    required var body,
    Map<String, dynamic>? query,
  }) {
    return DioHelperApi().post(
      "api/rubble/store_order",
      data: body,
      queryParameters: query,
    );
  }
}
