import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';
import 'package:shipmate_agent_app/core/widgets/app_exit_widget.dart';
import 'package:shipmate_agent_app/core/widgets/textfield_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationDialog(
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Shipmate-agent",
              style: GoogleFonts.inter(color: AppColors.whiteColor, fontWeight: FontWeight.w400, fontSize: 16),
            ),
            backgroundColor: AppColors.primaryColor,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Manifest Details",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppTextField(hintText: "Select Loading Type"),
                const SizedBox(height: 12),
                AppTextField(hintText: "Vehicle Number"),
                const SizedBox(height: 12),
                AppTextField(hintText: "Manifest Number"),
                const SizedBox(height: 12),
                AppTextField(hintText: "From Station"),
                const SizedBox(height: 12),
                AppTextField(hintText: "To Station"),
                const SizedBox(height: 12),
                AppTextField(hintText: "Owner/Broker Name"),
                const SizedBox(height: 12),
                AppTextField(hintText: "Rate"),
                const SizedBox(height: 12),
                AppTextField(hintText: "Total Hire Cost"),
                const SizedBox(height: 12),
                AppTextField(hintText: "Select Payment Party"),
                const SizedBox(height: 12),
                AppTextField(hintText: "Select Payment Type"),
                const SizedBox(height: 12),
                AppTextField(hintText: "Remarks"),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    context.go("/order_checkout_screen");
                  },
                  child: Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                      child: Text(
                        "Export to Excel",
                        style: GoogleFonts.inter(color: AppColors.whiteColor, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
