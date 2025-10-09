import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shipmate_agent_app/features/authentication/signup/controller/sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController signUpController = Get.put(SignUpController(), permanent: true);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.inActivePrimaryColor,
              AppColors.lightBackgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(6.w),
            child: Card(
              elevation: 5,
              color: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(height: 0.8.h),

                      // Subtitle
                      Text(
                        "Register as a ShipMate Agent",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.lightGreyColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),

                      // Animation
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 18.h,
                          width: 40.w,
                          child: Lottie.asset("assets/lottie/shipping truck.json"),
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // Full Name
                      TextFormField(
                        controller: signUpController.nameController,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          labelStyle: GoogleFonts.inter(),
                          prefixIcon: const Icon(Icons.person, color: AppColors.primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? "Enter your full name" : null,
                      ),
                      SizedBox(height: 2.h),

                      // Email
                      TextFormField(
                        controller: signUpController.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: GoogleFonts.inter(),
                          prefixIcon: const Icon(Icons.email, color: AppColors.primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        validator: (value) => value == null || !value.contains("@") ? "Enter a valid email" : null,
                      ),
                      SizedBox(height: 2.h),

                      // Phone
                      TextFormField(
                        controller: signUpController.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: GoogleFonts.inter(),
                          prefixIcon: const Icon(Icons.phone, color: AppColors.primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        validator: (value) => value == null || value.length < 10 ? "Enter valid phone number" : null,
                      ),
                      SizedBox(height: 3.h),

                      // Continue Button → OTP
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          minimumSize: Size(double.infinity, 6.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.h),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signUpController.sendOtp();
                            Get.toNamed("/otpVerification");
                          }
                        },
                        child: Text(
                          "Send OTP",
                          style: GoogleFonts.inter(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.5.h),

                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already registered? ",
                            style: GoogleFonts.inter(
                              color: AppColors.lightGreyColor,
                              fontSize: 12,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back(); // go back to login
                            },
                            child: Text(
                              "Log In",
                              style: GoogleFonts.inter(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.2.h),

                      Text(
                        "By continuing, you agree to our Terms of Service and Privacy Policy.",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.lightGreyColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
