import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum selectdOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/productsOverview';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  @override
  var _hasFavorite = false;
  var _isInit = true;
  var _isLoading = false;

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts(false).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    //final prods = Provider.of<Products>(context, listen: false); // i want just to listen

    return Scaffold(
        appBar: AppBar(
          title: Text("My Shop"),
          actions: [
            PopupMenuButton(
              onSelected: (selectdOptions selectedVal) {
                setState(() {
                  if (selectedVal == selectdOptions.Favorites) {
                    _hasFavorite = true;
                  } else {
                    _hasFavorite = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                    child: Text("Only Favorites"),
                    value: selectdOptions.Favorites),
                PopupMenuItem(
                    child: Text("Show All"), value: selectdOptions.All),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cartData, ch) => Badge(
                child: ch,
                value: cartData.itemCounts.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ProductGrid(_hasFavorite));
  }
}
