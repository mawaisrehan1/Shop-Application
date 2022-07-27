import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shop_application/utils/utils.dart';
import 'product_model_provider.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {

   List<ProductModelProvider> _items = [
    //  ProductModelProvider(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    //  ProductModelProvider(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    //  ProductModelProvider(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    //  ProductModelProvider(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];


   final String authToken;
   final String userId;
   ProductsProvider( this.authToken, this.userId, this._items);


  // getter for all items!
  List<ProductModelProvider> get items {




    return [..._items];
  }



  // getter for favoriteItems!
  List<ProductModelProvider> get favoriteItems {
    return _items.where((prodItems) => prodItems.isFavorite).toList();
  }



  // method for findProduct by Id!
  ProductModelProvider findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }



  /// get method for fetchAndSetProducts!
  Future<void> fetchAndSetProducts() async {
    var firebaseUrl =
        'https://shop-application-8a627-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(firebaseUrl));
      LoginUtils.printValue('fetchAndSetProducts Methods Response', json.decode(response.body));
      final List<ProductModelProvider> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null) {
        return;
      }
       firebaseUrl =
          'https://shop-application-8a627-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(firebaseUrl));
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(ProductModelProvider(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
          isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false,
        ),);
      });
      _items = loadedProducts;
      notifyListeners();
    } // try end here!

    catch (error) {
      rethrow;
    } // catch end here!

  } // method for get data end here!





  /// method for add new product!
  Future<void> addProducts(ProductModelProvider product) async {
    final firebaseUrl =
        'https://shop-application-8a627-default-rtdb.firebaseio.com/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
    try {
      final response = await http.post(
        Uri.parse(firebaseUrl),
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = ProductModelProvider(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct);
      notifyListeners();
    } // try end here!
    catch (error) {
      LoginUtils.printValue('Error message', error);
      rethrow;
    } // catch end here!

  } // addProducts end here!




  /// method for update existing product!
  Future<void> updateProduct(String id, ProductModelProvider newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final firebaseUrl =
          'https://shop-application-8a627-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(firebaseUrl), body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
      }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      LoginUtils.printValue('Message', 'Product not updated');
    }
  } // updateProduct end here!




  /// method for deleteProduct!
  Future<void> deleteProduct(String id) async{
    final firebaseUrl =
        'https://shop-application-8a627-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    ProductModelProvider? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
   final response = await http.delete(Uri.parse(firebaseUrl));
      if(response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw const HttpException('Could not delete product!');
      }
      existingProduct = null;
  } // deleteProduct end here!

} // ProductsProvider main class end here!




