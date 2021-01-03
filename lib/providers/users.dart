import 'package:flutter/cupertino.dart';
import '../providers/crop.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import './apiClass.dart';

class  UsersItem with ChangeNotifier {
final String id;
String userName;
String userFirstname;
String userLastname;
String userType;
String userEmail;
String userMobile;
String userImageUrl;
String userId;
String state;
String city;
String country;
String userVillage;
String userCrops;
bool isFavorite;



  UsersItem({
  @required this.id,  
  this.userName,
  @required this.userType, 
  @required this.userFirstname,
  @required this.userLastname,
  @required this.userEmail,  
  this.userImageUrl,
  this.userMobile, 
  this.userId, 
  this.state,
  this.city,
  this.country,
   this.userVillage,
  this.userCrops,
   this.isFavorite = false,
  
   });

   void _setFavValue(bool newValue){
  isFavorite = newValue;
   notifyListeners();
}
 
}



class Users with ChangeNotifier{

final apiurl = AppApi.api;

  List<UsersItem> _users = [ ];

List<UsersItem> get users { 
  /* /* if(_showFavoritesOnly){
    return items.where((cropItem) => cropItem.isFavorite).toList(); */
  } */
  return [..._users];
}


List<UsersItem> get favortieUsers{

return _users.where((userItem) => userItem.isFavorite).toList();

}
 

List<UsersItem> _items = [];
 String authToken;
  final String userId;
   final String userType;

  Users(this.authToken, this.userId, this.userType, this._items);

List<UsersItem> get items{

return [..._items];
}

 set Auth(dynamic Auth) {}
 
UsersItem findById(String userId){

return _items.firstWhere((user) => user.id == userId);
}

//@JsonSerializable(explicitToJson: true)
Future<List<UsersItem>> fetchUsers()  async{
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
  var url = '$apiurl/users';
   //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
    //final url = 'https://farmersfriend-4595f.firebaseio.com/albums/$authName/$name.json';
 final response = await http.get(url, headers: headers);
  
 final List<dynamic> usersMap = jsonDecode(response.body);
  final List<UsersItem> loadedUsers = [];
  if(usersMap != null){

  usersMap.forEach((dynamic userData){
  final String picId = userData['userId'];
   //var userImageUrl = '$apiurl/images/$picId.jpg';
  loadedUsers.add(UsersItem(

    id:userData['id'].toString(),
    userFirstname:userData['firstName'],
    userLastname:userData['lastName'],
    userType:userData['userType'],
    userEmail:userData['emailid'],
    userMobile:userData['userMobile'],
    userId:userData['userId'],
    userImageUrl : userData['userImageUrl'],
    userVillage : userData['userVillage'],
    state: userData['userState'],
    city : userData['userCity'],
    userCrops : userData['userCrops'],
    
    ),
    );

//print('Howdy, description ${expenseData['cropId']}!');



_items = loadedUsers;
notifyListeners();


}


);
  }
  else {
  
  _items = loadedUsers;
  
 
}
return loadedUsers;
}

//@JsonSerializable(explicitToJson: true)
Future<List<UsersItem>> getusers(String userId)  async{
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
  var url = '$apiurl/users/profile/$userId';
   //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
    //final url = 'https://farmersfriend-4595f.firebaseio.com/albums/$authName/$name.json';
 final response = await http.get(url, headers: headers);
  
 final List<dynamic> usersMap = jsonDecode(response.body);
  final List<UsersItem> loadedUsers = [];
  if(usersMap != null){

  usersMap.forEach((dynamic userData){
  final String picId = userData['userId'];
   //var userImageUrl = '$apiurl/images/$picId.jpg';
  loadedUsers.add(UsersItem(

    id:userData['id'].toString(),
    userFirstname:userData['firstName'],
    userLastname:userData['lastName'],
    userType:userData['userType'],
    userEmail:userData['emailid'],
    userMobile:userData['userMobile'],
    userId:userData['userId'],
    userImageUrl : userData['userImageUrl'],
    userVillage : userData['userVillage'],
    state: userData['userState'],
    city : userData['userCity'],
    userCrops : userData['userCrops'],
    
    ),
    );

//print('Howdy, description ${expenseData['cropId']}!');



_items = loadedUsers;
notifyListeners();


}


);
  }
  else {
  
  _items = loadedUsers;
  
 
}
return loadedUsers;
}


//@JsonSerializable(explicitToJson: true)
Future<List<UsersItem>> getUsersByType(String userType)  async{
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
  var url = '$apiurl/users/type/$userType';
  final response = await http.get(url, headers: headers);
  if(response.statusCode == 200){
 final List<dynamic> usersMap = jsonDecode(response.body);
  final List<UsersItem> loadedUsers = [];
  if(usersMap != null){

  usersMap.forEach((dynamic userData){
  final String picId = userData['userId'];
   //var userImageUrl = '$apiurl/images/$picId.jpg';
  loadedUsers.add(UsersItem(

    id:userData['id'].toString(),
    userFirstname:userData['firstName'],
    userLastname:userData['lastName'],
    userType:userData['userType'],
    userEmail:userData['emailid'],
    userMobile:userData['userMobile'],
    userId:userData['userId'],
    userImageUrl : userData['userImageUrl'],
    userVillage : userData['userVillage'],
    state: userData['userState'],
    city : userData['userCity'],
    userCrops : userData['userCrops'],
    
    ),
    );

//print('Howdy, description ${expenseData['cropId']}!');



_items = loadedUsers;
notifyListeners();


}


);
  }
  else {
  
  _items = loadedUsers;
  
 
}
return loadedUsers;
}
}


void updateUser(String id, UsersItem updateUser) async {

 

  String picName = updateUser.userId;;
final String imageUrl = '$apiurl/images/$picName/$picName.jpg';
  final userId = updateUser.id;
  final userIndex = _items.indexWhere((user) => user.id == id);
  if(userIndex >= 0){
  //Firbase url
  // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
  //local Sql
   Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/users/$userId';
    final response = await http.put(url, body: json.encode({
      'id': updateUser.id,
      'userName': updateUser.userName,
      'firstName': updateUser.userFirstname,
      'lastName': updateUser.userLastname,
      'userType' : updateUser.userType,
      'emailid' :updateUser.userEmail,
      'userMobile' :updateUser.userMobile,
      'userId' : updateUser.userId,
      'userImageUrl': imageUrl,
      'userVillage': updateUser.userVillage,
      'userState': updateUser.state,
      'userCity': updateUser.city,
      'userCrops': updateUser.userCrops,
      

    }),
    headers: headers,
    );
    _items[userIndex] = updateUser;
    notifyListeners();
    print(response.body);
  }else{
    print('...');

  }
}

void updatePassword(String userEmail, UsersItem updateUser) async {

  final userEmail= updateUser.userEmail;
  //final userIndex = _items.indexWhere((user) => user.userEmail == userEmail);
 
  //Firbase url
  // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
  //local Sql
   Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/user/$userEmail';
    final response = await http.post(url, body: json.encode({
      'id': updateUser.id,
      'userName': updateUser.userName,
      'firstName': updateUser.userFirstname,
      'lastName': updateUser.userLastname,
      'userType' : updateUser.userType,
      'emailid' :updateUser.userEmail,
      'userMobile' :updateUser.userMobile,
      'userId' : updateUser.userId,
      'userImageUrl': updateUser.userImageUrl,
      

    }),
    headers: headers,
    );
    //_items[userIndex] = updateUser;
    notifyListeners();
    print(response.body);
  }
  void resetPassword(String userEmail, UsersItem updateUser) async {

  final userEmail= updateUser.userEmail;
  //final userIndex = _items.indexWhere((user) => user.userEmail == userEmail);
 
  //Firbase url
  // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
  //local Sql
   Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/user/resetpassword/$userEmail';
    final response = await http.post(url, body: json.encode({
      'id': updateUser.id,
      'userName': updateUser.userName,
      'firstName': updateUser.userFirstname,
      'lastName': updateUser.userLastname,
      'userType' : updateUser.userType,
      'emailid' :updateUser.userEmail,
      'userMobile' :updateUser.userMobile,
      'userId' : updateUser.userId,
      'userImageUrl': updateUser.userImageUrl,
      

    }),
    headers: headers,
    );
    //_items[userIndex] = updateUser;
    notifyListeners();
    print(response.body);
  }
}



