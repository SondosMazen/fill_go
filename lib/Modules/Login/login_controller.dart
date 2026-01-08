import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:fill_go/Api/BaseResponse.dart';
import 'package:fill_go/Api/Repo/user_auth_repo.dart';
import 'package:fill_go/Helpers/DialogHelper.dart';
import 'package:fill_go/Model/TUser.dart';
import 'package:fill_go/Modules/Base/BaseGetxController.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api/DioExceptions.dart';
import '../../App/Constant.dart';
import '../../App/app.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/token_service.dart';

class LoginController extends BaseGetxController {
  final myIDController = TextEditingController();
  final myPasswordController = TextEditingController();

  @override
  void onClose() {
    myIDController.dispose();
    myPasswordController.dispose();
    super.onClose();
  }

  Future<BaseResponse<TUser>?> sendLoginRequest({
    required Map<String, dynamic> map,
  }) async {
    log('in login');
    try {
      DialogHelper.showLoading();

      BaseResponse<TUser>? response = await UserAuthRepo.instance.postLogin(
          map);

      DialogHelper.hideLoading();
      log("📤 login request body: $map");
      log("📥 login response: ${response!.data}");

      if (checkResponse(response, showPopup: true)) {
        return null;
      }

      TUser? tUser = response.data;
      SharedPreferences sharedPreferences = await Application.sharedPreferences;

      if (tUser != null && tUser.token != null) {
        Map<String, dynamic> user = {
          'oid': '${tUser.oid}',
          'name': '${tUser.name}',
          'user_name': '${tUser.userName}',
          'is_active': '${tUser.isActive}',
          'token': '${tUser.token}',
        };

        // 1. حفظ في SharedPreferences
        await sharedPreferences.setString(
          Constants.USER_DATA,
          jsonEncode(user),
        );
        await sharedPreferences.setString(
            Constants.USER_AUTH_TOKEN, tUser.token!);
        await sharedPreferences.setBool(Constants.USER_IS_LOGIN, true);
        Application.sharedPreferences = sharedPreferences;

        // 2) حفظ أيضاً في StorageService و TokenService لتوحيد المصدر
        try {
          if (Get.isRegistered<StorageService>()) {
            final storage = Get.find<StorageService>();
            await storage.saveAuthToken(tUser.token!);
            await storage.saveCurrentUser(tUser);
          }
          if (Get.isRegistered<TokenService>()) {
            final tokenSrv = Get.find<TokenService>();
            await tokenSrv.saveToken(tUser.token!);
          }
        } catch (e) {
          log('⚠️ فشل حفظ التوكن في Storage/TokenService: $e');
        }

        log('✅ تم حفظ بيانات المستخدم بنجاح');
        log('📦 Token: ${tUser.token}');
      }

      return response;
    } on String catch (msg) {
      DialogHelper.hideLoading();

      final errorJson = tryParseErrorResponse(msg);

      if (errorJson != null) {
        // اسم المستخدم غير موجود
        if (errorJson['errors'] != null &&
            errorJson['errors']['user_name'] != null &&
            (errorJson['errors']['user_name'] as List).isNotEmpty) {
          DialogHelper.showMyDialog(
            title: 'خطأ',
            description: errorJson['errors']['user_name'].first,
            type: ArtSweetAlertType.warning,
            submit: () {
              myIDController.clear();
              myPasswordController.clear();
            },
          );
        }
        // كلمة المرور غير صحيحة
        else if (errorJson['status'] == 'error' &&
            errorJson['message'] == 'الرجاء التاكد من بيانات الدخول') {
          DialogHelper.showMyDialog(
            title: 'خطأ في كلمة المرور',
            description: 'كلمة المرور غير صحيحة، يرجى المحاولة مرة أخرى',
            type: ArtSweetAlertType.warning,
            submit: () {
              myPasswordController.clear();
            },
          );
        }
        // أي خطأ آخر من السيرفر
        else {
          DialogHelper.showMyDialog(
            title: 'خطأ',
            description: errorJson['message'] ?? 'حدث خطأ في تسجيل الدخول',
            type: ArtSweetAlertType.warning,
          );
        }
      } else {
        DialogHelper.showMyDialog(
          title: 'خطأ',
          description: msg,
          type: ArtSweetAlertType.warning,
        );
      }

      return null;
    } on DioExceptions catch (e) {
      DialogHelper.hideLoading();
      DialogHelper.showMyDialog(
        title: 'خطأ',
        description: e.toString(),
        type: ArtSweetAlertType.warning,
      );
      return null;
    } catch (e) {
      DialogHelper.hideLoading();

      if (e.toString().contains('type string is not a subtype of type bool')) {
        DialogHelper.showMyDialog(
          title: 'خطأ في النظام',
          description: 'حدث خطأ تقني، يرجى المحاولة لاحقاً',
          type: ArtSweetAlertType.warning,
        );
      } else {
        DialogHelper.showMyDialog(
          title: 'خطأ غير متوقع',
          description: e.toString(),
          type: ArtSweetAlertType.warning,
        );
      }
      return null;
    }
  }

// دالة مساعدة لتحليل رسائل الخطأ JSON
  Map<String, dynamic>? tryParseErrorResponse(String errorMessage) {
    try {
      return jsonDecode(errorMessage);
    } catch (e) {
      return null;
    }
  }
}

