import 'dart:convert';
import 'package:fill_go/Model/PendingOrder.dart';
import 'package:fill_go/Model/TDriver.dart';
import 'package:fill_go/Model/TSite.dart';
import 'package:fill_go/core/database/database_helper.dart';
import 'package:fill_go/core/services/sync_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller لشاشة الطلبات المعلقة
class PendingOrdersController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  SyncService? _syncService;

  final RxList<PendingOrder> pendingOrders = <PendingOrder>[].obs;
  final RxBool isLoading = false.obs;

  // خرائط للبحث السريع عن الأسماء
  final RxMap<String, String> driversMap = <String, String>{}.obs;
  final RxMap<String, String> sitesMap = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // محاولة الحصول على SyncService بشكل آمن
    try {
      _syncService = Get.find<SyncService>();
    } catch (e) {
      print('SyncService not found: $e');
    }
    loadLookupData();
    loadPendingOrders();

    // استماع للتحديثات من خدمة المزامنة
    if (_syncService != null) {
      // عند انتهاء المزامنة، نحدث القائمة
      ever(_syncService!.isSyncing, (syncing) {
        if (!syncing) {
          loadPendingOrders();
        }
      });
      // عند تغير عدد المعلقات (مثل إضافة طلب جديد)، نحدث القائمة
      ever(_syncService!.pendingCount, (_) {
        loadPendingOrders();
      });
    }
  }

  /// تحميل بيانات البحث (Lookup Data) من الكاش
  Future<void> loadLookupData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // تحميل السائقين
      final driversJson = prefs.getString('cached_drivers');
      if (driversJson != null) {
        final List<dynamic> driversList = jsonDecode(driversJson);
        final drivers = driversList
            .map((json) => TDriver.fromJson(json))
            .toList();
        for (var driver in drivers) {
          if (driver.oid != null && driver.name != null) {
            driversMap[driver.oid.toString()] = driver.name!;
          }
        }
      }

      // تحميل المواقع
      final sitesJson = prefs.getString('cached_sites');
      if (sitesJson != null) {
        final List<dynamic> sitesList = jsonDecode(sitesJson);
        final sites = sitesList.map((json) => TSite.fromJson(json)).toList();
        for (var site in sites) {
          if (site.oid != null && site.name != null) {
            sitesMap[site.oid.toString()] = site.name!;
          }
        }
      }
    } catch (e) {
      print('Error loading lookup data: $e');
    }
  }

  /// الحصول على اسم السائق
  String getDriverName(String? id) {
    if (id == null) return '-';
    return driversMap[id.toString()] ?? id;
  }

  /// الحصول على اسم المكب
  String getSiteName(String? id) {
    if (id == null) return '-';
    // قد يتم تخزين الاسم مباشرة إذا تم اختياره، ولكننا نبحث بالـ ID
    return sitesMap[id.toString()] ?? id;
  }

  /// تحميل الطلبات المعلقة
  Future<void> loadPendingOrders() async {
    isLoading.value = true;
    try {
      final orders = await _dbHelper.readAll();
      pendingOrders.value = orders;
    } catch (e) {
      print('Error loading pending orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// مزامنة جميع الطلبات
  Future<void> syncAll() async {
    if (_syncService == null) {
      Get.snackbar(
        'خطأ',
        'خدمة المزامنة غير متوفرة',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    await _syncService!.syncPendingOrders();
    await loadPendingOrders();
  }

  /// مزامنة طلب واحد
  Future<void> syncSingle(int orderId) async {
    if (_syncService == null) {
      Get.snackbar(
        'خطأ',
        'خدمة المزامنة غير متوفرة',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // استخدام المزامنة الجماعية الشاملة بدلاً من المزامنة الفردية
    await _syncService!.syncPendingOrders();
    await loadPendingOrders();

    Get.snackbar(
      'تمت المحاولة',
      'تمت محاولة رفع الطلبات المعلقة',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// حذف طلب معلق
  Future<void> deletePendingOrder(int orderId) async {
    await _dbHelper.delete(orderId);

    // تحديث العداد في خدمة المزامنة
    if (_syncService != null) {
      await _syncService!.updatePendingCount();
    }

    await loadPendingOrders();
    Get.snackbar(
      'تم الحذف',
      'تم حذف الطلب من القائمة المحلية',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
