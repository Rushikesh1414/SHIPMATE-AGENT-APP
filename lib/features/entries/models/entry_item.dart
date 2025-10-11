class EntryItem {
  String siNo;
  String cnNo;
  String consignor;
  String consignee;
  String quantity;
  String weight;
  String origin;
  String destination;

  EntryItem({
    required this.siNo,
    required this.cnNo,
    required this.consignor,
    required this.consignee,
    required this.quantity,
    required this.weight,
    required this.origin,
    required this.destination,
  });

  Map<String, String> toMap() => {
        'siNo': siNo,
        'cnNo': cnNo,
        'consignor': consignor,
        'consignee': consignee,
        'quantity': quantity,
        'weight': weight,
        'origin': origin,
        'destination': destination,
      };

  factory EntryItem.fromMap(Map<String, String> m) => EntryItem(
        siNo: m['siNo'] ?? '',
        cnNo: m['cnNo'] ?? '',
        consignor: m['consignor'] ?? '',
        consignee: m['consignee'] ?? '',
        quantity: m['quantity'] ?? '',
        weight: m['weight'] ?? '',
        origin: m['origin'] ?? '',
        destination: m['destination'] ?? '',
      );

  EntryItem copyWith({
    String? siNo,
    String? cnNo,
    String? consignor,
    String? consignee,
    String? quantity,
    String? weight,
    String? origin,
    String? destination,
  }) {
    return EntryItem(
      siNo: siNo ?? this.siNo,
      cnNo: cnNo ?? this.cnNo,
      consignor: consignor ?? this.consignor,
      consignee: consignee ?? this.consignee,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
    );
  }

  @override
  String toString() => 'EntryItem(siNo: $siNo, cnNo: $cnNo)';
}
