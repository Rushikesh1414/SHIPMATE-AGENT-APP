import 'dart:convert';

class OrderDetails {
  final String cnNumber;
  final String consignerName;
  final String consigneeName;
  final int quantity;
  final double weight;
  final String originPoint;
  final String destinationPoint;

  OrderDetails({
    required this.cnNumber,
    required this.consignerName,
    required this.consigneeName,
    required this.quantity,
    required this.weight,
    required this.originPoint,
    required this.destinationPoint,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      cnNumber: json['cn_number']?.toString() ?? '',
      consignerName: json['consigner_name']?.toString() ?? '',
      consigneeName: json['consignee_name']?.toString() ?? '',
      quantity: (json['quantity'] is int) ? json['quantity'] as int : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      weight: (json['weight'] is num) ? (json['weight'] as num).toDouble() : double.tryParse(json['weight']?.toString() ?? '0') ?? 0.0,
      originPoint: json['origin_point']?.toString() ?? '',
      destinationPoint: json['destination_point']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'cn_number': cnNumber,
        'consigner_name': consignerName,
        'consignee_name': consigneeName,
        'quantity': quantity,
        'weight': weight,
        'origin_point': originPoint,
        'destination_point': destinationPoint,
      };

  @override
  String toString() => json.encode(toJson());
}
