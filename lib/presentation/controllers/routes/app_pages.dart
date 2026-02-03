import 'package:rubble_app/Modules/Login/login_screen.dart';
import 'package:rubble_app/Modules/Main/Home/home_screen.dart';
import 'package:rubble_app/Modules/PendingOrders/pending_orders_screen.dart';
import 'package:get/get.dart';
import 'package:rubble_app/Modules/Splash/splash_screen.dart';
import 'package:rubble_app/presentation/controllers/bindings/auth_binding.dart';
import 'package:rubble_app/presentation/controllers/bindings/initial_binding.dart';

/// مسارات التطبيق
abstract class AppPages {
  // Route names
  static const String splash = '/launch_screen';
  static const String login = '/login_screen';
  static const String home = '/home_screen';
  static const String pendingOrders = '/pending-orders';

  /// صفحات التطبيق
  static List<GetPage> get pages => [
    GetPage(
      name: splash,
      page: () => const LaunchScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: pendingOrders,
      page: () => const PendingOrdersScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
