import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fill_go/Helpers/assets_color.dart';

import '../Helpers/assets_helper.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    this.controller,
    this.validator,
  });
  TextEditingController? controller;
  String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        obscureText: true,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          iconColor: AssetsColors.color_text_gray_dark_hint_8A8A8F,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          hintText: '**********',
          suffixIcon: SvgPicture.asset(
            AssetsHelper.ic_lock,
            color: AssetsColors.color_text_gray_dark_hint_8A8A8F,
            fit: BoxFit.scaleDown,
          ),
        ),
        validator: validator);
  }
}


