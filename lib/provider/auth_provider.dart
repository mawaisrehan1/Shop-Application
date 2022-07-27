import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_application/utils/utils.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId{
    return _userId;
  }

  /// signUp method using firebase auth!
  Future<String?> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final authUrl =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBQeWwSJA-1klychUUUwX5VWhHcKr4xrms';
      final response = await http.post(
        Uri.parse(authUrl),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      LoginUtils.printValue('_authenticate Method Response', responseData);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      return token;
      notifyListeners();
    } // try end here!

    catch (error) {
      throw error;
      return null;
    } // catch end here!
  } // signUp method end here!




  /// signUp method using firebase auth!
  Future<String?> signUp(String email, String password) async {
    LoginUtils.printValue('signUp Method', '');
    return _authenticate(email, password, 'signUp');
  } // signUp method end here!



  /// logIn method using firebase auth!
  Future<String?> logIn(String email, String password) async {
    LoginUtils.printValue('logIn Method', '');
    return _authenticate(email, password, 'signInWithPassword');
  } // logIn method end here!



}
