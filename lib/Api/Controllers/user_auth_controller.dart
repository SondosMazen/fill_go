import 'package:dio/dio.dart';
import 'package:rubble_app/Api/DioHelper.dart';
import '../../App/Constant.dart';
import '../DioHelper.dart';

class UserAuthController {
 
   static UserAuthController instance = UserAuthController();

   static Future<Response> postUserAuthLogin(
       {required Map<String, dynamic> body, Map<String, dynamic>? query}) {
     return DioHelperApi(baseUrl: Constants.baseUrlMapps)
         .post("api/rubble/login", data: body, queryParameters: query);
   }

   static Future<Response> postUserAuthLogOut(
       {required Map<String, dynamic> body, Map<String, dynamic>? query}) {
     return DioHelperApi(baseUrl: Constants.baseUrlMapps)
         .get("api/rubble/logout", data: body, queryParameters: query);
   }

}
