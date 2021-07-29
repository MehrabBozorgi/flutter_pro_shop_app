import 'package:flutter/material.dart';
import 'package:flutter_shop_app/provider/cart.dart';
import 'package:flutter_shop_app/provider/product.dart';
import 'package:flutter_shop_app/widget/Badge.dart';
import 'package:flutter_shop_app/widget/app_drawer.dart';
import 'package:flutter_shop_app/widget/product_grid.dart';
import 'package:provider/provider.dart';

enum FilterOption {
  Favorite,
  All,
}

class ProductOverViewScreen extends StatefulWidget {
  static const routName = 'product_overView_screen';

  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showOnlyFavorite = false;
  var _isInit = true;

  Future<void> _refreshProduct(BuildContext context) async {
     Provider.of<ProductProvider>(context, listen: false).favoriteItems;
  }

  @override
  void initState() {
    if (_isInit) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchAndSendProduct();
    }
    _isInit = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('my shop'),
        actions: [
          //
          //show liked screen (i dont like this way)
          PopupMenuButton(
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favorite) {
                  _showOnlyFavorite = true;
                } else {
                  _showOnlyFavorite = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Favorite'),
                value: FilterOption.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOption.All,
              ),
            ],
          ),
          Consumer<CartProvider>(
            builder: (context, cart, ch) => Badge(
              value: cart.itemCount.toString(),
              child: ch!,
              color: Colors.red,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed('cart_screen');
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProduct(context),
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: ProductGrid(_showOnlyFavorite),
        ),
      ),
    );
  }
}
