// import 'package:get/get.dart';
// import 'package:rubble_app/Api/BaseResponse.dart';
// import 'package:rubble_app/Api/Repo/user_auth_repo.dart';
// import 'package:rubble_app/Model/TUser.dart';
// import 'package:rubble_app/Modules/Base/BaseGetxController.dart';

// import '../../Helpers/DialogHelper.dart';

// class ForgetPasswordController extends BaseGetxController {
//   static ForgetPasswordController get to =>
//       Get.find<ForgetPasswordController>();

//   Future<BaseResponse<TUser>?> postForgetPassword(
//       {required Map<String, dynamic> map}) async {
//     DialogHelper.showLoading();

//     BaseResponse<TUser>? response = await UserAuthRepo.instance
//         .postUserAuthForgetPass(body: map, isPopupLoading: true);

//     DialogHelper.hideLoading();

//     if (checkResponse(response)) {
//       return null;
//     }
//     return response;
//   }
// }
