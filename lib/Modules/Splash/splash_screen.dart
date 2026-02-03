import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rubble_app/App/Constant.dart';
import 'package:rubble_app/App/app.dart';
import 'package:rubble_app/presentation/controllers/routes/app_pages.dart';
import '../../Helpers/assets_helper.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      bool isUserLogin =
          Application.sharedPreferences.getBool(Constants.USER_IS_LOGIN) ??
          false;

      Get.updateLocale(const Locale("ar"));
      if (isUserLogin) {
        Get.offAllNamed(AppPages.home);
      } else {
        Get.offAllNamed(AppPages.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFAFAFA),
      body: Container(
        alignment: AlignmentDirectional.center,
        color: const Color(0xFFFAFAFA),
        child: Image.asset(
          AssetsHelper.getAssetPNG("rubble_app_icon"),
          width:
              350, // Set a reasonable width to prevent it from being too large or small
          height: 350,
        ),
      ),
    );
  }
}
