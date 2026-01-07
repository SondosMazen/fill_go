import 'dart:developer';

import 'package:fill_go/Api/Repo/requests_repo.dart';
import 'package:fill_go/Api/Repo/user_auth_repo.dart';
import 'package:fill_go/App/Constant.dart';
import 'package:fill_go/App/app.dart';
import 'package:fill_go/Helpers/snackbar_helper.dart';
import 'package:fill_go/Model/TOrder.dart';
import 'package:fill_go/Model/TUser.dart';
import 'package:fill_go/Modules/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
// import 'package:fill_go/Api/Repo/news_adv_repo.dart';
// import 'package:fill_go/Model/TMynotification.dart';
import 'package:fill_go/Modules/Base/BaseGetxController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Api/BaseResponse.dart';

class HomeController extends BaseGetxController {
  int selectedIndex = 0;
  String filterValue = 'all';
  MultiSelectController filterListController = MultiSelectController();
  RxList<TOrder> filteredOrders = RxList<TOrder>.empty();
  // List<Map<String, dynamic>> data_ref=[] ;
  bool isloadNotification = false;
  // static HomeController get to => Get.find<HomeController>();
  bool isUser = false;
  List<TOrder>? tOrder;
  String? acceptOrderMsg;
  String userType = '0';
  // var userType = '0'.obs;// 1=>  , 2=>

  // Future<List> getDummy() async {
  //   return Future.delayed(Duration(seconds: 0), () {
  //     ddata = data_ref;
  //     if (filterValue == 'full') {
  //       log('display loaded data');
  //       ddata = data_ref
  //           .where((element) => element['isLoaded'] == true)
  //           .toList();
  //     } else if (filterValue == 'empty') {
  //       log('display not loaded data');
  //       ddata = data_ref
  //           .where((element) => element['isUnloaded'] == true)
  //           .toList();
  //     } else {
  //       log('display all data');
  //       return ddata;
  //     }
  //     // update();
  //     // ddata = data;
  //     return ddata;
  //   });
  // }

  Future<List<TOrder>?> getOrders() async {
    setLoading(true);
    // update();
    BaseResponse<List<TOrder>>? response = await RequestsRepo.instance
        .getOrders();
    setLoading(false);
    if (checkResponse(response)) {
      return null;
    }
    if (response.data != null) {
      log('get Order fnished ${response.data?[0].orderNum}');
      tOrder = response.data!;
      tOrder!.sort((a, b) {
        return DateTime.parse(
          b.entryDate ?? '',
        ).compareTo(DateTime.parse(a.entryDate ?? ''));
      });
      filteredOrders.value = tOrder ?? [];
      // update();
    }
    return tOrder;
  }

  void logout() async {
    SharedPreferences sharedPreferences = await Application.sharedPreferences;
    setLoading(true);
    // update();
    await UserAuthRepo.instance.postUserAuthLogOut();
    setLoading(false);
    // update();
    sharedPreferences.setString(Constants.USER_DATA, '');
    sharedPreferences.setString(Constants.USER_AUTH_TOKEN, '');
    sharedPreferences.setBool(Constants.USER_IS_LOGIN, false);
    sharedPreferences.setString(Constants.USER_TYPE, '-1');

    Application.staticSharedPreferences = sharedPreferences;
    Get.offAll(LoginScreen());
    // if (checkResponse(response)) {
    //   return null;
    // }
  }

  // List<TMyNotification>? tMyNotification = [];
  // Future<void> getMyNotification() async {
  //   isloadNotification = true;
  //   update();
  //   BaseResponse<List<TMyNotification>>? baseResponse = await UserAuthRepo
  //       .instance
  //       .getMyNotification();
  //   isloadNotification = false;
  //   update();
  //   tMyNotification = baseResponse!.data;
  //   update();
  // }

  @override
  void onInit() async {
    userType =
        Application.staticSharedPreferences!.getString(Constants.USER_TYPE) ??
        '0';
    super.onInit();

    // isUser =
    //     Application.staticSharedPreferences!.getBool(Constants.USER_IS_LOGIN) ??
    //     false;
    // await getHome();
    if (isUser) {
      // getMyNotification();
    }
  }

  void changeCurrentIndex(int updatedIndex) {
    selectedIndex = updatedIndex;
    update();
  }

  void search(q) {
    if (q == '' || q == null) {
      filteredOrders.value = tOrder ?? [];
      update();
    } else {
      filteredOrders.value = tOrder!.where((order) {
        // var elementValues = tOrder.values.toString();
        // return elementValues.contains(value);
        bool t = false;
        if (order.oid?.toString().contains(q) ?? false) {
          t = true;
        } else if (order.location?.contains(q) ?? false) {
          t = true;
        } else if (order.carNum?.contains(q) ?? false) {
          t = true;
        } else if (order.carType?.contains(q) ?? false) {
          t = true;
        } else if (order.orderNum?.contains(q) ?? false) {
          t = true;
        } else if (order.entryNotes?.contains(q) ?? false) {
          t = true;
        } else if (order.processNotes?.contains(q) ?? false) {
          t = true;
        } else if (order.entryDate?.contains(q) ?? false) {
          t = true;
        } else if (order.site?.name?.contains(q) ?? false) {
          t = true;
        } else if (order.entryUser?.name?.contains(q) ?? false) {
          t = true;
        }
        return t;
      }).toList();
      // log('${filteredOrders.first.location}');
      // log('search result ${Ft.length}');
    }
    update();
  }

  void acceptOrder(String orderNumber, {String? notes}) async {
    Map<String, dynamic> body = {
      'notes': notes ?? 'تم قبول الطلب',
      'order_oid': orderNumber,
    };
    setLoading(true);
    // update();
    BaseResponse? response = await RequestsRepo.instance.postProcessOrder(
      body: body,
    );
    setLoading(false);
    if (checkResponse(response)) {
      return null;
    }
    if (response.data != null) {
      // log('get Order fnished ${response.data?[0].orderNum}');
      acceptOrderMsg = response.message!;
      SnackBarHelper.show(msg: acceptOrderMsg!, backgroundColor: Colors.green);
      update();
    }
    // return tOrder;
  }
}
