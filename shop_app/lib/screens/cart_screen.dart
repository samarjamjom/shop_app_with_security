import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_items.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Items"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 15),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cartData.totalAmount}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartData: cartData)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItems(
                cartData.items.values.toList()[i].id,
                cartData.items.keys.toList()[i],
                cartData.items.values.toList()[i].title,
                cartData.items.values.toList()[i].price,
                cartData.items.values.toList()[i].quantity,
              ),
              itemCount: cartData.items.length,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    @required this.cartData,
  });

  final Cart cartData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text("ORDER NOW"),
      textColor: Theme.of(context).primaryColor,
      onPressed: (widget.cartData.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cartData.items.values.toList(),
                widget.cartData.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cartData.clear();
            },
    );
  }
}
