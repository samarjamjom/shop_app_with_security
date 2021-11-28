import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String token;

  Orders(this.token, this._orders);

  void addOrder(List<CartItem> cartProducts, double total) async{
        final url =
        'https://prefab-glazing-330207-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$token';
        final timestamp = DateTime.now();
        final res = await http.post(url, body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts.map((cp) => {
            'id': cp.id,
            'title': cp.title,
            'price': cp.price,
            'quantity': cp.quantity,
          }).toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
          id:json.decode(res.body)['name'],
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
        ));
    notifyListeners();
  }
}
