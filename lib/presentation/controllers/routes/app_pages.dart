import 'package:fill_go/Modules/Login/login_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../Model/TUser.dart';
import '../../../Modules/Splash/splash_screen.dart';
import '../auth_controller.dart';
import '../bindings/auth_binding.dart';
import '../bindings/initial_binding.dart';

/// مسارات التطبيق
abstract class AppPages {
  // Route names
  static const String splash = '/launch_screen';
  static const String login = '/login_screen';
  static const String constractor = '/constractor_screen';

  // getPages: [
  // GetPage(
  // name: '/launch_screen',
  // page: () => const LaunchScreen(),
  // ),
  // GetPage(name: '/login_screen', page: () => const LoginScreen()),
  // ],

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
      ];
}
