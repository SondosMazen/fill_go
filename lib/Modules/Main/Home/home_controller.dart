import 'dart:convert';
import 'dart:developer';
import 'package:rubble_app/Api/Repo/requests_repo.dart';
import 'package:rubble_app/Api/Controllers/requests_controller.dart';
import 'package:rubble_app/App/Constant.dart';
import 'package:rubble_app/App/app.dart';
import 'package:rubble_app/Helpers/assets_color.dart';
import 'package:rubble_app/Helpers/font_helper.dart';
import 'package:rubble_app/Helpers/snackbar_helper.dart';
import 'package:rubble_app/Model/TOrder.dart';
import 'package:rubble_app/Model/PendingAcceptOrder.dart';
import 'package:rubble_app/Model/PendingOrder.dart';
import 'package:rubble_app/Model/TSite.dart';
import 'package:rubble_app/core/database/database_helper.dart';
import 'package:rubble_app/core/services/connectivity_service.dart';
import 'package:rubble_app/core/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:rubble_app/Modules/Base/BaseGetxController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Api/BaseResponse.dart';
import 'package:rubble_app/Modules/Main/Home/matching_offline_requests_screen.dart';
import '../../../presentation/controllers/controllers/auth_controller.dart';

class HomeController extends BaseGetxController {
  int selectedIndex = 0;
  String filterValue = 'all';
  MultiSelectController filterListController = MultiSelectController();
  RxList<TOrder> filteredOrders = RxList<TOrder>.empty();
  RxList<TOrder> filteredPendingOrders = RxList<TOrder>.empty();
  RxList<TOrder> filteredAcceptedOrders = RxList<TOrder>.empty();
  RxString loadingMessage = ''.obs;

  // قائمة طلبات الاوفلاين (PendingOrder)
  RxList<PendingOrder> offlineRequests = <PendingOrder>[].obs;
  RxList<PendingOrder> filteredOfflineRequests = <PendingOrder>[].obs;
  // العداد الكلي للطلبات المضافة اليوم (تراكمي)
  RxInt totalOfflineAddedToday = 0.obs;
  RxString appBarTitle = 'الطلبات'.obs;
  Map<String, String> sitesMap = {};

  List<TOrder> pendingOrders = [];
  List<TOrder> acceptedOrders = [];

  bool isloadNotification = false;
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
    loadOfflineRequests(); // تحميل طلبات الاوفلاين
    loadSitesMap();
    updateAppBarTitle();

    // الاستماع للتغييرات في SyncService
    try {
      if (Get.isRegistered<SyncService>()) {
        final syncService = Get.find<SyncService>();
        ever(syncService.pendingCount, (_) => loadLocalAcceptedOrderIds());
        ever(syncService.isSyncing, (syncing) {
          if (!syncing) {
            loadLocalAcceptedOrderIds();
            loadOfflineRequests(); // تحديث القائمة بعد انتهاء المزامنة
            refreshData(); // تحديث البيانات بما في ذلك الإحصائيات
          }
        });
        // تحديث القائمة عند تغير عداد الطلبات المعلقة
        ever(syncService.pendingCount, (_) => loadOfflineRequests());
      }
    } catch (e) {
      log('SyncService listeners error: $e');
    }
  }

  /// تحديث كافة البيانات والإحصائيات
  Future<void> refreshData() async {
    loadingMessage.value = '';
    setLoading(true);
    try {
      await Future.wait([getOrders(), calculateDailyStats()]);
    } finally {
      setLoading(false);
    }
  }

  /// تحميل معرفات الطلبات المقبولة محلياً
  Future<void> loadLocalAcceptedOrderIds() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final acceptedOrders = await dbHelper.readAllAcceptOrders();

      // Filter by User ID to prevent showing other users' accepted orders
      final prefs = await SharedPreferences.getInstance();
      String? currentUserId;
      final userDataStr = prefs.getString(Constants.USER_DATA);
      if (userDataStr != null) {
        final userData = jsonDecode(userDataStr);
        currentUserId = userData['oid']?.toString();
      }

      if (currentUserId != null) {
        localAcceptedOrderIds.value = acceptedOrders
            .where((o) => o.orderOid != null && o.userId == currentUserId)
            .map((o) => o.orderOid!)
            .toList();
      } else {
        localAcceptedOrderIds.value = [];
      }

      calculateDailyStats();
    } catch (e) {
      log('Error loading local accepted order IDs: $e');
    }
  }

  /// تحميل الطلبات المعلقة (الاوفلاين)
  Future<void> loadOfflineRequests() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final requests = await dbHelper.readAll();

      // Filter by User ID to prevent showing other users' requests
      final prefs = await SharedPreferences.getInstance();
      String? currentUserId;
      final userDataStr = prefs.getString(Constants.USER_DATA);
      if (userDataStr != null) {
        final userData = jsonDecode(userDataStr);
        currentUserId = userData['oid']?.toString();
      }

      List<PendingOrder> userRequests = [];
      if (currentUserId != null) {
        userRequests = requests
            .where((r) => r.userId == currentUserId)
            .toList();
      } else {
        // Fallback: If no user ID found, show nothing to be safe,
        // or show all if that was the intended legacy behavior (but here we want restriction)
        userRequests = [];
      }

      // Sort: Newest first
      userRequests.sort((a, b) {
        if (a.createdAt == null || b.createdAt == null) return 0;
        return DateTime.parse(
          b.createdAt!,
        ).compareTo(DateTime.parse(a.createdAt!));
      });

      offlineRequests.value = userRequests;
      filteredOfflineRequests.value = userRequests; // Initialize filtered list
      calculateDailyStats();
    } catch (e) {
      log('Error loading offline requests: $e');
    } finally {
      loadTotalOfflineAddedToday();
    }
  }

  /// تحميل العدد الكلي للطلبات المضافة اليوم (التراكمي)
  Future<void> loadTotalOfflineAddedToday() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? currentUserId;
      final userDataStr = prefs.getString(Constants.USER_DATA);

      if (userDataStr != null) {
        final userData = jsonDecode(userDataStr);
        currentUserId = userData['oid']?.toString();
      }

      if (currentUserId != null) {
        final now = DateTime.now();
        final todayStr =
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
        final key = 'offline_added_total_${currentUserId}_$todayStr';
        final total = prefs.getInt(key) ?? 0;

        // في حال كان العداد صفر ولكن هناك طلبات في القائمة (حالة تثبيت جديد أو مسح بيانات)
        // يمكننا استخدام طول القائمة كحد أدنى
        if (total < offlineRequests.length) {
          totalOfflineAddedToday.value = offlineRequests.length;
          // تحديث الكاش ليتوافق
          await prefs.setInt(key, offlineRequests.length);
        } else {
          totalOfflineAddedToday.value = total;
        }
      } else {
        totalOfflineAddedToday.value = 0;
      }
    } catch (e) {
      log('Error loading total offline added today: $e');
    }
  }

  /// التحقق مما إذا كان الطلب مقبولاً محلياً
  bool isOrderAcceptedLocally(String? oid) {
    if (oid == null) return false;
    return localAcceptedOrderIds.contains(oid.toString());
  }

  Future<void> loadSitesMap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
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
      updateAppBarTitle();
    } catch (e) {
      log('Error loading sites map: $e');
    }
  }

  void updateAppBarTitle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataStr = prefs.getString(Constants.USER_DATA);

      if (userDataStr != null) {
        final userData = jsonDecode(userDataStr);
        final name = userData['name'] ?? '';

        if (isContractor) {
          appBarTitle.value = name;
        } else {
          String siteName = userData['rubble_site_name'] ?? '';
          // Clean up 'null' string if it was saved that way
          if (siteName == 'null') siteName = '';

          if (siteName.isNotEmpty) {
            appBarTitle.value = "$name - $siteName";
          } else {
            appBarTitle.value = name;
          }
        }
      }
    } catch (e) {
      log('Error updating app bar title: $e');
    }
  }

  String getSiteName(String? oid) {
    if (oid == null) return '-';
    return sitesMap[oid.toString()] ?? '-';
  }

  RxInt todayAddedCount = 0.obs;
  RxInt todayAcceptedCount = 0.obs;

  Future<void> calculateDailyStats() async {
    /*
    final now = DateTime.now();
    final todayStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // --- PREVIOUS MANUAL CALCULATION (KEPT FOR REFERENCE) ---
    int added = 0;
    int accepted = 0;

    // 1. Server Orders
    if (tOrder != null) {
      for (var order in tOrder!) {
        // Added Today (Pending or Accepted)
        if (order.entryDate != null && order.entryDate!.startsWith(todayStr)) {
          added++;
        }
        // Accepted Today
        if (order.processUser != null &&
            order.processDate != null &&
            order.processDate!.startsWith(todayStr)) {
          accepted++;
        }
      }
    }

    // 2. Local Offline Requests (Added Today)
    // Disabled logic...

    // 3. Local Accepted Orders (Accepted Today)
    int localAcceptedToday = 0;
    try {
      final dbHelper = DatabaseHelper.instance;
      final allLocalAccepted = await dbHelper.readAllAcceptOrders();

      // Filter by User ID
      final prefs = await SharedPreferences.getInstance();
      String? currentUserId;
      final userDataStr = prefs.getString(Constants.USER_DATA);
      if (userDataStr != null) {
        final userData = jsonDecode(userDataStr);
        currentUserId = userData['oid']?.toString();
      }

      final localAccepted = currentUserId != null
          ? allLocalAccepted.where((o) => o.userId == currentUserId).toList()
          : <PendingAcceptOrder>[];
      for (var order in localAccepted) {
        if (order.processDate != null &&
            order.processDate!.startsWith(todayStr)) {
          localAcceptedToday++;
        }
      }
    } catch (e) {
      log('Error calculating local stats: $e');
    }

    todayAddedCount.value = added;
    todayAcceptedCount.value = accepted + localAcceptedToday;
    */

    // --- NEW LOGIC: FETCH FROM API ONLY ---
    try {
      final prefs = await SharedPreferences.getInstance();
      String? currentUserId;
      final userDataStr = prefs.getString(Constants.USER_DATA);
      if (userDataStr != null) {
        final userData = jsonDecode(userDataStr);
        currentUserId = userData['oid']?.toString();
      }

      Map<String, dynamic> query = {};
      if (currentUserId != null) {
        query['user_id'] = currentUserId;
      }

      log('Requesting Statistics: URL=api/rubble/statistic, Query=$query');
      final response = await RequestsController.getStatistics(query: query);
      log('Statistics Response: ${response.data}');

      if (response.data != null &&
          response.data['status'] == true &&
          response.data['data'] != null) {
        final data = response.data['data'];
        int apiPending = data['pending_orders'] ?? 0;
        int apiComplete = data['complete_orders'] ?? 0;

        todayAddedCount.value = apiPending;
        todayAcceptedCount.value = apiComplete;
      }
    } catch (e) {
      log('Error calculating daily stats from API: $e');
    }
  }

  Future<List<TOrder>?> getOrders({String? message}) async {
    try {
      loadingMessage.value = message ?? '';
      setLoading(true);

      // تحميل الطلبات المحفوظة أولاً (للعرض الفوري)
      await loadCachedOrders();

      // محاولة جلب البيانات من السيرفر
      BaseResponse<List<TOrder>>? response = await RequestsRepo.instance
          .getOrders();

      if (checkResponse(response)) {
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

        // calculateDailyStats() call moved to onReady to be independent

        // Split orders

        pendingOrders = tOrder!.where((o) => o.processUserOid == null).toList();
        acceptedOrders = tOrder!
            .where((o) => o.processUserOid != null)
            .toList();

        // Sort Pending (Added) by entryDate descending
        pendingOrders.sort((a, b) {
          return DateTime.parse(
            b.entryDate ?? '',
          ).compareTo(DateTime.parse(a.entryDate ?? ''));
        });

        // Sort Accepted by processDate descending
        acceptedOrders.sort((a, b) {
          final aDate =
              a.processDate ??
              a.entryDate ??
              ''; // Fallback to entryDate if processDate missing
          final bDate = b.processDate ?? b.entryDate ?? '';
          return DateTime.parse(bDate).compareTo(DateTime.parse(aDate));
        });

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

        pendingOrders = tOrder!.where((o) => o.processUserOid == null).toList();
        acceptedOrders = tOrder!
            .where((o) => o.processUserOid != null)
            .toList();

        // Sort Pending (Added) by entryDate descending
        pendingOrders.sort((a, b) {
          return DateTime.parse(
            b.entryDate ?? '',
          ).compareTo(DateTime.parse(a.entryDate ?? ''));
        });

        // Sort Accepted by processDate descending
        acceptedOrders.sort((a, b) {
          final aDate = a.processDate ?? a.entryDate ?? '';
          final bDate = b.processDate ?? b.entryDate ?? '';
          return DateTime.parse(bDate).compareTo(DateTime.parse(aDate));
        });

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
    calculateDailyStats();
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
      filteredOfflineRequests.value = offlineRequests;
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

      // Search Offline Requests
      filteredOfflineRequests.value = offlineRequests.where((req) {
        final refMatch = req.referenceNumber?.contains(q) ?? false;
        final driverMatch = req.driverName?.contains(q) ?? false;
        return refMatch || driverMatch;
      }).toList();
    }
    update();
  }

  void checkAndAcceptOrder(TOrder order) {
    // التحقق من وجود طلبات اوفلاين مطابقة لاسم السائق
    final driverName = order.driver?.name;
    if (driverName != null && driverName.isNotEmpty) {
      final matches = offlineRequests
          .where((req) => req.driverName == driverName)
          .toList();

      if (matches.isNotEmpty) {
        Get.to(
          () => MatchingOfflineRequestsScreen(
            matchingRequests: matches,
            driverName: driverName,
            onlineOrderNumber: order.orderNum,
            onConfirm: (selectedOfflineRequestId) {
              // تأخير بسيط لضمان إغلاق الشاشة السابقة قبل البدء
              Future.delayed(const Duration(milliseconds: 300), () {
                acceptOrder(
                  order.oid.toString(),
                  offlineRequestId: selectedOfflineRequestId,
                );
              });
            },
          ),
        );
        return;
      }
    }

    // المتابعة بشكل طبيعي
    acceptOrder(order.oid.toString());
  }

  List<PendingOrder> getOfflineMatches(String driverName) {
    return offlineRequests
        .where((req) => req.driverName == driverName)
        .toList();
  }

  void acceptOrder(
    String orderNumber, {
    String? notes,
    int? offlineRequestId,
  }) async {
    // التحقق من الاتصال بالإنترنت
    final connectivityService = Get.find<ConnectivityService>();
    final now = DateTime.now();
    // 2026-01-25 09:33:00
    final processDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    Map<String, dynamic> body = {
      'notes': notes ?? 'تم قبول الطلب',
      'order_oid': orderNumber,
      'process_date': processDate,
    };

    // إذا كان هناك اتصال، أرسل للسيرفر مباشرة
    if (connectivityService.isOnline.value) {
      // إظهار اللودينج مع الرسالة
      Get.dialog(
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AssetsColors.primaryOrange),
              SizedBox(height: 16),
              // Material(
              //   color: Colors.transparent,
              //   child: Text(
              //     "جاري قبول الطلب...",
              //     style: TextStyle(color: Colors.white, fontSize: 16),
              //   ),
              // ),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      BaseResponse? response = await RequestsRepo.instance.postProcessOrder(
        body: body,
      );

      // إغلاق اللودينج
      if (Get.isDialogOpen ?? false) Get.back();

      if (checkResponse(response)) {
        return null;
      }

      if (response.data != null) {
        // حذف طلب الاوفلاين إذا تم تحديده
        if (offlineRequestId != null) {
          try {
            final dbHelper = DatabaseHelper.instance;
            await dbHelper.delete(offlineRequestId);
            final syncService = Get.find<SyncService>();
            await syncService.updatePendingCount();
            log('تم حذف طلب الاوفلاين #$offlineRequestId بعد القبول');
            await loadOfflineRequests();
          } catch (e) {
            log('خطأ في حذف طلب الاوفلاين: $e');
          }
        }

        acceptOrderMsg = response.message!;
        SnackBarHelper.show(
          msg: acceptOrderMsg!,
          backgroundColor: Colors.green,
        );
        acceptOrderMsg = response.message!;
        SnackBarHelper.show(
          msg: acceptOrderMsg!,
          backgroundColor: Colors.green,
        );
        refreshData(); // Refresh lists and stats after accepting
      }
    }
    // إذا لم يكن هناك اتصال، احفظ محلياً
    else {
      try {
        // الحصول على المعرف الحالي
        final prefs = await SharedPreferences.getInstance();
        String? currentUserId;
        final userDataStr = prefs.getString(Constants.USER_DATA);
        if (userDataStr != null) {
          final userData = jsonDecode(userDataStr);
          currentUserId = userData['oid']?.toString();
        }

        final dbHelper = DatabaseHelper.instance;
        final pendingAcceptOrder = PendingAcceptOrder(
          orderOid: orderNumber,
          notes: notes ?? 'تم قبول الطلب',
          createdAt: DateTime.now().toIso8601String(),
          syncStatus: 'pending',
          processDate: processDate,
          userId: currentUserId,
        );

        await dbHelper.createAcceptOrder(pendingAcceptOrder);

        // حذف طلب الاوفلاين إذا تم تحديده (حتى لا يظهر مرة أخرى محلياً)
        if (offlineRequestId != null) {
          await dbHelper.delete(offlineRequestId);
          log('تم حذف طلب الاوفلاين #$offlineRequestId بعد القبول المحلى');
        }

        // تحديث عداد الطلبات المعلقة
        final syncService = Get.find<SyncService>();
        await syncService.updatePendingCount();

        // تحديث القوائم فوراً
        await loadOfflineRequests();
        await loadLocalAcceptedOrderIds();
        update();

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

  /// حذف طلب اوفلاين
  Future<void> deleteOfflineRequest(int id) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.delete(id);

      // تحديث القائمة
      await loadOfflineRequests();

      // تحديث عداد الطلبات المعلقة في SyncService
      if (Get.isRegistered<SyncService>()) {
        await Get.find<SyncService>().updatePendingCount();
      }

      Get.snackbar(
        'تم الحذف',
        'تم حذف الطلب بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      log('Error deleting offline request: $e');
      Get.snackbar(
        'خطأ',
        'فشل حذف الطلب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// إعادة محاولة مزامنة طلب اوفلاين
  Future<void> retrySyncRequest(PendingOrder order) async {
    if (order.id == null) return;

    final connectivityService = Get.find<ConnectivityService>();
    if (!connectivityService.isOnline.value) {
      Get.snackbar(
        'لا يوجد اتصال',
        'يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // إظهار مؤشر تحميل
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: AssetsColors.primaryOrange),
        ),
        barrierDismissible: false,
      );

      final syncService = Get.find<SyncService>();
      final success = await syncService.syncSingleOrder(order.id!);

      // إغلاق مؤشر التحميل
      Get.back();

      if (success) {
        Get.snackbar(
          'تمت العملية',
          'تم ترحيل الطلب بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // القائمة ستتحدث تلقائياً بسبب المستمع في onInit
      } else {
        // فشل الترحيل - قراءة رسالة الخطأ
        final dbHelper = DatabaseHelper.instance;
        final updatedOrder = await dbHelper.read(order.id!);
        final errorMessage = updatedOrder?.errorMessage ?? 'حدث خطأ غير معروف';

        Get.defaultDialog(
          title: 'فشل الترحيل',
          titleStyle: FontsAppHelper().cairoBoldFont(
            size: 16,
            color: Colors.red,
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: FontsAppHelper().cairoMediumFont(size: 14),
            ),
          ),
          confirm: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AssetsColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'حسناً',
                style: FontsAppHelper().cairoBoldFont(
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      // إغلاق مؤشر التحميل في حال حدوث استثناء
      if (Get.isDialogOpen ?? false) Get.back();

      log('Error retrying sync: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء المحاولة: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
