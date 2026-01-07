// import 'dart:convert';

// import 'package:fill_go/Modules/Main/Home/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:fill_go/Helpers/assets_color.dart';
// import 'package:fill_go/Helpers/assets_helper.dart';
// import 'package:fill_go/Modules/Login/register_controller.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../Api/BaseResponse.dart';
// import '../../App/Constant.dart';
// import '../../App/app.dart';
// import '../../Model/TUser.dart';
// import '../../Widgets/custom_widgets.dart';
// import '../Main/main_controller.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   TextEditingController myNameController = TextEditingController();
//   TextEditingController myPhoneController = TextEditingController();
//   TextEditingController mySubscriptionController = TextEditingController();
//   TextEditingController myEmailController = TextEditingController();
//   TextEditingController myPasswordController = TextEditingController();
//   TextEditingController myIdentityController = TextEditingController();

//   RegisterController registerController = Get.put(RegisterController());
//   final mainController = Get.put(MainController());

//   @override
//   void dispose() {
//     myNameController.dispose();
//     myPhoneController.dispose();
//     mySubscriptionController.dispose();
//     myEmailController.dispose();
//     myPasswordController.dispose();
//     myIdentityController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: false,
//       // resizeToAvoidBottomInset: true,
//       // resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'register_title',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: AssetsColors.color_text_black_392C23,
//             fontSize: 24.sp,
//             fontFamily: AssetsHelper.FONT_Avenir,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         iconTheme: const IconThemeData(
//           color: AssetsColors.color_text_black_392C23,
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       backgroundColor: AssetsColors.color_screen_background,
//       body: initBody(),
//     );
//   }

//   Column initBody() {
//     return Column(
//       children: [
//         SizedBox(height: 20.h),
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: const Color(0xFFEFEFF5)),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsetsDirectional.only(
//                 start: 14.w,
//                 end: 14.w,
//                 top: 10.h,
//                 bottom: 10.h,
//               ),
//               child: ListView(
//                 children: [
//                   bodyTitleUI(),
//                   const SizedBox(height: 26),
//                   bodyContentUI(),
//                   footerUI(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Column bodyTitleUI() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'register_title',
//           style: TextStyle(
//             color: AssetsColors.color_text_black_392C23,
//             fontSize: 18.sp,
//             fontFamily: AssetsHelper.FONT_Avenir,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         Text(
//           'login_sign_in',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: AssetsColors.color_text_black_392C23,
//             fontSize: 14.sp,
//             fontFamily: AssetsHelper.FONT_Avenir,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ],
//     );
//   }

//   Form bodyContentUI() {
//     final formKey = GlobalKey<FormState>();

//     return Form(
//       key: formKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'register_full_name',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: AssetsColors.color_text_black_392C23,
//               fontSize: 14.sp,
//               fontFamily: AssetsHelper.FONT_Avenir,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 5),
//           //name
//           MyTextField(
//             myController: myNameController,
//             hint: 'register_enter_full_name',
//             textValidType: TEXT_VALID_TYPE.GENERAL,
//             iconData: Icons.person_outline,
//             textInputType: TextInputType.name,
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'register_phone',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: AssetsColors.color_text_black_392C23,
//               fontSize: 14.sp,
//               fontFamily: AssetsHelper.FONT_Avenir,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 5),

//           //phone
//           MyTextField(
//             myController: myPhoneController,
//             textValidType: TEXT_VALID_TYPE.PalPhone,
//             hint: 'register_enter_phone',
//             iconData: Icons.phone_android_outlined,
//             textInputType: TextInputType.phone,
//           ),
//           const SizedBox(height: 10),

//           //identity num
//           Text(
//             'رقم الهوية الخاصة بالاشتراك',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: AssetsColors.color_text_black_392C23,
//               fontSize: 14.sp,
//               fontFamily: AssetsHelper.FONT_Avenir,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 10),

//           MyTextField(
//             myController: myIdentityController,
//             textValidType: TEXT_VALID_TYPE.NUMBER,
//             hint: 'ادخل رقم الهوية الخاصة بالاشتراك',
//             iconData: Icons.confirmation_number_sharp,
//             textInputType: TextInputType.number,
//           ),
//           const SizedBox(height: 10),

//           Text(
//             'email',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: AssetsColors.color_text_black_392C23,
//               fontSize: 14.sp,
//               fontFamily: AssetsHelper.FONT_Avenir,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 5),
//           //email
//           MyTextField(
//             myController: myEmailController,
//             textValidType: TEXT_VALID_TYPE.EMAIL,
//             hint: 'login_enter_email',
//             iconData: Icons.email_outlined,
//             textInputType: TextInputType.emailAddress,
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'register_number_of_sub',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: AssetsColors.color_text_black_392C23,
//               fontSize: 14.sp,
//               fontFamily: AssetsHelper.FONT_Avenir,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 5),

//           //number of subsicription
//           MyTextField(
//             myController: mySubscriptionController,
//             textValidType: TEXT_VALID_TYPE.NUMBER,
//             hint: 'register_enter_number_of_sub',
//             iconData: Icons.credit_card_rounded,
//             textInputType: TextInputType.number,
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'password',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: AssetsColors.color_text_black_392C23,
//               fontSize: 14.sp,
//               fontFamily: AssetsHelper.FONT_Avenir,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 5),

//           //password
//           MyTextField(
//             myController: myPasswordController,
//             hint: 'login_enter_password',
//             textValidType: TEXT_VALID_TYPE.PASSWORD,
//             iconData: Icons.lock_outline_rounded,
//             textInputType: TextInputType.text,
//             isPassword: true,
//           ),
//           const SizedBox(height: 30),
//           MyCustomButton(
//             text: 'register_create_account',
//             onPressed: () {
//               // checkData();
//               if (formKey.currentState!.validate()) {
//                 handleRegisterClick();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Row footerUI() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           'register_already_have_account',
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             color: AssetsColors.color_text_black_392C23,
//             fontSize: 14,
//             fontFamily: AssetsHelper.FONT_Avenir,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsetsDirectional.only(start: 4, end: 4),
//           child: TextButton(
//             onPressed: () {
//               Get.back();
//             },
//             child: Text(
//               'login',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: AssetsColors.color_green_3EC4B5,
//                 fontSize: 14,
//                 fontFamily: AssetsHelper.FONT_Avenir,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   bool isNotValidTextField({
//     required TextEditingController textController,
//     String? errorText,
//   }) {
//     if (textController.value.text.isEmpty) {
//       print("iam controller of  $textController");
//       return true;
//     }
//     return false;
//   }

//   void handleRegisterClick() async {
//     Map<String, dynamic> map = {};
//     map["email"] = myEmailController.text;
//     map["user_pwd"] = myPasswordController.text;
//     map["agreement_id"] = mySubscriptionController.text;
//     map["mobile"] = myPhoneController.text;
//     map["full_name"] = myNameController.text;
//     map["user_id"] = myIdentityController.text;

//     BaseResponse<TUser>? tUserResponse = await registerController
//         .sendeRegisterRequest(map: map);

//     if (tUserResponse == null || tUserResponse.msg == null) return;
//     if (tUserResponse.status!) {
//       SharedPreferences sharedPreferences = await Application.sharedPreferences;

//       Map<String, dynamic> user = {
//         'full_name': myNameController.text,
//         'email': myEmailController.text,
//         'acc_num': mySubscriptionController.text,
//         'api_token': '${tUserResponse.msg!.apiToken}',
//       };

//       await sharedPreferences.setString(Constants.USER_DATA, jsonEncode(user));
//       sharedPreferences.setString(
//         Constants.USER_AUTH_TOKEN,
//         tUserResponse.msg!.apiToken!,
//       );
//       //  sharedPreferences.setString(Constants.USER_AUTH_TOKEN, tUser.apiToken!);
//       sharedPreferences.setBool(Constants.USER_IS_LOGIN, true);

//       Get.offAll(() => const HomeScreen());
//     }
//   }
// }
