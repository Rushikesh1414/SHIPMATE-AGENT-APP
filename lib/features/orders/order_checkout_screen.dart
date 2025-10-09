import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';
import 'package:shipmate_agent_app/core/widgets/textfield_widget.dart';
import 'package:shipmate_agent_app/features/orders/qr_code_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:torch_light/torch_light.dart';

class OrderCheckoutScreen extends StatefulWidget {
  const OrderCheckoutScreen({super.key});

  @override
  State<OrderCheckoutScreen> createState() => _OrderCheckoutScreenState();
}

class _OrderCheckoutScreenState extends State<OrderCheckoutScreen> {
  RxBool isOn = false.obs;
  bool _showAdditionalFields = false;

  Future<void> toggleFlashlight() async {
    try {
      bool available = await TorchLight.isTorchAvailable();
      if (available) {
        if (isOn.value) {
          await TorchLight.disableTorch();
          isOn.value = false;
        } else {
          await TorchLight.enableTorch();
          isOn.value = true;
        }
      }
    } on Exception catch (e) {
      debugPrint("Could not toggle flashlight: $e");
    }
  }

  Future showQrCodeBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(2.h), // responsive padding
            child: Column(
              children: [
                // title text
                Text(
                  "Get your order details here",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: 2.h),

                // QR code inside a card-like container
                SizedBox(
                  height: 35.h,
                  child: PrettyQrView.data(
                    data: 'lorem ipsum dolor sit amet',
                    decoration: const PrettyQrDecoration(
                      image: PrettyQrDecorationImage(
                        image: AssetImage('assets/logo.png'),
                      ),
                      quietZone: PrettyQrQuietZone.standart,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.primaryColor),
                    child: Text(
                      "Close",
                      style: GoogleFonts.inter(color: AppColors.whiteColor),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.go("/home_screen");
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            title: Text(
              "Barcode Scanning & Data Entry",
              style: GoogleFonts.inter(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// Toggle Flashlight button
                ///
                GestureDetector(
                  onTap: () {
                    toggleFlashlight();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => Icon(
                              isOn.value ? Icons.flash_on : Icons.flash_off,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Toggle Flashlight",
                            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Input fields
                AppTextField(hintText: "CN Number"),
                const SizedBox(height: 12),

                AppTextField(hintText: "Consignor Name"),
                const SizedBox(height: 12),

                AppTextField(hintText: "Consignee Name"),
                const SizedBox(height: 12),

                AppTextField(hintText: "Quantity"),
                const SizedBox(height: 12),

                AppTextField(hintText: "Weight"),
                const SizedBox(height: 12),

                AppTextField(hintText: "Origin Point"),
                const SizedBox(height: 12),

                AppTextField(hintText: "Destination Point"),
                const SizedBox(height: 20),

                /// Add Entry button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      setState(() {
                        _showAdditionalFields = true;
                      });
                    },
                    child: Text(
                      "Add Entry",
                      style: GoogleFonts.inter(color: AppColors.whiteColor),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Additional fields that are revealed after tapping Add Entry
                if (_showAdditionalFields) ...[
                  AppTextField(hintText: "SI No"),
                  const SizedBox(height: 12),

                  AppTextField(hintText: "CN No"),
                  const SizedBox(height: 12),

                  /// Input fields
                  AppTextField(hintText: "Consignor"),
                  const SizedBox(height: 12),

                  AppTextField(hintText: "Consignee"),
                  const SizedBox(height: 12),

                  /// Input fields
                  AppTextField(hintText: "Weight"),
                  const SizedBox(height: 12),

                  AppTextField(hintText: "Origin"),
                  const SizedBox(height: 12),

                  /// Input fields
                  AppTextField(hintText: "Destination"),
                  const SizedBox(height: 12),
                ],

                const SizedBox(height: 20),

                /// Next Page button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    onPressed: () {
                      showQrCodeBottomSheet(context);
                    },
                    child: Text(
                      "Next Page",
                      style: GoogleFonts.inter(color: Colors.white),
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
