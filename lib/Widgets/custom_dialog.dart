import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../Helpers/assets_color.dart';
import '../Helpers/assets_helper.dart';
import '../Utils/utils.dart';
class ComplaintDialog{

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user can cancel without any btn!
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0),
          contentPadding:
          const EdgeInsetsDirectional.fromSTEB(16.0, 5.0, 16.0, 24.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.all(Radius.circular(12))),
          title: Align(
            alignment: AlignmentDirectional.topEnd,
            child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    color: Color(0xFFF7F7F8), shape: BoxShape.circle),
                child: IconButton(
                  padding: const EdgeInsets.all(2),
                  onPressed: () {
                    Get.back();
                    // Get.back()
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                )),
          ),
          content: Builder(builder: (context) {
            return SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListBody(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      alignment: AlignmentDirectional.center,
                      child: SvgPicture.asset(AssetsHelper.ic_success_msg),
                    ),
                    const SizedBox(height: 10),
                    Text('thank_you',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.getHeavyTextStyle(
                            colorValue: AssetsColors.color_text_black_392C23,
                            fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('complaint_sent_successful',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.getMediumTextStyle(
                            fontSize: 12,
                            colorValue:
                            AssetsColors.color_text_gray_dark_hint_8A8A8F)),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }


}