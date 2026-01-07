// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../Model/establishment_model.dart';
// import 'font_helper.dart';

// // ignore: camel_case_types
// class buildDocumentationItemHelper extends StatelessWidget {
//   final EstablishmentModel? model;
//   const buildDocumentationItemHelper({super.key, this.model});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'ملخص عن نشــأة بلدية غزة',
//             style: FontsAppHelper().avenirArabicHeavyFont(size: 16),
//           ),
//           SizedBox(
//             height: 9.sp,
//           ),
//           Expanded(
//             child: ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               scrollDirection: Axis.vertical,
//               itemBuilder: (context, index) => Text(
//                   EstablishmentModel.models[index],
//                   style: FontsAppHelper().avenirArabicBookFont()),
//               itemCount: EstablishmentModel.models.length,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
