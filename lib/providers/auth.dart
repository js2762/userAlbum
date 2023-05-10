import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:useralbum/models/user_data.dart';
import '../models/http_exception.dart';
import '../screens/getx_demo_screen.dart';
import '../screens/user_page_screen.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token.toString();
    }
    return null;
  }

  /* Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBuNJbmCI3KsHW6q3ZeCoFAJ7sgK_qoO50');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      //print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      //print(_token);
      //print(responseData['expiresIn']);
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      //print(_expiryDate);
      notifyListeners();
      _autoLogOut();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
          {'token': _token, 'expiryDate': _expiryDate!.toIso8601String()});
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  } */

/*  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  } */

  Future<void> login2(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      var idTokenResult = await user?.getIdTokenResult();
      //_token = await user?.getIdToken();
      DateTime? expirationTime = idTokenResult!.expirationTime;
      _expiryDate = expirationTime;

      //print(_token);
      notifyListeners();
      _autoLogOut();
      //Get.toNamed(GetXScreen.routeName);
      final prefs = await SharedPreferences.getInstance();
      /*  final userData = json.encode(
          {'token': _token, 'expiryDate': _expiryDate!.toIso8601String()}); */
      final userData =
          json.encode({'expiryDate': _expiryDate!.toIso8601String()});
      prefs.setString('userData', userData);
    } catch (error) {
      // print(error);
      throw error;
    }
  }

  Future<void> signUp2(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      var idTokenResult = await user?.getIdTokenResult();
      // _token = await user?.getIdToken();
      DateTime? expirationTime = idTokenResult!.expirationTime;
      _expiryDate = expirationTime;
      // print(_token);
      notifyListeners();
      _autoLogOut();
      //Get.to(() => GetXScreen());
      final prefs = await SharedPreferences.getInstance();
      /*  final userData = json.encode(
          {'token': _token, 'expiryDate': _expiryDate!.toIso8601String()}); */
      final userData =
          json.encode({'expiryDate': _expiryDate!.toIso8601String()});
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  /* Future<void> login2(String email, String password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      User? user = userCredential.user;
      user!.getIdToken().then((idToken) {
        _token = idToken.toString();
        print(_token);
        notifyListeners();
      });
      //Get.to(() => GetXScreen());
    });
    /* final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
        {'token': _token, 'expiryDate': _expiryDate!.toIso8601String()});
    prefs.setString('userData', userData); */
  } */

  /* Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData') as String)
        as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    //_token = extractedUserData['token'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogOut();
    return true;
  } */

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), googleSignOut);
  }

  GoogleSignInAccount? gUser;
  signInWithGoogle() async {
    // begin interactive sign in process
    gUser = await GoogleSignIn().signIn();
    if (gUser == null) {
      // User cancelled the sign-in process
      return;
    }
    // if (user != null) {
    //   gUser = user;
    // }
    //print(user.email);
    //print(gUser?.email);

    // obtain auth details from request
    final gAuth = await gUser!.authentication;

    // print(gAuth.accessToken);

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // let's sign in
    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
    //_autoLogOut();
  }

  googleSignOut() async {
    if (gUser != null) {
      await GoogleSignIn().disconnect();
    }
    gUser = null;

    // _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    FirebaseAuth.instance.signOut();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
