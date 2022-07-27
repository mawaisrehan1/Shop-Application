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
                  OrderButton(cartProvider: cartProvider),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartProvider,
  }) : super(key: key);

  final CartProvider cartProvider;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

 var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartProvider.totalAmount <= 0 || _isLoading) ? null : () async {
        setState((){
          _isLoading = true;
        });
       await Provider.of<OrdersProvider>(context,listen: false).addOrders(
            widget.cartProvider.items.values.toList(),
            widget.cartProvider.totalAmount,
        );
        setState((){
          _isLoading = false;
        });
        widget.cartProvider.clearCart();
      },
      child: _isLoading ? const CircularProgressIndicator() : const Text('ORDER NOW'),
    );
  }
}
