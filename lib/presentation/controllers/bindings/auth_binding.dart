import 'package:get/get.dart';

/// Binding لصفحات المصادقة
class AuthBinding implements Bindings {
  @override
  void dependencies() {
    // AuthController مسجل بالفعل في InitialBinding
    // لا حاجة لإعادة تسجيله هنا
    
    print('🔗 تم تهيئة AuthBinding');
  }
}
