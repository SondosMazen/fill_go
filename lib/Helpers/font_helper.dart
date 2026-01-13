import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'assets_color.dart';

class FontsAppHelper {
  TextStyle cairoMediumFont({
    final int size = -1,
    final Color color = blackColor,
    final Color backgroundColor = Colors.transparent,
  }) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: size == -1 ? 14.sp : size.sp,
      fontWeight: FontWeight.w500,
      color: color,
      backgroundColor: backgroundColor,
    );
  }

  TextStyle cairoBoldFont({
    final int size = -1,
    final Color color = blackColor,
    final Color backgroundColor = Colors.transparent,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: size == -1 ? 18.sp : size.sp,
      color: color,
      fontFamily: 'Cairo',
      backgroundColor: backgroundColor,
    );
  }

  TextStyle cairoRegularFont({
    final int size = -1,
    final Color color = blackColor,
    final Color backgroundColor = Colors.transparent,
  }) {
    return TextStyle(
      fontFamily: 'Cairo',
      color: color,
      fontWeight: FontWeight.w400,
      fontSize: size == -1 ? 14.sp : size.sp,
      backgroundColor: backgroundColor,
    );
  }

  TextStyle cairoLightFont({
    final int size = -1,
    final Color color = blackColor,
    final Color backgroundColor = Colors.transparent,
  }) {
    return TextStyle(
      fontFamily: 'Cairo',
      color: color,
      fontWeight: FontWeight.w300,
      fontSize: size == -1 ? 14.sp : size.sp,
      backgroundColor: backgroundColor,
    );
  }

  TextStyle avenirArabicMediumFont({
    int size = -1,
    Color color = blackColor,
    Color backgroundColor = Colors.transparent,
  }) => cairoMediumFont(
    size: size,
    color: color,
    backgroundColor: backgroundColor,
  );
  TextStyle avenirArabicHeavyFont({
    int size = -1,
    Color color = blackColor,
    Color backgroundColor = Colors.transparent,
  }) =>
      cairoBoldFont(size: size, color: color, backgroundColor: backgroundColor);
  TextStyle avenirArabicBookFont({
    int size = -1,
    Color color = blackColor,
    Color backgroundColor = Colors.transparent,
  }) => cairoRegularFont(
    size: size,
    color: color,
    backgroundColor: backgroundColor,
  );
  TextStyle avenirArabicLightFont({
    int size = -1,
    Color color = blackColor,
    Color backgroundColor = Colors.transparent,
  }) => cairoLightFont(
    size: size,
    color: color,
    backgroundColor: backgroundColor,
  );
}
