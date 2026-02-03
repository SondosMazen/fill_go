import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../Model/TUser.dart';
class StorageService extends GetxService {
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _currentUserKey = 'current_user';

  late GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    print('✅ تم تهيئة StorageService بنجاح');
    return this;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init();
    _box = GetStorage();
    print('✅ تم تهيئة StorageService في onInit');
  }

  // حفظ التوكن
  Future<void> saveAuthToken(String token) async {
    await _box.write(_authTokenKey, token);
    print('💾 تم حفظ التوكن');
  }

  // الحصول على التوكن
  String? getAuthToken() {
    return _box.read(_authTokenKey);
  }

  // حفظ Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _box.write(_refreshTokenKey, token);
  }

  // الحصول على Refresh Token
  String? getRefreshToken() {
    return _box.read(_refreshTokenKey);
  }

  // حفظ المستخدم الحالي
  Future<void> saveCurrentUser(TUser user) async {
    await _box.write(_currentUserKey, user.toJson());
    print('💾 تم حفظ بيانات المستخدم: ${user.name}');
  }

  // الحصول على المستخدم الحالي
  TUser? getCurrentUser() {
    final userData = _box.read(_currentUserKey);
    if (userData != null) {
      try {
        return TUser.fromJson(Map<String, dynamic>.from(userData));
      } catch (e) {
        print('❌ خطأ في تحليل بيانات المستخدم: $e');
        return null;
      }
    }
    return null;
  }

  // التحقق من تسجيل الدخول
  bool get isLoggedIn {
    final token = getAuthToken();
    final user = getCurrentUser();
    final isLogged = token != null && token.isNotEmpty && user != null;
    print('🔍 حالة تسجيل الدخول: $isLogged (توكن: ${token != null ? "موجود" : "غير موجود"}, مستخدم: ${user != null ? "موجود" : "غير موجود"})');
    return isLogged;
  }

  /// التحقق من أول إطلاق للتطبيق
  bool get isFirstLaunch => read<bool>('first_launch') ?? true;

  /// تحديد حالة أول إطلاق
  Future<void> setFirstLaunch(bool value) async => await write('first_launch', value);

  // تسجيل الخروج (مسح البيانات)
  Future<void> clearAuthData() async {
    await _box.remove(_authTokenKey);
    await _box.remove(_refreshTokenKey);
    await _box.remove(_currentUserKey);
    print('🧹 تم مسح بيانات المصادقة');
  }

  // قراءة قيمة عامة
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  // كتابة قيمة عامة
  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  // حذف قيمة
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  // التحقق من وجود مفتاح
  bool hasData(String key) {
    return _box.hasData(key);
  }
}
