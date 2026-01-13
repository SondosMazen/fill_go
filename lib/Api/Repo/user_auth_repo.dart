import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fill_go/Api/Controllers/user_auth_controller.dart';
import 'package:fill_go/Model/TUser.dart';
import '../BaseResponse.dart';
import '../DioExceptions.dart';

class UserAuthRepo {
  static var instance = UserAuthRepo();

  Future<BaseResponse<TUser>> postLogin(Map<String, dynamic> map) async {
    BaseResponse<TUser> baseResponse;
    try {
      Response response = await UserAuthController.postUserAuthLogin(body: map);

      // (مثلا اسم المستخدم غير موجود)
      if (response.data != null &&
          response.data is Map &&
          response.data.containsKey("errors")) {
        throw jsonEncode(response.data);
      }

      // حالة كلمة المرور غير صحيحة
      if (response.data != null &&
          response.data is Map &&
          (response.data["status"] == "error" || response.data["status"] == "failed")) {
        throw jsonEncode(response.data);
      }

      baseResponse = BaseResponse<TUser>().fromJson(response.data);

    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode ?? 0;
        final data = e.response?.data;

        if (statusCode == 422 && data != null && data is Map) {
          throw jsonEncode(data); // أي خطأ 422
        }
      }
      throw DioExceptions.fromDioException(e);
    }
    return baseResponse;
  }

  Future<BaseResponse<String>> Logout(Map<String, dynamic> map) async {
    BaseResponse<String> baseResponse;
    try {
      Response response = await UserAuthController.postUserAuthLogOut(body: map);
      baseResponse = BaseResponse<String>().fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw errorMessage;
    }
    return baseResponse;
  }
}
