import 'package:flutter/material.dart';
import '../screens/product_overview_screen.dart';
import '../screens/user_product_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello Friends!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("shop"),
            onTap: () {
              Navigator.of(context).restorablePushReplacementNamed(ProductOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("orders"),
            onTap: () {
              Navigator.of(context)
                  .restorablePushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () {
              Navigator.of(context)
                  .restorablePushReplacementNamed(UserProductScreen.routeName);
            },
          ),
           Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              /* Navigator.of(context)
                  .restorablePushReplacementNamed(UserProductScreen.routeName); */
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
