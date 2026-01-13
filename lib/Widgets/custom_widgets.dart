import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fill_go/Helpers/assets_color.dart';
import 'package:fill_go/Helpers/assets_helper.dart';
import 'package:fill_go/Utils/utils.dart';
import 'package:fill_go/Utils/validator.dart';

class MyCustomButton extends StatelessWidget {
  late String text;
  late double fontSize;
  late Color textColor;
  late bool isFullWidth;

  double paddingStart = 0;
  double paddingEnd = 0;

  Color? backgroundColor;
  Color? borderColor;
  late bool isOnlyBorder;

  late VoidCallback onPressed;
  static const Color _color = AssetsColors.primaryOrange;

  MyCustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize = 17,
    this.textColor = Colors.white,
    this.isFullWidth = true,
    this.backgroundColor = _color,
  });

  MyCustomButton.padding({
    super.key,
    required this.text,
    required this.onPressed,
    this.paddingStart = 0,
    this.paddingEnd = 0,
    this.fontSize = 17,
    this.textColor = Colors.white,
    this.isFullWidth = false,
    this.backgroundColor = _color,
  });

  MyCustomButton.borderOnly({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOnlyBorder = true,
    this.paddingStart = 0,
    this.paddingEnd = 0,
    this.fontSize = 17,
    this.textColor = Colors.white,
    this.isFullWidth = true,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        onPressed();
      },
      child: isFullWidth ? Center(child: _textBuilder()) : _textBuilder(),
    );
  }

  Container _textBuilder() {
    return Container(
      padding: EdgeInsetsDirectional.only(start: paddingStart, end: paddingEnd),
      child: Text(
        text,
        style: AppTextStyles.getBoldTextStyle(fontSize: fontSize.w),
        textScaler: const TextScaler.linear(1),
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  late String hint;
  late String? text;
  late IconData? iconData;
  late TextInputType textInputType;
  late bool isPassword;
  late String prefixIconUrl;
  late Color? prefixIconColor;
  late String prefixText;
  late bool filled = false;
  Color fillColor = Colors.transparent;

  late bool isEnabled;
  late TEXT_VALID_TYPE textValidType;

  late int maxLines = 1;
  late int minLines = 1;
  TextEditingController? myController;
  String? Function(String?)? validator;
  late bool noInputBorder;
  ValueChanged<String>? onFieldSubmitted;
  late TextInputAction? textInputAction;

  List<TextInputFormatter>? listInputFormatter;
  MyTextField({
    super.key,
    required this.hint,
    this.prefixIconColor,
    this.prefixText = '',
    this.textInputAction,
    this.onFieldSubmitted,
    this.listInputFormatter,
    this.text = "",
    this.iconData,
    this.prefixIconUrl = '',
    this.validator,
    this.noInputBorder = false,
    this.textValidType = TEXT_VALID_TYPE.NONE,
    this.textInputType = TextInputType.text,
    this.myController,
    this.isPassword = false,
    this.isEnabled = true,
    this.fillColor = Colors.white,
    this.filled = false,
  });

  MyTextField.form({
    super.key,
    required this.hint,
    this.text = "",
    this.prefixText = "",
    this.noInputBorder = false,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    this.prefixIconUrl = '',
    this.iconData,
    this.validator,
    this.textValidType = TEXT_VALID_TYPE.NONE,
    this.textInputType = TextInputType.text,
    this.myController,
    this.isPassword = false,
    this.isEnabled = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.fillColor = Colors.white,
    this.filled = false,
  });

  @override
  _MyTextFieldState createState() {
    return _MyTextFieldState();
  }
}

class _MyTextFieldState extends State<MyTextField> {
  late final FocusNode _focus = FocusNode();

  bool _isFocusedChanged = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focus.hasFocus != _isFocusedChanged) {
      setState(() {
        _isFocusedChanged = _focus.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_handleFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.myController,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.listInputFormatter,
      onFieldSubmitted: widget.onFieldSubmitted,
      keyboardType: widget.textInputType,
      obscureText: widget.isPassword,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      enableSuggestions: !widget.isPassword,
      autocorrect: !widget.isPassword,
      enabled: widget.isEnabled,
      enableInteractiveSelection: true,
      style: const TextStyle(
        color: AssetsColors.color_text_gray_dark_hint_8A8A8F,
        fontSize: 14,
        fontFamily: AssetsHelper.FONT_Avenir,
        fontWeight: FontWeight.w500,
      ),
      focusNode: _focus,
      validator: initValidator(widget.textValidType),
      onChanged: (text) => setState(() => text),

      decoration: InputDecoration(
        fillColor: widget.fillColor,
        filled: widget.filled,
        alignLabelWithHint: true,
        focusedBorder: widget.noInputBorder
            ? InputBorder.none
            : const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AssetsColors.primaryOrange,
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
        errorStyle: AppTextStyles.getRegularTextStyle(
          fontSize: 12,
          colorValue: AssetsColors.redColor,
        ),
        errorBorder: widget.noInputBorder
            ? null
            : const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AssetsColors.color_gray_CECFD2,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
        enabledBorder: widget.noInputBorder
            ? InputBorder.none
            : const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AssetsColors.color_gray_CECFD2,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        border: widget.noInputBorder
            ? InputBorder.none
            : const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AssetsColors.primaryOrange,
                  width: 0.7,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
        prefixIcon: widget.prefixIconUrl != ''
            ? Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 20.w,
                  end: 14.w,
                  bottom: (widget.maxLines - 1) * 20.0,
                ),
                child: SvgPicture.asset(
                  widget.prefixIconUrl,
                  color: widget.prefixIconColor,
                ),
              )
            : widget.iconData == null
            ? const SizedBox(width: 16)
            : Padding(
                padding: const EdgeInsetsDirectional.only(start: 16, end: 5),
                child: Icon(
                  widget.iconData,
                  size: 20,
                  color: _isFocusedChanged
                      ? AssetsColors.primaryOrange
                      : AssetsColors.color_gray_hint_9C9C9C,
                ),
              ),
        prefixIconConstraints: BoxConstraints.loose(Size.infinite),
        hintText: widget.hint,
        prefixText: widget.prefixText,
        hintStyle: const TextStyle(
          color: AssetsColors.color_text_gray_dark_hint_8A8A8F,
          fontSize: 12,
          fontFamily: AssetsHelper.FONT_Avenir,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String? Function(String? value)? initValidator(
    TEXT_VALID_TYPE textValidType,
  ) {
    switch (textValidType) {
      case TEXT_VALID_TYPE.GENERAL:
        return (value) {
          if (Validator.instance.generalValidator(value ?? '')) {
            return '* الحقل مطلوب';
          }
          return null;
        };
      case TEXT_VALID_TYPE.EMAIL:
        return (value) {
          if (Validator.instance.generalValidator(value ?? '')) {
            return '* الحقل مطلوب';
          }
          if (Validator.instance.emailValidator(value ?? '')) {
            return 'الرجاء ادخال البريد الإلكتروني بالشكل الصحيح';
          }
          return null;
        };
      case TEXT_VALID_TYPE.PASSWORD:
        return (value) {
          if (Validator.instance.generalValidator(value ?? '')) {
            return '* الحقل مطلوب';
          }
          if (Validator.instance.passwordValidator(value ?? '')) {
            return 'يجب ان يتكون من 6 احرف على الأقل';
          }
          return null;
        };
      case TEXT_VALID_TYPE.PHONE:
        return (value) {
          if (Validator.instance.generalValidator(value ?? '')) {
            return '* الحقل مطلوب';
          }
          if (Validator.instance.phoneValidator(value ?? '')) {
            return 'الرجاء اخال رقم الهاتف بالصيغة الصحيحة';
          }
          return null;
        };

      case TEXT_VALID_TYPE.PalPhone:
        return (value) {
          if (Validator.instance.generalValidator(value ?? '')) {
            return '* الحقل مطلوب';
          }
          if (Validator.instance.PalphoneValidator(value ?? '')) {
            return 'الرجاء التحقق من رقم الهاتف';
          }
          return null;
        };

      case TEXT_VALID_TYPE.NUMBER:
        return (value) {
          if (Validator.instance.generalValidator(value ?? '')) {
            return '* الحقل مطلوب';
          }
          if (Validator.instance.numbarValidator(value ?? '')) {
            return 'الرجاء ادخال الحقل بالشكل الصحيح';
          }
          return null;
        };

      case TEXT_VALID_TYPE.NONE:
        if (widget.validator != null) {
          return widget.validator;
        }
    }
    return null;
  }
}

enum TEXT_VALID_TYPE { GENERAL, EMAIL, PASSWORD, PHONE, NUMBER, NONE, PalPhone }
