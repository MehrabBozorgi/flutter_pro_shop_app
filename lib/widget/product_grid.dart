import 'package:flutter/material.dart';
import 'package:flutter_shop_app/provider/product.dart';
import 'package:flutter_shop_app/widget/product_item_screen.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorite;

  const ProductGrid(this.showFavorite);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context, listen: false);
    final products =
        showFavorite ? productData.favoriteItems : productData.items;

    return GridView.builder(
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItemScreen(),
      ),
    );
  }
}
