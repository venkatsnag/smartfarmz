import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:convert' as JSON;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_extension.dart';
import './apiClass.dart';

class Auth with ChangeNotifier {
  String _token;
  String _fbToken;
  DateTime _expiryDate;
  String _userId;
  String _fbUserId;
  String firstName;
  String lastName;
  String _userType;
  String _userMobile;
  String _userImageUrl;
  String _userEmail;
  String _userFullName;
  bool _isFBUser;

  final apiurl = AppApi.api;

//final apiurl = 'http://api.happyfarming.net:5000';
 //final apiurl = 'http://192.168.68.100:5000';
 // final apiurl = 'http://192.168.87.21:5000';

//FB
  //String fbUserId;

  List<Auth> _users = [ ];

  bool isLoggedIn = false;

  Map userProfile;
  final facebookLogin = FacebookLogin();

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get fbToken {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _fbToken != null) {
      return _fbToken;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get userType {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _userType;
    }
    return null;
  }

  String get userEmail {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _userEmail;
    }
    return null;
  }

  String get userImageUrl {
    return _userImageUrl;
  }

  String get fbUserId {
    return _fbUserId;
  }

  String get userFullName {
    return _userFullName;
  }

  String get userFirstName {
    return firstName;
  }

   String get userMobile {
    return _userMobile;
  }

  bool get isFBUser {
    return _isFBUser;
  }



//Nodejs Authentication API
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    var url = '$apiurl/$urlSegment';
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'emailid': email,
            'password': password,
          },
        ),
        headers: headers,
      );
      print(response.body);
      final dynamic responseData = json.decode(response.body);
      if (responseData['error'] != null || response.reasonPhrase== 'Unauthorized') {
        throw HttpException(responseData['msg']);
      }
      _token = responseData['Authtoken'];
      _userId = responseData['userId'];
      _expiryDate = DateTime.tryParse(responseData['expiresIn']).toLocal();
      firstName = responseData['firstName'];
      lastName = responseData['lastName'];
      _userType = responseData['userType'];
      _userMobile = responseData['userMobile'];
      _userEmail = responseData['userEmail'];

      notifyListeners();
     

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
          'firstName': firstName,
          'lastName': lastName,
          'userType': userType,
          'userEmail': userEmail,
        },
      );
      prefs.setString('userData', userData);
      prefs.setString('loginUserData', userData);
 return responseData;
      
    }
    
    
   
     catch (error) {
      rethrow;
    }
  }

//Signup
  Future<void> _signupAuthenticate(
      String email,
      String password,
      String firstName,
      String lastName,
      String userType,
      String userMobile) async {
    var url = '$apiurl/signup';
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'emailid': email,
            'password': password,
            'firstName': firstName,
            'lastName': lastName,
            'userType': userType,
            'userMobile': userMobile
          },
        ),
        headers: headers,
      );
      print(response.body);
      final dynamic responseData = json.decode(response.body);
       if (responseData['error'] != null || response.reasonPhrase== 'Unauthorized') {
        throw HttpException(responseData['msg']);
      }
      _token = responseData['Authtoken'];
      _userId = responseData['userId'];
      //_expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])),);
      _expiryDate = DateTime.tryParse(responseData['expiresIn']).toLocal();
      firstName = responseData['firstName'];
      lastName = responseData['lastName'];
      _userType = responseData['userType'];
      _userMobile = responseData['userMobile'];
      _userEmail = responseData['userEmail'];

      notifyListeners();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
          'firstName': firstName,
          'lastName': lastName,
          'userType': userType,
          'userEmail': userEmail,
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }



//Node js API
  Future<dynamic> login(String email, String password) async {
    return _authenticate(email, password, 'login');
  }

  Future<void> signup(String email, String password, String userType, String userMobile, String firstName, String lastName) async {
    return _signupAuthenticate(
      email,
      password,
      firstName,
      lastName,
      userType,
      userMobile,
    );
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryData = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryData.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    firstName = extractedUserData['firstName'];
    lastName = extractedUserData['lastName'];
    _userType = extractedUserData['userType'];
    _userMobile = extractedUserData['userMobile'];
    _userEmail = extractedUserData['userEmail'];

    _expiryDate = expiryData;
    notifyListeners();

    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }



  Future<void> loginWithFB(BuildContext context) async {
    final dynamic result = await facebookLogin.logIn(['email']);
    print(result);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        dynamic token = result.accessToken.token;
        //_token = result.accessToken.token;
        _userId = result.accessToken.userId;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(640),email&access_token=${token}');
        final dynamic profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        Map<String, dynamic> pictureData = profile['picture'];
        Map<String, dynamic> data = pictureData["data"];
        userProfile = profile;
        _userId = profile['id'];
        _fbUserId = profile['email'];
        _userEmail = profile['email'];
        _userImageUrl = data["url"];
        _expiryDate = result.accessToken.expires;
        _userFullName = profile['name'];
        _isFBUser = true;

        isLoggedIn = true;

        //String userId = _userEmail.substring(0, _userId.indexOf('.'));
        notifyListeners();
        final SharedPreferences sharedprefs =
            await SharedPreferences.getInstance();
        final String userData = json.encode(
          {
            'token': _token,
            'userId': _userEmail.substring(0, _userEmail.indexOf('@')),
            'fbUserId': _userId,
            'expiryDate': _expiryDate.toIso8601String(),
            'emailid': _userEmail,
            'userImageUrl': _userImageUrl,
            'userFullName': _userFullName,
          },
        );

        sharedprefs.setString('userData', userData);
        break;

      case FacebookLoginStatus.cancelledByUser:
        return isLoggedIn = false;
        // setState(() => _isLoggedIn = false );
        break;
      case FacebookLoginStatus.error:
        return isLoggedIn = false;
        // setState(() => _isLoggedIn = false );
        break;
    }
//Creatin JWT token for FB user.
    var url = '$apiurl/fbLogin';
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'userId': _userEmail.substring(0, _userEmail.indexOf('@')),
            'fbUserId': _userId,
            'emailid': _userEmail,
            'password': _userId,
            'userImageUrl': _userImageUrl,
            'firstName': _userFullName,
          },
        ),
        headers: headers,
      );
      print(response.body);
      final dynamic responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['Authtoken'];
      _userId = responseData['userId'];
      _expiryDate = DateTime.tryParse(responseData['expiresIn']).toLocal();
      firstName = responseData['firstName'];
      lastName = responseData['lastName'];
      _userType = responseData['userType'];
      _userMobile = responseData['userMobile'];
      _userEmail = responseData['userEmail'];

      notifyListeners();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
          'firstName': firstName,
          'userType': _userType,
          'userEmail': _userEmail,
          'lastName': lastName,
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  dynamic fbLogout() {
    facebookLogin.logOut();
    return isLoggedIn = false;
    /* setState(() {
      _isLoggedIn = false;
    }); */
  }

  Future<bool> fbTryAutoLogin() async {}
}


