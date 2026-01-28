import 'package:fill_go/Helpers/assets_color.dart';
import 'package:fill_go/Helpers/assets_helper.dart';
import 'package:fill_go/Modules/AddRequest/add_request_controller.dart';
import 'package:fill_go/Widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';
import 'package:fill_go/Modules/Main/Home/matching_offline_requests_screen.dart';
import 'package:fill_go/Modules/Main/Home/home_controller.dart';

class AddRequest extends StatefulWidget {
  String? location;
  String? carType;
  String? carNum;
  String? site;
  String? entryNotes;
  String? entryDate;
  String? driver;
  String? processNotes;
  String? orderId;
  String? orderNum;
  bool isDetails;
  bool isAccepted;
  String userType;
  AddRequest({
    super.key,
    required this.isDetails,
    required this.userType,
    this.isAccepted = false,
    this.location,
    this.carType,
    this.carNum,
    this.site,
    this.entryNotes,
    this.entryDate,
    this.driver,
    this.processNotes,
    this.orderId,
    this.orderNum,
  });

  @override
  State<AddRequest> createState() => _AddRequestState();
}

class _AddRequestState extends State<AddRequest> {
  late final FocusNode _driverFocusNode = FocusNode();
  late final FocusNode _unloadingLocationFocusNode = FocusNode();
  bool _isDriverFocused = false;
  bool _isUnloadingLocationFocused = false;

  @override
  void initState() {
    super.initState();
    _driverFocusNode.addListener(_handleDriverFocusChange);
    _unloadingLocationFocusNode.addListener(
      _handleUnloadingLocationFocusChange,
    );
  }

  void _handleDriverFocusChange() {
    if (_driverFocusNode.hasFocus != _isDriverFocused) {
      setState(() {
        _isDriverFocused = _driverFocusNode.hasFocus;
      });
    }
  }

  void _handleUnloadingLocationFocusChange() {
    if (_unloadingLocationFocusNode.hasFocus != _isUnloadingLocationFocused) {
      setState(() {
        _isUnloadingLocationFocused = _unloadingLocationFocusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _driverFocusNode.removeListener(_handleDriverFocusChange);
    _unloadingLocationFocusNode.removeListener(
      _handleUnloadingLocationFocusChange,
    );
    _driverFocusNode.dispose();
    _unloadingLocationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      appBar: AppBar(
        title: Text(widget.isDetails ? 'تفاصيل الطلب' : 'أضف طلب'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AssetsColors.primaryOrange,
        scrolledUnderElevation: 0,
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
          child: GetBuilder<AddRequestController>(
            builder: (controller) {
              String driverName = widget.driver ?? '';
              for (
                int i = 0;
                controller.tDrivers != null && i < controller.tDrivers!.length;
                i++
              ) {
                if (controller.tDrivers?[i].oid.toString() == widget.driver) {
                  driverName = controller.tDrivers?[i].name ?? '';
                }
              }
              return Form(
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
                          _buildSectionTitle('بيانات التحميل'),
                          const SizedBox(height: 16),
                          _buildLabel('موقع التحميل'),
                          MyTextField(
                            isEnabled: !widget.isDetails,
                            filled: true,
                            fillColor: const Color(0xFFFAFAFA),
                            hint: widget.location ?? 'أدخل موقع التحميل',
                            myController: controller.loadingLocationController,
                            iconData: Icons.location_on_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى ادخال موقع التحميل';
                              }
                              return null;
                            },
                          ),
                          if (!widget.isDetails ||
                              (widget.orderNum != null &&
                                  widget.orderNum!.isNotEmpty)) ...[
                            const SizedBox(height: 20),
                            _buildLabel('رقم الطلب'),
                            MyTextField(
                              isEnabled: !widget.isDetails,
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              hint: widget.orderNum ?? 'أدخل رقم الطلب',
                              myController: controller.orderNumController,
                              iconData: Icons.numbers,
                            ),
                          ],
                          const SizedBox(height: 20),
                          _buildLabel('أسم السائق'),
                          SearchField(
                            enabled: !widget.isDetails,
                            controller: controller.driversController,
                            textInputAction: TextInputAction.next,
                            autoCorrect: true,
                            focusNode: _driverFocusNode,
                            readOnly: false,
                            searchInputDecoration: SearchInputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              hintText: driverName.isNotEmpty
                                  ? driverName
                                  : 'اختر اسم السائق',
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                color: _isDriverFocused
                                    ? AssetsColors.primaryOrange
                                    : AssetsColors.color_gray_hint_9C9C9C,
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
                            maxSuggestionsInViewPort: 5,
                            offset: const Offset(0, 60),
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
                          if (!widget.isDetails ||
                              (widget.carType != null &&
                                  widget.carType!.isNotEmpty) ||
                              (widget.carNum != null &&
                                  widget.carNum!.isNotEmpty)) ...[
                            const SizedBox(height: 24),
                            const Divider(height: 1),
                            const SizedBox(height: 24),
                            _buildSectionTitle('بيانات المركبة'),
                          ],
                          if (!widget.isDetails ||
                              (widget.carType != null &&
                                  widget.carType!.isNotEmpty)) ...[
                            const SizedBox(height: 16),
                            _buildLabel('نوع السيارة'),
                            MyTextField(
                              isEnabled: !widget.isDetails,
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              hint: widget.carType ?? 'أدخل نوع السيارة',
                              myController: controller.carTypeController,
                              // myController: controller.carTypeController,
                              iconData: Icons.local_shipping_outlined,
                            ),
                          ],
                          if (!widget.isDetails ||
                              (widget.carNum != null &&
                                  widget.carNum!.isNotEmpty)) ...[
                            const SizedBox(height: 20),
                            _buildLabel('رقم السيارة'),
                            MyTextField(
                              isEnabled: !widget.isDetails,
                              textInputType: TextInputType.number,
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              hint: widget.carNum ?? 'اختر رقم السيارة',
                              myController: controller.carNumberController,
                              iconData: Icons.numbers_rounded,
                            ),
                          ],
                          const SizedBox(height: 24),
                          const Divider(height: 1),
                          const SizedBox(height: 24),
                          _buildSectionTitle('بيانات التفريغ'),
                          const SizedBox(height: 16),
                          _buildLabel('موقع التفريغ'),
                          SearchField(
                            enabled: !widget.isDetails,
                            controller: controller.unloadingLocationController,
                            textInputAction: TextInputAction.next,
                            autoCorrect: true,
                            focusNode: _unloadingLocationFocusNode,
                            readOnly: false,
                            searchInputDecoration: SearchInputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              hintText: widget.site ?? 'اختر موقع التفريغ',
                              prefixIcon: Icon(
                                Icons.flag_outlined,
                                color: _isUnloadingLocationFocused
                                    ? AssetsColors.primaryOrange
                                    : AssetsColors.color_gray_hint_9C9C9C,
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
                            maxSuggestionsInViewPort: 5,
                            offset: const Offset(0, 60),
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
                              controller.unloadingLocationController.text =
                                  value.searchKey;
                              controller.selectedUnloadLocationValue =
                                  value.value ?? '';
                              controller.update();
                            },
                            suggestions: controller.getSitesList() ?? [],
                            validator: (value) {
                              if (controller.unloadingLocationController.text
                                  .trim()
                                  .isEmpty) {
                                return 'يجب الاختيار من القائمة';
                              }
                              // التحقق من أن القيمة موجودة في القائمة
                              final isExist =
                                  controller.tSites?.any(
                                    (element) =>
                                        element.name ==
                                        controller
                                            .unloadingLocationController
                                            .text,
                                  ) ??
                                  false;
                              if (!isExist) {
                                return 'يجب اختيار موقع من القائمة';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildLabel('ملاحظات المفتش'),
                          MyTextField.form(
                            isEnabled: !widget.isDetails,
                            filled: true,
                            fillColor: const Color(0xFFFAFAFA),
                            hint: widget.entryNotes ?? ' أدخل ملاحظات',
                            minLines: 3,
                            maxLines: 5,
                            myController: controller.notesController,
                            iconData: Icons.note_alt_outlined,
                          ),
                          if (widget.isDetails &&
                              widget.processNotes != null &&
                              widget.processNotes!.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            _buildLabel('ملاحظات المراقب'),
                            MyTextField.form(
                              isEnabled: false,
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              hint: widget.processNotes!,
                              minLines: 2,
                              maxLines: 5,
                              iconData: Icons.assignment_turned_in_outlined,
                            ),
                          ],
                          if (widget.isDetails &&
                              (widget.userType == "1" ||
                                  widget.userType.toLowerCase().contains(
                                    "inspector",
                                  )) &&
                              !widget.isAccepted) ...[
                            const SizedBox(height: 20),
                            _buildLabel('ملاحظات المراقب'),
                            MyTextField.form(
                              isEnabled: true,
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              hint: 'ادخل ملاحظات المراقب',
                              minLines: 3,
                              maxLines: 5,
                              myController: controller.adminNotesController,
                              iconData: Icons.admin_panel_settings_outlined,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child:
                          (widget.isDetails &&
                              (!((widget.userType == "1" ||
                                      widget.userType.toLowerCase().contains(
                                        "inspector",
                                      ))) ||
                                  widget.isAccepted))
                          ? const SizedBox()
                          : MyCustomButton(
                              text: widget.isDetails
                                  ? 'قبول الطلب'
                                  : 'حفظ الطلب',
                              backgroundColor: widget.isDetails
                                  ? AssetsColors.color_green_3EC4B5
                                  : AssetsColors.primaryOrange,
                              onPressed: () {
                                if (widget.isDetails &&
                                    (widget.userType == "1" ||
                                        widget.userType.toLowerCase().contains(
                                          "inspector",
                                        ))) {
                                  if (widget.orderId != null) {
                                    // التحقق من وجود طلبات اوفلاين مطابقة
                                    bool matchFound = false;

                                    if (Get.isRegistered<HomeController>()) {
                                      final homeController =
                                          Get.find<HomeController>();
                                      String currentDriverName = '';

                                      // البحث عن اسم السائق الحالي
                                      if (controller.tDrivers != null) {
                                        for (var d in controller.tDrivers!) {
                                          if (d.oid.toString() ==
                                              widget.driver) {
                                            currentDriverName = d.name ?? '';
                                            break;
                                          }
                                        }
                                      }

                                      if (currentDriverName.isNotEmpty) {
                                        final matches = homeController
                                            .getOfflineMatches(
                                              currentDriverName,
                                            );
                                        if (matches.isNotEmpty) {
                                          matchFound = true;
                                          Get.to(
                                            () => MatchingOfflineRequestsScreen(
                                              matchingRequests: matches,
                                              driverName: currentDriverName,
                                              onlineOrderNumber:
                                                  widget.orderNum,
                                              onConfirm:
                                                  (selectedOfflineRequestId) {
                                                    Future.delayed(
                                                      const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                      () {
                                                        controller.acceptOrder(
                                                          widget.orderId!,
                                                          offlineRequestId:
                                                              selectedOfflineRequestId,
                                                        );
                                                      },
                                                    );
                                                  },
                                            ),
                                          );
                                        }
                                      }
                                    }

                                    if (!matchFound) {
                                      controller.acceptOrder(widget.orderId!);
                                    }
                                  }
                                } else {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    controller.postStoreOrder();
                                  }
                                }
                              },
                            ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
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
