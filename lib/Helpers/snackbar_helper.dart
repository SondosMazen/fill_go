import 'package:flutter/material.dart';
import 'package:rubble_app/App/app.dart';
import 'package:rubble_app/Helpers/assets_color.dart';
import 'package:rubble_app/Utils/utils.dart';

class SnackBarHelper {
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
