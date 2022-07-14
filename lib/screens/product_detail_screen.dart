import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/values/colors.dart';

import '../provider/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text(loadedProduct.title),
    );
    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.5,
                width: width * 1,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.02,
              ),
              Text(
                '\$${loadedProduct.price}',
                style: const TextStyle(color: greyColor, fontSize: 20),
              ),
              SizedBox(
                height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                    0.02,
              ),
              Container(
                width: width * 1,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  loadedProduct.description,
                  softWrap: true,
                  textAlign: TextAlign.center,
                //  style: const TextStyle(color: greyColor, fontSize: 20),
                ),
              ),
            ],
          ),
        ));
  }
}
