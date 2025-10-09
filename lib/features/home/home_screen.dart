import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipmate_agent_app/core/routes/app_routes.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';
import 'package:shipmate_agent_app/features/qrscanner/qr_code_scanner.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock previous orders (replace with your API data)
    final List<Map<String, dynamic>> previousOrders = [
      {"orderId": "ORD12345", "date": "2025-09-25", "status": "Delivered", "amount": "₹ 1,250"},
      {"orderId": "ORD12346", "date": "2025-09-26", "status": "Pending", "amount": "₹ 850"},
      {"orderId": "ORD12347", "date": "2025-09-27", "status": "Cancelled", "amount": "₹ 450"},
      {"orderId": "ORD12348", "date": "2025-09-28", "status": "Delivered", "amount": "₹ 2,000"},
      {"orderId": "ORD12349", "date": "2025-09-29", "status": "Delivered", "amount": "₹ 1,100"},
      {"orderId": "ORD12350", "date": "2025-09-30", "status": "Pending", "amount": "₹ 720"},
      {"orderId": "ORD12351", "date": "2025-10-01", "status": "Delivered", "amount": "₹ 3,500"},
      {"orderId": "ORD12352", "date": "2025-10-02", "status": "Cancelled", "amount": "₹ 900"},
      {"orderId": "ORD12353", "date": "2025-10-03", "status": "Pending", "amount": "₹ 1,750"},
      {"orderId": "ORD12354", "date": "2025-10-04", "status": "Delivered", "amount": "₹ 2,800"},
    ];

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Shipmate-Agent",
            style: GoogleFonts.inter(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          backgroundColor: AppColors.primaryColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  Scan QR Code Container Button
              InkWell(
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
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryColor, AppColors.inActivePrimaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: AppColors.transparentColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.whiteColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.qr_code_scanner,
                                color: AppColors.primaryColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Scan QR Code",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),

              const SizedBox(height: 20),

              Text(
                "Previous Orders",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(height: 12),

              // List of Orders
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: previousOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = previousOrders[index];
                  Color statusColor;

                  switch (order["status"]) {
                    case "Delivered":
                      statusColor = AppColors.greenColor;
                      break;
                    case "Pending":
                      statusColor = AppColors.deepOrangeColor;
                      break;
                    case "Cancelled":
                      statusColor = AppColors.redColor;
                      break;
                    default:
                      statusColor = AppColors.greyColor;
                  }

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Order Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order ID: ${order['orderId']}",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.blackColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Date: ${order['date']}",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.lightGreyColor,
                              ),
                            ),
                          ],
                        ),

                        // Status + Amount
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              order['status'],
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: statusColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order['amount'],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
