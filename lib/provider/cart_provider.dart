import 'package:flutter/material.dart';

// Model for CartItem!
class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});

} // CartItem class end here!




class CartProvider with ChangeNotifier {
   Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  // getter for shopping cart total items
  int get itemCount {
    return _items.length;
  }


  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItems(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // change quantity!
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      // add new cart item!
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  // remove product from ChartItems!
  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  //Remove single item!
   void removeSingleItem(String productId){
    if(!_items.containsKey(productId)) {
      return;
    }
    if(_items[productId]!.quantity > 1) {
      _items.update(productId, (existingCartItem) => CartItem(id: existingCartItem.id, title: existingCartItem.title,  price: existingCartItem.price, quantity: existingCartItem.quantity - 1,));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
   }

  //clear the cart after order
  void clearCart() {
    _items = {};
    notifyListeners();
  }


} // CartProvider main class end here!
