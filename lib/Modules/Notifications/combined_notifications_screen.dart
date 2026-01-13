import 'package:fill_go/Modules/PendingOrders/pending_orders_screen.dart';
import 'package:fill_go/Modules/PendingAcceptOrders/pending_accept_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:fill_go/Helpers/font_helper.dart';
import 'package:fill_go/Modules/Main/Home/home_controller.dart';
import 'package:get/get.dart';

/// شاشة الإشعارات بناءً على نوع المستخدم
class CombinedNotificationsScreen extends StatelessWidget {
  const CombinedNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على نوع المستخدم
    final homeController = Get.find<HomeController>();
    // userType: 2 = (مفتش (يضيف طلبات،
    // userType: 1 = مراقب (يقبل طلبات)
    final isContractor = homeController.isContractor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isContractor ? 'طلبات جديدة' : 'طلبات مقبولة',
          style: FontsAppHelper().cairoBoldFont(size: 22, color: Colors.white),
        ),
      ),
      body: isContractor
          ? const PendingOrdersScreen(showAppBar: false)
          : const PendingAcceptOrdersScreen(showAppBar: false),
    );
  }
}
