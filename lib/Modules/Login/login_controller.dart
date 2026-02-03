import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:rubble_app/Api/BaseResponse.dart';
import 'package:rubble_app/Api/Repo/user_auth_repo.dart';
import 'package:rubble_app/Helpers/DialogHelper.dart';
import 'package:rubble_app/Model/TUser.dart';
import 'package:rubble_app/Modules/Base/BaseGetxController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api/DioExceptions.dart';
import '../../App/Constant.dart';
import '../../App/app.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/token_service.dart';
import '../../core/services/connectivity_service.dart';

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
      // 2. معالجة الدخول في حالة الاوفلاين

      if (!Get.find<ConnectivityService>().isOnline.value) {
        log('Offline login attempt for user: ${map['user_name']}');
        return await _attemptOfflineLogin(
          map['user_name'],
          map['password'].toString(),
        );
      }

      DialogHelper.showLoading();

      BaseResponse<TUser>? response = await UserAuthRepo.instance.postLogin(
        map,
      );

      DialogHelper.hideLoading();
      log("📤 login request body: $map");
      log("📥 login response: ${response!.data}");

      if (checkResponse(response, showPopup: true)) {
        return null;
      }

      TUser? tUser = response.data;
      SharedPreferences sharedPreferences = await Application.sharedPreferences;

      if (tUser != null && tUser.token != null) {
        String userTypeStr = '1'; // Default
        if (tUser.userType == UserType.inspector) {
          userTypeStr = '1';
        } else if (tUser.userType == UserType.contractor) {
          userTypeStr = '2';
        }

        Map<String, dynamic> user = {
          'oid': '${tUser.oid}',
          'name': '${tUser.name}',
          'user_name': '${tUser.userName}',
          'is_active': '${tUser.isActive}',
          'token': '${tUser.token}',
          'user_type': userTypeStr, // Save type here
        };

        // 1. حفظ في SharedPreferences (Active Session)
        await sharedPreferences.setString(
          Constants.USER_DATA,
          jsonEncode(user),
        );
        await sharedPreferences.setString(
          Constants.USER_AUTH_TOKEN,
          tUser.token!,
        );
        await sharedPreferences.setBool(Constants.USER_IS_LOGIN, true);
        await sharedPreferences.setString(Constants.USER_TYPE, userTypeStr);

        Application.sharedPreferences = sharedPreferences;

        // 2. حفظ بيانات المستخدم للدخول الاوفلاين لاحقاً (Multi-User Support)
        await _saveUserForOffline(
          map['user_name'],
          map['password'].toString(),
          user,
          tUser,
        );

        // 3) حفظ أيضاً في StorageService و TokenService لتوحيد المصدر
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
            submit: () {},
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

  /// حفظ بيانات المستخدم في الكاش لدعم تعدد المستخدمين في وضع الاوفلاين
  Future<void> _saveUserForOffline(
    String username,
    String password,
    Map<String, dynamic> userData,
    TUser tUser,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> cachedUsers = {};
      final String? cachedUsersStr = prefs.getString('cached_users_map');

      if (cachedUsersStr != null) {
        cachedUsers = jsonDecode(cachedUsersStr);
      }

      // تحديث بيانات المستخدم
      cachedUsers[username] = {
        'password': password,
        'userData': userData,
        'tUser': tUser.toJson(),
        'lastLogin': DateTime.now().toIso8601String(),
      };

      await prefs.setString('cached_users_map', jsonEncode(cachedUsers));
      log('✅ Cached user credentials for offline use: $username');
    } catch (e) {
      log('❌ Error caching user for offline: $e');
    }
  }

  /// محاولة تسجيل الدخول في وضع الاوفلاين
  Future<BaseResponse<TUser>?> _attemptOfflineLogin(
    String username,
    String password,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cachedUsersStr = prefs.getString('cached_users_map');

      if (cachedUsersStr == null) {
        _showOfflineError(
          'لا توجد بيانات محفوظة لتسجيل الدخول في وضع الاوفلاين',
        );
        return null;
      }

      final Map<String, dynamic> cachedUsers = jsonDecode(cachedUsersStr);

      if (!cachedUsers.containsKey(username)) {
        _showOfflineError('المستخدم غير موجود في السجلات المحفوظة');
        return null;
      }

      final userData = cachedUsers[username];
      final String storedPassword = userData['password'];

      if (storedPassword != password.toString()) {
        _showOfflineError(
          'كلمة المرور غير صحيحة (وضع الاوفلاين). يرجى التأكد من كلمة المرور التي تم استخدامها سابقاً.',
        );
        return null;
      }

      // تسجيل الدخول ناجح
      DialogHelper.showLoading();

      // استعادة البيانات للجلسة الحالية
      final savedUserData = userData['userData'];
      final tUserJson = userData['tUser'];
      final tUser = TUser.fromJson(tUserJson);

      await prefs.setString(Constants.USER_DATA, jsonEncode(savedUserData));
      await prefs.setString(Constants.USER_AUTH_TOKEN, tUser.token ?? '');
      await prefs.setBool(Constants.USER_IS_LOGIN, true);
      await prefs.setString(Constants.USER_TYPE, savedUserData['user_type']);

      if (Get.isRegistered<StorageService>()) {
        final storage = Get.find<StorageService>();
        await storage.saveAuthToken(tUser.token ?? '');
        await storage.saveCurrentUser(tUser);
      }

      // محاكاة تأخير بسيط
      await Future.delayed(const Duration(milliseconds: 500));
      DialogHelper.hideLoading();

      Get.snackbar(
        'وضع الاوفلاين',
        'تم تسجيل الدخول محلياً بنجاح',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // إنشاء استجابة نجاح وهمية
      final response = BaseResponse<TUser>(
        status: true,

        // code: 200,
        message: 'Login Successful (Offline)',
        data: tUser,
      );

      return response;
    } catch (e) {
      DialogHelper.hideLoading();
      log('Error in offline login: $e');
      _showOfflineError('حدث خطأ أثناء محاولة تسجيل الدخول محلياً');
      return null;
    }
  }

  void _showOfflineError(String message) {
    DialogHelper.showMyDialog(
      title: 'خطأ في الدخول (Offline)',
      description: message,
      type: ArtSweetAlertType.warning,
    );
  }
}
