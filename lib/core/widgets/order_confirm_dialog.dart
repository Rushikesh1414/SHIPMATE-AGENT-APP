// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:shipmate_agent_app/core/theme/app_colors.dart';
// import 'package:shipmate_flutter_app/core/theme/app_colors.dart';
// import 'package:sizer/sizer.dart';

// class OrderConfirmationBottomSheet {
//   static void show(BuildContext context, {String? orderId}) {
//     final randomId = "rushikesh";
//     final finalId = orderId ?? randomId;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColors.whiteColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(3.h)),
//       ),
//       isScrollControlled: true,
//       builder: (context) {
//         return SafeArea(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // drag handle
//                 Container(
//                   height: 0.7.h,
//                   width: 12.w,
//                   margin: EdgeInsets.only(bottom: 2.h),
//                   decoration: BoxDecoration(
//                     color: AppColors.lightGreyColor.withOpacity(0.4),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),

//                 // success icon + heading
//                 Icon(Icons.check_circle, color: AppColors.greenColor, size: 6.h),
//                 SizedBox(height: 1.5.h),

//                 Text(
//                   'Order Confirmed!',
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.blackColor,
//                   ),
//                 ),
//                 SizedBox(height: 2.h),

//                 // ORDER DETAILS CARD
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(2.h),
//                   decoration: BoxDecoration(
//                     color: AppColors.lightGreyColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(1.5.h),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Order ID: $finalId",
//                           style: TextStyle(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.blackColor,
//                           )),
//                       SizedBox(height: 1.h),
//                       Text("Scheduled for delivery",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: AppColors.greyColor,
//                           )),
//                       Text("Standard Shipping",
//                           style: TextStyle(
//                             fontSize: 13.sp,
//                             color: AppColors.greyColor,
//                           )),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 3.h),

//                 // QR CODE (shown directly)
//                 Center(
//                   child: QrImageView(
//                     data: finalId,
//                     size: 40.w,
//                     backgroundColor: AppColors.whiteColor,
//                     foregroundColor: AppColors.blackColor,
//                   ),
//                 ),
//                 SizedBox(height: 2.h),

//                 // BUTTONS
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primaryColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(1.5.h),
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 1.8.h),
//                         ),
//                         onPressed: () {
//                           // TODO: implement share logic
//                         },
//                         icon: const Icon(Icons.share, color: AppColors.whiteColor),
//                         label: Text(
//                           "Share",
//                           style: TextStyle(fontSize: 16.sp, color: AppColors.whiteColor),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 4.w),
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.whiteColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(1.5.h),
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 1.8.h),
//                         ),
//                         onPressed: () {
//                           context.go('/home_screen');
//                         },
//                         child: Text(
//                           "OK",
//                           style: TextStyle(fontSize: 16.sp, color: AppColors.blackColor),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 2.h),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
