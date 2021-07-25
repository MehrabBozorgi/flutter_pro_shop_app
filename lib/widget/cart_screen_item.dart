import 'package:flutter/material.dart';
import 'package:flutter_shop_app/provider/cart.dart';
import 'package:provider/provider.dart';

class CartScreenItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  CartScreenItem(
    this.id,
    this.productId,
    this.title,
    this.quantity,
    this.price,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (value) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure ?'),
            content: Text('Do yo want to remove item ?'),
            actions: [
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (value) {
        Provider.of<CartProvider>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete_forever,
          size: 30,
          color: Colors.white,
        ),
      ),
      child: Card(
        elevation: 15,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Image.network(
                imageUrl,
                height: 50,
                width: 50,
              ),
              ListTile(
                leading: CircleAvatar(
                  child: FittedBox(
                    child: Text('\$$price'),
                  ),
                ),
                title: Text(title),
                subtitle: Text(
                  'Total: \$${(price * quantity)}',
                ),
                trailing: Text('$quantity x'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
