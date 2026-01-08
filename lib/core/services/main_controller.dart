import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api/BaseResponse.dart';
import '../../Api/DioHelper.dart';
import '../../Api/Repo/user_auth_repo.dart';
import '../../App/Constant.dart';
import '../../App/app.dart';
import '../../Helpers/assets_color.dart';
import '../../Helpers/assets_helper.dart';
import '../../Model/TUser.dart';
import '../../Utils/utils.dart';

class MainController extends GetxController {

  TUser? tUser;
  getUser() async {
    try {
      SharedPreferences shared = await Application.sharedPreferences;
      String? userData = shared.getString(Constants.USER_DATA);

      if (userData != null && userData.isNotEmpty) {
        try {
          tUser = TUser.fromJson(jsonDecode(userData));
        } catch (e) {
          print('Error parsing user data: $e');
          tUser = null;
        }
      } else {
        tUser = null;
      }
    } catch (e) {
      print('Error accessing SharedPreferences: $e');
      tUser = null;
    }
    update();
  }

  @override
  void onReady() {
    // called after the widget is rendered on screen
    super.onReady();
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    super.onClose();
  }

  logout() async {
    // SharedPreferences shared = await Application.sharedPreferences;
    BaseResponse<String>? response =
    await UserAuthRepo.instance.Logout({'token': getToken()});
  }
}
