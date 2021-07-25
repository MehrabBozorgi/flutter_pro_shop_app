import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductItem with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  ProductItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  void toggleFavoriteState() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

class ProductProvider with ChangeNotifier {
  List<ProductItem> _items = [];

  List<ProductItem> get items => _items;

  List<ProductItem> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  ProductItem findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSendProduct() async {
    final url =
        'https://pracrtice-udemy-default-rtdb.firebaseio.com/product.json';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<ProductItem> loadedProduct = [];
      extractedData.forEach(
        (prodId, prodData) {
          loadedProduct.add(
            ProductItem(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              isFavorite: prodData['isFavorite'],
            ),
          );
        },
      );
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(ProductItem product) async {
    const url =
        'https://pracrtice-udemy-default-rtdb.firebaseio.com/product.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      //
      //withOut server just use this bottom
      //
      final newProduct = ProductItem(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
