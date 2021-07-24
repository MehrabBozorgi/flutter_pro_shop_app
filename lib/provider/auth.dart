import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/model/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;

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

  Future<void> _authCase(String email, String password, String urlCase) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlCase?key=AIzaSyAl9cpcPubqvSr6cm7evxZsEFJXGerhkew';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
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
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = jsonEncode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      pref.setString('userDataPref', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool?> tryLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userDataPref')) {
      return false;
    }
    final extractedUserData =
        json.decode(pref.getString('userDataPref')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> signUp(String email, String password) async {
    return _authCase(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authCase(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
