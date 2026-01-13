import 'dart:io';
import 'package:fill_go/presentation/controllers/controllers/auth_controller.dart';
import 'package:fill_go/presentation/controllers/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fill_go/App/app.dart';
import 'App/binding.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Helpers/assets_color.dart';
import 'Helpers/font_helper.dart';
import 'Modules/Splash/splash_screen.dart';
import 'core/services/storage_service.dart';
import 'core/services/token_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/sync_service.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage services
  await GetStorage.init();
  await Application.initSharedPreferences();

  // Initialize GetX services
  await Get.putAsync<StorageService>(() => StorageService().init());
  await Get.putAsync<TokenService>(() => TokenService().init());

  // Initialize offline mode services
  Get.put<ConnectivityService>(ConnectivityService());
  Get.put<SyncService>(SyncService());

  Get.lazyPut(() => AuthController(), fenix: true);

  HttpOverrides.global = MyHttpOverrides();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: Binding(),
          locale: const Locale('ar'),
          fallbackLocale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            fontFamily: 'Cairo',
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              primary: AssetsColors.primaryOrange,
              seedColor: AssetsColors.primaryOrange,
            ),
            scaffoldBackgroundColor: whiteColor,
            primaryColor: AssetsColors.primaryOrange,
            appBarTheme: AppBarTheme(
              scrolledUnderElevation: 0,
              iconTheme: const IconThemeData(color: whiteColor),
              elevation: 0.0,
              backgroundColor: AssetsColors.primaryOrange,
              centerTitle: true,
              titleTextStyle: FontsAppHelper().cairoBoldFont(
                color: whiteColor,
                size: 20,
              ),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
            ),
            tabBarTheme: TabBarThemeData(
              labelColor: AssetsColors.primaryOrange,
              labelStyle: FontsAppHelper().cairoMediumFont(),
              unselectedLabelStyle: FontsAppHelper().cairoMediumFont(),
              unselectedLabelColor: const Color(0xff8A8A8F),
              indicator: const UnderlineTabIndicator(),
            ),
          ),
          navigatorKey: Application.navigatorKey,
          home: const LaunchScreen(),
          getPages: AppPages.pages,
        );
      },
    );
  }
}
