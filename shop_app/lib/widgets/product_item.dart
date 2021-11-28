import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_details_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  void selectProduct(BuildContext context, id) {
    Navigator.of(context)
        .pushNamed(ProductDetailsScreen.routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    //clipRRect to make each item with rouded border
    final product = Provider.of<Product>(context,
        listen: false); // i only want to tell , not interested in any change
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return InkWell(
      onTap: () => selectProduct(context, product.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
            child: Image.network(product.imageUrl, fit: BoxFit.cover),
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              leading: Consumer<Product>(
                builder: (ctx, product, child) => IconButton(
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    product.toggleFavorite(authData.token, authData.userId);
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
              title: FittedBox(
                  child: Text(
                product.title,
                textAlign: TextAlign.center,
              )),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addProduct(product.id, product.title, product.price);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("added item to cart!"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ));
                },
                color: Theme.of(context).accentColor,
              ),
            )),
      ),
    );
  }
}
