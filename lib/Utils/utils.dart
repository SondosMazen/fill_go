
// import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart' as AppLocale;
// import 'package:fill_go/App/app.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../Helpers/assets_color.dart';
import '../Helpers/assets_helper.dart';

class Utils {
  // static AppLocale.AppLocalizations getString() {
  //   return AppLocale.AppLocalizations.of(
  //       Application.navigatorKey.currentContext!)!;
  // }
}

class AppTextStyles {
  static TextStyle getHeavyTextStyle(
      {double fontSize = 14,
      Color colorValue = AssetsColors.color_green_3EC4B5}) {
    return TextStyle(
        color: colorValue,
        fontSize: fontSize,
        fontFamily: AssetsHelper.FONT_Avenir,
        fontWeight: FontWeight.w900);
  }

  static TextStyle getBoldTextStyle(
      {double fontSize = 14, Color colorValue = Colors.white}) {
    return TextStyle(
        color: colorValue,
        fontSize: fontSize,
        fontFamily: AssetsHelper.FONT_Avenir,
        fontWeight: FontWeight.w700);
  }

  static TextStyle getBoldTextStyleGreen(
      {double fontSize = 14,
      Color colorValue = AssetsColors.color_green_3EC4B5}) {
    return TextStyle(
        color: colorValue,
        fontSize: fontSize,
        fontFamily: AssetsHelper.FONT_Avenir,
        fontWeight: FontWeight.w700);
  }

  static TextStyle getMediumTextStyleColor(
      {double fontSize = 14, Color color = AssetsColors.color_green_3EC4B5}) {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: AssetsHelper.FONT_Avenir,
        fontWeight: FontWeight.w500);
  } 

  static TextStyle getMediumTextStyle(
      {double fontSize = 14,
      Color colorValue = AssetsColors.color_green_3EC4B5}) {
    return TextStyle(
        color: colorValue,
        fontSize: fontSize,
        fontFamily: AssetsHelper.FONT_Avenir,
        fontWeight: FontWeight.w500);
  }

  static TextStyle getRegularTextStyle(
      {double fontSize = 14,
      Color colorValue = AssetsColors.color_green_3EC4B5}) {
    return TextStyle(
        color: colorValue,
        fontSize: fontSize,
        fontFamily: AssetsHelper.FONT_Avenir,
        fontWeight: FontWeight.w400);
  }

  static TextStyle getLightTextStyle(
      {double fontSize = 14,
      Color color = AssetsColors.color_green_3EC4B5,
      List<FontFeature>? fontFeatures}) {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: AssetsHelper.FONT_Avenir,
        fontWeight: FontWeight.w300,
        fontFeatures: fontFeatures);
  }
}
