import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/provider/auth_provider.dart';
import 'package:shop_application/provider/cart_provider.dart';
import 'package:shop_application/routes/routes.dart';
import '../provider/product_model_provider.dart';
import '../values/colors.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);


  //
  // final String id;
  // final String title;
  // final String imageUrl;
  // const ProductItem({Key? key, required this.id, required this.title, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModelProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: productTitleBackgroundColor,
          leading: Consumer<ProductModelProvider>(
            builder: (_, product, child) => IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus(authProvider.token!, authProvider.userId!);
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
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Item added to cart!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cartProvider.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(Routes.productDetailScreen, arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/product_placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
