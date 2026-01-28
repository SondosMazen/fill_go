import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../App/Constant.dart';
import '../../../App/app.dart';
import '../../../Model/TUser.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/token_service.dart';

class AuthController extends GetxController {
  StorageService? storageService;

  // Observable variables
  final _isLoading = false.obs;
  final _currentUser = Rxn<TUser>();
  final _isLoggedIn = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  TUser? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isInspector => currentUser?.userType == UserType.inspector;
  bool get isContractor => currentUser?.userType == UserType.contractor;

  @override
  void onInit() {
    super.onInit();
    Get.put(TokenService());

    // تهيئة الخدمات بعد أن يكون GetX جاهزًا
    if (storageService == null) {
      storageService = Get.find<StorageService>();
    }

    // تهيئة المصادقة ثم التوجيه
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAuth();
    });
  }

  String get homeTitle {
    switch (currentUser?.userType) {
      case UserType.inspector:
        return 'لوحة تحكم المفتش';
      case UserType.contractor:
        return 'لوحة تحكم المقاول';
      default:
        return 'لوحة تحكم';
    }
  }

  void setCurrentUser(TUser user) {
    _currentUser.value = user;
    _isLoggedIn.value = true;
    Application.sharedPreferences.setString(
      Constants.USER_TYPE,
      user.userType.toString(),
    );

    update(); // إعلام GetX بالتغيير
  }

  void setLoggedOut() {
    _currentUser.value = null;
    _isLoggedIn.value = false;
    update();
  }

  /// تهيئة حالة المصادقة من التخزين المحلي
  void _initializeAuth() {
    try {
      // محاولة استرداد بيانات المستخدم المحفوظة
      final savedUser = storageService?.getCurrentUser();
      if (savedUser != null && savedUser.isActive) {
        _currentUser.value = savedUser;
        _isLoggedIn.value = true;
        print('✅ تم استرداد حالة تسجيل الدخول: ${savedUser.name}');
      } else {
        _isLoggedIn.value = false;
        _currentUser.value = null;
        print('ℹ️ لا توجد جلسة محفوظة، بدء بحالة غير مسجل دخول');
      }
    } catch (e) {
      print('❌ خطأ في استرداد حالة المصادقة: $e');
      _isLoggedIn.value = false;
      _currentUser.value = null;

      // 🔥 حتى في حالة الخطأ، توجيه لشاشة تسجيل الدخول
      checkAuthAndNavigate();
    }
  }

  /// تسجيل الدخول
  Future<bool> login(String userName, String password) async {
    try {
      _isLoading.value = true;

      if (userName.isEmpty || password.isEmpty) {
        Get.snackbar(
          'خطأ في البيانات',
          'الرجاء إدخال اسم المستخدم وكلمة المرور',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }

      // TODO: Implement API login call
      print('❌ خطأ: لم يتم تنفيذ دالة تسجيل الدخول');
      Get.snackbar(
        'خطأ',
        'وظيفة تسجيل الدخول غير متاحة حالياً',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } catch (e) {
      print('❌ خطأ في تسجيل الدخول: $e');
      Get.snackbar(
        'خطأ في تسجيل الدخول',
        _getErrorMessage(e),
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// التحقق من حالة المصادقة والتوجيه للشاشة المناسبة
  void checkAuthAndNavigate() {
    // إعطاء وقت لشاشة السبلاش للتظهر
    Future.delayed(Duration(milliseconds: 1500), () {
      if (isLoggedIn && currentUser != null) {
        // الانتقال للشاشة الرئيسية حسب نوع المستخدم
        final route = getHomeRoute();
        print('🚀 الانتقال للشاشة: $route');
        Get.offAllNamed(route);
      } else {
        // الانتقال لشاشة تسجيل الدخول
        print('🔐 الانتقال لشاشة تسجيل الدخول');
        Get.offAllNamed('/login');
      }
    });
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    try {
      _isLoading.value = true;

      // مسح التوكن
      final tokenService = Get.find<TokenService>();
      await tokenService.clearToken();

      // مسح البيانات المحلية
      await _clearAuthState();

      Get.snackbar(
        'تم تسجيل الخروج',
        'وداعاً، نراك قريباً',
        snackPosition: SnackPosition.TOP,
      );

      // التوجيه لشاشة تسجيل الدخول
      Get.offAllNamed('/login');

      print('✅ تم تسجيل الخروج بنجاح');
    } catch (e) {
      print('❌ خطأ في تسجيل الخروج: $e');
      await _clearAuthState();
      Get.offAllNamed('/login');
    } finally {
      _isLoading.value = false;
    }
  }

  /// تحديث رمز الوصول
  Future<bool> refreshToken() async {
    try {
      // TODO: Implement API refresh token call
      print('❌ خطأ: لم يتم تنفيذ دالة تحديث رمز الوصول');
      await logout();
      return false;
    } catch (e) {
      print('❌ خطأ في تحديث رمز الوصول: $e');
      await logout();
      return false;
    }
  }

  /// تحديث بيانات المستخدم الحالي
  Future<void> updateCurrentUser() async {
    try {
      if (!isLoggedIn) return;

      // TODO: Implement API get current user call
      print('❌ خطأ: لم يتم تنفيذ دالة تحديث بيانات المستخدم');
    } catch (e) {
      print('❌ خطأ في تحديث بيانات المستخدم: $e');
    }
  }

  /// التحقق من صلاحية المستخدم لإجراء معين
  bool hasPermission(String action) {
    if (currentUser == null) return false;

    final permissionsInspector = [
      'view_complaints',
      'inspect_complaints',
      'add_items',
      'take_photos',
      'update_status',
    ];

    final permissionsContractor = [
      'view_assigned_complaints',
      'update_work_status',
      'take_photos',
      'complete_work',
    ];

    switch (currentUser!.userType) {
      case UserType.inspector:
        return permissionsInspector.contains(action);

      case UserType.contractor:
        return permissionsContractor.contains(action);
    }
  }

  /// الحصول على الصفحة الرئيسية حسب نوع المستخدم
  String getHomeRoute() {
    if (!isLoggedIn || currentUser == null) {
      return '/login';
    }

    switch (currentUser!.userType) {
      case UserType.inspector:
        return '/inspector-dashboard';
      case UserType.contractor:
        return '/inspector-dashboard';
    }
  }

  /// مسح حالة المصادقة
  Future<void> _clearAuthState() async {
    _currentUser.value = null;
    _isLoggedIn.value = false;
    storageService?.clearAuthData();
  }

  /// الحصول على رسالة الخطأ المناسبة
  String _getErrorMessage(dynamic error) {
    final errorMessage = error.toString();

    if (errorMessage.contains('اسم المستخدم غير موجود')) {
      return 'اسم المستخدم غير موجود';
    } else if (errorMessage.contains('كلمة المرور غير صحيحة')) {
      return 'كلمة المرور غير صحيحة';
    } else if (errorMessage.contains('الحساب غير مفعل')) {
      return 'الحساب غير مفعل';
    } else {
      return 'حدث خطأ في تسجيل الدخول';
    }
  }

  @override
  void onClose() {
    super.onClose();
    print('🔄 تم إغلاق AuthController');
  }
}
