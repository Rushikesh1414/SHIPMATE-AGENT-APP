import 'dart:convert';

class ManifestDetails {
  final String manifestNumber;
  final String loadingType;
  final String vehicleNumber;
  final String fromStation;
  final String toStation;
  final String ownerBrokerName;
  final double rate;
  final double totalHireCost;
  final String paymentParty;
  final String paymentType;
  final String remarks;

  ManifestDetails({
    required this.manifestNumber,
    required this.loadingType,
    required this.vehicleNumber,
    required this.fromStation,
    required this.toStation,
    required this.ownerBrokerName,
    required this.rate,
    required this.totalHireCost,
    required this.paymentParty,
    required this.paymentType,
    required this.remarks,
  });

  factory ManifestDetails.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return ManifestDetails(
      manifestNumber: json['manifest_number']?.toString() ?? '',
      loadingType: json['loading_type']?.toString() ?? '',
      vehicleNumber: json['vehicle_number']?.toString() ?? '',
      fromStation: json['from_station']?.toString() ?? '',
      toStation: json['to_station']?.toString() ?? '',
      ownerBrokerName: json['owner_broker_name']?.toString() ?? '',
      rate: _toDouble(json['rate']),
      totalHireCost: _toDouble(json['total_hire_cost']),
      paymentParty: json['payment_party']?.toString() ?? '',
      paymentType: json['payment_type']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'manifest_number': manifestNumber,
        'loading_type': loadingType,
        'vehicle_number': vehicleNumber,
        'from_station': fromStation,
        'to_station': toStation,
        'owner_broker_name': ownerBrokerName,
        'rate': rate,
        'total_hire_cost': totalHireCost,
        'payment_party': paymentParty,
        'payment_type': paymentType,
        'remarks': remarks,
      };

  @override
  String toString() => json.encode(toJson());
}
