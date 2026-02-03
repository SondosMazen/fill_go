import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubble_app/Helpers/assets_color.dart';
import 'package:rubble_app/Helpers/assets_helper.dart';
import 'package:rubble_app/Utils/utils.dart';
import 'package:rubble_app/Widgets/custom_widgets.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({
    super.key,
  });
  static final GlobalKey<FormState> _formGlobalKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    final TextEditingController confirmPasswordController =
        TextEditingController();
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 8.0,
        right: 16.0,
        left: 16.0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 32,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: AssetsColors.border_color_EFEFF5,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AssetsColors.color_gray_F7F7F8,
                        ),
                        child: SvgPicture.asset(
                          AssetsHelper.ic_cancle,
                          color: AssetsColors.color_black_392C23,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                     'change_password',
                    style: AppTextStyles.getBoldTextStyle(
                        fontSize: 20.0,
                        colorValue: AssetsColors.color_text_black_392C23),
                  ),
                ),
                const SizedBox(height: 37.0),
                Form(
                  key: _formGlobalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                         'password',
                        style: AppTextStyles.getMediumTextStyle(
                            colorValue: AssetsColors.color_text_black_392C23),
                      ),
                      const SizedBox(height: 8.0),
                      MyTextField(
                        isPassword: true,
                        myController: currentPasswordController,
                        textValidType: TEXT_VALID_TYPE.PASSWORD,
                        hint: '',
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                         'new_password',
                        style: AppTextStyles.getMediumTextStyle(
                            colorValue: AssetsColors.color_text_black_392C23),
                      ),
                      const SizedBox(height: 8.0),
                      MyTextField(
                        isPassword: true,
                        hint: '',
                        myController: newPasswordController,
                        textValidType: TEXT_VALID_TYPE.PASSWORD,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                         'confirm_new_password',
                        style: AppTextStyles.getMediumTextStyle(
                            colorValue: AssetsColors.color_text_black_392C23),
                      ),
                      const SizedBox(height: 8.0),
                      MyTextField(
                        hint: '',
                        isPassword: true,
                        myController: confirmPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please_confirm_new_password';
                          }
                          if (value != newPasswordController.text) {
                            return  'un_matched';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                MyCustomButton(
                  onPressed: () {
                    if (_formGlobalKey.currentState!.validate()) {
                      }
                  },
                  text:  'save_changes',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
