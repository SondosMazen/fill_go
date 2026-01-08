import 'package:dio/dio.dart';
import 'package:fill_go/Api/DioHelper.dart';

import '../../App/Constant.dart';
import '../DioHelper.dart';

class UserAuthController {
 
   static UserAuthController instance = UserAuthController();

  //  Future<Response> postUserAuthLogin(
  //     {required Map<String, dynamic> body, Map<String, dynamic>? query}) {
  //   return DioHelper()
  //       .post("api/rubble/login", data: body, queryParameters: query);
  // }

   static Future<Response> postUserAuthLogin(
       {required Map<String, dynamic> body, Map<String, dynamic>? query}) {
     return DioHelperApi(baseUrl: Constants.baseUrlMapps)
         .post("api/rubble/login", data: body, queryParameters: query);
   }

   // static Future<Response> postUserAuthUpdateData(
  //     {dynamic body, Map<String, dynamic>? query}) {
  //   return DioHelper()
  //       .post("/public/api/UpdateUser", data: body, queryParameters: query);
  // }

  // static Future<Response> postUserAuthForgetPass(
  //     {required Map<String, dynamic> body, Map<String, dynamic>? query}) {
  //   return DioHelper()
  //       .post("/public/api/ForgetPass", data: body, queryParameters: query);
  // }

   static Future<Response> postUserAuthLogOut(
       {required Map<String, dynamic> body, Map<String, dynamic>? query}) {
     return DioHelperApi(baseUrl: Constants.baseUrlMapps)
         .get("api/rubble/logout", data: body, queryParameters: query);
   }

  //  Future<Response> postUserAuthLogOut(
  //     {Map<String, dynamic>? body, Map<String, dynamic>? query}) {
  //   return DioHelper().post("api/rubble/logout", data: body, queryParameters: query);
  // }

  // static Future<Response> postUserAuthChangePassword(
  //     {required Map<String, dynamic> body, Map<String, dynamic>? query}) {
  //   return DioHelper()
  //       .post("/public/api/ChangePass", data: body, queryParameters: query);
  // }

  // static Future<Response> getUserAuthProfile({Map<String, dynamic>? query}) {
  //   return DioHelper().get("/public/api/AuthUser", queryParameters: query);
  // }

  // static Future<Response> getMyNotification(
  //     {required Map<String, dynamic>? body, Map<String, dynamic>? query}) {
  //   return DioHelper()
  //       .get("/public/api/MyNotification", queryParameters: query);
  // }

  // static Future<Response> postNotificationToggle(
  //     {required Map<String, dynamic>? body, Map<String, dynamic>? query}) {
  //   return DioHelper().post("/public/api/NotificationToggle",
  //       queryParameters: query, data: body);
  // }
}
