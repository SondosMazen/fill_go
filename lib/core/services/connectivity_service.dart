import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// مراقبة حالة الاتصال بالإنترنت
class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  // حالة الاتصال الحالية
  final RxBool isOnline = true.obs;

  // Stream للاستماع للتغييرات
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _listenToConnectivityChanges();
  }

  /// التحقق من حالة الاتصال الأولية
  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus([result]);
    } catch (e) {
      print('Error checking connectivity: $e');
      isOnline.value = false;
    }
  }

  /// الاستماع للتغييرات في حالة الاتصال
  void _listenToConnectivityChanges() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      _updateConnectionStatus([result]);
    });
  }

  /// تحديث حالة الاتصال بناءً على النتيجة
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // إذا كان هناك أي اتصال (wifi, mobile, ethernet)
    final hasConnection = results.any(
      (result) =>
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet,
    );

    final wasOnline = isOnline.value;
    isOnline.value = hasConnection;

    if (wasOnline != hasConnection) {
      // تحديد نوع الاتصال
      String connectionType = 'غير معروف';
      if (results.contains(ConnectivityResult.wifi)) {
        connectionType = 'WiFi';
      } else if (results.contains(ConnectivityResult.mobile)) {
        connectionType = 'بيانات الهاتف';
      } else if (results.contains(ConnectivityResult.ethernet)) {
        connectionType = 'Ethernet';
      }

      print(
        '🌐 Connectivity changed: ${hasConnection ? "ONLINE ($connectionType)" : "OFFLINE"}',
      );

      // إضافة إشعار للمستخدم هنا
      if (hasConnection) {
        Get.snackbar(
          'متصل',
          'تم الاتصال عبر $connectionType',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'غير متصل',
          'أنت تعمل في وضع Offline',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  /// التحقق اليدوي من حالة الاتصال
  Future<bool> checkConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus([result]);
      return isOnline.value;
    } catch (e) {
      print('Error checking connection: $e');
      return false;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  /// Singleton instance
  static ConnectivityService get to => Get.find<ConnectivityService>();
}
