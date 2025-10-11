import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';
import 'package:shipmate_agent_app/core/widgets/textfield_widget.dart';
import 'dart:convert';
import 'package:shipmate_agent_app/core/widgets/progress_tracker.dart';

import 'package:torch_light/torch_light.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'controllers/manifest_controller.dart';
import 'models/manifest_details.dart';

class ManifestScreen extends StatefulWidget {
  const ManifestScreen({super.key});

  @override
  State<ManifestScreen> createState() => _ManifestScreenState();
}

class _ManifestScreenState extends State<ManifestScreen> {
  final _controller = ManifestController.instance;
  RxBool isOn = false.obs;
  List<ManifestDetails> _manifests = [];

  final TextEditingController loadingTypeController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController manifestNumberController = TextEditingController();
  final TextEditingController fromStationController = TextEditingController();
  final TextEditingController toStationController = TextEditingController();
  final TextEditingController ownerBrokerController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController totalHireController = TextEditingController();
  final TextEditingController paymentPartyController = TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final ManifestDetails? selected = _controller.selectedManifest;
    if (selected != null) {
      loadingTypeController.text = selected.loadingType;
      vehicleNumberController.text = selected.vehicleNumber;
      manifestNumberController.text = selected.manifestNumber;
      fromStationController.text = selected.fromStation;
      toStationController.text = selected.toStation;
      ownerBrokerController.text = selected.ownerBrokerName;
      rateController.text = selected.rate.toString();
      totalHireController.text = selected.totalHireCost.toString();
      paymentPartyController.text = selected.paymentParty;
      paymentTypeController.text = selected.paymentType;
      remarksController.text = selected.remarks;
    }
    // load available manifests for possible fallback match by manifest number
    _loadManifests();
  }

  Future<void> _loadManifests() async {
    try {
      final list = await _controller.loadManifestsFromAssets();
      setState(() {
        _manifests = list;
      });
    } catch (e) {
      // ignore errors, keep empty list
      // ignore: avoid_print
      print('Failed to load manifests: $e');
    }
  }

  Future<void> _openScannerAndFill() async {
    String? res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(
          appBarTitle: 'Scan Manifest',
          isShowFlashIcon: true,
        ),
      ),
    );

    if (res == null || res.isEmpty) return;

    // Try parse JSON first
    ManifestDetails? parsed;
    try {
      final maybeJson = res.trim();
      if ((maybeJson.startsWith('{') && maybeJson.endsWith('}')) || (maybeJson.startsWith('[') && maybeJson.endsWith(']'))) {
        final Map<String, dynamic> decoded =
            (maybeJson.startsWith('[')) ? (json.decode(maybeJson) as List).first as Map<String, dynamic> : json.decode(maybeJson) as Map<String, dynamic>;

        final mapped = {
          'manifest_number': decoded['manifest'] ?? decoded['manifest_number'] ?? decoded['manifestNumber'] ?? decoded['mn'] ?? decoded['manifest_no'],
          'loading_type': decoded['loading_type'] ?? decoded['loadingType'] ?? decoded['loading'] ?? decoded['loading_type'],
          'vehicle_number': decoded['vehicle'] ?? decoded['vehicle_number'] ?? decoded['vehicleNumber'],
          'from_station': decoded['from'] ?? decoded['from_station'] ?? decoded['fromStation'],
          'to_station': decoded['to'] ?? decoded['to_station'] ?? decoded['toStation'],
          'owner_broker_name': decoded['owner'] ?? decoded['owner_broker_name'] ?? decoded['ownerBrokerName'],
          'rate': decoded['rate'] ?? decoded['r'],
          'total_hire_cost': decoded['total_hire_cost'] ?? decoded['total'] ?? decoded['totalHireCost'],
          'payment_party': decoded['payment_party'] ?? decoded['paymentParty'] ?? decoded['payment_party'],
          'payment_type': decoded['payment_type'] ?? decoded['paymentType'] ?? decoded['payment_type'],
          'remarks': decoded['remarks'] ?? decoded['remark'] ?? decoded['notes'],
        };

        parsed = ManifestDetails.fromJson(mapped);
      }
    } catch (e) {
      parsed = null;
    }

    if (parsed != null && parsed.manifestNumber.isNotEmpty) {
      _controller.setSelectedManifest(parsed);
      _fillFromManifest(parsed);
      return;
    }

    // Fallback: try to match manifest number in loaded list
    try {
      final match = _manifests.firstWhere((m) => m.manifestNumber.toLowerCase() == res.toLowerCase());
      _controller.setSelectedManifest(match);
      _fillFromManifest(match);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No manifest found for: $res')));
    }
  }

  void _fillFromManifest(ManifestDetails selected) {
    setState(() {
      loadingTypeController.text = selected.loadingType;
      vehicleNumberController.text = selected.vehicleNumber;
      manifestNumberController.text = selected.manifestNumber;
      fromStationController.text = selected.fromStation;
      toStationController.text = selected.toStation;
      ownerBrokerController.text = selected.ownerBrokerName;
      rateController.text = selected.rate.toString();
      totalHireController.text = selected.totalHireCost.toString();
      paymentPartyController.text = selected.paymentParty;
      paymentTypeController.text = selected.paymentType;
      remarksController.text = selected.remarks;
    });
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

  @override
  void dispose() {
    loadingTypeController.dispose();
    vehicleNumberController.dispose();
    manifestNumberController.dispose();
    fromStationController.dispose();
    toStationController.dispose();
    ownerBrokerController.dispose();
    rateController.dispose();
    totalHireController.dispose();
    paymentPartyController.dispose();
    paymentTypeController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Manifest Details",
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.whiteColor),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress tracker: step 2 of 3
              ProgressTracker(totalSteps: 3, currentStep: 1, labels: ['Scan', 'Update', 'Dispatch']),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: () {
                  // Open scanner and fill form from result
                  _openScannerAndFill();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isOn.value
                            ? Icon(
                                Icons.flash_on,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.flash_off,
                                color: Colors.white,
                              ),
                        Text(
                          "Toggle Flashlight",
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppTextField(controller: loadingTypeController, hintText: "Select Loading Type"),
              const SizedBox(height: 12),
              AppTextField(controller: vehicleNumberController, hintText: "Vehicle Number"),
              const SizedBox(height: 12),
              AppTextField(controller: manifestNumberController, hintText: "Manifest Number"),
              const SizedBox(height: 12),
              AppTextField(controller: fromStationController, hintText: "From Station"),
              const SizedBox(height: 12),
              AppTextField(controller: toStationController, hintText: "To Station"),
              const SizedBox(height: 12),
              AppTextField(controller: ownerBrokerController, hintText: "Owner/Broker Name"),
              const SizedBox(height: 12),
              AppTextField(controller: rateController, hintText: "Rate"),
              const SizedBox(height: 12),
              AppTextField(controller: totalHireController, hintText: "Total Hire Cost"),
              const SizedBox(height: 12),
              AppTextField(controller: paymentPartyController, hintText: "Select Payment Party"),
              const SizedBox(height: 12),
              AppTextField(controller: paymentTypeController, hintText: "Select Payment Type"),
              const SizedBox(height: 12),
              AppTextField(controller: remarksController, hintText: "Remarks"),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  context.go("/order_checkout_screen");
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  child: Text(
                    "Export to Excel",
                    style: GoogleFonts.inter(color: AppColors.whiteColor, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
