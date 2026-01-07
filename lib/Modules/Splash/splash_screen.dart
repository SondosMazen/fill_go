import 'package:fill_go/Modules/Main/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:fill_go/App/Constant.dart';
import 'package:fill_go/App/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Helpers/assets_helper.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {

      SharedPreferences sharedPreferences = await Application.sharedPreferences;
      bool isUserLogin =
          sharedPreferences.getBool(Constants.USER_IS_LOGIN) ?? false;

      if (isUserLogin) {
        Get.updateLocale(const Locale("ar"));
        Get.offAll(()=> HomeScreen());
        return;
      }
      Get.updateLocale(const Locale("ar"));
      Get.offAllNamed("/login_screen");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFFAFAFA),
            alignment: AlignmentDirectional.center,
            child: Image.asset(AssetsHelper.getAssetPNG("ic_splash_bkg"),fit: BoxFit.cover),
          ),
          Container(
            alignment: AlignmentDirectional.center,
            child: Image.asset(AssetsHelper.getAssetPNG("ic_logo_splash")),
          )
        ],
      ),
    );
  }
}
