import 'package:flutter/cupertino.dart';

const purpleColor = Color(0xff6688FF);
const darkTextColor = Color(0xff1F1A3D);
const lightTextColor = Color(0xff999999);
const textFieldColor = Color(0xffF5F6FA);
const borderColor = Color(0xffD9D9D9);
const blueColor = Color(0xff3EC4B5);
const blackColor = Color(0xff000000);
const dividerColor = Color(0xffEFEFF5);
const hintColor = Color(0xff8A8A8F);
const stackColor = Color(0xffF7F7F8);
const whiteColor = Color(0xffFFFFFF);
const customAppBarColor = Color(0xffF7F7F8);
const tableColor = Color(0xff8A8A8F);
const lightGreen = Color(0x733EC4B4);

class AssetsColors {
  static const color_blue_004BFE = Color(0xFF004BFE);
  static const color_gray_F2F5FE = Color(0xFFF2F5FE);
  static const color_gray_hint_9C9C9C = Color(0xFF9C9C9C);
  static const color_black_202020 = Color(0xFF202020);
  static const lightGreen = Color(0x803EC4B5);
  static const color_white = Color(0xFFFFFFFF);
  static const Color darkBerry = Color(0xFF7A1E48);

  static const color_screen_background = Color(0xFFFAFAFA);
  static const border_color_EFEFF5 = Color(0xffEFEFF5);

  static const color_light_blue_unselected_intro_C7D6FB = Color(0xFFC7D6FB);
  static const color_dark_blue_selected_intro_004CFFB = Color(0xFF004CFF);

  static const color_text_black_392C23 = Color(0xFF392C23);
  static const color_text_gray_dark_hint_8A8A8F = Color(0xFF8A8A8F);

  static const color_gray_CECFD2 = Color(0xFFCECFD2);
  static const color_green_3EC4B5 = Color(0xFF3EC4B5);

  static const color_text_gray_BDBBBB = Color(0xFFBDBBBB);

  static const color_gray_F7F7F8 = Color(0xFFF7F7F8);
  static const color_green_3EC4B5_2 = Color(0xFF3EC4B5);

  static const color_gray_bkg_F0F3F4 = Color(0xFFF0F3F4);
  static const color_orange_bkg_FEF6DF = Color(0xFFFEF6DF);
  static const color_blue_bkg_E5F0FE = Color(0xFFE5F0FE);
  static const color_red_bkg_FFF0E9 = Color(0xFFFFF0E9);
  static const color_gray_dark_CECFD2 = Color(0xFFCECFD2);

  static const color_black_392C23 = Color(0xFF392C23);

  static const purpleColor = Color(0xff6688FF);
  static const darkTextColor = Color(0xff1F1A3D);
  static const lightTextColor = Color(0xff999999);
  static const textFieldColor = Color(0xffF5F6FA);
  static const borderColor = Color(0xffD9D9D9);
  static const blueColor = Color(0xff3EC4B5);
  static const blackColor = Color(0xff000000);
  static const dividerColor = Color(0xffEFEFF5);
  static const hintColor = Color(0xff8A8A8F);
  static const stackColor = Color(0xffF7F7F8);
  static const whiteColor = Color(0xffFFFFFF);
  static const customAppBarColor = Color(0xffF7F7F8);
  static const tableColor = Color(0xff8A8A8F);
  static const redColor = Color(0xffb51010);

  static Color primary = HexColor.fromHex("#000000");
  static Color darkGrey = HexColor.fromHex("#95989C");
  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#F7F7F8");
  static Color lightGreyBorder = HexColor.fromHex("#EFEFF5");

  static Color morelightGrey = HexColor.fromHex("#D3D3D3");
  static Color grey8A8A8F = HexColor.fromHex("#8A8A8F");
  static Color grey2 = HexColor.fromHex("#CECFD2");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color activeButtonColor = HexColor.fromHex("#3EC4B5");

  static Color green = HexColor.fromHex("#3EC4B5");
  static Color black = HexColor.fromHex("#392C23");

  static Color error = HexColor.fromHex("#e61f34"); // red color

  static const primaryOrange = Color(0xffFF9900);
  static const appSubtitleGreen = Color(0xFFA4FFA4);
  static const darkBrown = Color(0xFF492C00);
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
