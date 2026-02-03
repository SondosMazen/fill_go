import 'package:flutter/services.dart';
import 'package:rubble_app/Helpers/assets_color.dart';
import 'package:rubble_app/Helpers/assets_helper.dart';
import 'package:rubble_app/Modules/AddRequest/add_offline_request_controller.dart';
import 'package:rubble_app/Widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';

class AddOfflineRequest extends StatelessWidget {
  const AddOfflineRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddOfflineRequestController>(
      init: AddOfflineRequestController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            title: const Text('اضافة طلب اوفلاين'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: AssetsColors.primaryOrange,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('بيانات الطلب'),
                          const SizedBox(height: 20),
                          _buildLabel('الرقم المرجعي'),
                          MyTextField(
                            filled: true,
                            fillColor: const Color(0xFFFAFAFA),
                            hint: 'أدخل الرقم المرجعي (أرقام إنجليزية فقط)',
                            myController: controller.referenceNumberController,
                            iconData: Icons.numbers,
                            textInputType: TextInputType.number,
                            listInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]'),
                              ),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرقم المرجعي مطلوب';
                              }
                              if (RegExp(r'[٠-٩]').hasMatch(value)) {
                                return 'يجب استخدام الأرقام الإنجليزية فقط';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildLabel('أسم السائق'),
                          SearchField(
                            controller: controller.driversController,
                            textInputAction: TextInputAction.next,
                            autoCorrect: true,
                            readOnly: false,
                            searchInputDecoration: SearchInputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              hintText: 'اختر اسم السائق',
                              prefixIcon: const Icon(
                                Icons.person_outline_rounded,
                                color: AssetsColors.color_gray_hint_9C9C9C,
                                size: 22,
                              ),
                              hintStyle: const TextStyle(
                                fontSize: 13,
                                color: AssetsColors
                                    .color_text_gray_dark_hint_8A8A8F,
                                fontFamily: AssetsHelper.FONT_Avenir,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AssetsColors.primaryOrange,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                            itemHeight: 50,
                            maxSuggestionsInViewPort: 6,
                            suggestionsDecoration: SuggestionDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            onSuggestionTap: (value) {
                              controller.driversController.text =
                                  value.searchKey;
                              controller.selectedDriverValue =
                                  value.value ?? '';
                              controller.selectedDriverName = value.searchKey;
                              controller.update();
                            },
                            suggestions: controller.getDriversList() ?? [],
                            validator: (value) {
                              if (controller.driversController.text
                                  .trim()
                                  .isEmpty) {
                                return 'يجب الاختيار من القائمة';
                              }
                              // التحقق من أن القيمة موجودة في القائمة
                              final isExist =
                                  controller.tDrivers?.any(
                                    (element) =>
                                        element.name ==
                                        controller.driversController.text,
                                  ) ??
                                  false;
                              if (!isExist) {
                                return 'يجب اختيار سائق من القائمة';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildLabel('ملاحظات'),
                          MyTextField.form(
                            filled: true,
                            fillColor: const Color(0xFFFAFAFA),
                            hint: 'أدخل ملاحظات',
                            minLines: 3,
                            maxLines: 5,
                            myController: controller.notesController,
                            iconData: Icons.note_alt_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: MyCustomButton(
                        text: 'حفظ',
                        backgroundColor: AssetsColors.primaryOrange,
                        onPressed: () {
                          controller.saveOfflineRequest();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AssetsColors.primaryOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: AssetsColors.color_text_black_392C23,
            fontSize: 16.sp,
            fontFamily: AssetsHelper.FONT_Avenir,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 4),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 13.sp,
          fontFamily: AssetsHelper.FONT_Avenir,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
