import 'dart:math';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioPackage;
import 'package:dio/dio.dart' as dioFormData;import '../App/app.dart';
import 'package:get/get.dart' hide FormData, Response;
import '../App/Constant.dart';
import '../core/services/storage_service.dart';
import '../core/services/token_service.dart';
import '../presentation/controllers/auth_controller.dart';

String token = "";

// DioHelper الرئيسي
dioPackage.Dio DioHelper({bool isGazaCityBaseURL = false}) {
  dioPackage.Dio _dio = dioPackage.Dio();
  _dio.options.responseType = dioPackage.ResponseType.json;
  // _dio.options.connectTimeout =
  // const Duration(milliseconds: Constants.connectionTimeout);
  _dio.options.connectTimeout = const Duration(seconds: 30); // بدل 15 ثانية
  _dio.options.receiveTimeout = const Duration(seconds: 30);

  _dio.options.headers = {
    "Authorization": getToken(),
  };

  _dio.interceptors.add(_dioInterceptor());
  _dio.interceptors.add(dioPackage.LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
  ));

  return _dio;
}

// DioHelperApi مع baseUrl
dioPackage.Dio DioHelperApi({String baseUrl = Constants.baseUrlMapps}) {
  dioPackage.Dio _dio = dioPackage.Dio(dioPackage.BaseOptions(
    baseUrl: baseUrl,
    responseType: dioPackage.ResponseType.json,
    connectTimeout: const Duration(milliseconds: Constants.connectionTimeout),
    followRedirects: false, // منع التحويل التلقائي
    validateStatus: (status) => status != null && status < 500,
  ));

  _dio.interceptors.add(_dioInterceptor());
  _dio.interceptors.add(dioPackage.LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
  ));

  return _dio;
}

// Interceptor موحد لكل الطلبات
dioPackage.InterceptorsWrapper _dioInterceptor() =>
    dioPackage.InterceptorsWrapper(
      onRequest: (options, handler) {
        String? token =
        Application.sharedPreferences.getString(Constants.USER_AUTH_TOKEN);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onResponse: (response, handler) async {
        // التقاط 401 أو رسائل انتهاء صلاحية التوكن حتى عندما لا ترمى كأخطاء بسبب validateStatus
        bool unauthorized = response.statusCode == 401;

        // التحقق من 302 redirect إلى redirect_if_not_auth
        if (response.statusCode == 302 || response.statusCode == 301) {
          final location = response.headers.value('location');
          if (location != null && location.contains('redirect_if_not_auth')) {
            print(
                '❌ تم اكتشاف 302 redirect إلى redirect_if_not_auth - التوكن منتهي');
            unauthorized = true;
          }
        }

        try {
          final data = response.data;
          String? msg;
          if (data is Map) {
            msg = (data['message'] ?? data['msg'] ?? data['error'])?.toString();
          } else if (data is String) {
            msg = data;
            // التحقق من HTML redirect في الاستجابة
            if (msg.contains('redirect_if_not_auth') ||
                msg.contains('Redirecting to')) {
              print('❌ تم اكتشاف HTML redirect في الاستجابة - التوكن منتهي');
              unauthorized = true;
            }
          }
          if (msg != null) {
            final lower = msg.toLowerCase();
            if (msg.contains('غير مصرح') ||
                msg.contains('التوكن') ||
                lower.contains('unauthor') ||
                lower.contains('invalid token')) {
              unauthorized = true;
            }
          }
          // التحقق من WWW-Authenticate في الهيدر
          final www = response.headers.value('www-authenticate')?.toLowerCase();
          if (www != null && www.contains('bearer')) {
            unauthorized = true;
          }
        } catch (_) {}

        if (unauthorized) {
          print('❌ تم اكتشاف استجابة غير مصرح بها (onResponse)');
          await _clearAllAuthData();
          if (Get.isDialogOpen ?? false) Get.back();
          Future.delayed(Duration.zero, () {
            if (Get.currentRoute != '/login') {
              Get.offAllNamed('/login');
            }
          });
          return handler.reject(
            dioPackage.DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: dioPackage.DioExceptionType.badResponse,
              error: 'Unauthorized',
            ),
          );
        }

        handler.next(response);
      },
      onError: (dioPackage.DioException e, handler) async {
        if (e.response?.statusCode == 401 ||
            (e.response?.data is Map &&
                e.response?.data['message'] == "التوكن غير صالح") ||
            (e.response?.data is Map &&
                e.response?.data['message'] == "غير مصرح، يرجى تسجيل الدخول")) {
          print('❌ التوكن غير صالح أو منتهي الصلاحية');

          // مسح جميع بيانات المصادقة
          await _clearAllAuthData();

          // إغلاق أي ديالوج مفتوح
          if (Get.isDialogOpen ?? false) Get.back();

          // التوجيه لشاشة تسجيل الدخول
          Future.delayed(Duration.zero, () {
            if (Get.currentRoute != '/login') {
              Get.offAllNamed('/login');
            }
          });
        }
        handler.next(e);
      },
    );

// دالة لمسح جميع بيانات المصادقة من كل الخدمات
Future<void> _clearAllAuthData() async {
  try {
    print('🧹 بدء مسح جميع بيانات المصادقة...');

    // 1. مسح من SharedPreferences
    await Application.sharedPreferences.remove(Constants.USER_AUTH_TOKEN);
    await Application.sharedPreferences.remove(Constants.USER_DATA);
    await Application.sharedPreferences.remove(Constants.USER_IS_LOGIN);
    print('✅ تم مسح البيانات من SharedPreferences');

    // 2. مسح من StorageService (GetStorage)
    if (Get.isRegistered<StorageService>()) {
      try {
        final storageService = Get.find<StorageService>();
        await storageService.clearAuthData();
        print('✅ تم مسح البيانات من StorageService');
      } catch (e) {
        print('⚠️ خطأ في مسح StorageService: $e');
      }
    }

    // 3. مسح من TokenService
    if (Get.isRegistered<TokenService>()) {
      try {
        final tokenService = Get.find<TokenService>();
        await tokenService.clearToken();
        print('✅ تم مسح التوكن من TokenService');
      } catch (e) {
        print('⚠️ خطأ في مسح TokenService: $e');
      }
    }

    // 4. إعادة تعيين حالة AuthController
    if (Get.isRegistered<AuthController>()) {
      try {
        final authController = Get.find<AuthController>();
        authController.setLoggedOut();
        print('✅ تم تحديث حالة AuthController');
      } catch (e) {
        print('⚠️ خطأ في تحديث AuthController: $e');
      }
    }

    print('✅ تم مسح جميع بيانات المصادقة بنجاح');
  } catch (e) {
    print('❌ خطأ في مسح بيانات المصادقة: $e');
  }
}

//
// // دالة لمسح جميع بيانات المصادقة من كل الخدمات
// Dio DioHelper({bool isGazaCityBaseURL = false}) {
//   Dio dio = Dio();
//   dio.options.baseUrl = Constants.baseUrlMapps;
//   dio.options.responseType = ResponseType.json;
//   dio.options.connectTimeout = const Duration(milliseconds: Constants.connectionTimeout);
//
//   // احصل على الـ token
//   String? authHeader = getToken();
//
//   // أضف الـ header فقط إذا كان token موجود
//   if (authHeader != null) {
//     dio.options.headers = {
//       "Authorization": authHeader,
//     };
//   } else {
//     // لا تضيف header إذا لم يكن هناك token
//     dio.options.headers = {};
//     print('⚠️ No auth token added to headers');
//   }
//
//   dio.interceptors.add(dioLoggerInterceptor);
//   dio.interceptors.add(LogInterceptor(
//     request: true,
//     requestHeader: true,
//     requestBody: true,
//     responseHeader: true,
//     responseBody: true,
//   ));
//
//   // أضف interceptor للتعامل مع 401
//   dio.interceptors.add(InterceptorsWrapper(
//     onError: (DioException error, handler) async {
//       if (error.response?.statusCode == 401) {
//         print('🚨 401 Unauthorized - Token may be invalid or expired');
//
//         // أعد توجيه المستخدم لشاشة Login
//         // أو حاول تجديد الـ token هنا
//
//         // مثال: إرسال حدث لتسجيل الخروج
//         // Get.find<AuthController>().logout();
//
//         // أو إعادة التوجيه مباشرة
//         // Get.offAllNamed('/login');
//       }
//       return handler.next(error);
//     },
//   ));
//
//   return dio;
// }
/// ///
// final dioLoggerInterceptor =
//     InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
//   String headers = "";
//   options.headers.forEach((key, value) {
//     headers += "| $key: $value";
//   });
//   print(
//       "┌------------------------------------------------------------------------------");
//   print('''| [DIO] Request: ${options.method} ${options.uri}
// | ${options.data.toString()}
// | Headers:\n$headers''');
//   print(
//       "├------------------------------------------------------------------------------");
//   handler.next(options); //continue
// }, onResponse: (Response response, handler) async {
//   print(
//       "| [DIO] Response [code ${response.statusCode}]: ${response.data.toString()}");
//   print(
//       "└------------------------------------------------------------------------------");
//   handler.next(response);
//   // return response; // continue
// }, onError: (DioException error, handler) async {
//   print("| [DIO] Error: ${error.error}: ${error.response?.toString()}");
//   print(
//       "└------------------------------------------------------------------------------");
//   handler.next(error); //continue
// });
//
// String? getToken() {
//   if (Application.staticSharedPreferences == null) return null;
//
//   String? auth = Application.staticSharedPreferences?.getString(Constants.USER_AUTH_TOKEN);
//
//   // تحقق من وجود وقيمة الـ token
//   if (auth == null || auth.isEmpty) {
//     print('⚠️ Token is null or empty!');
//     return null;
//   }
//
//   print('✅ Token found: ${auth.substring(0, min(20, auth.length))}...');
//   return "Bearer $auth";
// }
//
// Future<FormData> addFormDataToJson(
//     {jsonKey, filePath, fileName, Map<String, dynamic>? jsonObject}) async {
//   jsonObject![jsonKey] = await dioFormData.MultipartFile.fromFile(
//     filePath,
//     filename: fileName,
//   );
//   return dioFormData.FormData.fromMap(jsonObject);
// }

// Logger Interceptor
final dioPackage.InterceptorsWrapper dioLoggerInterceptor =
dioPackage.InterceptorsWrapper(
  onRequest: (dioPackage.RequestOptions options, handler) {
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
    handler.next(options);
  },
  onResponse: (dioPackage.Response response, handler) async {
    print(
        "| [DIO] Response [code ${response.statusCode}]: ${response.data.toString()}");
    print(
        "└------------------------------------------------------------------------------");
    handler.next(response);
  },
  onError: (dioPackage.DioException error, handler) async {
    print("| [DIO] Error: ${error.error}: ${error.response?.toString()}");
    print(
        "└------------------------------------------------------------------------------");
    handler.next(error);
  },
);

// الحصول على التوكن
String getToken() {
  String? auth =
  Application.sharedPreferences.getString(Constants.USER_AUTH_TOKEN);
  return auth != null ? "Bearer $auth" : "";
}

// إضافة FormData لأي ملف
Future<dioFormData.FormData> addFormDataToJson({
  required String jsonKey,
  required String filePath,
  required String fileName,
  required Map<String, dynamic> jsonObject,
}) async {
  jsonObject[jsonKey] = await dioFormData.MultipartFile.fromFile(
    filePath,
    filename: fileName,
  );
  return dioFormData.FormData.fromMap(jsonObject);
}