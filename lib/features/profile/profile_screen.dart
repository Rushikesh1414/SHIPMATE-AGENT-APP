import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shipmate_agent_app/core/routes/app_routes.dart';
import 'package:shipmate_agent_app/core/storage/app_storage.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';
import 'package:shipmate_agent_app/core/widgets/app_exit_widget.dart';
import 'package:shipmate_agent_app/features/authentication/signup/controller/sign_up_controller.dart';

import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationDialog(
      child: Scaffold(
        backgroundColor: AppColors.lightBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          title: Text(
            "Profile",
            style: GoogleFonts.inter(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 3.h),

              CircleAvatar(
                  radius: 30,
                  child: ClipOval(
                      child: Image.network(
                    AppStorage.photo!,
                    errorBuilder: (context, error, stackTrace) {
                      return CircleAvatar();
                    },
                  ))),

              SizedBox(height: 2.h),

              // User Name
              Text(
                AppStorage.userName!,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),

              SizedBox(height: 1.h),

              // Email
              Text(
                AppStorage.email!,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: AppColors.lightGreyColor,
                ),
              ),

              SizedBox(height: 3.h),

              SizedBox(height: 20.h),

              // Account Settings Section
              Container(
                padding: EdgeInsets.all(2.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greyColor.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.privacy_tip, color: AppColors.primaryColor),
                      title: Text(
                        "Privacy Policy",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackColor,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navigate to privacy policy
                      },
                    ),
                    Divider(height: 1.h, color: AppColors.greyColor.withValues(alpha: 0.3)),
                    ListTile(
                      leading: const Icon(Icons.logout, color: AppColors.redColor),
                      title: Text(
                        "Logout",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackColor,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        await AppStorage.clearAll();
                        router.go('/sign_up_screen');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
