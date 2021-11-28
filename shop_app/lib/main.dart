import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/user_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/product_details_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
           ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            //create: (ctx)=> Products() ,
            update: (ctx, auth, previousProducts) => Products(auth.token, auth.userId,previousProducts==null? [] :previousProducts.items),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            //create: (ctx)=> Products() ,
            update: (ctx, auth, previousOrders) => Orders(auth.token, previousOrders==null? [] :previousOrders.orders),
          ),
         
        ], // return Products() as class for all listners
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: auth.isAuth ? ProductOverviewScreen():AuthScreen(),
            routes: {
              ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen()
            },
          ),
        ));
  }
}
