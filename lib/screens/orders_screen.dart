import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/orders_provider.dart' show OrdersProvider;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yours Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
          itemCount: ordersProvider.orders.length,
          itemBuilder: (ctx, index) => OrderItem(order: ordersProvider.orders[index],)),
    );
  }
}
