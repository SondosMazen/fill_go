import 'dart:async';
import 'package:rubble_app/Api/Repo/requests_repo.dart';
import 'package:rubble_app/core/database/database_helper.dart';
import 'package:rubble_app/core/services/connectivity_service.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:rubble_app/App/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

///  (المزامنة التلقائية) تقوم برفع الطلبات المعلقة عند استعادة الاتصال
class SyncService extends GetxService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final ConnectivityService _connectivityService = ConnectivityService.to;

  StreamSubscription? _connectivitySubscription;

  // عداد الطلبات المعلقة
  final RxInt pendingCount = 0.obs;

  // حالة المزامنة
  final RxBool isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    updatePendingCount();
    _listenToConnectivity();
  }

  /// الاستماع لتغييرات الاتصال
  void _listenToConnectivity() {
    // عند استعادة الاتصال، قم بالمزامنة
    ever(_connectivityService.isOnline, (isOnline) {
      if (isOnline) {
        print('🔄 Internet restored, starting auto-sync...');
        syncPendingOrders();
      }
    });
  }

  /// تحديث عداد الطلبات المعلقة
  Future<void> updatePendingCount() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataStr = prefs.getString(Constants.USER_DATA);
    String? userId;
    // Default to '1' (Inspector) if not set

    if (userDataStr != null) {
      try {
        final userData = jsonDecode(userDataStr);
        userId = userData['oid']?.toString();
      } catch (e) {
        // ignore error
      }
    }

    final pendingOrders = await _dbHelper.readAll();
    final acceptOrders = await _dbHelper.readAllAcceptOrders();

    int count = 0;

    // Filter Logic: Strict separation for ALL users
    // Filter Logic: Strict separation based on user permissions
    if (userId != null) {
      String? userType = prefs.getString(Constants.USER_TYPE);

      // Fallback: Check inside user data JSON if main pref is missing
      if (userType == null && userDataStr != null) {
        try {
          final userData = jsonDecode(userDataStr);
          userType = userData['user_type']?.toString();
        } catch (_) {}
      }

      print('🔄 UpdatePendingCount: UserId=$userId, UserType=$userType');

      // UserType 1 (Inspector/Monitor): Only count pending Accepts (offline accepted orders)
      // STRICTLY exclude 'pendingOrders' (Added Offline Requests) from the count for this user.
      if (userType == '1' ||
          userType.toString().toLowerCase().contains('inspector')) {
        final acceptedCount = acceptOrders
            .where((o) => o.userId == userId)
            .length;
        print(
          '👮 Inspector (Type 1): Counting only accepted orders ($acceptedCount)',
        );
        count = acceptedCount;
      } else {
        // UserType 2 (Contractor) or others: Count both
        final addedCount = pendingOrders
            .where((o) => o.userId == userId)
            .length;
        final acceptedCount = acceptOrders
            .where((o) => o.userId == userId)
            .length;
        print(
          '👷 Contractor/Other: Counting added ($addedCount) + accepted ($acceptedCount)',
        );
        count = addedCount + acceptedCount;
      }
    }

    pendingCount.value = count;
  }

  /// التحقق مما إذ كان المستخدم في شاشة الدخول
  bool get _isLoginOrSplash {
    final route = Get.currentRoute;
    return route == '/login_screen' ||
        route == '/splash_screen' ||
        route == '/launch_screen' ||
        route == '/';
  }

  /// مزامنة جميع الطلبات المعلقة (الطلبات الجديدة + عمليات القبول)
  Future<void> syncPendingOrders() async {
    if (_isLoginOrSplash) {
      print('🔕 Sync skipped (User is on Login/Splash screen)');
      return;
    }

    if (isSyncing.value) {
      print('⏳ Sync already in progress...');
      return;
    }

    if (!_connectivityService.isOnline.value) {
      print('📵 No internet connection, skipping sync');
      return;
    }

    isSyncing.value = true;

    try {
      // مزامنة الطلبات الجديدة
      await _syncNewOrders();

      // مزامنة عمليات القبول
      await _syncAcceptOrders();

      // تحديث العداد
      await updatePendingCount();
    } catch (e) {
      print('❌ Sync service error: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  /// مزامنة الطلبات الجديدة المعلقة
  Future<void> _syncNewOrders() async {
    try {
      // جلب جميع الطلبات المعلقة
      // بما أن الطلبات المزامنة تحذف، فإن الجدول يحتوي فقط على المعلقة والفاشلة
      final pendingOrders = await _dbHelper.readAll();

      if (pendingOrders.isEmpty) {
        print('✅ No pending orders to sync');
        return;
      }

      print('🔄 Syncing ${pendingOrders.length} pending orders...');

      int successCount = 0;
      int failCount = 0;

      for (var order in pendingOrders) {
        // تحديث الحالة إلى "syncing"
        await _dbHelper.update(order.copyWith(syncStatus: 'syncing'));

        try {
          // محاولة رفع الطلب للسيرفر
          final response = await RequestsRepo.instance.postStoreOrder(
            body: order.toServerFormat(),
          );

          if (response.status == true) {
            // نجحت العملية - حذف من قاعدة البيانات المحلية
            await _dbHelper.delete(order.id!);
            successCount++;
            print('✅ Order ${order.id} synced successfully');
          } else {
            // فشلت العملية - تحديث الحالة
            await _dbHelper.update(
              order.copyWith(
                syncStatus: 'failed',
                errorMessage: response.message ?? 'Unknown error',
              ),
            );
            failCount++;
            print('❌ Order ${order.id} sync failed: ${response.message}');
          }
        } catch (e) {
          final errorMsg = e.toString();
          if (errorMsg.contains('SILENT_UNAUTHORIZED') ||
              errorMsg.contains('غير مصرح') ||
              errorMsg.contains('Unauthorized')) {
            print('⏹️ Auth failed during sync (NewOrders), stopping...');
            return;
          }

          // خطأ في الاتصال
          await _dbHelper.update(
            order.copyWith(syncStatus: 'failed', errorMessage: e.toString()),
          );
          failCount++;
          print('❌ Order ${order.id} sync error: $e');
        }
      }

      // تحديث العداد
      await updatePendingCount();

      // إظهار نتيجة المزامنة (فقط إذا لم نكن في شاشة الدخول)
      if (!_isLoginOrSplash) {
        if (successCount > 0) {
          Get.snackbar(
            'تمت المزامنة',
            'تم رفع $successCount طلب بنجاح',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }

        if (failCount > 0) {
          Get.snackbar(
            'فشلت بعض العمليات',
            'فشل رفع $failCount طلب. سيتم المحاولة لاحقاً',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      print('❌ Error in _syncNewOrders: $e');
    }
  }

  /// مزامنة عمليات قبول الطلبات المعلقة
  Future<void> _syncAcceptOrders() async {
    try {
      // جلب جميع عمليات القبول المعلقة
      final pendingAcceptOrders = await _dbHelper.readAllAcceptOrders();

      if (pendingAcceptOrders.isEmpty) {
        print('✅ No pending accept orders to sync');
        return;
      }

      print(
        '🔄 Syncing ${pendingAcceptOrders.length} pending accept orders...',
      );

      int successCount = 0;

      for (var acceptOrder in pendingAcceptOrders) {
        // تحديث الحالة إلى "syncing"
        await _dbHelper.updateAcceptOrder(
          acceptOrder.copyWith(syncStatus: 'syncing'),
        );

        try {
          // محاولة رفع عملية القبول للسيرفر
          final response = await RequestsRepo.instance.postProcessOrder(
            body: acceptOrder.toServerFormat(),
          );

          if (response.status == true) {
            // نجحت العملية - حذف من قاعدة البيانات المحلية
            await _dbHelper.deleteAcceptOrder(acceptOrder.id!);
            successCount++;
            print('✅ Accept order ${acceptOrder.id} synced successfully');
          } else {
            // فشلت العملية - تحديث الحالة
            await _dbHelper.updateAcceptOrder(
              acceptOrder.copyWith(
                syncStatus: 'failed',
                errorMessage: response.message ?? 'Unknown error',
              ),
            );
            print(
              '❌ Accept order ${acceptOrder.id} sync failed: ${response.message}',
            );
          }
        } catch (e) {
          final errorMsg = e.toString();
          if (errorMsg.contains('SILENT_UNAUTHORIZED') ||
              errorMsg.contains('غير مصرح') ||
              errorMsg.contains('Unauthorized')) {
            print('⏹️ Auth failed during sync (AcceptOrders), stopping...');
            return;
          }

          // خطأ في الاتصال
          await _dbHelper.updateAcceptOrder(
            acceptOrder.copyWith(
              syncStatus: 'failed',
              errorMessage: e.toString(),
            ),
          );
          print('❌ Accept order ${acceptOrder.id} sync error: $e');
        }
      }

      // إظهار نتيجة المزامنة (فقط إذا لم نكن في شاشة الدخول)
      if (!_isLoginOrSplash) {
        if (successCount > 0) {
          Get.snackbar(
            'تمت المزامنة',
            'تم قبول $successCount طلب بنجاح',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      print('❌ Error in _syncAcceptOrders: $e');
    }
  }

  /// محاولة مزامنة طلب واحد يدوياً
  Future<bool> syncSingleOrder(int orderId) async {
    try {
      final order = await _dbHelper.read(orderId);
      if (order == null) return false;

      await _dbHelper.update(order.copyWith(syncStatus: 'syncing'));

      final response = await RequestsRepo.instance.postStoreOrder(
        body: order.toServerFormat(),
      );

      if (response.status == true) {
        await _dbHelper.delete(orderId);
        await updatePendingCount();
        return true;
      } else {
        await _dbHelper.update(
          order.copyWith(syncStatus: 'failed', errorMessage: response.message),
        );
        return false;
      }
    } catch (e) {
      print('Error syncing single order: $e');
      try {
        final order = await _dbHelper.read(orderId);
        if (order != null) {
          await _dbHelper.update(
            order.copyWith(syncStatus: 'failed', errorMessage: e.toString()),
          );
        }
      } catch (dbError) {
        print('Error updating order status in catch: $dbError');
      }
      return false;
    }
  }

  /// حذف طلب معلق
  Future<void> deletePendingOrder(int orderId) async {
    await _dbHelper.delete(orderId);
    await updatePendingCount();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  /// Singleton instance
  static SyncService get to => Get.find<SyncService>();
}
