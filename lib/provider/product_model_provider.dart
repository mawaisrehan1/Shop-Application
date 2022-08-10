import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductModelProvider with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductModelProvider(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false,
      });


  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }


  /// method for toggleFavoriteStatus!
  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final favFirebaseUrl =
        'https://shop-application-8a627-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try{
     final response = await http.put(Uri.parse(favFirebaseUrl),
       body: json.encode(
        isFavorite,
       ),
     );
     notifyListeners();
     if(response.statusCode >= 400) {
       _setFavValue(oldStatus);
     }

    } //try end here!
    catch (error) {
      _setFavValue(oldStatus);
    } // catch end here!

  } // toggleFavoriteStatus end here!

}  // ProductModelProvider main class end here!
