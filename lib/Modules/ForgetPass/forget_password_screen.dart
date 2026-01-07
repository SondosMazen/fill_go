// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:fill_go/Api/BaseResponse.dart';
// import 'package:fill_go/Helpers/assets_color.dart';
// import 'package:fill_go/Helpers/assets_helper.dart';
// import 'package:fill_go/Modules/ForgetPass/forget_password_controller.dart';
// import 'package:fill_go/Utils/utils.dart';
// import 'package:fill_go/Widgets/custom_app_bar.dart';

// import '../../Model/TUser.dart';
// import '../../Widgets/custom_widgets.dart';

// class ForgetPasswordScreen extends StatefulWidget {
//   final forgetPasswordController = Get.put(ForgetPasswordController());

//   ForgetPasswordScreen({super.key});

//   @override
//   _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
// }

// class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
//   TextEditingController emailController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: false,
//       // resizeToAvoidBottomInset: false,
//       appBar: CustomAppBar(
//         onPressed: () => Get.back(),
//         title: 'forget_title',
//       ),
//       backgroundColor: AssetsColors.color_screen_background,
//       body: initBody(),
//     );
//   }

//   Column initBody() {
//     return Column(
//       children: [
//         const SizedBox(height: 30),
//         Expanded(
//           flex: 1,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: const Color(0xFFEFEFF5)),
//               borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//             ),
//             child: ListView(
//                 padding: const EdgeInsetsDirectional.all(20),
//                 children: [
//                   bodyTitleUI(),
//                   const SizedBox(height: 26),
//                   bodyContentUI(),
//                 ]),
//           ),
//         )
//       ],
//     );
//   }

//   Column bodyTitleUI() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'forget_content',
//           textAlign: TextAlign.start,
//           style: TextStyle(
//               color: AssetsColors.color_text_black_392C23,
//               fontSize: 14.sp,
//               fontFamily: AssetsHelper.FONT_Avenir,
//               fontWeight: FontWeight.w400),
//         ),
//       ],
//     );
//   }

//   Column bodyContentUI() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'email',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               color: AssetsColors.color_text_black_392C23,
//               fontSize: 14.sp,
//               fontFamily: AssetsHelper.FONT_Avenir,
//               fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 5),
//         Form(
//           key: _formKey,
//           child: MyTextField(
//               myController: emailController,
//               hint: 'login_enter_email',
//               iconData: Icons.email_outlined,
//               textValidType: TEXT_VALID_TYPE.GENERAL,
//               textInputType: TextInputType.emailAddress),
//         ),
//         const SizedBox(height: 10),
//         const SizedBox(height: 30),
//         MyCustomButton(
//           text: 'send',
//           onPressed: () => {
//             if (_formKey.currentState!.validate()) {initForgetPasswordDialog()}
//           },
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

//   Future<void> initForgetPasswordDialog() async {
//     BaseResponse<TUser>? baseResponse = await widget.forgetPasswordController
//         .postForgetPassword(map: {'email': emailController.text});
//     if (baseResponse!.status!) {
//       _showMyDialog();
//     }
//   }

//   Future<void> _showMyDialog() {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: true, // user can cancel without any btn!

//       builder: (BuildContext context) {
//         return AlertDialog(
//           titlePadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
//           contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 24.0),
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadiusDirectional.all(Radius.circular(12))),
//           title: Align(
//             alignment: AlignmentDirectional.topEnd,
//             child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: const BoxDecoration(
//                     color: Color(0xFFF7F7F8), shape: BoxShape.circle),
//                 child: IconButton(
//                   padding: const EdgeInsets.all(2),
//                   onPressed: () {
//                     Get.back();
//                     // Get.back()
//                   },
//                   icon: const Icon(
//                     Icons.close,
//                   ),
//                 )),
//           ),
//           content: SingleChildScrollView(
//             child: Container(
//               decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(10))),
//               child: ListBody(
//                 children: <Widget>[
//                   Container(
//                     width: 100,
//                     height: 100,
//                     alignment: AlignmentDirectional.center,
//                     child: Image.asset(
//                         AssetsHelper.getImage(AssetsHelper.ic_email_sent)),
//                   ),
//                   Text("تحقق من كلمة المرور المرسلة لهاتفك",
//                       textAlign: TextAlign.center,
//                       style: AppTextStyles.getHeavyTextStyle(
//                           colorValue: AssetsColors.color_text_black_392C23,
//                           fontSize: 18.sp)),
//                   const SizedBox(height: 10),
//                   Text('forget_dialog_content',
//                       textAlign: TextAlign.center,
//                       style: AppTextStyles.getMediumTextStyle(
//                           fontSize: 12,
//                           colorValue:
//                               AssetsColors.color_text_gray_dark_hint_8A8A8F)),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     ).then((value) => Get.back());
//   }
// }
