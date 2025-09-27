import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';
import 'package:shipmate_agent_app/features/splash/controller/splash_controller.dart';



import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {

    return SafeArea(

      child: Scaffold(
          backgroundColor: AppColors.lightBackgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 250, width: 300, child: Image.asset("assets/WhatsApp_Image_2025-08-29_at_17.58.38_6a0c7b06-removebg-preview.png")),
              Lottie.asset(
                "assets/lottie/Shipping_complete_page_animation.json",
                filterQuality: FilterQuality.low,
                frameRate: FrameRate.composition,
                errorBuilder: (context, error, stackTrace) {
                  return CircleAvatar();
                },
              ),
              SizedBox(height: 1.h),
            ],
          )),
    );
  }
}
