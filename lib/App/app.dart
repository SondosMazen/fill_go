import 'dart:developer';
import '../App/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static const pageSize = 20;

  static late SharedPreferences sharedPreferences;
  static String? userType;

  static Future<void> initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userType = sharedPreferences.getString(Constants.USER_TYPE);

    log('USER_DATA: ${sharedPreferences.getString(Constants.USER_DATA)}');
    log(
      'USER_TOKEN: ${sharedPreferences.getString(Constants.USER_AUTH_TOKEN)}',
    );
    log('IS_LOGIN: ${sharedPreferences.getBool(Constants.USER_IS_LOGIN)}');
    log('USER_TYPE: ${sharedPreferences.getString(Constants.USER_TYPE)}');

    // Ensure clean slate if login status is undefined (e.g. fresh install or cleared data)
    if (sharedPreferences.getBool(Constants.USER_IS_LOGIN) == null) {
      await sharedPreferences.remove(Constants.USER_AUTH_TOKEN);
      await sharedPreferences.remove(Constants.USER_DATA);
      await sharedPreferences.remove(Constants.USER_TYPE);
    }
  }
}
