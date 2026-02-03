import 'dart:convert';
import 'package:rubble_app/Model/PendingAcceptOrder.dart';
import 'package:rubble_app/Model/TDriver.dart';
import 'package:rubble_app/Model/TSite.dart';
import 'package:rubble_app/core/database/database_helper.dart';
import 'package:rubble_app/core/services/sync_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rubble_app/App/Constant.dart';

/// Controller لشاشة الطلبات المقبولة محلياً
class PendingAcceptOrdersController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  SyncService? _syncService;

  final RxList<PendingAcceptOrder> pendingAcceptOrders =
      <PendingAcceptOrder>[].obs;
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
    loadPendingAcceptOrders();

    // استماع للتحديثات من خدمة المزامنة
    if (_syncService != null) {
      // عند انتهاء المزامنة، نحدث القائمة
      ever(_syncService!.isSyncing, (syncing) {
        if (!syncing) {
          loadPendingAcceptOrders();
        }
      });
      // عند تغير عدد المعلقات، نحدث القائمة
      ever(_syncService!.pendingCount, (_) {
        loadPendingAcceptOrders();
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
    return sitesMap[id.toString()] ?? id;
  }

  /// تحميل الطلبات المقبولة محلياً
  Future<void> loadPendingAcceptOrders() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? currentUserId;
      final userDataStr = prefs.getString(
        Constants.USER_DATA,
      ); //Constants.USER_DATA
      if (userDataStr != null) {
        final userData = jsonDecode(userDataStr);
        currentUserId = userData['oid']?.toString();
      }

      final orders = await _dbHelper.readAllAcceptOrders();

      if (currentUserId != null) {
        pendingAcceptOrders.value = orders
            .where((o) => o.userId == currentUserId)
            .toList();
      } else {
        pendingAcceptOrders.value = [];
      }
    } catch (e) {
      print('Error loading pending accept orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// مزامنة جميع الطلبات المقبولة
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
    await loadPendingAcceptOrders();
  }

  /// مزامنة طلب قبول واحد
  Future<void> syncSingle(int orderId) async {
    if (_syncService == null) {
      Get.snackbar(
        'خطأ',
        'خدمة المزامنة غير متوفرة',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // المزامنة تتم عبر syncPendingOrders التي تشمل accept orders
    await _syncService!.syncPendingOrders();
    await loadPendingAcceptOrders();

    Get.snackbar(
      'تمت المحاولة',
      'تم محاولة رفع الطلب',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// حذف طلب قبول معلق
  Future<void> deletePendingAcceptOrder(int orderId) async {
    await _dbHelper.deleteAcceptOrder(orderId);

    // تحديث العداد
    if (_syncService != null) {
      await _syncService!.updatePendingCount();
    }

    await loadPendingAcceptOrders();
    Get.snackbar(
      'تم الحذف',
      'تم حذف الطلب من القائمة المحلية',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
