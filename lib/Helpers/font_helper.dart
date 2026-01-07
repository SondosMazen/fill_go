import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'assets_color.dart';

class FontsAppHelper {
  TextStyle avenirArabicMediumFont({ 
    final int size = -1,
    final Color color = blackColor,
    final Color backgroundColor = Colors.transparent,
  }) {
    return TextStyle(
      fontFamily: 'Avenir',
      fontSize: size == -1 ? 14.sp : size.sp,
      fontWeight: FontWeight.w500,
      color: color,
      backgroundColor: backgroundColor,
    );
  }

  TextStyle avenirArabicHeavyFont({
    final int size = -1,
    final Color color = blackColor,
    final Color backgroundColor = Colors.transparent,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size == -1 ? 18.sp : size.sp,
      color: color,
      fontFamily: 'Avenir',
      backgroundColor: backgroundColor,
    );
  }

  TextStyle avenirArabicBookFont({
    final int size = -1,
    final Color color = blackColor,
    final Color backgroundColor = Colors.transparent,
  }) {
    return TextStyle(
      fontFamily: 'Avenir',
      color: color,
      fontWeight: FontWeight.w400,
      fontSize: size == -1 ? 14.sp : size.sp,
      backgroundColor: backgroundColor,
    );
  }


  TextStyle avenirArabicLightFont({
    final int size = -1,
    final Color color = blackColor,
    final Color backgroundColor = Colors.transparent,
  }) {
    return TextStyle(
      fontFamily: 'Avenir',
      color: color,
      fontWeight: FontWeight.w300,
      fontSize: size == -1 ? 14.sp : size.sp,
      backgroundColor: backgroundColor,
    );
  }
}
