import 'package:flutter/material.dart';
import 'package:fill_go/App/app.dart';
import 'package:fill_go/Helpers/assets_color.dart';
import 'package:fill_go/Utils/utils.dart';

class SnackBarHelper {
  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  static void show({String msg = "قيد التطوير", Color? backgroundColor}) {
    ScaffoldMessenger.of(Application.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor ?? AssetsColors.redColor,
        content: Text(
          msg,
          style: AppTextStyles.getRegularTextStyle(colorValue: Colors.white),
        ),
      ),
    );
  }

  static void Reward({
    String msg = "تهانيا لقد حصلت على مكافأة التزام بالتسديد",
  }) {
    ScaffoldMessenger.of(Application.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        backgroundColor: AssetsColors.green,
        content: Text(
          msg,
          style: AppTextStyles.getRegularTextStyle(colorValue: Colors.white),
        ),
      ),
    );
  }
}
