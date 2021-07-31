import 'package:flutter/material.dart';
import 'package:flutter_shop_app/provider/cart.dart';
import 'package:flutter_shop_app/provider/product.dart';
import 'package:provider/provider.dart';

class ProductItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductItem>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Column(
      children: [
        Image.network(
          product.imageUrl,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed('product_detail_screen', arguments: product.id);
          },
          child: Container(
            width: double.infinity,
            color: Colors.black26,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<ProductItem>(
                  builder: (context, product, child) => IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    onPressed: () {
                      product.toggleFavoriteState();
                    },
                  ),
                ),
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                  ),
                  onPressed: () {
                    cart.addItem(
                      product.id,
                      product.price,
                      product.title,
                      product.imageUrl,
                    );
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Add item to cart'),
                        duration: const Duration(seconds: 2),
                        elevation: 15,
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeItem(product.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
