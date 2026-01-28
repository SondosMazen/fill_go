import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:fill_go/Modules/Main/Home/home_controller.dart';
import 'package:fill_go/Api/BaseResponse.dart';
import 'package:fill_go/Api/Repo/requests_repo.dart';
import 'package:fill_go/Helpers/DialogHelper.dart';
import 'package:fill_go/Model/TDriver.dart';
import 'package:fill_go/Model/TSite.dart';
import 'package:fill_go/Model/PendingOrder.dart';
import 'package:fill_go/Model/PendingAcceptOrder.dart';
import 'package:fill_go/Modules/Base/BaseGetxController.dart';
import 'package:fill_go/core/database/database_helper.dart';
import 'package:fill_go/core/services/connectivity_service.dart';
import 'package:fill_go/core/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRequestController extends BaseGetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController orderNumController = TextEditingController();
  TextEditingController loadingLocationController = TextEditingController();
  TextEditingController carTypeController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController unloadingLocationController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController adminNotesController = TextEditingController();
  TextEditingController driversController = TextEditingController();
  List<TDriver>? tDrivers;
  List<TSite>? tSites;
  String? selectedDriverValue;
  String? selectedUnloadLocationValue;

  @override
  void onInit() {
    loadCachedData();
    loadNextCarNum();
    getDrivers();
    getSites();
    super.onInit();
  }

  Future<void> loadNextCarNum() async {
    carNumberController.text = '';
  }

  /// تحميل البيانات المحفوظة محلياً
  Future<void> loadCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // تحميل قائمة السائقين
      final driversJson = prefs.getString('cached_drivers');
      if (driversJson != null) {
        final List<dynamic> driversList = jsonDecode(driversJson);
        tDrivers = driversList.map((json) => TDriver.fromJson(json)).toList();
        log('تم تحميل ${tDrivers?.length} سائق من الكاش');
      }

      // تحميل قائمة مواقع التفريغ
      final sitesJson = prefs.getString('cached_sites');
      if (sitesJson != null) {
        final List<dynamic> sitesList = jsonDecode(sitesJson);
        tSites = sitesList.map((json) => TSite.fromJson(json)).toList();
        log('تم تحميل ${tSites?.length} موقع من الكاش');
      }

      update();
    } catch (e) {
      log('خطأ في تحميل البيانات المحفوظة: $e');
    }
  }

  /// حفظ قائمة السائقين محلياً
  Future<void> cacheDrivers(List<TDriver> drivers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final driversJson = jsonEncode(drivers.map((d) => d.toJson()).toList());
      await prefs.setString('cached_drivers', driversJson);
      log('تم حفظ ${drivers.length} سائق في الكاش');
    } catch (e) {
      log('خطأ في حفظ السائقين: $e');
    }
  }

  /// حفظ قائمة المواقع محلياً
  Future<void> cacheSites(List<TSite> sites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sitesJson = jsonEncode(sites.map((s) => s.toJson()).toList());
      await prefs.setString('cached_sites', sitesJson);
      log('تم حفظ ${sites.length} موقع في الكاش');
    } catch (e) {
      log('خطأ في حفظ المواقع: $e');
    }
  }

  Future<bool> postStoreOrder() async {
    // التحقق من الاتصال بالإنترنت
    final connectivityService = Get.find<ConnectivityService>();

    DialogHelper.showLoading();

    Map<String, dynamic> map = {
      'location': loadingLocationController.text,
      'car_num': carNumberController.text,
      'car_type': carTypeController.text,
      'rubble_site_oid': selectedUnloadLocationValue,
      'notes': notesController.text,
      'driver_oid': selectedDriverValue,
      'order_num': orderNumController.text,
    };

    // Check for duplicate order number is removed as per request.

    // إذا كان هناك اتصال، أرسل للسيرفر مباشرة
    if (connectivityService.isOnline.value) {
      BaseResponse<dynamic>? response = await RequestsRepo.instance
          .postStoreOrder(body: map);

      DialogHelper.hideLoading();

      if (checkResponse(response, showPopup: true)) {
        return false;
      }

      // إذا عاد السيرفر بخطأ يتعلق بالتكرار (يمكن التحقق من نص الرسالة إذا لزم الأمر)
      // ولكن checkResponse قد يعالج ذلك.
      // سنفترض أن السيرفر يرسل رسالة واضحة في حالة التكرار.

      // تحويل map إلى PendingOrder لإضافته مؤقتاً أو فقط للمزامنة (اختياري)
      // في هذه الحالة نكتفي بالنجاح

      // تحديث رقم السيارة بعد النجاح
      await _incrementCarNum();

      Get.back(result: true);
      return true;
    }
    // إذا لم يكن هناك اتصال، احفظ محلياً
    else {
      try {
        final dbHelper = DatabaseHelper.instance;
        final pendingOrder = PendingOrder(
          location: map['location'],
          carNum: map['car_num'],
          carType: map['car_type'],
          rubbleSiteOid: map['rubble_site_oid'],
          notes: map['notes'],
          driverOid: map['driver_oid'],
          referenceNumber: map['order_num'],
          createdAt: DateTime.now().toIso8601String(),
          syncStatus: 'pending',
        );

        await dbHelper.create(pendingOrder);

        // تحديث عداد الطلبات المعلقة
        final syncService = Get.find<SyncService>();
        await syncService.updatePendingCount();

        // تحديث رقم السيارة بعد النجاح
        await _incrementCarNum();

        DialogHelper.hideLoading();

        // إظهار Dialog للمستخدم
        await Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 10),
                Text('تم الحفظ محلياً بنجاح'),
              ],
            ),
            content: Text(
              'تم حفظ الطلب محلياً بنجاح. سيتم رفعه تلقائياً عند استعادة الاتصال بالإنترنت.',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.back(result: true); // الرجوع للشاشة السابقة
                },
                child: Text('حسناً'),
              ),
            ],
          ),
          barrierDismissible: false,
        );

        Get.back(result: true);
        return true;
      } catch (e) {
        DialogHelper.hideLoading();
        Get.snackbar(
          'خطأ',
          'فشل حفظ الطلب محلياً: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }
  }

  Future<void> _incrementCarNum() async {}

  bool isAccepting = false;

  Future<bool> acceptOrder(String orderId, {int? offlineRequestId}) async {
    // منع التكرار عند الضغط ع زر قبول الطلب في حالة اوفلاين (Double Tap)
    if (isAccepting) return false;
    isAccepting = true;

    try {
      // التحقق من الاتصال بالإنترنت
      final connectivityService = Get.find<ConnectivityService>();
      final now = DateTime.now();
      final processDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

      // إذا كان هناك اتصال، أرسل للسيرفر مباشرة
      if (connectivityService.isOnline.value) {
        DialogHelper.showLoading();
        Map<String, dynamic> body = {
          'notes': adminNotesController.text.isEmpty
              ? 'تم قبول الطلب'
              : adminNotesController.text,
          'order_oid': orderId,
          'process_date': processDate,
        };

        BaseResponse? response = await RequestsRepo.instance.postProcessOrder(
          body: body,
        );

        DialogHelper.hideLoading();
        if (checkResponse(response, showPopup: true)) {
          return false;
        }

        // حذف طلب الاوفلاين إذا تم تحديده
        if (offlineRequestId != null) {
          try {
            final dbHelper = DatabaseHelper.instance;
            await dbHelper.delete(offlineRequestId);
            final syncService = Get.find<SyncService>();
            await syncService.updatePendingCount();
            log(
              'تم حذف طلب الاوفلاين #$offlineRequestId بعد القبول من التفاصيل',
            );
          } catch (e) {
            log('خطأ في حذف طلب الاوفلاين: $e');
          }
        }

        Get.back(result: true);
        return true;
      }
      // إذا لم يكن هناك اتصال، احفظ محلياً
      else {
        try {
          DialogHelper.showLoading();

          final dbHelper = DatabaseHelper.instance;

          // التحقق من عدم التكرار
          final existingOrders = await dbHelper.readAllAcceptOrders();
          final isDuplicate = existingOrders.any((o) => o.orderOid == orderId);

          if (isDuplicate) {
            DialogHelper.hideLoading();
            Get.snackbar(
              'تنبيه',
              'تم قبول هذا الطلب محلياً من قبل، وهو في انتظار المزامنة',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            return false;
          }

          final pendingAcceptOrder = PendingAcceptOrder(
            orderOid: orderId,
            notes: adminNotesController.text.isEmpty
                ? 'تم قبول الطلب'
                : adminNotesController.text,
            createdAt: DateTime.now().toIso8601String(),
            syncStatus: 'pending',
            processDate: processDate,
          );

          await dbHelper.createAcceptOrder(pendingAcceptOrder);

          // حذف طلب الاوفلاين إذا تم تحديده (حتى لا يظهر مرة أخرى محلياً)
          if (offlineRequestId != null) {
            await dbHelper.delete(offlineRequestId);
            log(
              'تم حذف طلب الاوفلاين #$offlineRequestId بعد القبول المحلى من التفاصيل',
            );
          }

          // تحديث القائمة في الواجهة
          if (Get.isRegistered<HomeController>()) {
            await Get.find<HomeController>().loadLocalAcceptedOrderIds();
          }

          // تحديث عداد الطلبات المعلقة
          final syncService = Get.find<SyncService>();
          await syncService.updatePendingCount();

          DialogHelper.hideLoading();

          // إظهار Dialog للمستخدم
          await Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  SizedBox(width: 10),
                  Text('تم الحفظ محلياً'),
                ],
              ),
              content: Text(
                'تم حفظ قبول الطلب محلياً بنجاح. سيتم رفعه تلقائياً عند استعادة الاتصال بالإنترنت.',
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back(); // إغلاق Dialog
                    Get.back(result: true); // الرجوع للشاشة السابقة
                  },
                  child: Text('حسناً'),
                ),
              ],
            ),
            barrierDismissible: false,
          );

          return true;
        } catch (e) {
          DialogHelper.hideLoading();
          Get.snackbar(
            'خطأ',
            'فشل حفظ قبول الطلب محلياً: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      }
    } catch (e) {
      print('Error in acceptOrder: $e');
      DialogHelper.hideLoading();
      return false;
    } finally {
      isAccepting = false;
    }
  }

  Future<List<TDriver>?> getDrivers() async {
    log('in getDrivers');

    // التحقق من الاتصال بالإنترنت
    final connectivityService = Get.find<ConnectivityService>();

    // إذا لم يكن هناك اتصال، ولدينا بيانات محفوظة، استخدمها
    if (!connectivityService.isOnline.value &&
        (tDrivers?.isNotEmpty ?? false)) {
      log('لا يوجد اتصال - استخدام البيانات المحفوظة للسائقين');
      return tDrivers;
    }

    // محاولة جلب البيانات من السيرفر
    setLoading(true);
    BaseResponse<List<TDriver>>? response = await RequestsRepo.instance
        .getDrivers();
    setLoading(false);

    if (checkResponse(response, showPopup: false)) {
      log('فشل جلب السائقين من السيرفر - استخدام البيانات المحفوظة');
      return tDrivers;
    }

    if (response.data != null) {
      tDrivers = response.data!;
      // حفظ البيانات محلياً
      await cacheDrivers(tDrivers!);
    }
    update();
    return tDrivers;
  }

  Future<List<TSite>?> getSites() async {
    log('in getSites');

    // التحقق من الاتصال بالإنترنت
    final connectivityService = Get.find<ConnectivityService>();

    if (!connectivityService.isOnline.value && (tSites?.isNotEmpty ?? false)) {
      log('لا يوجد اتصال - استخدام البيانات المحفوظة للمواقع');
      return tSites;
    }

    // محاولة جلب البيانات من السيرفر
    BaseResponse<List<TSite>>? response = await RequestsRepo.instance
        .getSites();

    if (checkResponse(response, showPopup: false)) {
      log('فشل جلب المواقع من السيرفر - استخدام البيانات المحفوظة');
      return tSites;
    }

    if (response.data != null) {
      tSites = response.data!;
      // حفظ البيانات محلياً
      await cacheSites(tSites!);
    }
    update();
    return tSites;
  }

  List<SearchFieldListItem>? getSitesList() {
    return tSites?.map((driver) {
      return SearchFieldListItem(
        driver.name ?? 'لا يوجد اسم',
        value: '${driver.oid}',
      );
    }).toList();
  }

  List<SearchFieldListItem>? getDriversList() {
    return tDrivers?.map((driver) {
      return SearchFieldListItem(
        driver.name ?? 'لا يوجد اسم',
        value: '${driver.oid}',
      );
    }).toList();
  }
}
