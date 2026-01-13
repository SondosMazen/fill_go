import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../App/Constant.dart';
import '../../App/app.dart';
import '../../Helpers/assets_color.dart';
import '../../Helpers/assets_helper.dart';
import '../../Model/TUser.dart';

class MainController extends GetxController {
  int currantPageIndex = 0;
  var bottomNavIcon = [
    BottomNavigationBarItem(
      label: 'home',
      icon: SvgPicture.asset(AssetsHelper.ic_tab_home_off_svg),
      activeIcon: SvgPicture.asset(AssetsHelper.ic_tab_home_on_svg),
    ),
    BottomNavigationBarItem(
      label: 'tab_services',
      icon: SvgPicture.asset(AssetsHelper.ic_tab_services_off_svg),
      activeIcon: SvgPicture.asset(
        AssetsHelper.ic_tab_services_off_svg,
        color: AssetsColors.color_green_3EC4B5,
      ),
    ),
    BottomNavigationBarItem(
      label: 'tab_map',
      icon: SvgPicture.asset(AssetsHelper.ic_tab_map_off_svg),
      activeIcon: SvgPicture.asset(
        AssetsHelper.ic_tab_map_off_svg,
        color: AssetsColors.color_green_3EC4B5,
      ),
    ),
    BottomNavigationBarItem(
      label: 'tab_complaint',
      icon: SvgPicture.asset(AssetsHelper.ic_tab_complaint_off_svg),
      activeIcon: SvgPicture.asset(
        AssetsHelper.ic_tab_complaint_off_svg,
        color: AssetsColors.color_green_3EC4B5,
      ),
    ),
    BottomNavigationBarItem(
      label: 'tab_more',
      icon: SvgPicture.asset(AssetsHelper.ic_tab_more_off_svg),
      activeIcon: SvgPicture.asset(
        AssetsHelper.ic_tab_more_off_svg,
        color: AssetsColors.color_green_3EC4B5,
      ),
    ),
  ];

  void changeBottomNavigationBar(int value) {
    currantPageIndex = value;
    update();
  }

  TUser? tUser;
  Future<void> getUser() async {
    SharedPreferences shared = await Application.sharedPreferences;
    tUser = TUser.fromJson(jsonDecode(shared.getString(Constants.USER_DATA) ??
        ""));
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
