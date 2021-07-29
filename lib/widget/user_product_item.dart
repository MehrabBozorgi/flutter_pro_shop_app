import 'package:flutter/material.dart';
import 'package:flutter_shop_app/provider/product.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () {
            Provider.of<ProductProvider>(context, listen: false)
                .deleteProduct(id);
          },
        ),
        // child: Row(
        //   children: [
        //     IconButton(
        //       icon: Icon(Icons.edit),
        //       color: Theme.of(context).primaryColor,
        //       onPressed: () {
        //         Navigator.of(context)
        //             .pushNamed(EditProductScreen.routName, );
        //       },
        //     ),
        //     IconButton(
        //       icon: Icon(Icons.delete),
        //       color: Theme.of(context).errorColor,
        //       onPressed: () {
        //         Provider.of<ProductProvider>(context, listen: false)
        //             .deleteProduct(id);
        //       },
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
