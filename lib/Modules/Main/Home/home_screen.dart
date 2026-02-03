import 'package:rubble_app/Modules/AddRequest/add_request.dart';
import 'package:rubble_app/Modules/Main/Home/home_controller.dart';
import 'package:rubble_app/Modules/Main/Home/widgets/request_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import '../../../App/Constant.dart';
import '../../../App/app.dart';

import '../../../core/services/sync_service.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../presentation/controllers/routes/app_pages.dart';
import '../../../Helpers/assets_color.dart';
import '../../../Helpers/font_helper.dart';
import 'package:rubble_app/Model/PendingOrder.dart';
import 'package:rubble_app/Modules/AddRequest/add_offline_request.dart';
import 'package:rubble_app/Modules/Notifications/combined_notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
    // تحديث عداد الإشعارات (المزامنة) عند الدخول
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<SyncService>()) {
        Get.find<SyncService>().updatePendingCount();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isInspector = controller.isInspector;
      return DefaultTabController(
        length: isInspector ? 3 : 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(
              'الطلبات',
              style: FontsAppHelper().cairoBoldFont(
                size: 22,
                color: Colors.white,
              ),
            ),
            actions: [
              // زر الإشعارات مع عداد الطلبات المعلقة
              Obx(() {
                try {
                  final syncService = Get.find<SyncService>();
                  final count = syncService.pendingCount.value;
                  return badges.Badge(
                    showBadge: count > 0,
                    badgeContent: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Colors.red,
                      padding: EdgeInsets.all(5),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Get.to(() => const CombinedNotificationsScreen());
                      },
                    ),
                  );
                } catch (e) {
                  return IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.to(() => const CombinedNotificationsScreen());
                    },
                  );
                }
              }),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                onPressed: () {
                  // Check connectivity
                  final isOnline =
                      Get.find<ConnectivityService>().isOnline.value;

                  Get.defaultDialog(
                    title: 'تسجيل الخروج',
                    titleStyle: FontsAppHelper().cairoBoldFont(
                      size: 16,
                      color: AssetsColors.color_text_black_392C23,
                    ),
                    content: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        isOnline
                            ? 'هل أنت متأكد من تسجيل الخروج؟'
                            : 'أنت غير متصل بالإنترنت. تسجيل الخروج سيكون محلياً فقط، ويمكنك العودة بنفس الحساب.',
                        textAlign: TextAlign.center,
                        style: FontsAppHelper().cairoMediumFont(size: 14),
                      ),
                    ),
                    confirm: ElevatedButton(
                      onPressed: () async {
                        final shared = Application.sharedPreferences;

                        if (isOnline) {
                          // Online: We still want to keep data for potential offline re-login
                          // So we DO NOT clear token or user data here.
                          // Unless we strictly want to prevent offline login after online logout.
                          // But the requirement is to allow it.

                          // Optional: Call server logout API if exists (UserAuthController.postUserAuthLogOut)
                          // But currently not implemented here.
                        } else {
                          // Offline: Soft logout (Keep token & user data)
                        }

                        await shared.setBool(Constants.USER_IS_LOGIN, false);
                        Get.offAllNamed(AppPages.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AssetsColors.primaryOrange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        'نعم',
                        style: FontsAppHelper().cairoBoldFont(
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    cancel: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'لا',
                        style: FontsAppHelper().cairoBoldFont(
                          size: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              labelStyle: FontsAppHelper().cairoBoldFont(size: 16),
              unselectedLabelStyle: FontsAppHelper().cairoMediumFont(size: 16),
              tabs: [
                const Tab(text: 'قيد المعالجة'),
                const Tab(text: 'تم القبول'),
                if (isInspector) const Tab(text: 'طلبات الاوفلاين'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildTab(
                controller.filteredPendingOrders,
                'الطلبات المضافة اليوم',
                controller.todayAddedCount,
              ),
              _buildTab(
                controller.filteredAcceptedOrders,
                'الطلبات المقبولة اليوم',
                controller.todayAcceptedCount,
              ),
              if (isInspector)
                _buildOfflineRequestsTab(controller.filteredOfflineRequests),
            ],
          ),
          floatingActionButton: controller.isContractor
              ? FloatingActionButton(
                  onPressed: () async {
                    final result = await Get.to(
                      () => AddRequest(
                        isDetails: false,
                        userType: controller.userType.value,
                      ),
                    );
                    if (result == true) {
                      controller.getOrders();
                    }
                  },
                  backgroundColor: AssetsColors.primaryOrange,
                  elevation: 8,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add, color: Colors.white, size: 32),
                )
              : isInspector
              ? Obx(() {
                  final isOnline =
                      Get.find<ConnectivityService>().isOnline.value;
                  if (isOnline) return const SizedBox.shrink();

                  return FloatingActionButton.extended(
                    onPressed: () async {
                      final result = await Get.to(
                        () => const AddOfflineRequest(),
                      );
                      if (result == true) {
                        controller.loadOfflineRequests();
                      }
                    },
                    backgroundColor: AssetsColors.primaryOrange,
                    elevation: 8,
                    label: Text(
                      'اضافة طلب اوفلاين',
                      style: FontsAppHelper().cairoBoldFont(
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white, size: 24),
                  );
                })
              : const SizedBox.shrink(),
        ),
      );
    });
  }

  Widget _buildTab(RxList<dynamic> ordersList, String title, RxInt count) {
    return RefreshIndicator(
      onRefresh: () => controller.getOrders(),
      color: AssetsColors.primaryOrange,
      backgroundColor: Colors.white,
      child: Obx(() {
        // عرض مؤشر التحميل عند تحميل البيانات
        if (controller.isLoading) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  const CircularProgressIndicator(
                    color: AssetsColors.primaryOrange,
                  ),
                  if (controller.loadingMessage.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      controller.loadingMessage.value,
                      style: FontsAppHelper().cairoBoldFont(
                        size: 14,
                        color: AssetsColors.primaryOrange,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        // عرض المحتوى بعد انتهاء التحميل
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildDailyStatsCard(title, count),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => controller.search(value),
                    style: FontsAppHelper().cairoMediumFont(size: 15),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن طلب أو رقم سيارة...',
                      hintStyle: FontsAppHelper().cairoRegularFont(
                        color: Colors.grey.shade500,
                        size: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AssetsColors.primaryOrange.withOpacity(0.7),
                        size: 22,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ),
              ordersList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 120),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.assignment_rounded,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'لا توجد طلبات متوفرة حالياً',
                            style: FontsAppHelper().cairoBoldFont(
                              color: AssetsColors.darkBrown.withOpacity(0.5),
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'سيتم ظهور الطلبات الجديدة هنا فور إضافتها',
                            style: FontsAppHelper().cairoRegularFont(
                              color: Colors.grey,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: ordersList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
                      itemBuilder: (context, index) {
                        final order = ordersList[index];
                        return RequestCard(order: order);
                      },
                    ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOfflineRequestsTab(RxList<PendingOrder> ordersList) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => controller.search(value),
                style: FontsAppHelper().cairoMediumFont(size: 15),
                decoration: InputDecoration(
                  hintText: 'ابحث عن الرقم المرجعي أو اسم السائق...',
                  hintStyle: FontsAppHelper().cairoRegularFont(
                    color: Colors.grey.shade500,
                    size: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AssetsColors.primaryOrange.withOpacity(0.7),
                    size: 22,
                  ),
                  // عداد الطلبات على أقصى اليسار
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AssetsColors.primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${controller.totalOfflineAddedToday.value}',
                          style: FontsAppHelper().cairoBoldFont(
                            size: 14,
                            color: AssetsColors.primaryOrange,
                          ),
                        ),
                      ),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            if (ordersList.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد طلبات اوفلاين',
                        style: FontsAppHelper().cairoBoldFont(
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ordersList.length,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemBuilder: (context, index) {
                final order = ordersList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'طلب اوفلاين #${order.id}',
                            style: FontsAppHelper().cairoBoldFont(
                              size: 16,
                              color: AssetsColors.primaryOrange,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: 'حذف الطلب',
                                    titleStyle: FontsAppHelper().cairoBoldFont(
                                      size: 16,
                                      color:
                                          AssetsColors.color_text_black_392C23,
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        'هل أنت متأكد من حذف هذا الطلب؟',
                                        textAlign: TextAlign.center,
                                        style: FontsAppHelper().cairoMediumFont(
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                    confirm: ElevatedButton(
                                      onPressed: () {
                                        Get.back(); // close dialog
                                        controller.deleteOfflineRequest(
                                          order.id!,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 8,
                                        ),
                                      ),
                                      child: Text(
                                        'حذف',
                                        style: FontsAppHelper().cairoBoldFont(
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    cancel: TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text(
                                        'إلغاء',
                                        style: FontsAppHelper().cairoBoldFont(
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                tooltip: 'حذف',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (order.referenceNumber != null &&
                          order.referenceNumber!.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.numbers,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'الرقم المرجعي: ${order.referenceNumber}',
                              style: FontsAppHelper().cairoMediumFont(size: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (order.carNum != null && order.carNum!.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.directions_car,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'السيارة: ${order.carNum}',
                              style: FontsAppHelper().cairoMediumFont(size: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      // Row(
                      //   children: [
                      //     const Icon(
                      //       Icons.domain,
                      //       size: 20,
                      //       color: Colors.grey,
                      //     ),
                      //     const SizedBox(width: 8),
                      //     Text(
                      //       'المكب: ${controller.getSiteName(order.rubbleSiteOid)}',
                      //       style: FontsAppHelper().cairoMediumFont(size: 14),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'السائق: ${order.driverName ?? order.driverOid ?? '-'}',
                            style: FontsAppHelper().cairoMediumFont(size: 14),
                          ),
                        ],
                      ),
                      if (order.notes != null && order.notes!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.note_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                order.notes!,
                                style: FontsAppHelper().cairoRegularFont(
                                  size: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        order.createdAt
                                ?.replaceAll('T', ' ')
                                .substring(0, 16) ??
                            '',
                        style: FontsAppHelper().cairoRegularFont(
                          size: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDailyStatsCard(String title, RxInt count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AssetsColors.primaryOrange.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AssetsColors.primaryOrange.withOpacity(0.15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AssetsColors.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: FontsAppHelper().cairoBoldFont(
                    size: 13,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Obx(() {
              return Text(
                '${count.value}',
                style: FontsAppHelper().cairoBoldFont(
                  size: 18,
                  color: AssetsColors.primaryOrange,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
