
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Helpers/assets_color.dart';
import '../Utils/utils.dart';
import '../App/app.dart';

class DialogHelper {
  //show error dialog
  static void showMyDialog(
      {String title = 'خطأ',
      String? description = 'Something went wrong',
      ArtSweetAlertType? type = ArtSweetAlertType.warning,
      Function? submit}) {

    showDialog(
        context: Get.context!,
        builder: (context) => ArtDialog(
            artDialogArgs: ArtDialogArgs(
                type: type,
                title: title,
                text: description == '' ? null : description,
                confirmButtonColor: AssetsColors.green,
                confirmButtonText: 'ok',
                onConfirm: submit)));

  }

  static void showDialogWithCancelBtn(
      {String title = 'Error',
      String? description = 'Something went wrong',
      Function? submit}) {
    ArtSweetAlert.show(
        context: Application.navigatorKey.currentState!.context,
        artDialogArgs: ArtDialogArgs(

            type: ArtSweetAlertType.success,
            title: title,
            text: description,
            showCancelBtn: true,
            cancelButtonColor: AssetsColors.green,
            confirmButtonColor: AssetsColors.green,
            cancelButtonText: 'رجوع',
            confirmButtonText: 'فتح الملف',
            onConfirm: submit));
  }

  static void showLoading([String? message]) {

    showDialog(
        context: Application.navigatorKey.currentState!.context,
        builder: (c) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: AssetsColors.green,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message ?? 'انتظر...',
                      style: AppTextStyles.getRegularTextStyle(
                          colorValue: AssetsColors.color_text_black_392C23),
                    ),
                  ],
                ),
              ),
        
            )

        );
  }

  //hide loading
  static void hideLoading() {
    Navigator.of(Application.navigatorKey.currentState!.context,
            rootNavigator: true)
        .pop();
  }
}
