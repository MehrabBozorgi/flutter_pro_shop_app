import 'package:flutter/material.dart';
import 'package:flutter_shop_app/provider/order.dart';
import 'package:flutter_shop_app/widget/app_drawer.dart';
import 'package:flutter_shop_app/widget/order_item_screen.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routName = 'order_screen';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: ListView.builder(
        itemCount: orderData.order.length,
        itemBuilder: (context, index) => OrderItemScreen(
          order: orderData.order[index],
        ),
      ),
    );
  }
}
