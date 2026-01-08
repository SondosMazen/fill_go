import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart' show StorageService;
import '../auth_controller.dart';

/// Binding للتهيئة الأولية للتطبيق
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // الخدمات الأساسية دائمة
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<ApiService>(ApiService(), permanent: true);

    // AuthController دائم
    Get.put<AuthController>(AuthController(), permanent: true);


    print('🔗 تم تهيئة InitialBinding');
  }
}
