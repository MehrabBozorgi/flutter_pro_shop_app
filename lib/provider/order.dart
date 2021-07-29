import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/provider/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class OrderProvider with ChangeNotifier {
  List<OrderItem> _order = [];

  List<OrderItem> get order => _order;

  void addOrder(List<CartItem> cartProducts, double total) {
    _order.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
