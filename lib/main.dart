import 'dart:io';
import 'package:fill_go/Modules/Main/Home/home_screen.dart';
import 'package:fill_go/presentation/controllers/auth_controller.dart';
import 'package:fill_go/presentation/controllers/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:fill_go/App/app.dart';
// import 'package:timeago/timeago.dart';
import 'App/binding.dart';
// import 'Helpers/Object_box.dart';
import 'Helpers/assets_color.dart';
import 'Helpers/font_helper.dart';
import 'Modules/Login/login_screen.dart';
import 'Modules/Splash/splash_screen.dart';
import 'core/services/storage_service.dart';
import 'core/services/token_service.dart';
// import 'l10n/app_localization.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// late ObjectBox objectbox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Application.initSharedPreferences();

  await GetStorage.init();

  await Get.putAsync<StorageService>(() => StorageService().init());
  await Get.putAsync<TokenService>(() => TokenService().init());

  Get.lazyPut(() => AuthController(), fenix: true);

  // objectbox = await ObjectBox.init();
  HttpOverrides.global = MyHttpOverrides();

  // AppLocalization.localesMap.forEach((locale, lookupMessages) {
  //   // setLocaleMessages(locale, lookupMessages);
  // });

  // تهيئة GetStorage
  await GetStorage.init();
  Application().init(); //SharedPreferences init

  runApp(MaterialApp.router(
    routerConfig: router,
    debugShowCheckedModeBanner: false,
  ));
}
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, state) => const MainApp(),
      routes: [
        GoRoute(
          path: '/MServices/laravel/public/MobileNews',
          builder: (context, state) {
            return HomeScreen();
          },
          // routes: [
          //   GoRoute(
          //       path: ':title',
          //       builder: (context, state) => DeepLinkScreen(),
          //       routes: [
          //         GoRoute(
          //           path: ':id',
          //           builder: (context, state) => DeepLinkScreen(),
          //         )
          //       ])
          // ]),
          //   GoRoute(
          //       path: 'advertise',
          //       builder: (context, state) {
          //         return DeepLinkScreen();
          //       },
          //       routes: [
          //         GoRoute(
          //             path: ':title',
          //             builder: (context, state) => DeepLinkScreen(),
          //             routes: [
          //               GoRoute(
          //                 path: ':id',
          //                 builder: (context, state) => DeepLinkScreen(),
        )
        //             ])
        //       ]),
      ],
    ),
  ],
);

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // enableScaleWH: () => false,
      // useInheritedMediaQuery: false,
      designSize: const Size(320, 696),
      // fontSizeResolver: (fontSize, instance) {
      //   return 18;
      // },
      // enableScaleText: () => false,
      builder: (child, constraint) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: Binding(),
          theme: ThemeData(
            useMaterial3: true,
             colorScheme: ColorScheme.fromSeed(
              primary: AssetsColors.color_green_3EC4B5,
              seedColor: AssetsColors.color_green_3EC4B5, // Change the seed color
            ),
            scaffoldBackgroundColor: whiteColor,
            primaryColor: AssetsColors.color_green_3EC4B5,
            appBarTheme: AppBarTheme(
              scrolledUnderElevation: 0,
              iconTheme: const IconThemeData(color: blackColor),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              titleTextStyle: FontsAppHelper().avenirArabicHeavyFont(),
              systemOverlayStyle: const SystemUiOverlayStyle(
                // Status bar color
                statusBarColor: Color(0x33FFFFFF),
                // Status bar brightness (optional)
                statusBarIconBrightness:
                    Brightness.dark, // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)xw
              ),
            ),
            tabBarTheme: TabBarThemeData(
              labelColor: blueColor,
              labelStyle: FontsAppHelper().avenirArabicMediumFont(),
              unselectedLabelStyle: FontsAppHelper().avenirArabicMediumFont(),
              unselectedLabelColor: const Color(0xff8A8A8F
                  // 0xffBDBBBB,
                  ),
              indicator: const UnderlineTabIndicator(),
            ),
          ),
          navigatorKey: Application.navigatorKey,
          // set property
          // localizationsDelegates: AppLocalization.localizationsDelegates,
          // supportedLocales: AppLocalization.all,
          home: const LaunchScreen(),
          getPages: AppPages.pages,

          // getPages: [
          //   GetPage(
          //     name: '/launch_screen',
          //     page: () => const LaunchScreen(),
          //   ),
          //   GetPage(name: '/login_screen', page: () => const LoginScreen()),
          // ],

        );
      },
    );
  }
}
