import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/provider/product_provider.dart';
import 'package:shop_application/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;
  const ProductsGrid({Key? key, required this.showFav}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    ProductsProvider productData = Provider.of<ProductsProvider>(context,);
    final products = showFav ? productData.favoriteItems : productData.items;
    return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: products[index],
         // create: (c) => products[index],
          child: const ProductItem(
            // id: products[index].id,
            // title: products[index].title,
            // imageUrl: products[index].imageUrl,
          ),
        ),
        );
  }
}
