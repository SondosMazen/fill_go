import 'dart:convert';
import 'dart:developer';

import 'package:fill_go/Api/Repo/requests_repo.dart';
import 'package:fill_go/App/Constant.dart';
import 'package:fill_go/App/app.dart';
import 'package:fill_go/Helpers/snackbar_helper.dart';
import 'package:fill_go/Model/TOrder.dart';
import 'package:fill_go/Model/PendingAcceptOrder.dart';
import 'package:fill_go/core/database/database_helper.dart';
import 'package:fill_go/core/services/connectivity_service.dart';
import 'package:fill_go/core/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
// import 'package:fill_go/Api/Repo/news_adv_repo.dart';
// import 'package:fill_go/Model/TMynotification.dart';
import 'package:fill_go/Modules/Base/BaseGetxController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Api/BaseResponse.dart';
import '../../../presentation/controllers/controllers/auth_controller.dart';

class HomeController extends BaseGetxController {
  int selectedIndex = 0;
  String filterValue = 'all';
  MultiSelectController filterListController = MultiSelectController();
  RxList<TOrder> filteredOrders = RxList<TOrder>.empty();
  RxList<TOrder> filteredPendingOrders = RxList<TOrder>.empty();
  RxList<TOrder> filteredAcceptedOrders = RxList<TOrder>.empty();

  List<TOrder> pendingOrders = [];
  List<TOrder> acceptedOrders = [];

  // List<Map<String, dynamic>> data_ref=[] ;
  bool isloadNotification = false;
  // static HomeController get to => Get.find<HomeController>();
  bool isUser = false;
  List<TOrder>? tOrder;
  String? acceptOrderMsg;

  RxString userType = '0'.obs;

  bool get isContractor =>
      userType.value == "2" || userType.value.toString().contains("contractor");
  bool get isInspector =>
      userType.value == "1" || userType.value.toString().contains("inspector");

  RxList<String> localAcceptedOrderIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    // تهيئة نوع المستخدم
    userType.value =
        Application.sharedPreferences.getString(Constants.USER_TYPE) ?? '1';
    if (userType.value == '1' && Get.isRegistered<AuthController>()) {
      try {
        final authController = Get.find<AuthController>();
        if (authController.currentUser?.userType != null) {
          userType.value = authController.currentUser!.userType! as String;
        }
      } catch (e) {}
    }

    loadLocalAcceptedOrderIds();

    // الاستماع للتغييرات في SyncService
    try {
      if (Get.isRegistered<SyncService>()) {
        final syncService = Get.find<SyncService>();
        ever(syncService.pendingCount, (_) => loadLocalAcceptedOrderIds());
        ever(syncService.isSyncing, (syncing) {
          if (!syncing) {
            loadLocalAcceptedOrderIds();
            getOrders();
          }
        });
      }
    } catch (e) {
      log('SyncService listeners error: $e');
    }
  }

  /// تحميل معرفات الطلبات المقبولة محلياً
  Future<void> loadLocalAcceptedOrderIds() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final acceptedOrders = await dbHelper.readAllAcceptOrders();
      localAcceptedOrderIds.value = acceptedOrders
          .where((o) => o.orderOid != null)
          .map((o) => o.orderOid!)
          .toList();
    } catch (e) {
      log('Error loading local accepted order IDs: $e');
    }
  }

  /// التحقق مما إذا كان الطلب مقبولاً محلياً
  bool isOrderAcceptedLocally(String? oid) {
    if (oid == null) return false;
    return localAcceptedOrderIds.contains(oid.toString());
  }

  Future<List<TOrder>?> getOrders() async {
    try {
      setLoading(true);

      // تحميل الطلبات المحفوظة أولاً (للعرض الفوري)
      await loadCachedOrders();

      // محاولة جلب البيانات من السيرفر
      BaseResponse<List<TOrder>>? response = await RequestsRepo.instance
          .getOrders();

      if (checkResponse(response)) {
        // في حالة الفشل، استخدم البيانات المحفوظة
        log('فشل جلب الطلبات من السيرفر - استخدام البيانات المحفوظة');
        return tOrder;
      }

      if (response.data != null) {
        log('get Order finished ${response.data?[0].orderNum}');
        tOrder = response.data!;
        tOrder!.sort((a, b) {
          return DateTime.parse(
            b.entryDate ?? '',
          ).compareTo(DateTime.parse(a.entryDate ?? ''));
        });

        // Split orders
        pendingOrders = tOrder!.where((o) => o.processUser == null).toList();
        acceptedOrders = tOrder!.where((o) => o.processUser != null).toList();

        filteredOrders.value = tOrder ?? [];
        filteredPendingOrders.value = pendingOrders;
        filteredAcceptedOrders.value = acceptedOrders;

        // حفظ الطلبات محلياً
        await cacheOrders(tOrder!);

        // حفظ car_num إذا كان موجوداً في الـ response
        await _cacheCarNum(response);
      }
      return tOrder;
    } catch (e) {
      log('خطأ في getOrders: $e');
      return tOrder;
    } finally {
      setLoading(false);
    }
  }

  /// حفظ رقم السيارة التالي محلياً
  Future<void> _cacheCarNum(BaseResponse<List<TOrder>> response) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // محاولة الحصول على car_num من الـ response
      // قد يكون في response.msg أو response.items أو response.message
      String? carNum;

      // إذا كان car_num في response.msg
      if (response.msg != null && response.msg is String) {
        carNum = response.msg as String?;
      }
      // إذا كان car_num في response.items
      else if (response.items != null && response.items is String) {
        carNum = response.items as String?;
      }

      if (carNum != null && carNum.isNotEmpty) {
        await prefs.setString('next_car_num', carNum);
        log('تم حفظ رقم السيارة التالي: $carNum');
      }
    } catch (e) {
      log('خطأ في حفظ رقم السيارة: $e');
    }
  }

  /// الحصول على رقم السيارة التالي المحفوظ
  static Future<String?> getNextCarNum() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('next_car_num');
    } catch (e) {
      log('خطأ في تحميل رقم السيارة: $e');
      return null;
    }
  }

  /// حفظ الطلبات محلياً
  Future<void> cacheOrders(List<TOrder> orders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = orders.map((o) => o.toJson()).toList();
      await prefs.setString('cached_orders', jsonEncode(ordersJson));
      log('تم حفظ ${orders.length} طلب في الكاش');
    } catch (e) {
      log('خطأ في حفظ الطلبات: $e');
    }
  }

  /// البحث عن طلب بواسطة رقم الطلب
  TOrder? getOrderByNum(String? orderNum) {
    if (orderNum == null || tOrder == null) return null;
    try {
      return tOrder!.firstWhere(
        (o) => o.orderNum.toString() == orderNum.toString(),
      );
    } catch (e) {
      return null;
    }
  }

  /// البحث عن طلب بواسطة المعرف الفريد (OID)
  TOrder? getOrderByOid(String? oid) {
    if (oid == null || tOrder == null) return null;
    try {
      return tOrder!.firstWhere((o) => o.oid.toString() == oid.toString());
    } catch (e) {
      return null;
    }
  }

  /// تحميل الطلبات المحفوظة محلياً
  Future<void> loadCachedOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getString('cached_orders');

      if (ordersJson != null) {
        final List<dynamic> ordersList = jsonDecode(ordersJson);
        tOrder = ordersList.map((json) => TOrder.fromJson(json)).toList();

        // Split orders
        pendingOrders = tOrder!.where((o) => o.processUser == null).toList();
        acceptedOrders = tOrder!.where((o) => o.processUser != null).toList();

        filteredOrders.value = tOrder ?? [];
        filteredPendingOrders.value = pendingOrders;
        filteredAcceptedOrders.value = acceptedOrders;

        log('تم تحميل ${tOrder?.length} طلب من الكاش');
        update();
      }
    } catch (e) {
      log('خطأ في تحميل الطلبات المحفوظة: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
    getOrders();
  }

  void changeCurrentIndex(int updatedIndex) {
    selectedIndex = updatedIndex;
    update();
  }

  void search(q) {
    if (q == '' || q == null) {
      filteredOrders.value = tOrder ?? [];
      filteredPendingOrders.value = pendingOrders;
      filteredAcceptedOrders.value = acceptedOrders;
      update();
    } else {
      bool Function(TOrder) filterFn = (order) {
        bool t = false;
        if (order.oid?.toString().contains(q) ?? false) {
          t = true;
        } else if (order.location?.contains(q) ?? false) {
          t = true;
        } else if (order.carNum?.contains(q) ?? false) {
          t = true;
        } else if (order.carType?.contains(q) ?? false) {
          t = true;
        } else if (order.orderNum?.contains(q) ?? false) {
          t = true;
        } else if (order.entryNotes?.contains(q) ?? false) {
          t = true;
        } else if (order.processNotes?.contains(q) ?? false) {
          t = true;
        } else if (order.entryDate?.contains(q) ?? false) {
          t = true;
        } else if (order.site?.name?.contains(q) ?? false) {
          t = true;
        } else if (order.entryUser?.name?.contains(q) ?? false) {
          t = true;
        }
        return t;
      };

      filteredOrders.value = tOrder!.where(filterFn).toList();
      filteredPendingOrders.value = pendingOrders.where(filterFn).toList();
      filteredAcceptedOrders.value = acceptedOrders.where(filterFn).toList();
    }
    update();
  }

  void acceptOrder(String orderNumber, {String? notes}) async {
    // التحقق من الاتصال بالإنترنت
    final connectivityService = Get.find<ConnectivityService>();

    Map<String, dynamic> body = {
      'notes': notes ?? 'تم قبول الطلب',
      'order_oid': orderNumber,
    };

    // إذا كان هناك اتصال، أرسل للسيرفر مباشرة
    if (connectivityService.isOnline.value) {
      setLoading(true);
      BaseResponse? response = await RequestsRepo.instance.postProcessOrder(
        body: body,
      );
      setLoading(false);

      if (checkResponse(response)) {
        return null;
      }

      if (response.data != null) {
        acceptOrderMsg = response.message!;
        SnackBarHelper.show(
          msg: acceptOrderMsg!,
          backgroundColor: Colors.green,
        );
        getOrders(); // Refresh lists after accepting
      }
    }
    // إذا لم يكن هناك اتصال، احفظ محلياً
    else {
      try {
        final dbHelper = DatabaseHelper.instance;
        final pendingAcceptOrder = PendingAcceptOrder(
          orderOid: orderNumber,
          notes: notes ?? 'تم قبول الطلب',
          createdAt: DateTime.now().toIso8601String(),
          syncStatus: 'pending',
        );

        await dbHelper.createAcceptOrder(pendingAcceptOrder);

        // تحديث عداد الطلبات المعلقة
        final syncService = Get.find<SyncService>();
        await syncService.updatePendingCount();

        // إظهار رسالة للمستخدم
        Get.snackbar(
          'تم الحفظ محلياً',
          'لا يوجد اتصال بالإنترنت. سيتم قبول الطلب تلقائياً عند استعادة الاتصال',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'خطأ',
          'فشل حفظ عملية القبول محلياً: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
