import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/provider/product_provider.dart';
import 'package:shop_application/routes/routes.dart';
import 'package:shop_application/widgets/app_drawer.dart';

import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
   await Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.editProductScreen);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              ListView.builder(
                itemCount: productProvider.items.length,
                itemBuilder: (_, index) => Column(
                  children: [
                    UserProductItem(
                      id: productProvider.items[index].id,
                      title: productProvider.items[index].title,
                      imageUrl: productProvider.items[index].imageUrl,
                    ),
                    const Divider(),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}

