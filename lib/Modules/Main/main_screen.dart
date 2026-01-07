// // import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:fill_go/App/Constant.dart';
// import 'package:fill_go/App/app.dart';
// import 'package:fill_go/Helpers/assets_color.dart';
// import 'package:fill_go/Helpers/assets_helper.dart';
// import 'package:fill_go/Helpers/snackbar_helper.dart';
// // import 'package:fill_go/Modules/About/about_screen.dart';
// import 'package:fill_go/Modules/List/allNewsItem.dart';
// import 'package:fill_go/Modules/List/list_screen.dart';
// import 'package:fill_go/Modules/Login/login_screen.dart';
// // import 'package:fill_go/Modules/Main/Complaint/complaint_screen.dart';
// import 'package:fill_go/Modules/Main/Home/home_screen.dart';
// // import 'package:fill_go/Modules/Main/Map/map_screen.dart';
// // import 'package:fill_go/Modules/Main/More/more_screen.dart';
// import 'package:fill_go/Modules/Main/main_controller.dart';
// // import 'package:fill_go/Modules/Settings/Contact/contact_screen.dart';
// // import 'package:fill_go/Modules/Settings/common_questions/common_q.dart';
// // import 'package:fill_go/Modules/Settings/setting_screen.dart';
// import 'package:fill_go/Widgets/custom_app_bar.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:shrink_sidemenu/shrink_sidemenu.dart';

// import '../../Utils/utils.dart';
// import '../../Widgets/custom_widgets.dart';
// // import '../Notification/notification_screen.dart';
// import 'Services/services_screen.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// /// This is the private State class that goes with MyStatefulWidget.
// class _MainScreenState extends State<MainScreen>
//     with AutomaticKeepAliveClientMixin {
//   final int _selectedIndex = 0;
//   final mainController = Get.put(MainController());
//   // late final GlobalKey<SideMenuState> sideMenuKey;
//   late final _mPages;

//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

//   void _onItemTapped(int index) {
//     mainController.changeBottomNavigationBar(index);
//   }

//   bool isUser = false;

//   @override
//   void initState() {
//     isUser =
//         Application.staticSharedPreferences!.getBool(Constants.USER_IS_LOGIN) ??
//             false;
//     super.initState();
//     // sideMenuKey = GlobalKey<SideMenuState>();

//     mainController.getUser();

//     _mPages = <Widget>[
//       HomeScreen(
//         // sideMenuKey: sideMenuKey,
//         // mainController: mainController,
//       ),
//       ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<MainController>(
//         init: mainController,
//         builder: (context1) {
//           return SideMenu(
//               key: sideMenuKey,
//               closeIcon: const Icon(
//                 Icons.close,
//                 color: Colors.black,
//               ),
//               menu: buildMenu(),
//               background: AssetsColors.color_screen_background,
//               inverse: true,
//               type: SideMenuType.shrinkNSlide,
//               child: Scaffold(
//                 appBar: mainController.currantPageIndex == 0
//                     ? null
//                     : AppBar(
//                         centerTitle: true,
//                         title: Text(
//                           "${mainController.bottomNavIcon[mainController.currantPageIndex].label}",
//                           textAlign: TextAlign.center,
//                           style: AppTextStyles.getBoldTextStyle(
//                               fontSize: 18,
//                               colorValue: AssetsColors.color_text_black_392C23),
//                         ),
//                         leading: IconButton(
//                             onPressed: () {
//                               sideMenuKey.currentState!.isOpened
//                                   ? sideMenuKey.currentState!
//                                       .closeSideMenu() // close side menu
//                                   : sideMenuKey.currentState!
//                                       .openSideMenu(); // close side menu
//                             },
//                             icon: RotatedBox(
//                               quarterTurns: 2,
//                               child: SvgPicture.asset(
//                                 AssetsHelper.ic_menu_svg,
//                                 color: AssetsColors.color_text_black_392C23,
//                               ),
//                             )),
//                         actions: [
//                           isUser
//                               ? IconButton(
//                                   onPressed: () {
//                                     Get.to(const NotificationScreen());
//                                   },
//                                   icon: SvgPicture.asset(
//                                     AssetsHelper.ic_notification_svg,
//                                     color: AssetsColors.color_text_black_392C23,
//                                   ))
//                               : Container()
//                         ],
//                         backgroundColor: Colors.transparent,
//                         elevation: 0,
//                       ),
//                 body: _mPages[mainController.currantPageIndex],
//                 bottomNavigationBar: Container(
//                   decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(16),
//                           topRight: (Radius.circular(16)))),
//                   child: BottomNavigationBar(
//                     backgroundColor: Colors.white,
//                     type: BottomNavigationBarType.fixed,
//                     items: mainController.bottomNavIcon,
//                     selectedLabelStyle:
//                         AppTextStyles.getMediumTextStyle(fontSize: 12),
//                     unselectedLabelStyle: AppTextStyles.getMediumTextStyle(
//                         fontSize: 11,
//                         colorValue: AssetsColors.color_text_gray_BDBBBB),
//                     currentIndex: mainController.currantPageIndex,
//                     selectedItemColor: AssetsColors.color_green_3EC4B5,
//                     onTap: _onItemTapped,
//                   ),
//                 ),
//               ));
//         });
//   }

//   Padding buildMenu() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           handleUserGuestView(),
//           Expanded(
//             child: NotificationListener<OverscrollIndicatorNotification>(
//               onNotification: (overscroll) {
//                 overscroll.disallowIndicator();
//                 return true;
//               },
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: mainController.menuList.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 4, bottom: 4),
//                           child: InkWell(
//                             onTap: () {
//                               switch (index) {
//                                 case 0:
//                                   mainController.changeBottomNavigationBar(0);
//                                   sideMenuKey.currentState!.closeSideMenu();
//                                   break;
//                                 case 1:
//                                   sideMenuKey.currentState!.closeSideMenu();
//                                   Get.to(ListScreen<AllNewsItem>(
//                                     appBar: CustomAppBar(
//                                       title: Utils.getString().home_last_news,
//                                       onPressed: () {
//                                         Get.back();
//                                       },
//                                     ),
//                                   ));
//                                   break;
//                                 case 2:
//                                   mainController.changeBottomNavigationBar(1);
//                                   sideMenuKey.currentState!.closeSideMenu();
//                                   break;

//                                 case 3:
//                                   Get.to(const AboutScreen());
//                                   sideMenuKey.currentState!.closeSideMenu();
//                                   break;
//                                 case 4:
//                                   mainController.changeBottomNavigationBar(2);
//                                   sideMenuKey.currentState!.closeSideMenu();
//                                   break;
//                                 case 5:
//                                   Get.to(const CommonQuestions());
//                                   sideMenuKey.currentState!.closeSideMenu();
//                                   break;
//                                 case 6:
//                                   Get.to(const ContactScreen());
//                                   sideMenuKey.currentState!.closeSideMenu();
//                                   break;
//                                 case 7:
//                                   Get.to(const SettingScreen());
//                                   sideMenuKey.currentState!.closeSideMenu();
//                                   break;

//                                 case 8:
//                                   SnackBarHelper.show();
//                                   sideMenuKey.currentState!.closeSideMenu();
//                                   break;
//                               }
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   decoration: const BoxDecoration(
//                                       color: AssetsColors.color_gray_F7F7F8,
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(6))),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: SvgPicture.asset(
//                                       mainController.menuList[index].iconPath,
//                                       width: 20,
//                                       color:
//                                           AssetsColors.color_text_black_392C23,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsetsDirectional.only(
//                                       start: 10.0),
//                                   child: Text(
//                                     mainController.menuList[index].name,
//                                     textAlign: TextAlign.start,
//                                     style: AppTextStyles.getMediumTextStyle(
//                                         fontSize: 16,
//                                         colorValue: AssetsColors
//                                             .color_text_black_392C23),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: 24.h,
//                   ),
//                   handleGuestLogoutWidget(),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Column handleUserGuestView() {
//     return mainController.tUser == null
//         ? Column(
//             children: [
//               const CircleAvatar(
//                 backgroundColor: Color(0xFFE2E2E2),
//                 radius: 50,
//                 child: Icon(
//                   Icons.person,
//                   size: 50,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(
//                 height: 8.h,
//               ),
//               Text(
//                 Utils.getString().menu_welcome_guest,
//                 textAlign: TextAlign.center,
//                 style: AppTextStyles.getBoldTextStyle(
//                     fontSize: 16,
//                     colorValue: AssetsColors.color_text_black_392C23),
//               ),
//             ],
//           )
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               (mainController.tUser!.imgPath != null &&
//                       mainController.tUser!.imgPath!.isNotEmpty)
//                   ? CachedNetworkImage(
//                       imageUrl: mainController.tUser!.imgPath ?? "",
//                       imageBuilder: (context, image) =>
//                           CircleAvatar(radius: 50.r, backgroundImage: image),
//                       progressIndicatorBuilder:
//                           (context, url, downloadProgress) => Center(
//                         child: CircularProgressIndicator(
//                             value: downloadProgress.progress),
//                       ),
//                       errorWidget: (context, child, error) => CircleAvatar(
//                         backgroundColor: const Color(0xFFE2E2E2),
//                         radius: 50.r,
//                         child: Icon(
//                           Icons.person,
//                           size: 50.r,
//                           color: Colors.white,
//                         ),
//                       ),
//                     )
//                   : const CircleAvatar(
//                       backgroundColor: Color(0xFFE2E2E2),
//                       radius: 50,
//                       child: Icon(
//                         Icons.person,
//                         size: 50,
//                         color: Colors.white,
//                       ),
//                     ),
//               Text(
//                 "${mainController.tUser!.fullName}",
//                 textAlign: TextAlign.center,
//                 style: AppTextStyles.getMediumTextStyle(
//                     fontSize: 20,
//                     colorValue: AssetsColors.color_text_black_392C23),
//               ),
//               Text(
//                 "${mainController.tUser!.email}",
//                 textAlign: TextAlign.center,
//                 style: AppTextStyles.getMediumTextStyle(
//                     fontSize: 14,
//                     colorValue: AssetsColors.color_text_gray_dark_hint_8A8A8F),
//               )
//             ],
//           );
//   }

//   InkWell handleGuestLogoutWidget() {
//     return InkWell(
//       onTap: () {
//         mainController.tUser == null
//             ? Get.offAll(const LoginScreen())
//             : showCustomDialog(context);
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//                 color: AssetsColors.color_gray_F7F7F8,
//                 borderRadius: BorderRadius.all(Radius.circular(6))),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SvgPicture.asset(
//                 mainController.tUser == null
//                     ? AssetsHelper.ic_menu_login_svg
//                     : AssetsHelper.ic_logout,
//                 width: 20,
//                 color: mainController.tUser == null
//                     ? AssetsColors.green
//                     : const Color(0xFFFF4040),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsetsDirectional.only(start: 10.0),
//             child: Text(
//               mainController.tUser == null
//                   ? Utils.getString().menu_login
//                   : Utils.getString().menu_logout,
//               textAlign: TextAlign.start,
//               style: AppTextStyles.getBoldTextStyle(
//                   colorValue: mainController.tUser == null
//                       ? AssetsColors.green
//                       : const Color(0xFFFF4040)),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;

// // Widget projectWidget() {
// //   return FutureBuilder(
// //     builder: (context, projectSnap) {
// //       if (projectSnap.connectionState == ConnectionState.none &&
// //           projectSnap.hasData == null) {
// //         //print('project snapshot data is: ${projectSnap.data}');
// //         return Container();
// //       }
// //       return Text(
// //         Utils.getString().menu_welcome_guest,
// //         textAlign: TextAlign.center,
// //         style: AppTextStyles.getBoldTextStyle(
// //             fontSize: 16, colorValue: AssetsColors.color_text_black_392C23),
// //       );
// //     },
// //     future: ,
// //   );
// // }
// }

// Future<void> showCustomDialog(BuildContext context) {
//   return showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) => CupertinoAlertDialog(
//       title: Container(
//           margin: const EdgeInsetsDirectional.only(bottom: 10.0, top: 12.0),
//           child: Text(Utils.getString().log_out,
//               style: AppTextStyles.getBoldTextStyle(
//                   fontSize: 20,
//                   colorValue: AssetsColors.color_text_black_392C23))),
//       content: Text(Utils.getString().r_u_sure_logout,
//           style: AppTextStyles.getMediumTextStyle(
//               colorValue: AssetsColors.color_text_gray_dark_hint_8A8A8F)),
//       actions: <CupertinoDialogAction>[
//         CupertinoDialogAction(
//           child: Text(Utils.getString().log_out,
//               style: AppTextStyles.getMediumTextStyleColor(
//                   fontSize: 16.0, color: Colors.red)),
//           onPressed: () async {
//             SharedPreferences shared = await Application.sharedPreferences;
//             shared.setString(Constants.USER_AUTH_TOKEN, "");
//             shared.setBool(Constants.USER_IS_LOGIN, false);
//             shared.setString(Constants.USER_DATA, "");
//             Navigator.of(Application.navigatorKey.currentState!.context,
//                     rootNavigator: true)
//                 .pop();
//             Get.offAll(const LoginScreen());
//           },
//         ),
//         CupertinoDialogAction(
//           isDestructiveAction: true,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text(Utils.getString().cancle,
//               style: AppTextStyles.getMediumTextStyleColor(
//                   fontSize: 16.0,
//                   color: AssetsColors.color_text_gray_dark_hint_8A8A8F)),
//         )
//       ],
//     ),
//   );
// }
