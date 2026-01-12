import 'dart:async';
import 'package:fill_go/Api/Repo/requests_repo.dart';
import 'package:fill_go/Model/PendingOrder.dart';
import 'package:fill_go/core/database/database_helper.dart';
import 'package:fill_go/core/services/connectivity_service.dart';
import 'package:fill_go/Modules/Main/Home/home_controller.dart';
import 'package:get/get.dart';

/// خدمة المزامنة التلقائية
/// تقوم برفع الطلبات المعلقة عند استعادة الاتصال
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
    // نحسب جميع الطلبات الموجودة محلياً بغض النظر عن حالتها
    final newOrdersCount = await _dbHelper.getCount();
    final acceptOrdersCount = await _dbHelper.getAcceptOrdersCount();
    pendingCount.value = newOrdersCount + acceptOrdersCount;
  }

  /// مزامنة جميع الطلبات المعلقة (الطلبات الجديدة + عمليات القبول)
  Future<void> syncPendingOrders() async {
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
      // جلب جميع الطلبات المحلية بغض النظر عن الحالة لإعادة المحاولة
      final allOrders = await _dbHelper.readAll();

      if (allOrders.isEmpty) {
        print('✅ No pending orders to sync');
        return;
      }

      print('🔄 Syncing ${allOrders.length} pending orders...');

      int successCount = 0;
      int failCount = 0;

      for (var order in allOrders) {
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
          // خطأ في الاتصال
          await _dbHelper.update(
            order.copyWith(syncStatus: 'failed', errorMessage: e.toString()),
          );
          failCount++;
          print('❌ Order ${order.id} sync error: $e');
        }
      }

      // تحديث قوائم Home Controller
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.getOrders();
      }

      // إظهار نتيجة المزامنة
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
    } catch (e) {
      print('❌ Sync service error during new orders sync: $e');
    }
  }

  /// مزامنة عمليات قبول الطلبات المعلقة
  Future<void> _syncAcceptOrders() async {
    try {
      // جلب جميع عمليات القبول المحلية بغض النظر عن الحالة
      final allAcceptOrders = await _dbHelper.readAllAcceptOrders();

      if (allAcceptOrders.isEmpty) {
        print('✅ No pending accept orders to sync');
        return;
      }

      print('🔄 Syncing ${allAcceptOrders.length} pending accept orders...');

      int successCount = 0;
      int failCount = 0;

      for (var acceptOrder in allAcceptOrders) {
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

            // تحديث قوائم Home Controller
            if (Get.isRegistered<HomeController>()) {
              final homeController = Get.find<HomeController>();
              homeController.getOrders();
            }

            print('✅ Accept order ${acceptOrder.id} synced successfully');
          } else {
            // فشلت العملية - تحديث الحالة
            await _dbHelper.updateAcceptOrder(
              acceptOrder.copyWith(
                syncStatus: 'failed',
                errorMessage: response.message ?? 'Unknown error',
              ),
            );
            failCount++;
            print(
              '❌ Accept order ${acceptOrder.id} sync failed: ${response.message}',
            );
          }
        } catch (e) {
          // خطأ في الاتصال
          await _dbHelper.updateAcceptOrder(
            acceptOrder.copyWith(
              syncStatus: 'failed',
              errorMessage: e.toString(),
            ),
          );
          failCount++;
          print('❌ Accept order ${acceptOrder.id} sync error: $e');
        }
      }

      // إظهار نتيجة المزامنة
      if (successCount > 0) {
        Get.snackbar(
          'تمت المزامنة',
          'تم قبول $successCount طلب بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('❌ Sync service error during accept orders sync: $e');
    }
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}
