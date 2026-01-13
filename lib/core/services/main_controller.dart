import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api/BaseResponse.dart';
import '../../Api/DioHelper.dart';
import '../../Api/Repo/user_auth_repo.dart';
import '../../App/Constant.dart';
import '../../App/app.dart';
import '../../Model/TUser.dart';

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
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  logout() async {
    BaseResponse<String>? response =
    await UserAuthRepo.instance.Logout({'token': getToken()});
  }
}
