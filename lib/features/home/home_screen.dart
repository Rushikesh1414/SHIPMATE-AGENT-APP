import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:shipmate_agent_app/core/routes/app_routes.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';
import 'package:shipmate_agent_app/features/qrscanner/qr_code_scanner.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'controllers/home_controller.dart';
import 'models/order_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = HomeController.instance;
  List<OrderDetails> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final list = await _controller.loadOrderDetailsFromAssets();
      setState(() {
        _orders = list;
        _isLoading = false;
      });
    } catch (e) {
      // If loading fails, keep _orders empty and log error
      setState(() => _isLoading = false);
      // ignore: avoid_print
      print('Failed to load orders: $e');
    }
  }

  double _normalizeWeight(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    final s = value.toString().trim();
    // strip non-digit and non-dot characters
    final cleaned = s.replaceAll(RegExp(r'[^0-9\.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
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
                    // ignore: avoid_print
                    print("response in qr $res");
                    if (res != null && res.isNotEmpty) {
                      // If scanner returned JSON, parse it and fill model directly
                      OrderDetails? parsed;
                      try {
                        final maybeJson = res.trim();
                        if ((maybeJson.startsWith('{') && maybeJson.endsWith('}')) || (maybeJson.startsWith('[') && maybeJson.endsWith(']'))) {
                          final Map<String, dynamic> decoded = (maybeJson.startsWith('['))
                              ? (json.decode(maybeJson) as List).first as Map<String, dynamic>
                              : json.decode(maybeJson) as Map<String, dynamic>;

                          // map possible keys to OrderDetails fields
                          parsed = OrderDetails.fromJson({
                            'cn_number': decoded['cn'] ?? decoded['cn_number'] ?? decoded['cnNumber'] ?? decoded['cnNumber'],
                            'consigner_name': decoded['consigner'] ?? decoded['consigner_name'] ?? decoded['consignerName'],
                            'consignee_name': decoded['consignee'] ?? decoded['consignee_name'] ?? decoded['consigneeName'],
                            'quantity': decoded['qty'] ?? decoded['quantity'],
                            'weight': _normalizeWeight(decoded['weight'] ?? decoded['wt'] ?? decoded['w']),
                            'origin_point': decoded['origin'] ?? decoded['origin_point'] ?? decoded['originPoint'],
                            'destination_point': decoded['destination'] ?? decoded['destination_point'] ?? decoded['destinationPoint'],
                          });
                        }
                      } catch (e) {
                        // Not JSON or parsing failed; we'll fallback to CN lookup
                        parsed = null;
                      }

                      if (parsed != null && parsed.cnNumber.isNotEmpty) {
                        _controller.setSelectedOrder(parsed);
                        router.go('/order_checkout_screen');
                        return;
                      }

                      // Fallback: try to find a matching CN in loaded orders
                      OrderDetails? match;
                      try {
                        match = _orders.firstWhere((e) => e.cnNumber.toLowerCase() == res.toLowerCase());
                      } catch (_) {
                        match = null;
                      }

                      if (match != null) {
                        _controller.setSelectedOrder(match);
                        router.go('/order_checkout_screen');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No CN found for: $res')),
                        );
                      }
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

              // Temporary mock recent orders showcase
              Builder(builder: (context) {
                final List<Map<String, String>> mockPreviousOrders = [
                  {"orderId": "ORD12345", "date": "2025-09-25", "time": "10:45 AM", "status": "Delivered", "amount": "₹ 1,250", "address": "Pune, Maharashtra"},
                  {"orderId": "ORD12346", "date": "2025-09-26", "time": "03:20 PM", "status": "Pending", "amount": "₹ 850", "address": "Mumbai, Maharashtra"},
                  {"orderId": "ORD12347", "date": "2025-09-27", "time": "09:10 AM", "status": "Cancelled", "amount": "₹ 450", "address": "Nagpur, Maharashtra"},
                  {"orderId": "ORD12348", "date": "2025-09-28", "time": "06:55 PM", "status": "Delivered", "amount": "₹ 1,750", "address": "Delhi, NCR"},
                  {"orderId": "ORD12349", "date": "2025-09-29", "time": "02:15 PM", "status": "Pending", "amount": "₹ 999", "address": "Bangalore, Karnataka"},
                ];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recent Orders",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: mockPreviousOrders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final order = mockPreviousOrders[index];
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
                          padding: const EdgeInsets.all(14),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order ID: ${order['orderId']}",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  Text(
                                    order['amount']!,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Date: ${order['date']} • ${order['time']}",
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.lightGreyColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Address: ${order['address']}",
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.lightGreyColor),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      order['status']!,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Viewing ${order['orderId']}")),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: Text(
                                      "View Details",
                                      style: GoogleFonts.inter(color: Colors.white, fontSize: 12),
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
                );
              })

              // Text(
              //   "Previous Orders",
              //   style: GoogleFonts.inter(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w600,
              //     color: AppColors.blackColor,
              //   ),
              // ),
              // const SizedBox(height: 12),

              // if (_isLoading) ...[
              //   const Center(child: CircularProgressIndicator()),
              // ] else if (_orders.isEmpty) ...[
              //   const Text('No CN entries found.'),
              // ] else ...[
              //   ListView.separated(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemCount: _orders.length,
              //     separatorBuilder: (_, __) => const SizedBox(height: 12),
              //     itemBuilder: (context, index) {
              //       final o = _orders[index];
              //       return Container(
              //         padding: const EdgeInsets.all(12),
              //         decoration: BoxDecoration(
              //           color: AppColors.whiteColor,
              //           borderRadius: BorderRadius.circular(12),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.black12,
              //               blurRadius: 6,
              //               spreadRadius: 1,
              //               offset: const Offset(0, 2),
              //             )
              //           ],
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               'CN: ${o.cnNumber}',
              //               style: GoogleFonts.inter(
              //                 fontWeight: FontWeight.w600,
              //                 fontSize: 14,
              //                 color: AppColors.blackColor,
              //               ),
              //             ),
              //             const SizedBox(height: 6),
              //             Text('Consigner: ${o.consignerName}'),
              //             Text('Consignee: ${o.consigneeName}'),
              //             Text('Qty: ${o.quantity}  •  Weight: ${o.weight} kg'),
              //             const SizedBox(height: 6),
              //             Text('${o.originPoint} → ${o.destinationPoint}'),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              //  ],
            ],
          ),
        ),
      ),
    );
  }
}
