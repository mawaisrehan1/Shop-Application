import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/provider/cart_provider.dart';
import 'package:shop_application/routes/routes.dart';
import '../provider/product.dart';
import '../values/colors.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  // final String id;
  // final String title;
  // final String imageUrl;
  // const ProductItem({Key? key, required this.id, required this.title, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false) ;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: productTitleBackgroundColor,
          leading: Consumer<Product>(
            builder: (_, product, child) => IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus();
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cartProvider.addItems(product.id, product.price, product.title); 
            },
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(Routes.productDetailScreen, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
