import 'dart:convert';

import 'package:flutter/services.dart';
import '../models/order_details.dart';

class HomeController {
  HomeController._internal();

  static final HomeController instance = HomeController._internal();

  /// Currently selected order (set after scanning or selection)
  OrderDetails? selectedOrder;

  Future<List<OrderDetails>> loadOrderDetailsFromAssets({String path = 'assets/data/dummy_cn_data.json'}) async {
    final raw = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(raw) as List<dynamic>;
    return jsonList.map((e) => OrderDetails.fromJson(e as Map<String, dynamic>)).toList();
  }

  void setSelectedOrder(OrderDetails order) => selectedOrder = order;
}
