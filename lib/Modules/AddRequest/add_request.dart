import 'dart:developer';

import 'package:fill_go/App/app.dart';
import 'package:fill_go/Helpers/assets_color.dart';
import 'package:fill_go/Helpers/assets_helper.dart';
import 'package:fill_go/Modules/AddRequest/add_request_controller.dart';
import 'package:fill_go/Widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';

class AddRequest extends StatelessWidget {
  String? location;
  String? carType;
  String? carNum;
  String? site;
  String? entryNotes;
  String? entryDate;
  String? driver;
  bool isDetails;
  String userType;
  AddRequest({
    super.key,
    required this.isDetails,
    required this.userType,
    this.location,
    this.carType,
    this.carNum,
    this.site,
    this.entryNotes,
    this.entryDate,
    this.driver,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('أضف طلب')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<AddRequestController>(
            builder: (controller) {
              String driverName = driver!;
              for (
                int i = 0;
                controller.tDrivers != null && i < controller.tDrivers!.length;
                i++
              ) {
                if (controller.tDrivers?[i].oid.toString() == driver) {
                  driverName = controller.tDrivers?[i].name ?? '';
                }
              }
              return Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text.rich(
                    //   TextSpan(
                    //     children: [
                    //       TextSpan(
                    //         text: 'عنوان الطلب',
                    //         style: TextStyle(
                    //           color: AssetsColors.color_text_black_392C23,
                    //           fontSize: 14.sp,
                    //           fontFamily: AssetsHelper.FONT_Avenir,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //       TextSpan(
                    //         text: '*',
                    //         style: TextStyle(
                    //           color: AssetsColors.redColor,
                    //           fontSize: 11.sp,
                    //           fontFamily: AssetsHelper.FONT_Avenir,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   textAlign: TextAlign.start,
                    //   style: TextStyle(
                    //     color: AssetsColors.color_text_black_392C23,
                    //     fontSize: 14.sp,
                    //     fontFamily: AssetsHelper.FONT_Avenir,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // MyTextField(
                    //   filled: true,
                    //   fillColor: Colors.white,
                    //   hint: 'عنوان الطلب',
                    // ),
                    // const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'العنوان',
                            style: TextStyle(
                              color: AssetsColors.color_text_black_392C23,
                              fontSize: 14.sp,
                              fontFamily: AssetsHelper.FONT_Avenir,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: AssetsColors.redColor,
                              fontSize: 11.sp,
                              fontFamily: AssetsHelper.FONT_Avenir,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AssetsColors.color_text_black_392C23,
                        fontSize: 14.sp,
                        fontFamily: AssetsHelper.FONT_Avenir,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      isEnabled: !isDetails,
                      filled: true,
                      fillColor: Colors.white,
                      hint: location ?? 'شارع النصر-ستبس',
                      myController: controller.loadingLocationController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى ادخال موقع التحميل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'أسم السائق',
                            style: TextStyle(
                              color: AssetsColors.color_text_black_392C23,
                              fontSize: 14.sp,
                              fontFamily: AssetsHelper.FONT_Avenir,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: AssetsColors.redColor,
                              fontSize: 11.sp,
                              fontFamily: AssetsHelper.FONT_Avenir,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AssetsColors.color_text_black_392C23,
                        fontSize: 14.sp,
                        fontFamily: AssetsHelper.FONT_Avenir,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    SearchField(
                      enabled: !isDetails,
                      controller: controller.driversController,
                      textInputAction: TextInputAction.next,
                      autoCorrect: true,
                      searchInputDecoration: SearchInputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: driverName ?? 'اختر اسم السائق',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: AssetsColors.color_text_gray_dark_hint_8A8A8F,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AssetsColors.color_green_3EC4B5,
                            width: 0.7,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AssetsColors.color_gray_CECFD2,
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      itemHeight: 50,
                      maxSuggestionsInViewPort: 6,
                      suggestionsDecoration: SuggestionDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSuggestionTap: (value) {
                        controller.driversController.text = value.searchKey;
                        controller.selectedDriverValue = value.value ?? '';
                        controller.update();
                      },
                      suggestions: controller.getDriversList() ?? [],
                      validator: (value) {
                        for (int i = 0; i < controller.tSites!.length; i++) {
                          if (controller.unloadingLocationController.text !=
                              controller.tSites![i].name) {
                            return 'يجب الاختيار من القائمة';
                          }
                        }

                        if (controller.driversController.text == '' ||
                            controller.driversController.text == ' ') {
                          return 'يجب الاختيار من القائمة';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'نوع السيارة',
                            style: TextStyle(
                              color: AssetsColors.color_text_black_392C23,
                              fontSize: 14.sp,
                              fontFamily: AssetsHelper.FONT_Avenir,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: AssetsColors.redColor,
                              fontSize: 11.sp,
                              fontFamily: AssetsHelper.FONT_Avenir,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AssetsColors.color_text_black_392C23,
                        fontSize: 14.sp,
                        fontFamily: AssetsHelper.FONT_Avenir,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),
                    MyTextField(
                      isEnabled: !isDetails,
                      filled: true,
                      fillColor: Colors.white,
                      hint: carType ?? '12 عجل',
                      myController: controller.carTypeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى ادخال نوع السيارة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'رقم السيارة',
                            style: TextStyle(
                              color: AssetsColors.color_text_black_392C23,
                              fontSize: 14.sp,
                              fontFamily: AssetsHelper.FONT_Avenir,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: AssetsColors.redColor,
                              fontSize: 11.sp,
                              fontFamily: AssetsHelper.FONT_Avenir,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AssetsColors.color_text_black_392C23,
                        fontSize: 14.sp,
                        fontFamily: AssetsHelper.FONT_Avenir,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),
                    MyTextField(
                      isEnabled: !isDetails,
                      textInputType: TextInputType.number,
                      filled: true,
                      fillColor: Colors.white,
                      hint: carNum ?? '3655885',
                      myController: controller.carNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى ادخال رقم السيارة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'موقع التفريغ',
                            style: TextStyle(
                              color: AssetsColors.color_text_black_392C23,
                              fontSize: 14.sp,
                              fontFamily: AssetsHelper.FONT_Avenir,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: AssetsColors.redColor,
                              fontSize: 11.sp,
                              fontFamily: AssetsHelper.FONT_Avenir,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AssetsColors.color_text_black_392C23,
                        fontSize: 14.sp,
                        fontFamily: AssetsHelper.FONT_Avenir,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),
                    SearchField(
                      enabled: !isDetails,
                      controller: controller.unloadingLocationController,
                      textInputAction: TextInputAction.next,
                      autoCorrect: true,
                      searchInputDecoration: SearchInputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: site ?? 'اختر موقع التفريغ',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: AssetsColors.color_text_gray_dark_hint_8A8A8F,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AssetsColors.color_green_3EC4B5,
                            width: 0.7,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AssetsColors.color_gray_CECFD2,
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      itemHeight: 50,
                      maxSuggestionsInViewPort: 6,
                      suggestionsDecoration: SuggestionDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSuggestionTap: (value) {
                        controller.unloadingLocationController.text =
                            value.searchKey;
                        controller.selectedUnloadLocationValue =
                            value.value ?? '';
                        controller.update();
                      },
                      suggestions: controller.getSitesList() ?? [],
                      validator: (value) {
                        for (int i = 0; i < controller.tSites!.length; i++) {
                          if (controller.unloadingLocationController.text !=
                              controller.tSites![i].name) {
                            return 'يجب الاختيار من القائمة';
                          }
                        }

                        if (controller.driversController.text == '' ||
                            controller.driversController.text == ' ') {
                          return 'يجب الاختيار من القائمة';
                        }
                        return null;
                      },
                    ),

                    // MyTextField(
                    //   isEnabled: !isDetails,
                    //   filled: true,
                    //   fillColor: Colors.white,
                    //   hint: siteLocationSSSiteName ?? 'سوق فراس',
                    //   myController: controller.unloadingLocationController,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'يرجى ادخال موقع التفريغ';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    const SizedBox(height: 20),
                    Text(
                      'ملاحظات',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AssetsColors.color_text_black_392C23,
                        fontSize: 14.sp,
                        fontFamily: AssetsHelper.FONT_Avenir,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyTextField.form(
                      isEnabled: !isDetails,
                      filled: true,
                      fillColor: Colors.white,
                      hint: entryNotes ?? ' ',
                      minLines: 3,
                      maxLines: 5,
                      myController: controller.notesController,
                    ),
                    const SizedBox(height: 10),
                    if (isDetails && userType == "1")
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 200,
                          minHeight: 200,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ملاحظات المراقب',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: AssetsColors.color_text_black_392C23,
                                fontSize: 14.sp,
                                fontFamily: AssetsHelper.FONT_Avenir,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            MyTextField.form(
                              isEnabled: isDetails,
                              filled: true,
                              fillColor: Colors.white,
                              hint: ' ',
                              minLines: 3,
                              maxLines: 5,
                              myController: controller.adminNotesController,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),

                    MyCustomButton(
                      text: isDetails ? 'قبول الطلب' : 'حفط',
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          //submit
                          controller.postStoreOrder();
                          Get.back();
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
