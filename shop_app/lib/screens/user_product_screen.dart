
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final products = Provider.of<Products>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
        })
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting 
        ? 
        Center(child: CircularProgressIndicator(),)
        : 
        RefreshIndicator(
          onRefresh: ()=> refreshProducts(context),
          child: Consumer<Products>(
            builder: (ctx, products, _)=>Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: products.items.length,
                itemBuilder: (_, index) => Column(children: [
                  UserProduct(
                    products.items[index].id,
                    products.items[index].title,
                    products.items[index].imageUrl,
                  ),
                  Divider(),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
