import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../Helpers/snackbar_helper.dart';
import '../Modules/Login/login_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../App/Constant.dart';
import '../core/services/token_service.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioException(
    DioException DioException, {
    bool isPopupLoading = false,
  }) {
    if (DioException.error == 'SILENT_UNAUTHORIZED') {
      message = 'SILENT_UNAUTHORIZED';
      return;
    }

    switch (DioException.type) {
      case DioExceptionType.cancel:
        message = "تم إلغاء العملة";
        break;
      case DioExceptionType.connectionTimeout:
        message = "الإتصال استغرق الكثير من الوقت ، حاول مجددا";
        break;
      case DioExceptionType.receiveTimeout:
        message = "لا يوجد استجابة من الخادم، حاول في وقت اخر";
        break;
      case DioExceptionType.unknown:
        message = _handleError(
          DioException.response?.statusCode,
          DioException.response?.data,
        );
        break;
      case DioExceptionType.badResponse:
        dynamic data = DioException.response?.data;
        if (data != null && data is Map && data['message'] != null) {
          message = "خطأ في الإستجابة ${data['message']}";
        } else {
          message = _handleError(
            DioException.response?.statusCode,
            DioException.response?.data,
          );
        }
        break;
      case DioExceptionType.sendTimeout:
        message = "لا يوجد رد من الخادم ";
        break;
      case DioExceptionType.connectionError:
        message = "انت غير متصل بالإنترنت";
        break;
      default:
        message = 'مشكلة غير محددة ${DioException.type}';
        break;
    }
    if (isPopupLoading && (Get.isDialogOpen ?? false)) Get.back();
    // SnackBarHelper.show(msg: message); // Removed to prevent double notifications
  }

  String _handleError(int? statusCode, dynamic error) {
    if (statusCode == null) return 'حدث خطأ غير معروف';

    // محاولة استخراج الرسالة إذا كانت موجودة
    String? serverMsg;
    if (error is Map && error['message'] != null) {
      serverMsg = error['message'];
    } else if (error is String) {
      serverMsg = error;
    }

    switch (statusCode) {
      case 302: // Treat 302 as Unauthorized
      case 400:
        return serverMsg ?? 'Bad request';
      case 401:
        // مسح بيانات الجلسة عند انتهاء الصلاحية (401)
        TokenService.to.clearToken().then((_) async {
          final shared = await SharedPreferences.getInstance();
          await shared.setBool(Constants.USER_IS_LOGIN, false);
          await shared.setString(Constants.USER_DATA, "");
          Get.offAll(() => const LoginScreen());
        });
        return serverMsg ?? 'غير مصرح بك يرجى تسجيل الدخول';
      case 403:
        return serverMsg ?? 'Forbidden';
      case 404:
        return serverMsg ?? 'الصفحة غير موجودة';
      case 429:
        return serverMsg ?? 'الرجاء المحاولة مره اخرى';
      case 500:
        return serverMsg ?? 'يوجد مشكلة من السيرفر (500)';
      case 502:
        return serverMsg ?? 'Bad gateway';
      default:
        return serverMsg ?? 'يوجد مشكلة من السيرفر ($statusCode)';
    }
  }

  @override
  String toString() => message;
}
