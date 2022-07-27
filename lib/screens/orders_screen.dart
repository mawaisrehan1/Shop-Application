import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/utils/utils.dart';
import '../provider/orders_provider.dart' show OrdersProvider;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }
//
// class _OrdersScreenState extends State<OrdersScreen> {
//   var _isLoading = false;

  // @override
  // void initState() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   Provider.of<OrdersProvider>(context, listen: false).fetchAndSetOrders().then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yours Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<OrdersProvider>(context, listen: false)
              .fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.hasError) {
              LoginUtils.printValue('hasError', dataSnapshot.hasError);
              return const Center(child: Text('Has error'));
            }else  if (dataSnapshot.connectionState == ConnectionState.waiting) {
              LoginUtils.printValue('connectionState', dataSnapshot.connectionState == ConnectionState.waiting);
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // else {
            //   // if (!dataSnapshot.hasData) {
            //   //   return const Center(
            //   //     child: Text('No orders added yet!'),
            //   //   );
            //   // }
            //
            // if (dataSnapshot.error != null) {
            //       // do error handling......
            //       return const Center(
            //         child: Text('An error occurred!'),
            //       );
            //     }
            else if (dataSnapshot.connectionState ==  ConnectionState.done) {
              LoginUtils.printValue('ConnectionState.done', dataSnapshot.connectionState ==  ConnectionState.done);
              return Consumer<OrdersProvider>(
                builder: (ctx, ordersProvider, child) => ListView.builder(
                  itemCount: ordersProvider.orders.length,
                  itemBuilder: (ctx, index) => OrderItem(
                    order: ordersProvider.orders[index],
                  ),
                ),
              );

            }else {
              return const Center(child: Text('No ordered yet'));
            }
           // return const Text('Hello');
          }),
      // _isLoading
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     :
    );
  }
}
