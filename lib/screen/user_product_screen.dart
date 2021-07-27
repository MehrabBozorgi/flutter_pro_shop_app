import 'package:flutter/material.dart';
import 'package:flutter_shop_app/provider/product.dart';
import 'package:flutter_shop_app/widget/app_drawer.dart';
import 'package:flutter_shop_app/widget/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routName = 'user_product_screen';

  Future<void> _refreshProduct(BuildContext context) async {
     Provider.of<ProductProvider>(context, listen: false).favoriteItems;
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your product'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('edit_product_screen');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProduct(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: (context, index) => Column(
              children: [
                UserProductItem(
                  id: productData.items[index].id,
                  title: productData.items[index].title,
                  imageUrl: productData.items[index].imageUrl,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
