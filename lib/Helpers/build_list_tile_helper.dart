// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// // ignore: implementation_imports

// import 'package:flutter_svg/svg.dart';
// import 'package:fill_go/Model/TAboutModel.dart';
// import 'package:fill_go/Utils/utils.dart';

// import 'assets_color.dart';

// class AboutWidgetHelper extends StatelessWidget {
//   final TAboutModel model;
//   final Function()? onTap;

//   const AboutWidgetHelper({super.key, required this.model, this.onTap});
//   @override
//   Widget build(BuildContext context) {
//     // return Container();
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
//       child: Column(
//         children: [
//           ListTile(
//             key: const Key("Your Key"),
//             onTap: onTap,
//             leading: Stack(
//               children: [
//                 Container(
//                   width: 36.w,
//                   height: 36.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8.r),
//                     color: stackColor,
//                   ),
//                   child: Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
//                     child: SvgPicture.asset(model.iconPath),
//                   ),
//                 ),
//               ],
//             ),
//             title: Text(
//               model.title,
//               style: AppTextStyles.getMediumTextStyle(
//                   colorValue: AssetsColors.blackColor),
//             ),
//             trailing: Icon(
//               Icons.arrow_forward_ios_outlined,
//               size: 14.sp,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
