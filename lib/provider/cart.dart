import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem>? _items = {};

  Map<String, CartItem> get items => _items!;

  int get itemCount {
    return _items!.length;
  }

  void addItem(String productId, double price, String title, String imageUrl) {
    if (_items!.containsKey(productId)) {
      _items!.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items!.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items!.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items!.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  //for snack bar
  void removeSingleChild(String productId) {
    if (_items!.containsKey(productId)) {
      return;
    }
    if (_items![productId]!.quantity > 1) {
      _items!.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items!.remove(productId);
    }
    notifyListeners();
  }
}
