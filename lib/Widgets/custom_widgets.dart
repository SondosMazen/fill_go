import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:fill_go/Helpers/assets_color.dart';
import 'package:fill_go/Helpers/assets_helper.dart';
import 'package:fill_go/Helpers/font_helper.dart';
import 'package:fill_go/Modules/Login/login_screen.dart';
// import 'package:fill_go/Modules/Services/FollowUp/AddESApps/add_esapp_controller.dart';
// import 'package:fill_go/Modules/Services/FollowUp/app_details_controller.dart';
import 'package:fill_go/Utils/utils.dart';
import 'package:fill_go/Utils/validator.dart';
import 'package:fill_go/Widgets/vertical_dashed_line.dart';

class CustomMultiSelectFormField<T> extends FormField<T> {
  CustomMultiSelectFormField({
    super.key,
    void Function(bool)? onSelected,
    backgroundColor,
    selectedColor,
    shape,
    label,
    selected,
    required List<Map<dynamic, dynamic>> items,
    super.validator,
    // Widget? hintText,
    // required AddEsappController controller,
    index,
  }) : super(
         builder: (state) {
           // var selectedItem = items
           //     .where((element) => element.selected == state.value)
           //     .toList();
           return Wrap(
             children: [
               ...List.generate(
                 1,
                 // controller.documents.length,
                 (index) => Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 5),
                   child: ChoiceChip(
                     showCheckmark: false,
                     // onSelected: onSelected,
                     onSelected: (value) {
                       // controller.documents[index]['selected'] = value;
                       // controller.selectedDoc
                       //     .add(controller.documents[index]['oid']);
                       // controller.update();
                     },
                     // disabledColor: AssetsColors.black,
                     backgroundColor: backgroundColor, // Colors.white,
                     selectedColor: selectedColor, //AssetsColors.green,
                     shape: shape,

                     // color: WidgetStatePropertyAll(Colors.white),
                     // label: label,
                     label: Text(
                       "controller.documents[index]['const_desc']",
                       style: FontsAppHelper().avenirArabicHeavyFont(
                         color: Colors.black,
                         size: 12,
                       ),
                     ),
                     selected: false,
                     // selected: selected
                   ),
                 ),
               ),
               if (state.hasError)
                 Text(
                   state.errorText ?? "Invalid field",
                   style: const TextStyle(color: Colors.red),
                 ),
             ],
           );
         },
       );
}

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
  static const Color _color = AssetsColors.color_green_3EC4B5;

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
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  late final FocusNode _focus = FocusNode();

  bool _isFocusedChanged = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_handleFocusChange);
    // WidgetsBinding.instance!.addPostFrameCallback((_){
    //   FocusScope.of(context).requestFocus(_focus);
    // });
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
    // myController!.dispose();
    // widget.myController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.myController,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.listInputFormatter,
      onFieldSubmitted: widget.onFieldSubmitted,
      // style: TextStyle(color: Color(AssetsColors.color_blue_004BFE)),
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
                  color: AssetsColors.color_green_3EC4B5,
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
                  color: AssetsColors.color_green_3EC4B5,
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
                      ? AssetsColors.color_green_3EC4B5
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

class EmptyWidget extends StatelessWidget {
  late bool isMap;
  String? noData;

  EmptyWidget({super.key, this.isMap = false, this.noData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Text(
          noData ?? 'no_data',
          style: AppTextStyles.getMediumTextStyle(),
        ),
      ),
    );
  }
}

class GuestWidget extends StatelessWidget {
  late bool isMap;
  String? noData;

  GuestWidget({super.key, this.isMap = false, this.noData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "عذراً",
            textAlign: TextAlign.center,
            style: AppTextStyles.getBoldTextStyle(
              fontSize: 24.0,
              colorValue: AssetsColors.color_text_black_392C23,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "يرجى تسجيل الدخول للاستفادة من خدمات التطبيق",
            textAlign: TextAlign.center,
            style: AppTextStyles.getMediumTextStyle(
              fontSize: 17.0,
              colorValue: AssetsColors.color_text_black_392C23,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsetsDirectional.only(start: 24, end: 24),
            child: MyCustomButton(
              text: 'login',
              onPressed: () {
                Get.offAll(() => const LoginScreen());
                // Navigator.pushNamed(context, '/register_screen');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionBox extends StatelessWidget {
  List<Widget> icons = [];
  late List<Widget> elements;
  ExpansibleController controller = ExpansibleController();
  int index = 1;
  // final Key key;
  final bool isExpanded;

  Widget transactionElement({
    required Widget icon,
    required String firstTitle,
    required String lastTitle,
    required String status,
    required String date,
  }) {
    return Stack(
      children: [
        Positioned(
          right: 8,
          // top: 1,
          child: CustomPaint(
            size: const Size(2, 140),
            painter: VerticalDashedLine(),
          ),
        ),
        // Positioned(child: VerticalDivider()),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (firstTitle != '')
              SizedBox(
                width: 255.w,
                // height: 60,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AssetsColors.color_orange_bkg_FEF6DF,
                    ),
                    child: icon,
                  ),
                  title: Text(firstTitle),
                  subtitle: Text(
                    date,
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
                  ),
                  // trailing: Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8),
                  //   child: Text(
                  //     'تم التسليم',
                  //     style: TextStyle(fontSize: 10.sp),
                  //   ),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       color: Colors.white),
                  // ),
                ),
              ),
            if (lastTitle != '')
              SizedBox(
                width: 255.w,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AssetsColors.color_orange_bkg_FEF6DF,
                    ),
                    child: SvgPicture.asset('assets/images/progres.svg'),
                  ),

                  title: Text(lastTitle),
                  // subtitle: Text(
                  //   date,
                  //   style: TextStyle(fontSize: 10.sp),
                  // ),
                  // trailing: Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8),
                  //   child: Text(
                  //     status,
                  //     style: TextStyle(fontSize: 10.sp),
                  //   ),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       color: Colors.white),
                  // ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  TransactionBox({
    super.key,
    required this.index,
    required Widget icon,
    required List<Map<String, String>> titles,
    this.isExpanded = false,
  }) {
    log('tites in transcation $titles');
    // for (var count = 0; count < titles.length; count++) {
    //   icons.add(icon);
    // }
    elements = titles.map((title) {
      return transactionElement(
        icon: icon,
        firstTitle: title['sender']!,
        status: title['status']!,
        lastTitle: title['receiver']!,
        date: title['date']!,
      );
    }).toList();

    // .map((key,title) {
    //   return ConstrainedBox(
    //     constraints: BoxConstraints(maxWidth: 229.w),
    //     child: Text(
    //       title,
    //       style: AppTextStyles.getMediumTextStyle(
    //           fontSize: 14.sp,
    //           colorValue: AssetsColors.color_text_black_392C23),
    //       softWrap: true,
    //       maxLines: 3,
    //     ),
    //   );
    // }).toList();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Theme(
      data: theme,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.w)),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AssetsColors.color_orange_bkg_FEF6DF,
                ),
                padding: EdgeInsets.all(5.w),
                child: Text(
                  'التحويلات',
                  style: FontsAppHelper().avenirArabicMediumFont(size: 16),
                ),
              ),
              // Spacer()
            ],
          ),

          backgroundColor: AssetsColors.color_orange_bkg_FEF6DF,
          collapsedBackgroundColor: AssetsColors.color_orange_bkg_FEF6DF,
          childrenPadding: EdgeInsets.only(
            right: 16.w,
            left: 16.w,
            bottom: 16.w,
          ),
          onExpansionChanged: ((newState) {
            // Obx(() {
            //   final AppDetailsController controller =
            //       Get.find<AppDetailsController>();
            //   log(' on changed to $newState and selected ${controller.selected}');
            //   if (newState) {
            //     controller.selected.value = index;
            //     controller.expand();
            //   } else {
            //     controller.selected.value = 0;
            //     controller.collapse();
            //   }
            //   log(' changed to $newState and selected ${controller.selected}');
            //   return const SizedBox();
            // });
          }),
          children: List.generate(elements.length, (index) {
            return elements[index];
          }),
        ),
      ),
    );
  }
}

class DataBox extends StatelessWidget {
  late Widget header;
  late List<Widget> icons;
  late List titles;
  late List<Widget> values;
  int expandedElement = 1;
  bool iconRepete;
  ExpansibleController controller = ExpansibleController();
  int index;
  final context;
  final bool isExpanded;

  List tempTitles = [];
  DataBox({
    super.key,
    required this.index,
    required List<Widget> icons,
    required List titles,
    required List values,
    required String header,
    this.iconRepete = false,
    // required this.key,
    this.context,
    required this.isExpanded,
  }) {
    this.icons = icons;
    if (iconRepete) {
      for (var count = 1; count < titles.length; count++) {
        this.icons.add(icons[0]);
      }
    }
    this.header = Row(
      children: [
        Container(
          width: 210.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AssetsColors.color_orange_bkg_FEF6DF,
          ),
          padding: EdgeInsets.all(5.w),
          child: Text(
            softWrap: true,
            maxLines: 3,
            header,
            style: FontsAppHelper().avenirArabicMediumFont(size: 16),
          ),
        ),
        // Spacer()
      ],
    );

    this.icons = icons;

    if (titles.runtimeType == List<TextButton>) {
      this.titles = titles;
    } else {
      this.titles = titles.map((title) {
        return ConstrainedBox(
          constraints: BoxConstraints(minWidth: 30.w, maxWidth: 229.w),
          child: Text(
            title,
            style: AppTextStyles.getMediumTextStyle(
              fontSize: 14.sp,
              colorValue: AssetsColors.color_text_black_392C23,
            ),
            softWrap: true,
            maxLines: 3,
          ),
        );
      }).toList();
    }
    if (values.isEmpty) {
      this.values = List.empty();
    } else {
      LineSplitter ls = const LineSplitter();
      this.values = values
          .map(
            (value) => ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110.w, minWidth: 90.w),
              child: Text(
                value == 'null' ? 'غير مدخل' : ls.convert(value)[0],
                softWrap: true,
                maxLines: 4,
                style: AppTextStyles.getLightTextStyle(
                  fontSize: 16,
                  color: AssetsColors.black,
                ),
              ),
            ),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    // log(' textScaleFactor:${ScreenUtil().textScaleFactor}');
    return Theme(
      data: theme,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.w)),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          title: header,
          controller: controller,
          backgroundColor: AssetsColors.color_orange_bkg_FEF6DF,
          collapsedBackgroundColor: AssetsColors.color_orange_bkg_FEF6DF,
          childrenPadding: EdgeInsets.only(
            right: 16.w,
            left: 16.w,
            bottom: 16.w,
          ),
          onExpansionChanged: (value) {
            if (value) {
              controller.expand();
            } else {
              controller.collapse();
            }
          },
          children: List.generate(titles.length, (index) {
            log('message titles  ${titles.length}');
            return ConstrainedBox(
              constraints: BoxConstraints(minHeight: 25.h, maxHeight: 120.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  icons[index],
                  SizedBox(width: 7.w),
                  titles[index],
                  SizedBox(width: 10.w),
                  values.isEmpty ? const SizedBox() : values[index],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class IterableWidget extends StatelessWidget {
  int length;
  List<Widget> icon;
  List<Widget>? titles;
  List<Widget> values = [];
  String header;
  bool isExpanded;
  String? spliter;
  IterableWidget({
    super.key,
    this.isExpanded = false,
    required this.icon,
    required this.titles,
    required this.values,
    required this.length,
    this.spliter,
    required this.header,
  }) {
    // this.titles =
    //  titles
    //     .map((title) => RichText(
    //           text: TextSpan(children: [
    //             TextSpan(
    //               text: '${title.toString()}:',
    //               style: AppTextStyles.getMediumTextStyle(
    //                   fontSize: 14.sp,
    //                   colorValue: AssetsColors.color_text_black_392C23),
    //               // softWrap: true,
    //               // maxLines: 3,
    //             )
    //           ]),
    //         ))
    //     .toList();
    // values.forEach((_values) {
    //   _values.forEach((value, subvalue) {
    //     this.values?.add(
    //       RichText(
    //           softWrap: true,
    //           maxLines: 3,
    //           text: TextSpan(
    //             children: [
    //               TextSpan(
    //                 text: '${value.toString()}',
    //                 style: AppTextStyles.getMediumTextStyle(
    //                     fontSize: 14.sp,
    //                     colorValue: AssetsColors.color_text_black_392C23),
    //               ),
    //               TextSpan(
    //                 text: '${subvalue.toString()}',
    //                 style: AppTextStyles.getLightTextStyle(
    //                     fontSize: 14.sp,
    //                     color: AssetsColors.color_text_black_392C23,
    //                     fontFeatures: [FontFeature.subscripts()]),
    //               ),
    //             ],
    //           ),
    //         )
    //         );
    // });
    // });
  }

  ExpansibleController controller = ExpansibleController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Theme(
      data: theme,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.w)),
        child: ExpansionTile(
          initiallyExpanded: !isExpanded,
          title: Text(
            header,
            style: FontsAppHelper().avenirArabicMediumFont(size: 16),
          ),
          controller: controller,
          // trailing: Icon(Icons.add),
          backgroundColor: AssetsColors.color_orange_bkg_FEF6DF,
          collapsedBackgroundColor: AssetsColors.color_orange_bkg_FEF6DF,
          childrenPadding: EdgeInsets.only(
            right: 16.w,
            left: 16.w,
            bottom: 16.w,
          ),
          onExpansionChanged: (value) {
            if (value) {
              controller.expand();
            } else {
              controller.collapse();
            }
          },
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 45.h,
                maxHeight: (titles!.length * 30.h + 50),
              ),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: titles!.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //icon
                      icon.length <= titles!.length ? icon[0] : icon[index],
                      SizedBox(width: 5.w),
                      //title
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 180.w),
                        child: titles?[index] ?? SizedBox(width: 5.w),
                      ),
                      SizedBox(width: 5.w),
                      //value
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 140.w),
                        child: values[index],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum TEXT_VALID_TYPE { GENERAL, EMAIL, PASSWORD, PHONE, NUMBER, NONE, PalPhone }
