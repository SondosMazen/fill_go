import 'package:flutter/material.dart';
import 'fonts_manager.dart';

TextStyle _getTextStyle(
    double fontSize, String fontFamily, FontWeight fontWight, Color color) {
  return TextStyle(
      fontFamily: fontFamily,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWight);
}
// regular style

TextStyle getBlackStyle({
  double fontSize = FontSizeManager.s12,
  required Color color,
  fontFamily = FontConstants.fontFamily,
}) {
  return _getTextStyle(fontSize, fontFamily, FontWeightManager.black, color);
}

TextStyle getHeavyStyle({
  double fontSize = FontSizeManager.s12,
  required Color color,
  fontFamily = FontConstants.fontFamily,
}) {
  return _getTextStyle(fontSize, fontFamily, FontWeightManager.heavy, color);
}
// bold text style

TextStyle getMediumStyle(
    {double fontSize = FontSizeManager.s12,
    required Color color,
    fontFamily = FontConstants.fontFamily}) {
  return _getTextStyle(
    fontSize,
    fontFamily,
    FontWeightManager.medium,
    color,
  );
}

// semi bold text style

TextStyle getBookStyle(
    {double fontSize = FontSizeManager.s12,
    required Color color,
    fontFamily = FontConstants.fontFamily}) {
  return _getTextStyle(fontSize, fontFamily, FontWeightManager.book, color);
}

// medium text style

TextStyle getLightStyle(
    {double fontSize = FontSizeManager.s12,
    fontFamily = FontConstants.fontFamily,
    required Color color}) {
  return _getTextStyle(fontSize, fontFamily, FontWeightManager.light, color);
}

TextStyle getLight1Style(
    {double fontSize = FontSizeManager.s12,
    fontFamily = FontConstants.fontFamily,
    required Color color}) {
  return _getTextStyle(fontSize, fontFamily, FontWeightManager.light1, color);
}