// import 'package:get/get.dart';
// import 'package:fill_go/Api/BaseResponse.dart';
// import 'package:fill_go/Api/Repo/user_auth_repo.dart';
// import 'package:fill_go/Model/TUser.dart';
// import 'package:fill_go/Modules/Base/BaseGetxController.dart';

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
