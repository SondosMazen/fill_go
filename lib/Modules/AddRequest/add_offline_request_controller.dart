import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rubble_app/Modules/Base/BaseGetxController.dart';
import 'package:rubble_app/Model/TDriver.dart';
import 'package:rubble_app/Model/PendingOrder.dart';
import 'package:rubble_app/Api/Repo/requests_repo.dart';
import 'package:rubble_app/Api/BaseResponse.dart';
import 'package:rubble_app/Helpers/DialogHelper.dart';
import 'package:rubble_app/core/services/connectivity_service.dart';
import 'package:rubble_app/core/services/sync_service.dart';
import 'package:rubble_app/core/database/database_helper.dart';
import 'package:searchfield/searchfield.dart';
import 'package:rubble_app/App/Constant.dart';

class AddOfflineRequestController extends BaseGetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController driversController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController referenceNumberController =
      TextEditingController();

  List<TDriver>? tDrivers;
  String? selectedDriverValue;
  String? selectedDriverName;
  bool isSaving = false;

  @override
  void onInit() {
    super.onInit();
    loadCachedDrivers();
    getDrivers();
  }

  /// تحميل السائقين المحفوظين محلياً
  Future<void> loadCachedDrivers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final driversJson = prefs.getString('cached_drivers');
      if (driversJson != null) {
        final List<dynamic> driversList = jsonDecode(driversJson);
        tDrivers = driversList.map((json) => TDriver.fromJson(json)).toList();
        update();
      }
    } catch (e) {
      log('Error loading cached drivers: $e');
    }
  }

  /// حفظ السائقين محلياً
  Future<void> cacheDrivers(List<TDriver> drivers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final driversJson = jsonEncode(drivers.map((d) => d.toJson()).toList());
      await prefs.setString('cached_drivers', driversJson);
    } catch (e) {
      log('Error caching drivers: $e');
    }
  }

  /// جلب قائمة السائقين
  Future<List<TDriver>?> getDrivers() async {
    final connectivityService = Get.find<ConnectivityService>();

    // اذا لا يوجد نت، نستخدم الكاش
    if (!connectivityService.isOnline.value &&
        (tDrivers?.isNotEmpty ?? false)) {
      return tDrivers;
    }

    setLoading(true);
    BaseResponse<List<TDriver>>? response = await RequestsRepo.instance
        .getDrivers();
    setLoading(false);

    if (checkResponse(response, showPopup: false)) {
      return tDrivers;
    }

    if (response.data != null) {
      tDrivers = response.data!;
      await cacheDrivers(tDrivers!);
    }
    update();
    return tDrivers;
  }

  List<SearchFieldListItem>? getDriversList() {
    return tDrivers?.map((driver) {
      return SearchFieldListItem(
        driver.name ?? 'لا يوجد اسم',
        value: '${driver.oid}',
      );
    }).toList();
  }

  /// حفظ الطلب الاوفلاين
  Future<void> saveOfflineRequest() async {
    if (isSaving) return;
    if (!formKey.currentState!.validate()) return;

    if (selectedDriverValue == null) {
      DialogHelper.showMyDialog(description: 'الرجاء اختيار السائق');
      return;
    }

    isSaving = true;
    DialogHelper.showLoading();

    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId;
      final userDataStr = prefs.getString(
        Constants.USER_DATA,
      ); // Constants.USER_DATA
      if (userDataStr != null) {
        final userData = jsonDecode(userDataStr);
        userId = userData['oid']?.toString();
      }

      final dbHelper = DatabaseHelper.instance;
      final pendingOrder = PendingOrder(
        driverOid: selectedDriverValue,
        driverName: selectedDriverName,
        referenceNumber: referenceNumberController.text,
        notes: notesController.text,
        createdAt: DateTime.now().toIso8601String(),
        syncStatus: 'pending',
        userId: userId,
      );

      await dbHelper.create(pendingOrder);

      // تحديث عداد الطلبات المعلقة في SyncService
      if (Get.isRegistered<SyncService>()) {
        final syncService = Get.find<SyncService>();
        await syncService.updatePendingCount();
      }

      // زيادة العداد اليومي للطلبات المضافة (للعرض فقط)
      if (userId != null) {
        final now = DateTime.now();
        final todayStr =
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
        final key = 'offline_added_total_${userId}_$todayStr';
        final currentTotal = prefs.getInt(key) ?? 0;
        await prefs.setInt(key, currentTotal + 1);
        log('✅ Incremented Offline Total for $todayStr to ${currentTotal + 1}');
      }

      DialogHelper.hideLoading();

      Get.back(result: true); // إغلاق الشاشة قبل عرض السناك بار لمنع التكرار

      Get.snackbar(
        'تم الحفظ',
        'تمت إضافة الطلب للأوفلاين بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      DialogHelper.hideLoading();
      DialogHelper.showMyDialog(description: 'حدث خطأ أثناء الحفظ: $e');
    } finally {
      isSaving = false;
    }
  }
}
