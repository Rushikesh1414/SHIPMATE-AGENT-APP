import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';
import 'controllers/entries_controller.dart';
import 'models/entry_item.dart';
import 'package:flutter/widgets.dart';
import 'package:shipmate_agent_app/core/widgets/progress_tracker.dart';

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({super.key});

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  final _controller = EntriesController.instance;

  @override
  Widget build(BuildContext context) {
    final entries = _controller.entries;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Entries',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.whiteColor),
          ),
          backgroundColor: AppColors.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Progress tracker: step 1 of 3
              ProgressTracker(totalSteps: 3, currentStep: 1, labels: ['Scan & Verify', 'Record Details', 'Generate Manifest']),

              if (entries.isEmpty) ...[
                Expanded(child: Center(child: Text('No entries yet', style: GoogleFonts.inter()))),
              ] else ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Entries (${entries.length})',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
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
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'SI No: ${entry.siNo}',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () => _showEditDialog(index, entry),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            _controller.deleteEntry(index);
                                            // Re-assign SI numbers
                                            for (int i = 0; i < _controller.entries.length; i++) {
                                              _controller.entries[i] = _controller.entries[i].copyWith(siNo: (i + 1).toString());
                                            }
                                          });
                                        },
                                        color: Colors.red,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              _buildInfoRow('CN No', entry.cnNo),
                              _buildInfoRow('Consignor', entry.consignor),
                              _buildInfoRow('Consignee', entry.consignee),
                              _buildInfoRow('QTY', entry.quantity),
                              _buildInfoRow('Weight', entry.weight),
                              _buildInfoRow('Origin', entry.origin),
                              _buildInfoRow('Destination', entry.destination),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
              GestureDetector(
                onTap: () {
                  _showAddDialog();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.blackColor)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 20,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text('Add Entry', style: GoogleFonts.inter(fontSize: 14, color: AppColors.greyColor, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  context.go("/manifest_screen");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.primaryColor),
                  child: Center(
                    child: Text(
                      "Next",
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.whiteColor),
                    ),
                  ),
                ),
              ),
            ],
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
              '$label:',
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

  void _showAddDialog() {
    final siNo = (_controller.entries.length + 1).toString();
    final cnNoCtl = TextEditingController();
    final consignorCtl = TextEditingController();
    final consigneeCtl = TextEditingController();
    final qtyCtl = TextEditingController();
    final weightCtl = TextEditingController();
    final originCtl = TextEditingController();
    final destCtl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Entry'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: cnNoCtl, decoration: const InputDecoration(labelText: 'CN No')),
              TextField(controller: consignorCtl, decoration: const InputDecoration(labelText: 'Consignor')),
              TextField(controller: consigneeCtl, decoration: const InputDecoration(labelText: 'Consignee')),
              TextField(controller: qtyCtl, decoration: const InputDecoration(labelText: 'Quantity')),
              TextField(controller: weightCtl, decoration: const InputDecoration(labelText: 'Weight')),
              TextField(controller: originCtl, decoration: const InputDecoration(labelText: 'Origin')),
              TextField(controller: destCtl, decoration: const InputDecoration(labelText: 'Destination')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final item = EntryItem(
                siNo: siNo,
                cnNo: cnNoCtl.text,
                consignor: consignorCtl.text,
                consignee: consigneeCtl.text,
                quantity: qtyCtl.text,
                weight: weightCtl.text,
                origin: originCtl.text,
                destination: destCtl.text,
              );
              setState(() {
                _controller.addEntry(item);
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int index, EntryItem item) {
    final cnNoCtl = TextEditingController(text: item.cnNo);
    final consignorCtl = TextEditingController(text: item.consignor);
    final consigneeCtl = TextEditingController(text: item.consignee);
    final qtyCtl = TextEditingController(text: item.quantity);
    final weightCtl = TextEditingController(text: item.weight);
    final originCtl = TextEditingController(text: item.origin);
    final destCtl = TextEditingController(text: item.destination);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Entry'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: cnNoCtl, decoration: const InputDecoration(labelText: 'CN No')),
              TextField(controller: consignorCtl, decoration: const InputDecoration(labelText: 'Consignor')),
              TextField(controller: consigneeCtl, decoration: const InputDecoration(labelText: 'Consignee')),
              TextField(controller: qtyCtl, decoration: const InputDecoration(labelText: 'Quantity')),
              TextField(controller: weightCtl, decoration: const InputDecoration(labelText: 'Weight')),
              TextField(controller: originCtl, decoration: const InputDecoration(labelText: 'Origin')),
              TextField(controller: destCtl, decoration: const InputDecoration(labelText: 'Destination')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final updated = EntryItem(
                siNo: item.siNo,
                cnNo: cnNoCtl.text,
                consignor: consignorCtl.text,
                consignee: consigneeCtl.text,
                quantity: qtyCtl.text,
                weight: weightCtl.text,
                origin: originCtl.text,
                destination: destCtl.text,
              );
              setState(() {
                _controller.updateEntry(index, updated);
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
