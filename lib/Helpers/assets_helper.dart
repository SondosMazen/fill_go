class AssetsHelper {
  static const String image_path = "assets/images/";
  static const String FONT_Avenir = "Avenir";

  static String getAssetPNG(String name) => "$image_path$name.png";

  static String getAssetJPG(String name) => "$image_path$name.jpg";

  static String getImage(String name) => image_path + name;

  static const String logo = "${image_path}rubble_app_icon.png";

  static const String ic_tab_complaint_off_svg =
      "${image_path}ic_tab_complaint_off.svg";

  static const ic_tab_home_off_svg = "${image_path}ic_tab_home_off.svg";
  static const ic_tab_home_on_svg = "${image_path}ic_tab_home_on.svg";

  static const ic_tab_map_off_svg = "${image_path}ic_tab_map_off.svg";

  static const ic_tab_more_off_svg = "${image_path}ic_tab_more_off.svg";

  static const ic_tab_services_off_svg = "${image_path}ic_tab_services_off.svg";

  static const ic_cancle = '${image_path}ic_cancle.svg';

}
