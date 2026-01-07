import 'dart:ui';

import 'package:fill_go/Api/BaseResponse.dart';
import 'package:fill_go/Model/TUser.dart';
import 'package:fill_go/Modules/Main/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fill_go/Helpers/assets_color.dart';
import 'package:fill_go/Helpers/assets_helper.dart';
import 'package:fill_go/Modules/Login/login_controller.dart';
import 'package:fill_go/Widgets/custom_widgets.dart';
// import 'package:sso_plugin/sso_plugin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController myEmailController = TextEditingController();
  TextEditingController myPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());

  @override
  void dispose() {
    myEmailController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,

      // resizeToAvoidBottomInset: false,
      backgroundColor: AssetsColors.color_screen_background,
      body: initBody(formKey),
    );
  }

  GetBuilder<LoginController> initBody(formKey) {
    // final formKey0 = GlobalKey<FormState>();
    return GetBuilder<LoginController>(
      init: loginController,
      builder: (controller) {
        return Stack(
          children: [
            // Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF7FAFF),
                    Color(0xFFEAF2FF),
                    Color(0xFFD6E6FF),
                  ],
                ),
              ),
            ),
            // Blurred shapes
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
              child: Container(color: Colors.transparent),
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100.h),
                  Center(
                    child: Image.asset(
                      AssetsHelper.logo,
                      width: 150.w,
                      height: 150.h,
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.topStart,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: 14.w,
                        end: 14.w,
                        top: 10.h,
                        bottom: 10.h,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'اسم المستخدم',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: AssetsColors.color_text_black_392C23,
                                fontSize: 14.sp,
                                fontFamily: AssetsHelper.FONT_Avenir,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            MyTextField(
                              myController: myEmailController,
                              textValidType: TEXT_VALID_TYPE.GENERAL,
                              textInputAction: TextInputAction.next,
                              hint: 'اكتب اسم المستخدم',
                              iconData: Icons.person,
                              isPassword: false,
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'كلمة المرور',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AssetsColors.color_text_black_392C23,
                                fontSize: 14.sp,
                                fontFamily: AssetsHelper.FONT_Avenir,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            MyTextField(
                              myController: myPasswordController,
                              textValidType: TEXT_VALID_TYPE.GENERAL,
                              hint: 'اكتب كلمة المرور',
                              iconData: Icons.lock_outline_rounded,
                              isPassword: true,
                            ),
                            const SizedBox(height: 30),
                            MyCustomButton(
                              text: 'تسجيل الدخول',
                              onPressed: () {
                                // if (formKey.currentState!.validate()) {
                                  handleLoginClick();
                                // }
                              },
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void handleLoginClick() async {
    // Get.offAll(() => HomeScreen());
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map["user_name"] = myEmailController.text;
      map["password"] = myPasswordController.text;

      BaseResponse<TUser>? tUserResponse = await loginController
          .sendLoginRequest(map: map);

      if (tUserResponse!.message == null) return;
      if (tUserResponse.status!) {
        Get.offAll(()=>HomeScreen());
      }
    }
  }
}
