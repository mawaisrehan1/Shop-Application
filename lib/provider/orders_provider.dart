import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_application/utils/utils.dart';
import 'package:shop_application/widgets/cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  List products;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class OrdersProvider with ChangeNotifier {

   List<OrderItem> _orders = [];

   final String authToken;
   final String userId;
   OrdersProvider(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  /// get method for fetchAndSetOrders!
  Future<void> fetchAndSetOrders() async {
    final firebaseUrl =
        'https://shop-application-8a627-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(firebaseUrl));
      LoginUtils.printValue(
          'fetchAndSetOrders Method Response', json.decode(response.body));
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List)
              .map((item) => CartItem(
            id: item['id'],
            price: item['price'],
            quantity: item['quantity'],
            title: item['title'],
          )
          )
              .toList(),
        ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }
    catch (error) {
      throw (error);
    } // catch end here!

  } // get method for fetchAndSetOrders end here!

  /// addOrders method
  Future<void> addOrders(List cartProducts, double total) async {
    final firebaseUrl =
        'https://shop-application-8a627-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
   try {
     final response = await http.post(Uri.parse(firebaseUrl),
         body: json.encode({
           'amount': total,
           'dateTime': timestamp.toIso8601String(),
           'products': cartProducts
               .map((cp) => {
             'id': cp.id,
             'title': cp.title,
             'quantity': cp.quantity,
             'price': cp.price,
           })
               .toList(),
         }));
     _orders.insert(
         0,
         OrderItem(
             id: json.decode(response.body)['name'],
             amount: total,
             products: cartProducts,
             dateTime: DateTime.now()));
     notifyListeners();
   }
   catch (error) {
     throw error;
   }
  } // addOrders method end here!

} // OrdersProvider main class end here!
