import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

import 'dart:math';
class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('${widget.order.amount}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(isExpanded? Icons.expand_less :Icons.expand_more),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          // ignore: sdk_version_ui_as_code
          if(isExpanded)
          Container(
            height: min(widget.order.products.length * 20.0 + 100, 180) , 
            child: ListView(
              children: widget.order.products
              .map(
                  (prod) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(prod.title),
                      Text('${prod.price}'), 
                      ],
                  ))
                  .toList(),
              ),
          ),
        ],
      ),
    );
  }
}
