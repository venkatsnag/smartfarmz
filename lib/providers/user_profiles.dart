import 'package:flutter/cupertino.dart';
import '../providers/crop.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import './apiClass.dart';

class UserProfieItem with ChangeNotifier {
  String id;
  String userName;
  String userFirstname;
  String userLastname;
  String userType;
  String userEmail;
  String userMobile;
  String userVillage;
  String userImageUrl;
  String userId;
  String userState;
  String userCity;
  String userCountry;
  String countryDialCode;
  String userCrops;
  String newPwd;
  bool isFavorite;

  UserProfieItem({
    @required this.id,
    this.userName,
    @required this.userType,
    @required this.userFirstname,
    @required this.userLastname,
    @required this.userEmail,
    this.userImageUrl,
    this.userVillage,
    this.userMobile,
    this.userId,
    this.userState,
    this.userCity,
    this.userCountry,
    this.countryDialCode,
    this.userCrops,
    this.newPwd,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }
}

class UserProfiles with ChangeNotifier {
  final apiurl = AppApi.api;

  List<UserProfieItem> _users = [];

  List<UserProfieItem> get users {
    /* /* if(_showFavoritesOnly){
    return items.where((cropItem) => cropItem.isFavorite).toList(); */
  } */
    return [..._users];
  }

  List<UserProfieItem> get favortieUsers {
    return _users.where((userItem) => userItem.isFavorite).toList();
  }

  List<UserProfieItem> _items = [];
  String authToken;
  final String userId;
  String userType;
  String userFirstName;
  String userMobile;
  String userEmail;

  UserProfiles(
      this.authToken, this.userId, this.userType, this.userEmail, this.userFirstName, this.userMobile, this._items);

  List<UserProfieItem> get items {
    return [..._items];
  }

  set Auth(dynamic Auth) {}

  UserProfieItem findById(String userId) {
//return _items.firstWhere((user) => user.userId == userId);
    return _items.firstWhere((user) => user.id == userId);
  }

//@JsonSerializable(explicitToJson: true)
  Future<List<UserProfieItem>> fetchUsers() async {
    Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
    var url = '$apiurl/users';
    //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
    //final url = 'https://farmersfriend-4595f.firebaseio.com/albums/$authName/$name.json';
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> usersMap = jsonDecode(response.body);
      final List<UserProfieItem> loadedUsers = [];
      if (usersMap != null) {
        usersMap.forEach((dynamic userData) {
          final String picId = userData['userId'];
          ;
          //String picName = updateUser.userId;;
          final String imageUrl = '$apiurl/images/$picId/$picId.jpg';
          loadedUsers.add(
            UserProfieItem(
              id: userData['id'].toString(),
              userFirstname: userData['firstName'],
              userLastname: userData['lastName'],
              userType: userData['userType'],
              userEmail: userData['emailid'],
              userMobile: userData['userMobile'],
              userId: userData['userId'],
              userImageUrl: imageUrl,
              userVillage: userData['userVillage'],
              userState: userData['userState'],
              userCity: userData['userCity'],
              userCrops: userData['userCrops'],
              userCountry: userData['userCountry'],
            ),
          );

//print('Howdy, description ${expenseData['cropId']}!');

          _items = loadedUsers;
          notifyListeners();
        });
      } else {
        _items = loadedUsers;
      }
      return loadedUsers;
    }
  }

//@JsonSerializable(explicitToJson: true)
  Future<List<UserProfieItem>> getusers(String userId) async {
    Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
    var url = '$apiurl/users/$userId';

    String picName = userId;
    ;
    final String imageUrl = '$apiurl/images/$picName/$picName.jpg';
    //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
    //final url = 'https://farmersfriend-4595f.firebaseio.com/albums/$authName/$name.json';
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> usersMap = jsonDecode(response.body);
      final List<UserProfieItem> loadedUsers = [];
      if (usersMap != null) {
        usersMap.forEach((dynamic userData) {
          final String picId = userData['userId'];
          // var userImageUrl = '$apiurl/images/$picId.jpg';
          loadedUsers.add(
            UserProfieItem(
              id: userData['id'].toString(),
              userFirstname: userData['firstName'],
              userLastname: userData['lastName'],
              userType: userData['userType'],
              userEmail: userData['emailid'],
              userMobile: userData['userMobile'],
              userId: userData['userId'],
              userImageUrl: userData['userImageUrl'],
              userVillage: userData['userVillage'],
              userState: userData['userState'],
              userCity: userData['userCity'],
              userCrops: userData['userCrops'],
              userCountry: userData['userCountry'],
              countryDialCode: userData['countryDialCode'],
            ),
          );

//print('Howdy, description ${expenseData['cropId']}!');

          _items = loadedUsers;
          notifyListeners();
        });
      } else {
        _items = loadedUsers;
      }
      return loadedUsers;
    }
  }

//@JsonSerializable(explicitToJson: true)
  Future<List<UserProfieItem>> getUsersByType(String userType) async {
    Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
    var url = '$apiurl/users/type/$userType';
    //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
    //final url = 'https://farmersfriend-4595f.firebaseio.com/albums/$authName/$name.json';
    final response = await http.get(url, headers: headers);

    final List<dynamic> usersMap = jsonDecode(response.body);
    final List<UserProfieItem> loadedUsers = [];
    if (usersMap != null) {
      usersMap.forEach((dynamic userData) {
        String picName = userData['userId'];
        ;
        final String imageUrl = '$apiurl/images/$picName/$picName.jpg';
        //var userImageUrl = '$apiurl/images/$picId.jpg';
        loadedUsers.add(
          UserProfieItem(
            id: userData['id'].toString(),
            userFirstname: userData['firstName'],
            userLastname: userData['lastName'],
            userType: userData['userType'],
            userEmail: userData['emailid'],
            userMobile: userData['userMobile'],
            userId: userData['userId'],
            userImageUrl: imageUrl,
            userVillage: userData['userVillage'],
            userState: userData['userState'],
            userCity: userData['userCity'],
            userCrops: userData['userCrops'],
            userCountry: userData['userCountry'],
            countryDialCode: userData['countryDialCode'],
          ),
        );

//print('Howdy, description ${expenseData['cropId']}!');

        _items = loadedUsers;
        notifyListeners();
      });
    } else {
      _items = loadedUsers;
    }
    return loadedUsers;
  }

  void updateUser(String id, UserProfieItem updateUser) async {
    String picName = updateUser.userId;
    ;
    final String imageUrl = '$apiurl/images/$picName/$picName.jpg';
    final userId = updateUser.id;
    final userIndex = _items.indexWhere((user) => user.id == id);
    if (userIndex >= 0) {
      //Firbase url
      // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
      //local Sql
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Authorization': 'Bearer $authToken'
      };
      final url = '$apiurl/users/$userId';
      final response = await http.put(
        url,
        body: json.encode({
          'id': updateUser.id,
          'firstName': updateUser.userFirstname,
          'lastName': updateUser.userLastname,
          'userType': updateUser.userType,
          'emailid': updateUser.userEmail,
          'userMobile': updateUser.userMobile,
          'userId': updateUser.userId,
          'userImageUrl': imageUrl,
          'userVillage': updateUser.userVillage,
          'userState': updateUser.userState,
          'userCity': updateUser.userCity,
          'userCrops': updateUser.userCrops,
          'userCountry': updateUser.userCountry,
          'countryDialCode': updateUser.countryDialCode,
        }),
        headers: headers,
      );
      _items[userIndex] = updateUser;
      notifyListeners();
      //print(response.body);
    } else {
      print('...');
    }
  }

  void patchUser(String userId, String userImageUrl) async {
    String id = userId;

    final userIndex = _items.indexWhere((user) => user.userId == id);
    if (userIndex >= 0) {
      //Firbase url
      // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
      //local Sql
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Authorization': 'Bearer $authToken'
      };
      final url = '$apiurl/users/$id';

      final response = await http.patch(
        url,
        body: json.encode({
          //'id':userId,
          'userImageUrl': userImageUrl,

          //'price': newCrop.price.toDouble(),
        }),
        headers: headers,
      );

      notifyListeners();
      //print(response.body);
    } else {
      print('...');
    }
  }

  void updatePassword(String userEmail, UserProfieItem updateUser) async {
    final userEmail = updateUser.userEmail;
    //final userIndex = _items.indexWhere((user) => user.userEmail == userEmail);

    //Firbase url
    // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
    //local Sql
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Authorization': 'Bearer $authToken'
    };
    final url = '$apiurl/user/$userEmail';
    final response = await http.post(
      url,
      body: json.encode({
        'id': updateUser.id,
        'userName': updateUser.userName,
        'firstName': updateUser.userFirstname,
        'lastName': updateUser.userLastname,
        'userType': updateUser.userType,
        'emailid': updateUser.userEmail,
        'userMobile': updateUser.userMobile,
        'userId': updateUser.userId,
        'userImageUrl': updateUser.userImageUrl,
      }),
      headers: headers,
    );
    //_items[userIndex] = updateUser;
    notifyListeners();
    print(response.body);
  }

  void resetPassword(String userEmail, UserProfieItem updateUser) async {
    final userEmail = updateUser.userEmail;
    //final userIndex = _items.indexWhere((user) => user.userEmail == userEmail);

    //Firbase url
    // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
    //local Sql
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Authorization': 'Bearer $authToken'
    };
    final url = '$apiurl/reset-password/$userEmail';
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          // 'emailid' :updateUser.userEmail,
          'password': updateUser.newPwd,
        }),
        headers: headers,
      );
      //_items[userIndex] = updateUser;
      notifyListeners();
      print(response.body);
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
