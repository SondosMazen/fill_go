import 'dart:developer';
import 'dart:ui';
import 'package:fill_go/Api/BaseResponse.dart';
import 'package:fill_go/Model/TUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fill_go/Helpers/assets_color.dart';
import 'package:fill_go/Helpers/assets_helper.dart';
import 'package:fill_go/Modules/Login/login_controller.dart';
import 'package:fill_go/Widgets/custom_widgets.dart';
import '../../App/Constant.dart';
import '../../App/app.dart';
import '../../presentation/controllers/controllers/auth_controller.dart';
import 'package:fill_go/presentation/controllers/routes/app_pages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());

  @override
  void dispose() {
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
      backgroundColor: AssetsColors.color_screen_background,
      body: initBody(formKey),
    );
  }

  Widget initBody(GlobalKey<FormState> formKey) {
    return GetBuilder<LoginController>(
      init: loginController,
      builder: (controller) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF8F0), // Very light orange tint
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  // Logo Section
                  Hero(
                    tag: 'logo',
                    child: Container(
                      // padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AssetsColors.primaryOrange.withOpacity(0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AssetsHelper.logo,
                        width: 200.w,
                        height: 200.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  // Login Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: AssetsColors.darkBrown,
                              fontSize: 26.sp,
                              fontFamily: AssetsHelper.FONT_Avenir,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 40.h),
                          _buildLabel('اسم المستخدم'),
                          SizedBox(height: 10.h),
                          MyTextField(
                            myController: loginController.myIDController,
                            textValidType: TEXT_VALID_TYPE.GENERAL,
                            textInputAction: TextInputAction.next,
                            hint: 'ادخل اسم المستخدم',
                            iconData: Icons.person_outline_rounded,
                            isPassword: false,
                            filled: true,
                            fillColor: const Color(0xFFFAFAFA),
                          ),
                          SizedBox(height: 20.h),
                          _buildLabel('كلمة المرور'),
                          SizedBox(height: 10.h),
                          MyTextField(
                            myController: loginController.myPasswordController,
                            textValidType: TEXT_VALID_TYPE.GENERAL,
                            hint: 'ادخل كلمة المرور',
                            iconData: Icons.lock_outline_rounded,
                            isPassword: true,
                            filled: true,
                            fillColor: const Color(0xFFFAFAFA),
                          ),
                          SizedBox(height: 16.h),

                          // Align(
                          //   alignment: AlignmentDirectional.centerEnd,
                          //   child: TextButton(
                          //     onPressed: () {
                          //       // Forgot password logic
                          //     },
                          //     style: TextButton.styleFrom(
                          //       foregroundColor: AssetsColors.primaryOrange,
                          //       padding: EdgeInsets.zero,
                          //       minimumSize: const Size(0, 30),
                          //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //     ),
                          //     child: Text(
                          //       'نسيت كلمة المرور؟',
                          //       style: TextStyle(
                          //         fontSize: 13.sp,
                          //         fontWeight: FontWeight.w700,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 28.h),
                          MyCustomButton(
                            text: 'دخول',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                handleLoginClick();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AssetsColors.color_text_black_392C23,
        fontSize: 14.sp,
        fontFamily: AssetsHelper.FONT_Avenir,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void handleLoginClick() async {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map["user_name"] = loginController.myIDController.text;
      map["password"] = loginController.myPasswordController.text;

      BaseResponse<TUser>? tUserResponse = await loginController
          .sendLoginRequest(map: map);
      log('${tUserResponse?.status}');

      if (tUserResponse!.message == null) return;
      if (tUserResponse.status!) {
        TUser user = tUserResponse.data!;
        final userType = user.userType?.toString() ?? '1';
        await Application.sharedPreferences.setString(
          Constants.USER_TYPE,
          userType,
        );
        // نستخدم AuthController لتحديث حالة المستخدم
        final authController = Get.find<AuthController>();
        authController.setCurrentUser(user);
        authController.storageService?.saveCurrentUser(user); // حفظ محلي
        Get.offAllNamed(AppPages.home);
      }
    }
  }
}
