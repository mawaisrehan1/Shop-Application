import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/provider/cart_provider.dart' show CartProvider;
import 'package:shop_application/provider/orders_provider.dart';
import '../widgets/cart_item.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final mediaQuery = MediaQuery.of(context);

    // store appBar in this variable!
    final appBar = AppBar(
      title: const Text('Cart Screen'),
    );

    return  Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          SizedBox(
            height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
                0.02,
          ),
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleLarge
                              ?.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<OrdersProvider>(context,listen: false).addOrders(
                          cartProvider.items.values.toList(),
                          cartProvider.totalAmount,
                      );
                      cartProvider.clearCart();
                    },
                    child: const Text('ORDER NOW'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.07,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (ctx, index) => CartItem(
                productId: cartProvider.items.keys.toList()[index],
                  id: cartProvider.items.values.toList()[index].id,
                  title: cartProvider.items.values.toList()[index].title,
                  quantity: cartProvider.items.values.toList()[index].quantity,
                  price: cartProvider.items.values.toList()[index].price),
            ),
          ),
        ],
      ),
    );
  }
}
