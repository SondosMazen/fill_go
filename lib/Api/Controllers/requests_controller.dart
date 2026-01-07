// import 'dart:developer';
// import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:fill_go/Api/DioExceptions.dart';
// import 'package:fill_go/App/Constant.dart';
// import 'package:fill_go/Helpers/DialogHelper.dart';
// import 'package:fill_go/Helpers/snackbar_helper.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';

import '../DioHelper.dart';

class RequestsController {
  // static Future<Response> postEmpPhone({
  //   Map<String, dynamic>? body,
  //   Map<String, dynamic>? query,
  // }) {
  //   return DioHelper().post(
  //     "/public/api/EmpPhone",
  //     data: body,
  //     queryParameters: query,
  //   );
  // }

  static Future<Response> getSites({
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) {
    return DioHelper().get('api/rubble/get_sites', queryParameters: query);
    // return DioHelper().get("/public/api/Apps", queryParameters: query);
  }

  static Future<Response> getOrders({
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) {
    return DioHelper(
      // baseUrl: Constants.baseUrlCSApi,
    ).get("api/rubble/get_orders", queryParameters: query);
    // return DioHelper().get("/public/api/Apps", queryParameters: query);
  }

  static Future<Response> getDrivers({
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) {
    return DioHelper(
      // baseUrl: Constants.baseUrlCSApi,
    ).get("api/rubble/get_drivers", queryParameters: query);
    // return DioHelper().get("/public/api/Apps", queryParameters: query);
  }

  // static Future<void> downloadFile(
  //   String url,
  //   String fileName,
  //   bool isCSBase,
  // ) async {
  //   DialogHelper.showLoading();
  //   Directory tempDir = await getTemporaryDirectory();
  //   // File pdfFile = File((await getDownloadPath())! + '/'+ 'WaterBill' + vDate + '.pdf' );
  //   var dio = Dio();
  //   // DioHelperCS.
  //   // dio.options.baseUrl = Constants.baseUrlFlutterApi;
  //   dio.interceptors.add(
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) {
  //         options.headers["Authorization"] = "Bearer ${getToken()}";
  //         return handler.next(options); //continu
  //       },
  //       onResponse: (response, handler) {
  //         try {
  //           String headers = response.headers['content-disposition']!.last
  //               .toString();
  //           File file = File(
  //             '${tempDir.path}/temp.${headers.split('.').last.split('"').first}',
  //           );

  //           file.writeAsBytesSync(response.data);
  //           DialogHelper.hideLoading();
  //           // OpenFilex.open(
  //           //   file.path,
  //           // );
  //         } catch (e) {
  //           DialogHelper.hideLoading();
  //           // isLoading.value = false;
  //           SnackBarHelper.show(msg: 'فشل في عملية تحميل الفاتورة');
  //         }
  //         return handler.next(response); // continue
  //       },
  //       onError: (DioException e, handler) {
  //         final errorMessage = DioExceptions.fromDioException(e).toString();
  //         throw errorMessage;
  //       },
  //     ),
  //   );
  //   Response response = await dio.get(
  //     '${isCSBase ? Constants.baseUrlCSApi : Constants.baseUrlCSApi}$url',
  //     options: Options(responseType: ResponseType.bytes),
  //   );
  // }

  static Future<Response> postProcessOrder({
    required Map<String, dynamic> body,
    Map<String, dynamic>? query,
  }) {
    return DioHelper().post(
      "api/rubble/process_order",
      data: body,
      queryParameters: query,
    );
  }

  static Future<Response> postStoreOrder({
    required var body,
    Map<String, dynamic>? query,
  }) {
    return DioHelper().post(
      "api/rubble/store_order",
      data: body,
      queryParameters: query,
    );
  }

  // static Future<Response> postStatementInfoReport({
  //   required FormData body,
  //   Map<String, dynamic>? query,
  // }) {
  //   log('${body.fields}   ${body.boundaryName}  ${body.files}   */*/*/*/');
  //   var response = DioHelperCS(baseUrl: Constants.baseUrlCSApi).post(
  //     "/api/citizen/building_statement_order",
  //     data: body,
  //     queryParameters: query,
  //   );
  //   // log('from reposssss ${response}   ${response}');
  //   return response;
  // }

  // static Future<Response> deleteTempFile({
  //   required FormData body,
  //   Map<String, dynamic>? query,
  // }) {
  //   return DioHelperCS(baseUrl: Constants.baseUrlCSApi).post(
  //     "/api/citizen/delete_floor_temp_att",
  //     data: body,
  //     queryParameters: query,
  //   );
  // }
}
