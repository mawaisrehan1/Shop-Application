import 'package:flutter/material.dart';
import 'package:shop_application/routes/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friends!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title:  const Text('Shop'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(Routes.productOverviewScreen);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title:  const Text('Orders'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(Routes.ordersScreen);
            },
          ),
        ],
      ),
    );
  }
}
