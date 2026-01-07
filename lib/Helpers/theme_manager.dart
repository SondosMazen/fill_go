import 'package:flutter/material.dart';
import 'assets_color.dart';
import 'fonts_manager.dart';
import 'style_manager.dart';
import 'value_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    scaffoldBackgroundColor: AssetsColors.white,
    //main color of the app
    primaryColor: AssetsColors.black,
    primaryColorLight: AssetsColors.lightGrey,
    primaryColorDark: AssetsColors.darkGrey,
    disabledColor: AssetsColors.grey8A8A8F,
    splashColor: AssetsColors.white,

    //card theme
    cardTheme: CardThemeData(
      color: AssetsColors.white,
      shadowColor: AssetsColors.grey,
      elevation: AppSize.s4,
    ),
//Appbar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AssetsColors.white,
      iconTheme: IconThemeData(color: AssetsColors.black),
      // elevation: AppSize.s8,
      titleTextStyle: getMediumStyle(
        color: AssetsColors.white,
        fontSize: FontSizeManager.s16,
      ),
    ),
    buttonTheme: ButtonThemeData(
      hoverColor: AssetsColors.grey,
      disabledColor: AssetsColors.grey8A8A8F,
      splashColor: AssetsColors.grey,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getMediumStyle(color: AssetsColors.white),
        backgroundColor: AssetsColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),

    textTheme: TextTheme(
      bodySmall: getLightStyle(color: AssetsColors.black),
      bodyLarge: getLightStyle(color: AssetsColors.black),
    ),

    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
        borderSide: BorderSide(
          color: AssetsColors.grey2,
          width: AppSize.s1_5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
        borderSide: BorderSide(
          color: AssetsColors.grey2,
          width: AppSize.s1_5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
        borderSide: BorderSide(
          color: AssetsColors.error,
          width: AppSize.s1_5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
        borderSide: BorderSide(
          color: AssetsColors.grey2,
          width: AppSize.s1_5,
        ),
      ),
    ),

    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(selectedItemColor: AssetsColors.primary),

    iconTheme: IconThemeData(color: AssetsColors.primary),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AssetsColors.grey),
  );
}
