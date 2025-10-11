import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';
import 'package:shipmate_agent_app/core/widgets/textfield_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:torch_light/torch_light.dart';
import 'package:shipmate_agent_app/features/home/controllers/home_controller.dart';
import 'package:shipmate_agent_app/features/home/models/order_details.dart';
import 'package:shipmate_agent_app/features/entries/controllers/entries_controller.dart';
import 'package:shipmate_agent_app/features/entries/models/entry_item.dart';
import 'package:shipmate_agent_app/core/widgets/progress_tracker.dart';

class OrderCheckoutScreen extends StatefulWidget {
  const OrderCheckoutScreen({super.key});

  @override
  State<OrderCheckoutScreen> createState() => _OrderCheckoutScreenState();
}

class _OrderCheckoutScreenState extends State<OrderCheckoutScreen> {
  RxBool isOn = false.obs;

  // Controllers for input fields
  final TextEditingController cnNumberController = TextEditingController();
  final TextEditingController consignorController = TextEditingController();
  final TextEditingController consigneeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // If an order was selected (for example via scanner), populate fields so user can edit or add
    final OrderDetails? selected = HomeController.instance.selectedOrder;
    if (selected != null) {
      cnNumberController.text = selected.cnNumber;
      consignorController.text = selected.consignerName;
      consigneeController.text = selected.consigneeName;
      quantityController.text = selected.quantity.toString();
      weightController.text = selected.weight.toString();
      originController.text = selected.originPoint;
      destinationController.text = selected.destinationPoint;
    }
  }

  // List to store entries
  List<Map<String, String>> entries = [];

  @override
  void dispose() {
    cnNumberController.dispose();
    consignorController.dispose();
    consigneeController.dispose();
    quantityController.dispose();
    weightController.dispose();
    originController.dispose();
    destinationController.dispose();
    super.dispose();
  }

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

  void addEntry() {
    if (cnNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in CN Number')),
      );
      return;
    }
    final controller = EntriesController.instance;
    final item = EntryItem(
      siNo: (controller.entries.length + 1).toString(),
      cnNo: cnNumberController.text,
      consignor: consignorController.text,
      consignee: consigneeController.text,
      quantity: quantityController.text,
      weight: weightController.text,
      origin: originController.text,
      destination: destinationController.text,
    );

    setState(() {
      controller.addEntry(item);

      // Clear all fields
      cnNumberController.clear();
      consignorController.clear();
      consigneeController.clear();
      quantityController.clear();
      weightController.clear();
      originController.clear();
      destinationController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entry added successfully')),
    );

    // Navigate to entries screen to show table
    context.go('/entries_screen');
  }

  void deleteEntry(int index) {
    setState(() {
      entries.removeAt(index);
      // Update SI numbers
      for (int i = 0; i < entries.length; i++) {
        entries[i]['siNo'] = (i + 1).toString();
      }
    });
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
            padding: EdgeInsets.all(2.h),
            child: Column(
              children: [
                Text(
                  "Get your order details here",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: 2.h),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primaryColor,
                    ),
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
                // Progress tracker: step 0 of 3
                ProgressTracker(totalSteps: 3, currentStep: 1, labels: ['Scan', 'Update', 'Dispatch']),

                const SizedBox(height: 20),

                /// Input fields
                AppTextField(
                  controller: cnNumberController,
                  hintText: "CN Number",
                ),
                const SizedBox(height: 12),

                AppTextField(
                  controller: consignorController,
                  hintText: "Consignor Name",
                ),
                const SizedBox(height: 12),

                AppTextField(
                  controller: consigneeController,
                  hintText: "Consignee Name",
                ),
                const SizedBox(height: 12),

                AppTextField(
                  controller: quantityController,
                  hintText: "Quantity",
                ),
                const SizedBox(height: 12),

                AppTextField(
                  controller: weightController,
                  hintText: "Weight",
                ),
                const SizedBox(height: 12),

                AppTextField(
                  controller: originController,
                  hintText: "Origin Point",
                ),
                const SizedBox(height: 12),

                AppTextField(
                  controller: destinationController,
                  hintText: "Destination Point",
                ),
                const SizedBox(height: 20),

                /// Add Entry button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: addEntry,
                    child: Text(
                      "Add Entry",
                      style: GoogleFonts.inter(color: AppColors.whiteColor),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Display entries as cards
                if (entries.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Entries (${entries.length})",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "SI No: ${entry['siNo']}",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 20),
                                    onPressed: () => deleteEntry(index),
                                    color: Colors.red,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              _buildInfoRow("CN No", entry['cnNo'] ?? '-'),
                              _buildInfoRow("Consignor", entry['consignor'] ?? '-'),
                              _buildInfoRow("Consignee", entry['consignee'] ?? '-'),
                              _buildInfoRow("QTY", entry['quantity'] ?? '-'),
                              _buildInfoRow("Weight", entry['weight'] ?? '-'),
                              _buildInfoRow("Origin", entry['origin'] ?? '-'),
                              _buildInfoRow("Destination", entry['destination'] ?? '-'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "$label:",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: GoogleFonts.inter(
                color: AppColors.blackColor,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
