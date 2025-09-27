import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';

import 'package:shipmate_agent_app/features/authentication/signup/controller/sign_up_controller.dart';

import 'package:sizer/sizer.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController signUpController = Get.put(SignUpController(), permanent: true);

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
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 5,
              color: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Main Title
                    const Text(
                      "Welcome to ShipMate",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Subtitle / Tagline
                    const Text(
                      "Reliable shipping services at your fingertips",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.lightGreyColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(height: 15.h, width: 30.w, child: Lottie.asset("assets/lottie/shipping truck.json")),
                    ),
                    const SizedBox(height: 30),

                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                       
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Center text & icon
                        children: [
                          const Text(
                            "Sign In with Google",
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8), // Space between text and icon
                          SizedBox(
                            height: 24,
                            child: Image.asset(
                              "assets/png-clipart-google-logo-logo-logo-company-text-removebg-preview.png",
                            ),
                          ),
                        ],
                      ),
                    ),

                    // const SizedBox(height: 20),
                    // OutlinedButton(
                    //   style: OutlinedButton.styleFrom(
                    //     side: const BorderSide(color: Colors.grey),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(30),
                    //     ),
                    //     minimumSize: const Size(double.infinity, 50),
                    //   ),
                    //   onPressed: () {
                    //     signUpController.signInWithFacebook();
                    //   },
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center, // Center text & icon
                    //     children: [
                    //       const Text(
                    //         "Sign In with Facebook",
                    //         style: TextStyle(
                    //           color: AppColors.blackColor,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //       const SizedBox(width: 0), // Space between text and icon
                    //       SizedBox(
                    //         height: 50,
                    //         width: 50,
                    //         child: Image.asset(
                    //           "assets/facebook-logo-transparent-background-free-png.webp",
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 20),

                    // Optional features / benefits
                    Column(
                      children: const [
                        Text(
                          "Why choose ShipMate?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "• Fast and reliable shipping services\n"
                          "• Easy booking process\n"
                          "• Affordable pricing",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.lightGreyColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Terms & Privacy
                    const Text(
                      "By continuing, you agree to our Terms of Service and Privacy Policy.",
                      style: TextStyle(
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
    );
  }
}
