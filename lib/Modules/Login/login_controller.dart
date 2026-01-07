import 'dart:convert';
import 'dart:developer';

import 'package:fill_go/Api/BaseResponse.dart';
import 'package:fill_go/Api/Repo/user_auth_repo.dart';
import 'package:fill_go/Helpers/DialogHelper.dart';
import 'package:fill_go/Model/TUser.dart';
import 'package:fill_go/Modules/Base/BaseGetxController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../App/Constant.dart';
import '../../App/app.dart';

class LoginController extends BaseGetxController {
  Future<BaseResponse<TUser>?> sendLoginRequest({
    required Map<String, dynamic> map,
  }) async {
    // log('in login');
    DialogHelper.showLoading();
    // setLoading(true);
    BaseResponse<TUser>? response = await UserAuthRepo.instance.postLogin(map);
    // setLoading(false);
    DialogHelper.hideLoading();
    if (checkResponse(response, showPopup: false)) {
      return null;
    }

    TUser? tUser = response.data;
    SharedPreferences sharedPreferences = await Application.sharedPreferences;
    if (tUser != null) {
      Map<String, dynamic> user = {
        "name": '${tUser.name}',
        'user_name': '${tUser.userName}',
        'is_active': '${tUser.isActive}',
        "user_type": "${tUser.userType}",
        "token": '${tUser.token}',
        "updated_at": '${tUser.updatedAt}',
      };
      await sharedPreferences!.setString(Constants.USER_DATA, jsonEncode(user));
      sharedPreferences!.setString(Constants.USER_AUTH_TOKEN, tUser.token!);
      sharedPreferences!.setBool(Constants.USER_IS_LOGIN, true);
      sharedPreferences!.setString(Constants.USER_TYPE, user['user_type']);
      Application.staticSharedPreferences = sharedPreferences;
    }
    return response;
  }
}
