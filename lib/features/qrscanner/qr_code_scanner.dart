import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipmate_agent_app/core/routes/app_routes.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:sizer/sizer.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  String? scannedValue;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.go('/home_screen');
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
            appBar: AppBar(
                leading: GestureDetector(
                  onTap: () {
                    context.go('/home_screen');
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.whiteColor,
                  ),
                ),
                centerTitle: true,
                backgroundColor: AppColors.primaryColor,
                title: Text(
                  "Scan QR Code",
                  style: GoogleFonts.inter(fontSize: 16, color: AppColors.whiteColor, fontWeight: FontWeight.w500),
                )),
            body: GestureDetector(
              onTap: () async {
                String? res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      // ignore: deprecated_member_use
                      builder: (context) => const SimpleBarcodeScannerPage(
                        // ignore: deprecated_member_use
                        appBarTitle: 'Scan Barcode',
                        isShowFlashIcon: true,
                      ),
                    ));
                if (res!.isNotEmpty) {
                  router.go('/manifest_screen');
                }
              },
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.blackColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Scan",
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.blackColor),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Icon(Icons.qr_code),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
