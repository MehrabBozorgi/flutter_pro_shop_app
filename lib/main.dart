import 'package:flutter/material.dart';
import 'package:flutter_shop_app/provider/auth.dart';
import 'package:flutter_shop_app/provider/cart.dart';
import 'package:flutter_shop_app/provider/order.dart';
import 'package:flutter_shop_app/provider/product.dart';
import 'package:flutter_shop_app/screen/SplashScreen.dart';
import 'package:flutter_shop_app/screen/auth_screen.dart';
import 'package:flutter_shop_app/screen/cart_screen.dart';
import 'package:flutter_shop_app/screen/product_detail_screen.dart';
import 'package:flutter_shop_app/screen/product_overview_screen.dart';
import 'package:provider/provider.dart';

import 'screen/edit_product_screen.dart';
import 'screen/order_screen.dart';
import 'screen/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        // ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
        //   create: (context) => ProductProvider(auth.token,items),
        //   update: (context, auth, previousProduct) => ProductProvider(
        //     auth.token!,
        //     previousProduct == null ? [] : previousProduct.items,
        //   ),
        // ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: auth.isAuth
              ? ProductOverViewScreen()
              : FutureBuilder(
                  future: auth.tryLogin(),
                  builder: (context, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            'product_overView_screen': (context) => ProductOverViewScreen(),
            'product_detail_screen': (context) => ProductDetailScreen(),
            'cart_screen': (context) => CartScreen(),
            'order_screen': (context) => OrderScreen(),
            'user_product_screen': (context) => UserProductScreen(),
            'edit_product_screen': (context) => EditProductScreen(),
            'auth_screen': (context) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
