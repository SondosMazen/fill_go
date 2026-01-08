
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/controllers/auth_controller.dart';

class TokenService extends GetxService {
  static TokenService get to => Get.find();

  final RxString _token = ''.obs;
  final RxBool _isTokenValid = false.obs;
  final RxBool _isInitialized = false.obs;

  String get token => _token.value;
  bool get isTokenValid => _isTokenValid.value;
  bool get isInitialized => _isInitialized.value;

  // دالة التهيئة الجديدة
  Future<TokenService> init() async {
    try {
      print('🔄 بدء تهيئة TokenService...');
      await _loadTokenFromStorage();
      _isInitialized.value = true;
      print('✅ تم تهيئة TokenService بنجاح');
      return this;
    } catch (e) {
      print('❌ خطأ في تهيئة TokenService: $e');
      _isInitialized.value = true; // مع ذلك نعتبرها مهيأة للمتابعة
      return this;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadTokenFromStorage();
  }

  // تحميل التوكن من التخزين المحلي
  Future<void> _loadTokenFromStorage() async {
    try {

      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('auth_token');

      if (savedToken != null && savedToken.isNotEmpty) {
        _token.value = savedToken;
        _isTokenValid.value = true;
        print('✅ تم تحميل التوكن من التخزين المحلي');
      } else {
        print('ℹ️ لا يوجد توكن محفوظ');
        _token.value = '';
        _isTokenValid.value = false;
      }
    } catch (e) {
      print('❌ خطأ في تحميل التوكن: $e');
      _token.value = '';
      _isTokenValid.value = false;
    }
  }

  // حفظ التوكن جديد
  Future<void> saveToken(String newToken) async {
    try {
      if (newToken.isEmpty) {
        throw Exception('التوكن فارغ');
      }

      _token.value = newToken;
      _isTokenValid.value = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', newToken);

      print('✅ تم حفظ التوكن الجديد');
    } catch (e) {
      print('❌ خطأ في حفظ التوكن: $e');
      rethrow;
    }
  }

  // مسح التوكن
  Future<void> clearToken() async {
    try {
      _token.value = '';
      _isTokenValid.value = false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      print('✅ تم مسح التوكن');
    } catch (e) {
      print('❌ خطأ في مسح التوكن: $e');
      rethrow;

    }
  }

  // التحقق من صلاحية التوكن
  Future<bool> validateToken() async {
    if (token.isEmpty) {return false;}

    // هنا يمكنك إضافة منطق للتحقق من صلاحية التوكن مع السيرفر
    // إذا كان التوكن لا يزال صالحًا

    try {
      // هنا يمكنك إضافة منطق التحقق من السيرفر
      // مؤقتاً نعتبر أي توكن غير فارغ صالح
      return token.isNotEmpty;
    } catch (e) {
      print('❌ خطأ في التحقق من التوكن: $e');
      return false;
    }
    }

  // تجديد التوكن تلقائيًا عند الحاجة
  Future<String?> refreshTokenIfNeeded() async {
    if (!isTokenValid || token.isEmpty) {
      final authController = Get.find<AuthController>();
      final success = await authController.refreshToken();
      return success ? token : null;
    }
    return token;
  }
}
