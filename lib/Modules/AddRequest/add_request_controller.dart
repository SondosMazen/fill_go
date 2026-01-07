import 'dart:developer';

import 'package:fill_go/Api/BaseResponse.dart';
import 'package:fill_go/Api/Repo/requests_repo.dart';
import 'package:fill_go/App/app.dart';
import 'package:fill_go/Helpers/DialogHelper.dart';
import 'package:fill_go/Model/TDriver.dart';
import 'package:fill_go/Model/TOrder.dart';
import 'package:fill_go/Model/TSite.dart';
import 'package:fill_go/Modules/Base/BaseGetxController.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRequestController extends BaseGetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController loadingLocationController = TextEditingController();
  TextEditingController carTypeController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController unloadingLocationController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController adminNotesController = TextEditingController();
  TextEditingController driversController = TextEditingController();
  List<TDriver>? tDrivers;
  List<TSite>? tSites;
  String? selectedDriverValue;
  String? selectedUnloadLocationValue;

  @override
  void onInit() {
    getDrivers();
    getSites();
    super.onInit();
  }

  Future postStoreOrder() async {
    // log('in login');
    DialogHelper.showLoading();
    // setLoading(true);
    Map<String, dynamic> map = {
      'location': loadingLocationController.text,
      'car_num': carNumberController.text,
      'car_type': carTypeController.text,
      'rubble_site_oid': selectedUnloadLocationValue,
      'notes': notesController.text,
      'driver_oid': selectedDriverValue,
    };
    BaseResponse<dynamic>? response = await RequestsRepo.instance
        .postStoreOrder(body: map);
    // setLoading(false);
    DialogHelper.hideLoading();
    if (checkResponse(response, showPopup: true)) {
      return null;
    }
    String? tOrder = response.message ?? '';
    // SharedPreferences sharedPreferences = await Application.sharedPreferences;
  }

  Future<List<TDriver>?> getDrivers() async {
    log('in login');
    // DialogHelper.showLoading();
    setLoading(true);
    BaseResponse<List<TDriver>>? response = await RequestsRepo.instance
        .getDrivers();
    setLoading(false);
    // DialogHelper.hideLoading();
    if (checkResponse(response, showPopup: false)) {
      return null;
    }
    if (response.data != null) {
      tDrivers = response.data!;
      // update();
    }
    update();
    return tDrivers;
  }

  Future<List<TSite>?> getSites() async {
    log('in login');
    // DialogHelper.showLoading();
    // setLoading(true);
    BaseResponse<List<TSite>>? response = await RequestsRepo.instance
        .getSites();
    // setLoading(false);
    // DialogHelper.hideLoading();
    if (checkResponse(response, showPopup: false)) {
      return null;
    }
    if (response.data != null) {
      tSites = response.data!;
      // update();
    }
    update();
    return tSites;
  }

  List<SearchFieldListItem>? getSitesList() {
    return tSites?.map((driver) {
      return SearchFieldListItem(
        driver.name ?? 'لا يوجد اسم',
        value: '${driver.oid}',
      );
    }).toList();
  }

  List<SearchFieldListItem>? getDriversList() {
    return tDrivers?.map((driver) {
      return SearchFieldListItem(
        driver.name ?? 'لا يوجد اسم',
        value: '${driver.oid}',
      );
    }).toList();
  }
}
