import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_application/utils/utils.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  ///isAuth getter!
  bool get isAuth {
    return token != null && token != '';
  }

  ///token getter!
  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  ///userId getter!
  String? get userId {
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

      //_autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String()
      });
      prefs.setString('userData', userData);

      LoginUtils.printValue("USER DATA", userData);

      return token;
    } // try end here!

    catch (error) {
      rethrow;
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



   Future<bool> tryAutoLogin()async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey('userData')) {
        LoginUtils.printValue("USER DATA Not EXISTS",prefs.containsKey('userData'));
        return false;
      }

      final extractedUserData = json.decode(
          prefs.getString('userData')!);
      LoginUtils.printValue('User Data Exist!', prefs.getString('userData'));
      final expiryDate = DateTime.parse(
          extractedUserData['expiryDate']);

      /*if(expiryDate.isBefore(DateTime.now())) {
      return false;
    }*/
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _expiryDate = expiryDate;

      //notifyListeners();
      //_autoLogout();

      LoginUtils.printValue("TRY OUT AUTH", extractedUserData);

      return true;
    }catch(e){
      LoginUtils.printValue("EXCEPTION TRY OUY AUTH", e);
      return false;
    }
  }




  ///Logout Method!
  Future<void> logout() async {
    _token = "";
    _userId = "";
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  } //logout method end here!

  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer!.cancel();
  //   }
  //   final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(const Duration(seconds: 3), logout);
  // }
}
