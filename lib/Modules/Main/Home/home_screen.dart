import 'package:fill_go/Modules/AddRequest/add_request.dart';
import 'package:fill_go/Modules/Main/Home/home_controller.dart';
import 'package:fill_go/Modules/Main/Home/widgets/request_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import '../../../App/Constant.dart';
import '../../../App/app.dart';
import '../../../core/services/token_service.dart';
import '../../../core/services/sync_service.dart';
import '../../../presentation/controllers/routes/app_pages.dart';
import '../../../Helpers/assets_color.dart';
import '../../../Helpers/font_helper.dart';
import 'package:fill_go/Modules/Notifications/combined_notifications_screen.dart';

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
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
              onPressed: () async {
                await TokenService.to.clearToken();
                final shared = Application.sharedPreferences;
                await shared.setBool(Constants.USER_IS_LOGIN, false);
                await shared.setString(Constants.USER_DATA, "");
                Get.offAllNamed(AppPages.login);
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.6),
            labelStyle: FontsAppHelper().cairoBoldFont(size: 16),
            unselectedLabelStyle: FontsAppHelper().cairoMediumFont(size: 16),
            tabs: const [
              Tab(text: 'قيد المعالجة'),
              Tab(text: 'تم القبول'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTab(controller.filteredPendingOrders),
            _buildTab(controller.filteredAcceptedOrders),
          ],
        ),
        floatingActionButton: Obx(
          () => controller.isContractor
              ? FloatingActionButton(
                  onPressed: () async {
                    final result = await Get.to(
                      AddRequest(
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
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildTab(RxList<dynamic> ordersList) {
    return RefreshIndicator(
      onRefresh: () => controller.getOrders(),
      color: AssetsColors.primaryOrange,
      backgroundColor: Colors.white,
      child: Obx(() {
        // عرض مؤشر التحميل عند تحميل البيانات
        if (controller.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 200),
              child: CircularProgressIndicator(
                color: AssetsColors.primaryOrange,
              ),
            ),
          );
        }

        // عرض المحتوى بعد انتهاء التحميل
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
}
