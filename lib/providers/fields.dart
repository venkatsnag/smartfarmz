import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import './crop.dart';
import 'package:http/http.dart' as http;
import '../providers/auth.dart';
import 'dart:async';
import './apiClass.dart';

class Field with ChangeNotifier{

final String id;
String title;
String description;
      String cropMethod;
      String ownershipType;
String owner;
String farmer;
double area;
String units;
String authToken;
String imageUrl;
final String userId;
String location;
String landType;



Field({
  
   
  @required this.id,  
  @required this.title, 
  @required this.description, 
  @required this.cropMethod,
  @required this.ownershipType,
  @required this.owner,
  @required this.farmer,
  @required this.area,
  this.imageUrl,
  this.location,
  this.authToken,
  @required this.units,
  @required this.userId,
  this.landType,
  
});
}

class Fields with ChangeNotifier{

 final apiurl = AppApi.api;

// holds the Crops.
List<Field> _items = [ ];

  // var _showFavoritesOnly = false;
String authToken;
final String userId;




Fields(this.authToken,  this.userId, this._items);

//copy of the Crops
List<Field> get items { 
  /* /* if(_showFavoritesOnly){
    return items.where((cropItem) => cropItem.isFavorite).toList(); */
  } */
  return [..._items];
}



  set Auth(dynamic Auth) {}
/* void showFavoritesOnly(){

  _showFavoritesOnly = true;
  notifyListeners();
}

void showAll(){

  _showFavoritesOnly = false;
  notifyListeners();
} */
Field findById(String id){

return _items.firstWhere((field) => field.id == id);
}

Future<void> fetchfields([bool filterByUser = false]) async {
  //final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
  //var url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId.json?$authToken';
  Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
   var url = '$apiurl/lands/users/"$userId"';
  

 final response = await http.get(url, headers: headers);
// final extractedCrops = json.decode(response.body) as Map<String, dynamic>;
if(response.statusCode == 200){
  final List<dynamic> extractedCrops = json.decode(response.body);
  final List<Field> loadedfields = [];
 if(extractedCrops.length > 0){
  /*url = 'https://farmersfriend-4595f.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
 final favoriteResponse = await http.get(url);
 final dynamic favoriteData = json.decode(favoriteResponse.body);
 print(favoriteData);*/
 
 extractedCrops.forEach((dynamic cropData ){
    final String picId = userId + cropData['title'];
     var imageUrl = '$apiurl/images/$picId.jpg';
     
   //print(favoriteData[cropId]);
loadedfields.add(Field(
  id: cropData['id'].toString(),
  title: cropData['title'],
  description: cropData['description'],
  ownershipType: cropData['ownershipType'],
  landType: cropData['landType'],
  location: cropData['location'],
  owner: cropData['owner'],
  farmer: cropData['farmer'],
  cropMethod: cropData['cropMethod'],
  userId: cropData['userId'],
  area : double.parse(cropData['area'].toString()),
  units: cropData['units'],
  imageUrl: cropData['imageUrl'],
  authToken : authToken,
  
  ));
 
  
_items = loadedfields;
notifyListeners();
 });
 print(response.body);
} else{
  _items = loadedfields;
  
  
  return Container(
    child: Text('No Data'),);

}
}
  
else{
  return;
}
 
}

Future <void> addField(Field field) async {


  final url = '$apiurl/lands';
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId.json?$authToken';
 String picName = field.userId + field.title ;
//final String imageUrl = '$apiurl/images/$userId/$picName.jpg';
try{
final response = await http.post(url, body: json.encode({
  
  'title': field.title,
  'description': field.description,
  'ownershipType' : field.ownershipType,
  'landType' : field.landType,
  'location' : field.location,
  'owner' : field.owner,
  'farmer' : field.farmer,
  'area': field.area,
  'imageUrl' : field.imageUrl,
  'cropMethod' :field.cropMethod,
  'units' : field.units,
  'userId' : userId,
}),
headers: headers,
);
final dynamic newField = Field(

title:  field.title,
ownershipType : field.ownershipType,
owner: field.owner,
description: field.description,
farmer: field.farmer,
cropMethod: field.cropMethod,
location: field.location,
landType: field.landType,
area: field.area,
units: field.units,
userId: field.userId,
imageUrl: field.imageUrl,
id: json.decode(response.body)['name']
);
_items.add(newField);

notifyListeners();

} catch(error){
  print(error);
throw error; 

}

}




Future <void> updateField(String id, Field newField) async {

  final fieldId = newField.id;
  final fieldIndex = _items.indexWhere((field) => field.id == id);
  if(fieldIndex >= 0){
  //Firbase url
  // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
  //local Sql
   Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/lands/$id';
  String picName = newField.userId + newField.title + newField.id;
   final String imageUrl = '$apiurl/images/$userId/$picName.jpg';
    final response = await http.put(url, body: json.encode({
      'id':newField.id,
      'title':newField.title,
      'description': newField.description,
      'owner' : newField.owner,
'ownershipType' : newField.ownershipType,
      'farmer' : newField.farmer,
      'cropMethod' :newField.cropMethod,
      'landType' :newField.landType,
      'location' :newField.location,
      'area' : newField.area.toDouble(),
      'units' : newField.units,
      'userId' : newField.userId,
      'imageUrl': imageUrl,
      //'price': newCrop.price.toDouble(),

    }),
    headers: headers,
    );
    _items[fieldIndex] = newField;
    notifyListeners();
    print(response.body);
  }else{
    print('...');

  }
}

Future <void> patchField(String fieldId, String email, String userType) async {

  String userId = email.substring(0, email.lastIndexOf("@"));;
  String id = fieldId;
  String  key = userType;
  if(userType == 'Admin'){
    key = 'adminUserId';
  }

  
  final cropIndex = _items.indexWhere((crop) => crop.id == id);
  if(cropIndex >= 0){
  //Firbase url
  // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
  //local Sql
   Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/lands/$id';
  
    final response = await http.patch(url, body: json.encode({
      //'id':userId,
      '$key' : userId,
      
      //'price': newCrop.price.toDouble(),

    }),
    headers: headers,
    );
    
    notifyListeners();
    print(response.body);
  }else{
    print('...');

  }
}

void deleteLand(String id) async {
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
_items.removeWhere((crop) => crop.id == id);
final url = '$apiurl/lands/$id';
    final response = await http.delete(url, headers: headers);
notifyListeners();
print(response.body);

} 

void deleteUserCropSale(String id) async {
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
_items.removeWhere((crop) => crop.id == id);
final url = '$apiurl/V1/forSale/lands/$id';
    final response = await http.delete(url, headers: headers);
notifyListeners();
print(response.body);

} 

void update(String token) {
 if (token == null){
this.authToken == null;

 } 
 else{
   return;
 }
  
  //this.authToken = token;
  // do some requests
}
}

