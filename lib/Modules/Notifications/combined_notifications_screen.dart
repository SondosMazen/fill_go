import 'package:rubble_app/Modules/PendingOrders/pending_orders_screen.dart';
import 'package:rubble_app/Modules/PendingAcceptOrders/pending_accept_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:rubble_app/Helpers/font_helper.dart';
import 'package:rubble_app/Modules/Main/Home/home_controller.dart';
import 'package:get/get.dart';
import 'package:rubble_app/Helpers/assets_color.dart';

/// شاشة الإشعارات بناءً على نوع المستخدم
class CombinedNotificationsScreen extends StatelessWidget {
  const CombinedNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على نوع المستخدم
    final homeController = Get.find<HomeController>();
    // userType: 2 = Contractor (Add Orders)
    // userType: 1 = Inspector/Monitor (Accept Orders)
    final isContractor = homeController.isContractor;

    // Monitor/Inspector (UserType 1): Sees "Accepted Requests" (Offline) only
    if (!isContractor) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AssetsColors.primaryOrange,
          centerTitle: true,
          title: Text(
            'تم القبول أوفلاين',
            style: FontsAppHelper().cairoBoldFont(
              size: 22,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: const PendingAcceptOrdersScreen(showAppBar: false),
      );
    }

    // Contractor (UserType 2): Sees only their "New Requests" (Offline added)
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AssetsColors.primaryOrange,
        centerTitle: true,
        title: Text(
          'طلبات جديدة',
          style: FontsAppHelper().cairoBoldFont(size: 22, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: const PendingOrdersScreen(showAppBar: false),
    );
  }
}
