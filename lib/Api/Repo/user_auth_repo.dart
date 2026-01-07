import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:fill_go/Api/Controllers/user_auth_controller.dart';
// import 'package:fill_go/Model/TMynotification.dart';
import 'package:fill_go/Model/TUser.dart';

import '../BaseResponse.dart';
// import '../Controllers/users_controller.dart';
import '../DioExceptions.dart';

class UserAuthRepo {
  static var instance = UserAuthRepo();
  Response? response;

  // Future<BaseResponse<TUser>> postUserAuthRegister(
  //     {required Map<String, dynamic> body,
  //     Map<String, dynamic>? query,
  //     bool isPopupLoading = false}) async {
  //   BaseResponse<TUser> baseResponse;
  //   try {
  //     response = await UserAuthController.postUserAuthRegister(
  //         body: body, query: query);

  //     baseResponse = BaseResponse<TUser>().fromJson(response!.data);
  //   } on DioException catch (e) {
  //     final errorMessage =
  //         DioExceptions.fromDioException(e, isPopupLoading: isPopupLoading)
  //             .toString();
  //   }
  //   baseResponse = BaseResponse<TUser>().fromJson(response?.data);
  //   return baseResponse;
  // }

  // Future<BaseResponse<List<int>>> postUserAuthUpdateData(
  //     {dynamic body,
  //     Map<String, dynamic>? query,
  //     bool isPopupLoading = false}) async {
  //   BaseResponse<List<int>> baseResponse;
  //   try {
  //     Response response = await UserAuthController.postUserAuthUpdateData(
  //         body: body, query: query);
  //     baseResponse = BaseResponse<List<int>>().fromJson(response.data);
  //   } on DioException catch (e) {
  //     final errorMessage =
  //         DioExceptions.fromDioException(e, isPopupLoading: isPopupLoading)
  //             .toString();
  //     throw errorMessage;
  //   }

  //   return baseResponse;
  // }

  // Future<BaseResponse<List<TUser>>?> getUserAuthProfile(
  //     {Map<String, dynamic>? query, bool isPopupLoading = false}) async {
  //   BaseResponse<List<TUser>> baseResponse;
  //   try {
  //     Response response =
  //         await UserAuthController.getUserAuthProfile(query: query);
  //     baseResponse = BaseResponse<List<TUser>>().fromJson(response.data);
  //   } on DioException catch (e) {
  //     final errorMessage =
  //         DioExceptions.fromDioException(e, isPopupLoading: isPopupLoading)
  //             .toString();
  //     throw errorMessage;
  //   }

  //   return baseResponse;
  // }

  // Future<BaseResponse> postUserAuthChangePassword(
  //     {required Map<String, dynamic> body,
  //     Map<String, dynamic>? query,
  //     bool isPopupLoading = false}) async {
  //   BaseResponse baseResponse;
  //   try {
  //     Response response = await UserAuthController.postUserAuthChangePassword(
  //         body: body, query: query);
  //     baseResponse = BaseResponse().fromJson(response.data);
  //   } on DioException catch (e) {
  //     final errorMessage =
  //         DioExceptions.fromDioException(e, isPopupLoading: isPopupLoading)
  //             .toString();
  //     throw errorMessage;
  //   }
  //   return baseResponse;
  // }

  // Future<BaseResponse<TUser>> postUserAuthForgetPass(
  //     {required Map<String, dynamic> body,
  //     Map<String, dynamic>? query,
  //     bool isPopupLoading = false}) async {
  //   BaseResponse<TUser> baseResponse;
  //   try {
  //     Response response = await UserAuthController.postUserAuthForgetPass(
  //         body: body, query: query);
  //     baseResponse = BaseResponse<TUser>().fromJson(response.data);
  //   } on DioException catch (e) {
  //     final errorMessage =
  //         DioExceptions.fromDioException(e, isPopupLoading: isPopupLoading)
  //             .toString();
  //     throw errorMessage;
  //   }

  //   return baseResponse;
  // }

  Future<BaseResponse<TUser>> postLogin(Map<String, dynamic> map) async {
    BaseResponse<TUser> baseResponse;
    try {
      Response response = await UserAuthController.instance.postUserAuthLogin(
        body: map,
      );
      // Map<String, dynamic> temp = {
      //   "status": true,
      //   "message": "تم تسجيل الدخول بنجاح",
      //   "data": {
      //     "oid": 1,
      //     "name": "عمر ابوراس",
      //     "user_name": "3088",
      //     "is_active": "1",
      //     "password":
      //         '\$2y\$10\$Z2lukWRcQgG/Rt8AiX0K..Ix8w6okCkHHhhZUz5ieBtbNfz5jUISK',
      //     "user_type": "2",
      //     "api_token":
      //         "69ef89cdeece4824f7f0c264730615cf4dd3a56bda7e03fe91c6cf15ddc43a7d",
      //     "updated_at": "2026-01-04T13:59:51.000000Z",
      //     "token":
      //         "VVEyqbLSIx9MYXpN25SSjr64Db25mljytiiVGMOV9r2ah5ovjUOm7FDk8yBE",
      //   },
      // };

      baseResponse = BaseResponse<TUser>().fromJson(
response.data
      );
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw errorMessage;
    }
    return baseResponse;
  }

  Future<void>? postUserAuthLogOut({
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) async {
    Response response = await UserAuthController.instance.postUserAuthLogOut(
      body: body,
      query: query,
    );
    // BaseResponse<String> baseResponse = response.data['message'];
    // return baseResponse;
  }

  // Future<BaseResponse<List<TMyNotification>>?> getMyNotification({
  //   Map<String, dynamic>? query,
  //   Map<String, dynamic>? body,
  //   bool isPopupLoading = false,
  // }) async {
  //   BaseResponse<List<TMyNotification>> baseResponse;
  //   try {
  //     Response response = await UserAuthController.getMyNotification(
  //       query: query,
  //       body: body,
  //     );
  //     baseResponse = BaseResponse<List<TMyNotification>>().fromJson(
  //       response.data,
  //     );
  //   } on DioException catch (e) {
  //     final errorMessage = DioExceptions.fromDioException(
  //       e,
  //       isPopupLoading: isPopupLoading,
  //     ).toString();
  //     throw errorMessage;
  //   }

  //   return baseResponse;
  // }

  // Future<BaseResponse<List<int>>?> postNotificationToggle({
  //   Map<String, dynamic>? query,
  //   Map<String, dynamic>? body,
  //   bool isPopupLoading = false,
  // }) async {
  //   BaseResponse<List<int>> baseResponse;
  //   try {
  //     Response response = await UserAuthController.postNotificationToggle(
  //       query: query,
  //       body: body,
  //     );
  //     baseResponse = BaseResponse<List<int>>().fromJson(response.data);
  //   } on DioException catch (e) {
  //     final errorMessage = DioExceptions.fromDioException(
  //       e,
  //       isPopupLoading: isPopupLoading,
  //     ).toString();
  //     throw errorMessage;
  //   }

  //   return baseResponse;
  // }
}
