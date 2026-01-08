import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../Helpers/snackbar_helper.dart';
import '../Modules/Login/login_screen.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioException(DioException DioException,
      {bool isPopupLoading = false}) {
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
        // message =
        message = "خطأ في الإستجابة ${DioException.response?.data['message']}";
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
    if (isPopupLoading && Get.isDialogOpen!) Get.back();
    SnackBarHelper.show(msg: message);
    // Get.snackbar("Error", message);
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        Get.offAll(() => const LoginScreen());
        return 'غير مصرح بك يرجى تسجيل الدخول';
      case 403:
        return 'Forbidden';
      case 404:
        return error['message'];
      case 429:
        return 'الرجاء المحاولة مره اخرى';
      case 500:
        {
          return error['message'];
        }
        //'Internal server error'
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'يوجد مشكلة من السيرفر';
    }
  }

  @override
  String toString() => message;
}
