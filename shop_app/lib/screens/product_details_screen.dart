import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = "/product_details";

  @override
  Widget build(BuildContext context) {

    final id = ModalRoute.of(context).settings.arguments as String;
    Product product = Provider.of<Products>(context, listen: false).findById(id);

    return Scaffold(
      appBar: AppBar(title: Text(id),),
      body: Container(
        height: 300,
        width: double.infinity,
        child: Image.network(product.imageUrl,
        fit: BoxFit.cover),
        )
    );
  }
}