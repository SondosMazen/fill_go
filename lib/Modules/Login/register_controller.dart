// import 'package:fill_go/Api/BaseResponse.dart';
// import 'package:fill_go/Api/Repo/user_auth_repo.dart';
// import 'package:fill_go/Model/TUser.dart';
// import 'package:fill_go/Modules/Base/BaseGetxController.dart';

// import '../../Helpers/DialogHelper.dart';

// class RegisterController extends BaseGetxController {
//   BaseResponse<TUser>? response;
//   TUser? tUser;

//   Future<BaseResponse<TUser>?> sendeRegisterRequest(
//       {required Map<String, dynamic> map}) async {
//     DialogHelper.showLoading();

//     setLoading(true);
//     try {
//       response = await UserAuthRepo.instance.postUserAuthRegister(body: map);
//       if (response!.status == false) {
//         setLoading(false);

//         DialogHelper.hideLoading();
//         if (checkResponse(response)) {
//           return null;
//         }

//         tUser = response!.msg;
//       } else if (response!.message == 'acc not found') {
//         setLoading(false);
//         DialogHelper.hideLoading();
//         DialogHelper.showMyDialog(
//             title: 'رقم الهوية غير تابع لهذا الاشتراك', description: '');
//       }
//     } catch (e) {
//       setLoading(false);

//       DialogHelper.hideLoading();
//       print('${e}erroroo');

//       return null;
//     }
//     update();

//     return response;
//   }
// }
