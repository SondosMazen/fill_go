// import 'dart:developer';

// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:fill_go/Helpers/DateHelper.dart';
// import 'package:fill_go/Helpers/assets_color.dart';
// import 'package:fill_go/Helpers/assets_helper.dart';
// import 'package:fill_go/Helpers/snackbar_helper.dart';
// import 'package:fill_go/Model/TSlider.dart';
// // import 'package:fill_go/Modules/Bills/bill_screen.dart';
// import 'package:fill_go/Modules/List/AllAdsItem.dart';
// import 'package:fill_go/Modules/List/allNewsItem.dart';
// import 'package:fill_go/Modules/List/list_screen.dart';
// // import 'package:fill_go/Modules/Main/Home/HomeSearch/search_screen.dart';
// import 'package:fill_go/Modules/Main/Home/home_controller.dart';
// import 'package:fill_go/Modules/Main/main_controller.dart';
// // import 'package:fill_go/Modules/NewsDetails/news_details_screen.dart';
// // import 'package:fill_go/Modules/Notification/notification_screen.dart';
// // import 'package:fill_go/Modules/Schedule/schedule_water_screen.dart';
// import 'package:fill_go/Widgets/custom_app_bar.dart';

// import 'package:fill_go/Widgets/custom_widgets.dart';
// // import 'package:shrink_sidemenu/shrink_sidemenu.dart';
// // import 'package:url_launcher/url_launcher.dart';

// import '../../../Helpers/Shimmer.dart';
// import '../../../Model/THome.dart';
// import '../../../Utils/utils.dart';
// // import '../../../Widgets/BottomSheet/src/flexible_bottom_sheet_route.dart';
// import '../../../Widgets/CustomImageSlider.dart';
// // import '../../Guide/EmergencyNumber/emergency_number_screen.dart';
// // import '../../NewsDetails/advertisment_screen.dart';

// // import '../../Services/EnterCounter/enter_counter_screen.dart';
// // import '../../Settings/web_view_screen.dart';

// final List<String> imgList = [
//   'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
//   'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
//   'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
//   'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
// ];

// class HomeScreen extends StatelessWidget {
//   HomeScreen(
//       {super.key, required this.sideMenuKey, required this.mainController});

//   final homeController = Get.put(HomeController());

//   GlobalKey<SideMenuState> sideMenuKey;
//   MainController mainController;

//   // final CarouselController _controller = CarouselController();

//   Column initBodyListView(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppBar(
//           centerTitle: true,
//           title: Text(
//             Utils.getString().home,
//             textAlign: TextAlign.center,
//             style: AppTextStyles.getBoldTextStyle(
//                 fontSize: 18, colorValue: AssetsColors.color_white),
//           ),
//           actions: [
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 homeController.isUser
//                     ? IconButton(
//                         onPressed: () {
//                           Get.to(() => const NotificationScreen());
//                         },
//                         icon: Stack(
//                           alignment: AlignmentDirectional.center,
//                           children: [
//                             SizedBox(
//                               height: 20.h,
//                               width: 17.w,
//                               child: SvgPicture.asset(
//                                   AssetsHelper.ic_notification_svg,
//                                   fit: BoxFit.cover),
//                             ),
//                             if (homeController.tMyNotification!.isNotEmpty)
//                               Align(
//                                 alignment: AlignmentDirectional.topStart,
//                                 child: CircleAvatar(
//                                   radius: 8,
//                                   backgroundColor: AssetsColors.white,
//                                   child: CircleAvatar(
//                                     radius: 7,
//                                     backgroundColor: Colors.red,
//                                     child: Text(
//                                       '${homeController.tMyNotification!.length}',
//                                       style: AppTextStyles.getHeavyTextStyle(
//                                           colorValue: AssetsColors.white,
//                                           fontSize: 10.sp),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ))
//                     : const SizedBox(
//                         width: 0,
//                         height: 0,
//                       ),
//                 IconButton(
//                     onPressed: () {
//                       Get.to(() => SearchScreen());
//                     },
//                     icon: SvgPicture.asset(
//                       AssetsHelper.ic_search,
//                       color: AssetsColors.white,
//                     )),
//               ],
//             ),
//           ],
//           leading: IconButton(
//               onPressed: () {
//                 sideMenuKey.currentState!.isOpened
//                     ? sideMenuKey.currentState!
//                         .closeSideMenu() // close side menu
//                     : sideMenuKey.currentState!
//                         .openSideMenu(); // close side menu
//               },
//               icon: RotatedBox(
//                 quarterTurns: 2,
//                 child: SvgPicture.asset(
//                   AssetsHelper.ic_menu_svg,
//                   color: Colors.white,
//                 ),
//               )),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//         ),
//         Stack(
//           children: [
//             Container(
//               clipBehavior: Clip.hardEdge,
//               margin: const EdgeInsetsDirectional.all(10),
//               decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(16)),
//                   shape: BoxShape.rectangle),
//               child: initSliderHome(),
//             ),
//           ],
//         ),
//         Expanded(
//           child: ListView(
//             padding: EdgeInsetsDirectional.zero,
//             shrinkWrap: true,
//             children: [
//               const Padding(
//                 padding: EdgeInsetsDirectional.only(start: 10.0),
//                 // child: Text(
//                 //   Utils.getString().home_quick_access,
//                 //   textAlign: TextAlign.start,
//                 //   style: AppTextStyles.getBoldTextStyle(
//                 //       fontSize: 18,
//                 //       colorValue: AssetsColors.color_text_black_392C23),
//                 // ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     const Expanded(
//                       flex: 1,
//                       child: SizedBox(),
//                     ),
//                     Expanded(
//                       flex: 3,
//                       child: InkWell(
//                         //onTap: () =>showCustomBottomSheet(context),
//                         onTap: () {
//                           if (homeController.isUser) {
//                             Get.to(() => EnterCounterScreen());
//                           } else {
//                             SnackBarHelper.show(
//                                 msg: "يجب تسجيل الدخول لادخال القراءة");
//                           }
//                         },
//                         child: Column(
//                           children: [
//                             Container(
//                               width: double.maxFinite,
//                               padding: const EdgeInsetsDirectional.all(20),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(16)),
//                                 border:
//                                     Border.all(color: const Color(0xFFEFEFF5)),
//                                 shape: BoxShape.rectangle,
//                               ),
//                               child: SvgPicture.asset(
//                                 AssetsHelper.ic_service_enter_svg,
//                               ),
//                             ),
//                             Text(
//                               Utils.getString().services_guide_enter,
//                               textAlign: TextAlign.center,
//                               style: AppTextStyles.getMediumTextStyle(
//                                   fontSize: 12,
//                                   colorValue:
//                                       AssetsColors.color_text_black_392C23),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 25.w,
//                     ),
//                     // Expanded(
//                     //   flex: 1,
//                     //   child: InkWell(
//                     //     onTap: () => mainController.changeBottomNavigationBar(1),
//                     //     child: Column(
//                     //       children: [
//                     //         Container(
//                     //           padding: const EdgeInsetsDirectional.all(20),
//                     //           decoration: BoxDecoration(
//                     //             color: Colors.white,
//                     //             borderRadius:
//                     //                 const BorderRadius.all(Radius.circular(16)),
//                     //             border:
//                     //                 Border.all(color: const Color(0xFFEFEFF5)),
//                     //             shape: BoxShape.rectangle,
//                     //           ),
//                     //           child: SvgPicture.asset(
//                     //             AssetsHelper.ic_home_ecommarce_svg,
//                     //           ),
//                     //         ),
//                     //         Text(
//                     //           Utils.getString().home_quick_services,
//                     //           textAlign: TextAlign.center,
//                     //           style: AppTextStyles.getMediumTextStyle(
//                     //               fontSize: 12,
//                     //               colorValue:
//                     //                   AssetsColors.color_text_black_392C23),
//                     //         )
//                     //       ],
//                     //     ),
//                     //   ),
//                     // ),
//                     // const SizedBox(
//                     //   width: 8,
//                     // ),
//                     Expanded(
//                       flex: 3,
//                       child: InkWell(
//                         onTap: () {
//                           if (homeController.isUser) {
//                             Get.to(() => MyBillScreen());
//                           } else {
//                             SnackBarHelper.show(
//                                 msg: "يجب تسجيل الدخول للاطلاع على الفاتورة");
//                           }
//                         },
//                         child: Column(
//                           children: [
//                             Container(
//                               width: double.maxFinite,
//                               padding: const EdgeInsetsDirectional.all(20),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(16)),
//                                 border:
//                                     Border.all(color: const Color(0xFFEFEFF5)),
//                                 shape: BoxShape.rectangle,
//                               ),
//                               child: SvgPicture.asset(
//                                 AssetsHelper.ic_service_my_bill_svg,
//                               ),
//                             ),
//                             Text(
//                               Utils.getString().txt_my_bill,
//                               textAlign: TextAlign.center,
//                               style: AppTextStyles.getMediumTextStyle(
//                                   fontSize: 12,
//                                   colorValue:
//                                       AssetsColors.color_text_black_392C23),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 25.w,
//                     ),
//                     Expanded(
//                       flex: 3,
//                       child: InkWell(
//                         onTap: () => Get.to(() => EmergencyNumberScreen()),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: double.maxFinite,
//                               padding: const EdgeInsetsDirectional.all(20),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(16)),
//                                 border:
//                                     Border.all(color: const Color(0xFFEFEFF5)),
//                                 shape: BoxShape.rectangle,
//                               ),
//                               child: SvgPicture.asset(
//                                 AssetsHelper.ic_home_numbers_svg,
//                               ),
//                             ),
//                             Text(
//                               Utils.getString().home_quick_numbers,
//                               textAlign: TextAlign.center,
//                               style: AppTextStyles.getMediumTextStyle(
//                                   fontSize: 12,
//                                   colorValue:
//                                       AssetsColors.color_text_black_392C23),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     const Expanded(
//                       flex: 1,
//                       child: SizedBox(),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         Utils.getString().home_last_news,
//                         textAlign: TextAlign.start,
//                         style: AppTextStyles.getBoldTextStyle(
//                             fontSize: 18,
//                             colorValue: AssetsColors.color_text_black_392C23),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Get.to(() {
//                           return ListScreen<AllNewsItem>(
//                             appBar: CustomAppBar(
//                               title: Utils.getString().home_last_news,
//                               onPressed: () {
//                                 Get.back();
//                               },
//                             ),
//                             // isAdsItem: false,
//                           );
//                         });
//                       },
//                       child: Text(
//                         Utils.getString().view_all,
//                         textAlign: TextAlign.start,
//                         style: AppTextStyles.getMediumTextStyle(
//                             fontSize: 12,
//                             colorValue: AssetsColors.color_green_3EC4B5),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(12.0),
//                 height: 140.h,
//                 child: widgetListNews(),
//               ),
//               Padding(
//                 padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         Utils.getString().home_ads,
//                         textAlign: TextAlign.start,
//                         style: AppTextStyles.getBoldTextStyle(
//                             fontSize: 18,
//                             colorValue: AssetsColors.color_text_black_392C23),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Get.to(() => ListScreen<AllAdsItem>(
//                               appBar: CustomAppBar(
//                                 title: Utils.getString().home_last_news,
//                                 onPressed: () {
//                                   Get.back();
//                                 },
//                               ),
//                               // isAdsItem: true,
//                             ));
//                       },
//                       child: Text(
//                         Utils.getString().view_all,
//                         textAlign: TextAlign.start,
//                         style: AppTextStyles.getMediumTextStyle(
//                             fontSize: 12,
//                             colorValue: AssetsColors.color_green_3EC4B5),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(12.0),
//                 height: 120,
//                 child: widgetListAds(),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }

//   Widget initSliderHome() {
//     return homeController.isLoading
//         ? ShimmerCard(
//             height: 200,
//           )
//         : CustomImageSlider(
//             width: double.infinity,
//             height: 200,
//             initialPage: 0,
//             indicatorColor: Colors.white,
//             indicatorBackgroundColor: Colors.grey,
//             onPageChanged: (value) {},
//             autoPlayInterval: 8000,
//             isLoop: true,
//             isTextFromOutside: true,
//             children: handleImages(homeController.tHome),
//           );
//   }

//   widgetListAds() {
//     return homeController.tHome == null
//         ? Center(
//             child: CircularProgressIndicator(
//               color: AssetsColors.green,
//             ),
//           )
//         : (homeController.tHome!.adv == null ||
//                 homeController.tHome!.adv!.isEmpty)
//             ? EmptyWidget()
//             : GridView.builder(
//                 shrinkWrap: true,
//                 itemCount: homeController.tHome!.adv!.length,
//                 scrollDirection: Axis.horizontal,
//                 physics: const BouncingScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 1,
//                     mainAxisExtent: 250,
//                     crossAxisSpacing: 10.0,
//                     mainAxisSpacing: 10.0),
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       Get.to(() => AdvertisementScreen(
//                             tAdv: homeController.tHome!.adv![index],
//                           ));
//                     },
//                     child: Container(
//                         clipBehavior: Clip.hardEdge,
//                         decoration: BoxDecoration(
//                             border: Border.all(color: const Color(0xFFEFEFF5)),
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(10)),
//                             shape: BoxShape.rectangle),
//                         child: Stack(
//                           children: [
//                             Positioned.fill(
//                               child: Container(
//                                 padding: const EdgeInsetsDirectional.all(10),
//                                 alignment: AlignmentDirectional.topStart,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       homeController.tHome!.adv![index].title??'',
//                                       maxLines: 2,
//                                       textAlign: TextAlign.start,
//                                       style: AppTextStyles.getMediumTextStyle(
//                                           colorValue: AssetsColors
//                                               .color_text_black_392C23),
//                                     ),
//                                     RichText(
//                                       textAlign: TextAlign.start,
//                                       text: TextSpan(
//                                         children: [
//                                           WidgetSpan(
//                                             alignment: PlaceholderAlignment.top,
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 5, right: 5),
//                                               child: SvgPicture.asset(
//                                                 AssetsHelper.ic_calender_svg,
//                                                 color: AssetsColors
//                                                     .color_text_black_392C23,
//                                               ),
//                                             ),
//                                           ),
//                                           TextSpan(
//                                               text: DateHelper.timeAgo(
//                                                 dateStr: homeController.tHome!
//                                                     .adv![index].createdAt??'',
//                                               ),
//                                               style: AppTextStyles
//                                                   .getMediumTextStyle(
//                                                       fontSize: 12,
//                                                       colorValue: const Color(
//                                                           0xFFCF2A45))),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           ],
//                         )),
//                   );
//                 },
//               );
//   }

//   widgetListNews() {
//     return homeController.tHome == null
//         ? Center(
//             child: CircularProgressIndicator(
//             color: AssetsColors.green,
//           ))
//         : (homeController.tHome!.news == null ||
//                 homeController.tHome!.news!.isEmpty)
//             ? EmptyWidget()
//             : GridView.builder(
//                 itemCount: homeController.tHome!.news!.length,
//                 scrollDirection: Axis.horizontal,
//                 physics: const BouncingScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 1,
//                     mainAxisExtent: 250,
//                     crossAxisSpacing: 10.0,
//                     mainAxisSpacing: 10.0),
//                 itemBuilder: (BuildContext context, int index) {
//                   return Container(
//                     clipBehavior: Clip.hardEdge,
//                     decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                         shape: BoxShape.rectangle),
//                     child: InkWell(
//                       onTap: () {
//                         Get.to(() => NewsDetailsScreen(
//                               // tNews: homeController.tHome!.news![index],
//                               NewsID: homeController.tHome!.news![index].id,
//                             ));
//                       },
//                       child: Stack(
//                         children: [
//                           Positioned.fill(
//                             child: CachedNetworkImage(
//                               imageUrl:
//                                   homeController.tHome!.news![index].mainImg!,
//                               imageBuilder: (context, imageProvider) =>
//                                   Container(
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                     image: imageProvider,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               placeholder: (context, url) => Center(
//                                   child: CircularProgressIndicator(
//                                 color: AssetsColors.green,
//                               )),
//                               errorWidget: (context, url, error) =>
//                                   const Icon(Icons.error),
//                             ),
//                           ),
//                           Container(
//                             decoration: const BoxDecoration(
//                               gradient: LinearGradient(
//                                   begin: Alignment.bottomCenter,
//                                   end: Alignment.topCenter,
//                                   colors: [
//                                     Colors.black54,
//                                     Colors.black38,
//                                     Colors.black12
//                                   ]),
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsetsDirectional.all(10),
//                             alignment: AlignmentDirectional.bottomStart,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   homeController.tHome!.news![index].title!,
//                                   textAlign: TextAlign.start,
//                                   style: AppTextStyles.getMediumTextStyle(
//                                       colorValue: AssetsColors.color_white),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//   }

//   List<Widget> handleImages(THome? tHome) {
//     List<Widget> listSlider = [];

//     if (tHome == null) return listSlider;

//     if (tHome.slider != null) {
//       for (TSlider tSlider in tHome.slider!) {
//         listSlider.add(initStackSlider(tSlider));
//       }
//     }

//     return listSlider;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(),
//       body: GetBuilder<HomeController>(
//           init: homeController,
//           builder: (contextHome) {
//             return Stack(
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       child: SvgPicture.asset(AssetsHelper.ic_home_shape_svg),
//                       decoration: BoxDecoration(
//                           color: AssetsColors.color_green_3EC4B5,
//                           border: Border.all(color: const Color(0xFFEFEFF5)),
//                           borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(10),
//                               bottomRight: (Radius.circular(10)))),
//                     )
//                   ],
//                 ),
//                 initBodyListView(context),
//               ],
//             );
//           }),
//     );
//   }

//   SizedBox test() {
//     return SizedBox(
//       width: 200.0,
//       height: 100.0,
//       child: FancyShimmerImage(
//         imageUrl:
//             'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1',
//         shimmerBaseColor: AssetsColors.color_light_blue_unselected_intro_C7D6FB,
//         shimmerHighlightColor: AssetsColors.color_green_3EC4B5,
//         shimmerBackColor: AssetsColors.color_gray_bkg_F0F3F4,
//       ),
//     );
//   }

//   Widget initStackSlider(TSlider tSlider) {
//     return InkWell(
//       onTap: () {
//         if (tSlider.youtubeLink != null && tSlider.youtubeLink!.isNotEmpty) {
//           _launchUniversalLinkIos(Uri.parse(tSlider.youtubeLink!));
//         } else if (tSlider.eventLink != null && tSlider.eventLink!.isNotEmpty) {
//           Get.to(SocialWebView(title: "التفاصيل"),
//               arguments: '${tSlider.eventLink}');
//         }
//       },
//       child: Stack(
//         children: [
//           CachedNetworkImage(
//             imageUrl: tSlider.mainImage!,
//             imageBuilder: (context, imageProvider) => Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: imageProvider,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             placeholder: (context, url) => Center(
//                 child: CircularProgressIndicator(
//               color: AssetsColors.green,
//             )),
//             errorWidget: (context, url, error) => const Icon(Icons.error),
//           ),
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [Colors.black54, Colors.black38, Colors.black12]),
//             ),
//           ),
//           Positioned.fill(
//             child: Container(
//               padding: const EdgeInsetsDirectional.all(10),
//               alignment: AlignmentDirectional.bottomStart,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${tSlider.title}",
//                     textAlign: TextAlign.start,
//                     style: AppTextStyles.getMediumTextStyle(
//                         fontSize: 16, colorValue: AssetsColors.color_white),
//                   ),
//                   RichText(
//                     textAlign: TextAlign.justify,
//                     text: TextSpan(
//                       children: [
//                         const WidgetSpan(
//                           alignment: PlaceholderAlignment.top,
//                           child: Padding(
//                             padding: EdgeInsetsDirectional.only(end: 5),
//                             child: Icon(
//                               Icons.access_time,
//                               size: 14,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         TextSpan(
//                             text:
//                                 DateHelper.timeAgo(dateStr: tSlider.updatedAt??''),
//                             style: AppTextStyles.getMediumTextStyle(
//                                 fontSize: 12,
//                                 colorValue: AssetsColors.color_white)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> _launchUniversalLinkIos(Uri url) async {
//     final bool nativeAppLaunchSucceeded = await launchUrl(
//       url,
//       mode: LaunchMode.externalNonBrowserApplication,
//     );
//     if (!nativeAppLaunchSucceeded) {
//       await launchUrl(
//         url,
//         mode: LaunchMode.inAppWebView,
//       );
//     }
//   }

//   void showCustomBottomSheet(BuildContext context) {
//     showFlexibleBottomSheet<void>(
//       initHeight: 0.3,
//       maxHeight: 0.3,
//       context: context,
//       isSafeArea: true,
//       isCollapsible: false,
//       isExpand: true,
//       bottomSheetColor: Colors.black12,
//       builder: (context, controller, offset) {
//         return ScheduleWaterScreen(controller);
//       },
//     );
//     // _showMyDialog(response.data);
//   }

//   //
//   //   return showModalBottomSheet(
//   //       isScrollControlled: true,
//   //       isDismissible: true,
//   //       enableDrag: true,
//   //       context: context,
//   //       shape: const RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.only(
//   //           topLeft: Radius.circular(20.0),
//   //           topRight: Radius.circular(20.0),
//   //         ),
//   //       ),
//   //       builder: (context) {
//   //         return ScheduleWaterScreen();
//   //       });
//   // }
// }

import 'dart:developer';

import 'package:fill_go/Model/TOrder.dart';
import 'package:fill_go/Modules/AddRequest/add_request.dart';
import 'package:fill_go/Modules/Main/Home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  SharedPreferences? sharedPreferences;
  // Future<void> getSharedPref() async {
  //   log('the getSharedPref called');

  //   await Application.sharedPreferences.then((val) {
  //     log('the getSharedPref  then called');

  //     sharedPreferences = val;
  //   });
  //   log('the getSharedPref end');
  // }

  HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // getSharedPref();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 248),
      appBar: AppBar(
        centerTitle: false,
        title: const Text('الطلبات', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              controller.logout();
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () => controller.getOrders(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // GetBuilder<HomeController>(
              //   builder: (controller) {
              //     return
              SearchBar(
                leading: Icon(Icons.search, color: Colors.grey),
                hintText: 'ابحث عن طلب',
                hintStyle: WidgetStatePropertyAll(
                  TextStyle(color: Colors.grey, fontSize: 14),
                ),
                elevation: WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                onChanged: (value) {
                  controller.search(value);
                },
              ),
              //   },
              // ),
          
              // SizedBox(
              //   height: 60,
              //   child: MultiSelectContainer(
              //     showInListView: true,
              //     // maxSelectableCount: 1,
              //     singleSelectedItem: true,
              //     controller: controller.filterListController,
              //     listViewSettings: ListViewSettings(
              //       scrollDirection: Axis.horizontal,
              //       separatorBuilder: (_, __) => const SizedBox(width: 10),
              //     ),
              //     items: [
              //       MultiSelectCard(value: 'all', label: 'الجميع'),
              //       MultiSelectCard(value: 'full', label: 'تم التحميل'),
              //       MultiSelectCard(value: 'empty', label: 'تم التفريغ'),
              //     ],
              //     onChange: (allSelectedItems, selectedItem) {
              //       controller.filterValue = selectedItem;
              //       controller.update();
              //     },
              //   ),
              // ),
              SizedBox(
                height: 570.h,
                child: FutureBuilder(
                  future: controller.getOrders(),
                  builder: (context, snapshot) {
                    return Obx(
                      () => ListView.builder(
                        itemCount: controller.filteredOrders.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          List<TOrder> orders = controller.filteredOrders;
                          return RequestCard(
                            loadLocation: orders?[index].location ?? '',
                            unloadLocation:
                                '${orders?[index].site?.location} - ${orders?[index].site?.name}',
                            careType: orders?[index].carType ?? '',
                            careNumber: orders?[index].carNum ?? '',
                            note: orders?[index].entryNotes ?? '',
                            time:
                                DateTime.tryParse(
                                  orders?[index].entryDate ?? '',
                                ) ??
                                DateTime.now(),
                            isAccepted: orders?[index].processUser != null,
                            name: '${orders?[index].entryUser?.name}',
                            orderNumber: '${orders?[index].oid}',
                            driver: orders[index].entryUserOid!,
                          );
                        },
          
                        // physics: NeverScrollableScrollPhysics(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          // Obx(() {
          //   return
          Visibility(
            visible: controller.userType == "2",
            child: FloatingActionButton(
              onPressed: () {
                // Action for FAB
                Get.to(
                  AddRequest(isDetails: false, userType: controller.userType),
                );
              },
              // backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
          ),

      //           } // إخفاء الزر تماماً
      // )
    );
  }
}

class RequestCard extends StatelessWidget {
  String loadLocation;
  String unloadLocation;
  String note;
  String careType;
  String careNumber;
  DateTime time;
  bool isAccepted;
  String name;
  String driver;
  String orderNumber;
  RequestCard({
    super.key,
    required this.loadLocation,
    required this.careNumber,
    required this.isAccepted,
    required this.careType,
    required this.unloadLocation,
    required this.name,
    required this.note,
    required this.driver,
    required this.time,
    required this.orderNumber,
  });
  HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.userType == "1") {
          Get.to(
            () => AddRequest(
              userType: controller.userType,
              isDetails: true,
              carNum: careNumber,
              carType: careType,
              entryDate: time.toString(),
              entryNotes: note,
              location: loadLocation,
              site: unloadLocation,
              driver: driver,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.symmetric(
            vertical: BorderSide(
              color: Colors.grey[100]!, // Border color for AVAILABLE status
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status and Time Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status Badge
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 6,
                  //     vertical: 4,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.green.withOpacity(0.1),
                  //     // borderRadius: BorderRadius.circular(20),
                  //     // border: Border.all(color: Colors.green, width: 1),
                  //   ),
                  //   child: Text(
                  //     'AVAILABLE',
                  //     style: TextStyle(
                  //       color: Colors.green,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 8,
                  //     ),
                  //   ),
                  // ),

                  // Time ago
                  Text(
                    '${time.hour}:${time.minute} - ${time.day}/${time.month}/${time.year}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Request Title
              Text(
                '$loadLocation إلى $unloadLocation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 8),

              // Truck and Pallets Info
              Row(
                children: [
                  Text(
                    '$careType - ',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                  // const SizedBox(width: 16),
                  Text(
                    careNumber,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Divider
              // Dispatch Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      'SS',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  !isAccepted
                      ? GetBuilder<HomeController>(
                          builder: (controller) {
                            return TextButton(
                              onPressed: () {
                                if (controller.userType == "1") {
                                  controller.acceptOrder(orderNumber);
                                }
                              },
                              style: TextButton.styleFrom(
                                minimumSize:
                                    Size.zero, // إزالة الحد الأدنى للحجم
                                tapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // تصغير مساحة الضغط
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 8,
                                ),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    controller.userType == "1"
                                        ? 'قبول الطلب'
                                        : 'الطلب قيد المراجعة',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.done, color: Colors.white),
                                ],
                              ),
                            );
                          },
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            // border: Border.all(color: Colors.green, width: 1),
                          ),
                          child: Text(
                            'تم قبول الطلب',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                ],
              ),

              // Accept Button
            ],
          ),
        ),
      ),
    );
  }
}
