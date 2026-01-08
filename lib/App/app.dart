import 'dart:developer';

import '../App/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Application instance = Application();
  static const pageSize = 20;
  // static Future<SharedPreferences> sharedPreferences =
  //     SharedPreferences.getInstance();
  static late SharedPreferences sharedPreferences;

  static Future<void> initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences? staticSharedPreferences;

  static String? userType;
  Application() {
    init();
  }

  void init() async {
    staticSharedPreferences ??= await sharedPreferences;
    userType = staticSharedPreferences!.getString(Constants.USER_TYPE);
    log('USER_DATA from main Application ${await staticSharedPreferences!.getString(Constants.USER_DATA)}');
    log('USER_AUTH_TOKEN from main Application ${await staticSharedPreferences!.getString(Constants.USER_AUTH_TOKEN)}');
    log('USER_IS_LOGIN from main Application ${await staticSharedPreferences!.getBool(Constants.USER_IS_LOGIN)}');
    log('USER_TYPE from main Application ${await staticSharedPreferences!.getString(Constants.USER_TYPE)}');
  }
}
