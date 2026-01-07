import 'package:fill_go/Helpers/assets_color.dart';
import 'package:fill_go/Helpers/assets_helper.dart';
import 'package:fill_go/Widgets/custom_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class RequestDetails extends StatelessWidget {
  const RequestDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تفاصيل الطلب',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AssetsColors.color_text_black_392C23,
                  fontSize: 14.sp,
                  fontFamily: AssetsHelper.FONT_Avenir,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              MyTextField.form(
                minLines: 1,
                maxLines: 15,
                isEnabled: false,
                hint:
                    ' نص طويل يوضح تفاصيل الطلب هنا نص طويل يوضح تفاصيل الطلب هنا نص طويل يوضح تفاصيل الطلب هنا نص طويل يوضح تفاصيل الطلب هنا نص طويل يوضح تفاصيل الطلب هنا نص طويل يوضح تفاصيل الطلب هنا  نص طويل يوضح تفاصيل الطلب هنا نص طويل يوضح تفاصيل الطلب هنا',
              ),
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
              SizedBox(height: 10),
              MyTextField.form(
                minLines: 1,
                maxLines: 15,
                hint: 'ملاحظات على قبول او رفض الطلب',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MyCustomButton(
                      text: 'رفض الطلب',
                      onPressed: () {},
                      backgroundColor: Colors.red,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: MyCustomButton(
                      text: 'قبول الطلب',
                      onPressed: () {},
                      backgroundColor: AssetsColors.color_green_3EC4B5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
