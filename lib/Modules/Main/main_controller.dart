import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:fill_go/Model/TMenu.dart';
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

  // var menuList = [
  //   TMenu(
  //       iconPath: AssetsHelper.ic_tab_home_on_svg,
  //       name: 'home'),
  //   TMenu(
  //       iconPath: AssetsHelper.ic_menu_last_news_svg,
  //       name:' menu_last_news'),
  //   TMenu(
  //       iconPath: AssetsHelper.ic_tab_services_off_svg,
  //       name:' menu_services'),
  //   TMenu(
  //       iconPath: AssetsHelper.ic_menu_about_svg,
  //       name: 'menu_about'),
  //   TMenu(
  //       iconPath: AssetsHelper.ic_menu_search_location_svg,
  //       name: 'menu_search_building'),
  //   TMenu(
  //       iconPath: AssetsHelper.ic_menu_questions_svg,
  //       name: 'menu_questions'),
  //   TMenu(
  //       iconPath: AssetsHelper.ic_menu_contact_svg,
  //       name: 'menu_contact_us'),
  //   TMenu(
  //       iconPath: AssetsHelper.ic_menu_settings_svg,
  //       name:' menu_settings'),
  //   // TMenu(iconPath: AssetsHelper.ic_menu_privacy_svg , name: menu_privacy_policy),
  // ];

  void changeBottomNavigationBar(int value) {
    currantPageIndex = value;
    update();
  }

  TUser? tUser;
  Future<void> getUser() async {
    SharedPreferences shared = await Application.sharedPreferences;
    tUser = TUser.fromJson(jsonDecode(shared.getString(Constants.USER_DATA) ??
        "")); // called immediately after the widget is allocated memory
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
}
