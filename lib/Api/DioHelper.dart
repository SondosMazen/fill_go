import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioFormData;
import '../App/app.dart';

import '../App/Constant.dart';

String token = "";

Dio DioHelper({bool isGazaCityBaseURL = false}) {
  Dio dio = Dio();
  dio.options.baseUrl = Constants.baseUrlMapps;
  dio.options.responseType = ResponseType.json;
  dio.options.connectTimeout =
      const Duration(milliseconds: Constants.connectionTimeout);
  dio.options.headers = {
    "Authorization": getToken(),
  };
  dio.interceptors.add(dioLoggerInterceptor);
  dio.interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
  ));
  return dio;
}

// Dio DioHelperCS({String baseUrl = Constants.baseUrlMapps}) {
//   Dio dio = Dio();
//   dio.options.baseUrl = baseUrl;
//   dio.options.responseType = ResponseType.json;
//   dio.options.connectTimeout =
//       const Duration(milliseconds: Constants.connectionTimeout);
//   dio.options.headers = {
//     "Authorization": getToken(),
//   };
//   dio.interceptors.add(dioLoggerInterceptor);
//   dio.interceptors.add(LogInterceptor(
//     request: true,
//     requestHeader: true,
//     requestBody: true,
//     responseHeader: true,
//     responseBody: true,
//   ));

//   return dio;
// }

final dioLoggerInterceptor =
    InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
  String headers = "";
  options.headers.forEach((key, value) {
    headers += "| $key: $value";
  });
  print(
      "┌------------------------------------------------------------------------------");
  print('''| [DIO] Request: ${options.method} ${options.uri}
| ${options.data.toString()}
| Headers:\n$headers''');
  print(
      "├------------------------------------------------------------------------------");
  handler.next(options); //continue
}, onResponse: (Response response, handler) async {
  print(
      "| [DIO] Response [code ${response.statusCode}]: ${response.data.toString()}");
  print(
      "└------------------------------------------------------------------------------");
  handler.next(response);
  // return response; // continue
}, onError: (DioException error, handler) async {
  print("| [DIO] Error: ${error.error}: ${error.response?.toString()}");
  print(
      "└------------------------------------------------------------------------------");
  handler.next(error); //continue
});

String getToken() {
  if (Application.staticSharedPreferences == null) return "";
  String? auth =
      Application.staticSharedPreferences?.getString(Constants.USER_AUTH_TOKEN);
  return "Bearer $auth";
}

Future<FormData> addFormDataToJson(
    {jsonKey, filePath, fileName, Map<String, dynamic>? jsonObject}) async {
  jsonObject![jsonKey] = await dioFormData.MultipartFile.fromFile(
    filePath,
    filename: fileName,
  );
  return dioFormData.FormData.fromMap(jsonObject);
}
