import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import './crop.dart';
import 'package:http/http.dart' as http;
import '../providers/auth.dart';
import 'dart:async';
import './apiClass.dart';


class UserCrop with ChangeNotifier{
final String id;
String cropId;
String cropUserId;
String userType;

UserCrop({
@required this.id,  
this.cropId,  
this.cropUserId,  
this.userType,  


  });
  @override toString() => '$cropId';
}



class Crops with ChangeNotifier{

final apiurl = AppApi.api;

// holds the Crops.
List<Crop> _items = [ ];

List<UserCrop> _usersCrops = [ ];

List<Crop> _cropInvestments = [ ];

  // var _showFavoritesOnly = false;
String authToken;
final String userId;


Crops(this.authToken,  this.userId, this._items);

//copy of the Crops
List<Crop> get items { 
  /* /* if(_showFavoritesOnly){
    return items.where((cropItem) => cropItem.isFavorite).toList(); */
  } */
  return [..._items];
}

//copy of the Crops
List<Crop> get cropInvestments { 
  /* /* if(_showFavoritesOnly){
    return items.where((cropItem) => cropItem.isFavorite).toList(); */
  } */
  return [..._cropInvestments];
}

//gets the crop ids from cropusers table
List<UserCrop> get usersCrops { 
  
  return [..._usersCrops];
}

//loops crop ids from users table
 String get allCropsByUser{
    List<UserCrop> cropsByUser = [];
     //String cropsByUserId;

    _usersCrops.forEach((dynamic userCrops){

cropsByUser.add(UserCrop(
  cropId:userCrops.cropId.toString() )
  );

   
      //cropsByUser += userCrops.cropId;
      //var dynamic colorsString = cropsByUser.join(",");
    },
    );
    String cropsByUserId = cropsByUser.join(', ');
   
   return cropsByUserId;
  }





List<Crop> get favortieItems{

return _items.where((cropItem) => cropItem.isFavorite).toList();

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
Crop findById(String id){

return _items.firstWhere((crop) => crop.id == id);
}

Crop findByLandId(String id){

return _items.firstWhere((crop) => crop.landId == id);
}

Crop findCropsForInvestmentsById(String id){

return _cropInvestments.firstWhere((crop) => crop.id == id);
}

Future<void> fetchCropsByUser([bool filterByUser = false]) async {
  //final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
  //var url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId.json?$authToken';
  Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
   var url = '$apiurl/crops/users/"$userId"';
  

 final response = await http.get(url, headers: headers);
// final extractedCrops = json.decode(response.body) as Map<String, dynamic>;
if(response.statusCode == 200){
  final List<dynamic> extractedCrops = json.decode(response.body);
  final List<UserCrop> loadedCrops = [];
 if(extractedCrops.length > 0){
  /*url = 'https://farmersfriend-4595f.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
 final favoriteResponse = await http.get(url);
 final dynamic favoriteData = json.decode(favoriteResponse.body);
 print(favoriteData);*/
 
 extractedCrops.forEach((dynamic cropData ){
   
     
   //print(favoriteData[cropId]);
loadedCrops.add(UserCrop(
  id: cropData['id'].toString(),
  cropId: cropData['cropId'].toString(),
  cropUserId: cropData['userId'],
  userType : cropData['userType'],
 
  ));
 
  
_usersCrops = loadedCrops;
notifyListeners();
 });
 print(response.body);
} else{
  _usersCrops = loadedCrops;
  
  
  return Container(
    child: Text('No Data'),);

}
}
  
else{
  return;
}

}

Future <void> addCropsByUser(String cropId, String email, String userType) async {
//String cropId = userCrop.cropId;
String cropUserId;
email.contains('@') ?
cropUserId = email.substring(0, email.lastIndexOf("@")) : cropUserId = email;;
  final url = '$apiurl/cropsusers/crops';
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId.json?$authToken';
 
try{
final response = await http.post(url, body: json.encode({
  'cropId' : cropId,
  'userId' : cropUserId,
  'userType': userType,
  
}),
headers: headers,
);
final dynamic newCrop = UserCrop(
cropId: cropId, 
cropUserId: cropUserId, 
userType: userType,

id: json.decode(response.body)['name']
);
_usersCrops.add(newCrop);

notifyListeners();

} catch(error){
  print(error);
throw error; 

}

}


Future<void> fetchCrops([bool filterByUser = false]) async {
  await fetchCropsByUser();
  //final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
  //var url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId.json?$authToken';
  Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
   var url = '$apiurl/crops/multiselect/$allCropsByUser';
  

 final response = await http.get(url, headers: headers);
// final extractedCrops = json.decode(response.body) as Map<String, dynamic>;
if(response.statusCode == 200){
  final List<dynamic> extractedCrops = json.decode(response.body);
  final List<Crop> loadedCrops = [];
 if(extractedCrops.length > 0){
  /*url = 'https://farmersfriend-4595f.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
 final favoriteResponse = await http.get(url);
 final dynamic favoriteData = json.decode(favoriteResponse.body);
 print(favoriteData);*/
 
 extractedCrops.forEach((dynamic cropData ){
    final String picId = userId + cropData['title'];
     var imageUrl = '$apiurl/images/$picId.jpg';
     
   //print(favoriteData[cropId]);
loadedCrops.add(Crop(
  id: cropData['id'].toString(),
  title: cropData['title'],
   otherTitle: cropData['otherTitle'],
  description: cropData['description'],
  seedingDate: DateTime.tryParse(cropData['seedingDate']).toLocal(),
  seedVariety: cropData['seedVariety'],
  farmer: cropData['farmer'],
  investor: cropData['investor'],
  cropMethod: cropData['cropMethod'],
  userId: cropData['userId'],
  area : double.parse(cropData['area'].toString()),
  totalPlants: cropData['totalPlants'].toString(),
  units: cropData['units'],
   landId: cropData['landId'],
 // price: double.parse(cropData['price'].toString()),
  imageUrl: cropData['imageUrl'],
  authToken : authToken,
  //isFavorite: favoriteData['cropId'],
  //isFavorite: favoriteData == null ? false :  favoriteData['cropId'] ?? false,
  ));
 
  
_items = loadedCrops;
notifyListeners();
 });
 print(response.body);
} else{
  _items = loadedCrops;
  
  
  return Container(
    child: Text('No Data'),);

}
}
  
else{
  return;
}

}

Future<void> fetchAndFetchCropWithLand(String landId, String type) async {
  //final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
  //var url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId.json?$authToken';
  Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
   var url = '$apiurl/crops/lands/$landId';
  

 final response = await http.get(url, headers: headers);
// final extractedCrops = json.decode(response.body) as Map<String, dynamic>;
if(response.statusCode == 200){
  final List<dynamic> extractedCrops = json.decode(response.body);
  final List<Crop> loadedCrops = [];
 if(extractedCrops.length > 0){
  /*url = 'https://farmersfriend-4595f.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
 final favoriteResponse = await http.get(url);
 final dynamic favoriteData = json.decode(favoriteResponse.body);
 print(favoriteData);*/
 
 extractedCrops.forEach((dynamic cropData ){
    final String picId = userId + cropData['title'];
     var imageUrl = '$apiurl/images/$picId.jpg';
     
   //print(favoriteData[cropId]);
loadedCrops.add(Crop(
  id: cropData['id'].toString(),
  title: cropData['title'],
   otherTitle: cropData['otherTitle'],
  description: cropData['description'],
  seedingDate: DateTime.tryParse(cropData['seedingDate']).toLocal(),
  seedVariety: cropData['seedVariety'],
  farmer: cropData['farmer'],
  investor: cropData['investor'],
  cropMethod: cropData['cropMethod'],
  userId: cropData['userId'],
  area : double.parse(cropData['area'].toString()),
  totalPlants: cropData['totalPlants'].toString(),
  units: cropData['units'],
  landId: cropData['landId'],
 // price: double.parse(cropData['price'].toString()),
  imageUrl: cropData['imageUrl'],
  authToken : authToken,
  //isFavorite: favoriteData['cropId'],
  //isFavorite: favoriteData == null ? false :  favoriteData['cropId'] ?? false,
  ));
 
  
_items = loadedCrops;
notifyListeners();
 });
 print(response.body);
} else{
  _items = loadedCrops;
  
  
  return Container(
    child: Text('No Data'),);

}
}
  
else{
  return;
}
 
 


}

Future<void> fetchCropsForSale() async {
  //final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
  //var url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId.json?$authToken';
  Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
   var url = '$apiurl/V1/forSale/crops';
  

 final response = await http.get(url, headers: headers);
// final extractedCrops = json.decode(response.body) as Map<String, dynamic>;
 if(response.statusCode == 200){
 final List<dynamic> extractedCrops = json.decode(response.body);
 final List<Crop> loadedCrops = [];
 if(extractedCrops.length > 0){
  /*url = 'https://farmersfriend-4595f.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
 final favoriteResponse = await http.get(url);
 final dynamic favoriteData = json.decode(favoriteResponse.body);
 print(favoriteData);*/
 
 extractedCrops.forEach((dynamic cropData ){
    final String picId = userId + cropData['title'];
     var imageUrl = '$apiurl/images/$picId.jpg';
    
   //print(favoriteData[cropId]);
loadedCrops.add(Crop(
  id: cropData['id'].toString(),
  title: cropData['title'],
  otherTitle: cropData['otherTitle'],
  
  description: cropData['description'],
  expectedHarvestDate: DateTime.tryParse(cropData['expectedHarvestDate']).toLocal(),
  seedVariety: cropData['seedVariety'],
  farmer: cropData['farmer'],
  investor: cropData['investor'],
  cropMethod: cropData['cropMethod'],
  userId: cropData['userId'],
  area : double.parse(cropData['area'].toString()),
  units: cropData['units'],
  salesUnits: cropData['salesUnits'],
  quantityUnits: cropData['quantityUnits'],
  quantityForSale: cropData['quantityForSale'],
  location: cropData['location'],
  price: double.parse(cropData['price'].toString()),
  imageUrl: cropData['imageUrl'],
 forSale: cropData['forSale'],
  authToken : authToken,
  //isFavorite: favoriteData['cropId'],
  //isFavorite: favoriteData == null ? false :  favoriteData['cropId'] ?? false,
  ));
 
  
_items = loadedCrops;
notifyListeners();
 });
 print(response.body);
} else{
  _items = loadedCrops;
  
  
  return Container(
    child: Text('No Data'),);

}
 }


}

Future<void> fetchUserCropsForSale() async {
  //final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
  //var url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId.json?$authToken';
  Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
   var url = '$apiurl/V1/forSale/crops/"$userId"';
  

 final response = await http.get(url, headers: headers);
// final extractedCrops = json.decode(response.body) as Map<String, dynamic>;
 if(response.statusCode == 200){
 final List<dynamic> extractedCrops = json.decode(response.body);
 final List<Crop> loadedCrops = [];

    
 if(extractedCrops.length > 0){
  /*url = 'https://farmersfriend-4595f.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
 final favoriteResponse = await http.get(url);
 final dynamic favoriteData = json.decode(favoriteResponse.body);
 print(favoriteData);*/
 
 extractedCrops.forEach((dynamic cropData ){
    final String picId = userId + cropData['title'];
     var imageUrl = '$apiurl/images/$picId.jpg';
    
     
   //print(favoriteData[cropId]);
loadedCrops.add(Crop(
  id: cropData['id'].toString(),
  title: cropData['title'],
  otherTitle: cropData['otherTitle'],
  description: cropData['description'],
  expectedHarvestDate: DateTime.tryParse(cropData['expectedHarvestDate']).toLocal(),
  seedVariety: cropData['seedVariety'],
  farmer: cropData['farmer'],
  investor: cropData['investor'],
  cropMethod: cropData['cropMethod'],
  userId: cropData['userId'],
  area : double.parse(cropData['area'].toString()),
  units: cropData['units'],
  salesUnits: cropData['salesUnits'],
  quantityUnits: cropData['quantityUnits'],
  quantityForSale: cropData['quantityForSale'],
  location: cropData['location'],
  price: double.parse(cropData['price'].toString()),
  imageUrl: cropData['imageUrl'],
  authToken : authToken,
  forSale: cropData['forSale'],
  //isFavorite: favoriteData['cropId'],
  //isFavorite: favoriteData == null ? false :  favoriteData['cropId'] ?? false,
  ));
 
  
_items = loadedCrops;
notifyListeners();
 });
 print(response.body);
} else{
  _items = loadedCrops;
  
  
  return Container(
    child: Text('No Data'),);

}
 }


}



Future <void> addCrop(Crop crop) async {

String userType = 'Admin';
  final url = '$apiurl/crops';
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId.json?$authToken';
 String picName = crop.userId + crop.title + crop.otherTitle;;
final String imageUrl = '$apiurl/images/$userId/$picName.jpg';
try{
final response = await http.post(url, body: json.encode({
  'title' : crop.title,
  'otherTitle' : crop.otherTitle,
  'description': crop.description,
  'farmer' : crop.farmer,
  'seedVariety': crop.seedVariety,
  'investor' : crop.investor,
  'area': crop.area,
  'imageUrl' : crop.imageUrl,
  'cropMethod' :crop.cropMethod,
  'totalPlants' :crop.totalPlants,
  'price': crop.price,
  'seedingDate' :crop.seedingDate.toIso8601String(),
  'isFavorite': crop.isFavorite,
  'landId' : crop.landId,
  'units' : crop.units,
  'userId' : userId,
  
}),
headers: headers,
);
final dynamic newCrop = Crop(
title: crop.title, 
otherTitle: crop.otherTitle, 
description: crop.description,
seedingDate: crop.seedingDate,
seedVariety: crop.seedVariety,
farmer: crop.farmer,
investor: crop.investor, 
cropMethod: crop.cropMethod,
price: crop.price,
area: crop.area,
units: crop.units,
userId: crop.userId,
landId: crop.landId,
imageUrl: crop.imageUrl,
id: json.decode(response.body)['cropInsId'].toString()
);
_items.add(newCrop);

notifyListeners();
await addCropsByUser(newCrop.id, userId, userType);
} catch(error){
  print(error);
throw error; 

}

}



Future <void> anounseCropSale(Crop crop) async {

  //String imageUrl;

 String picName = crop.userId + crop.title + 'forsale' ;;
 
 //crop.imageUrl.isEmpty ? imageUrl = '$apiurl/images/$picName.jpg' : imageUrl = crop.imageUrl;
final String imageUrl = '$apiurl/images/$userId/$picName.jpg';
  final url = '$apiurl/V1/forSale/crops';
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId.json?$authToken';

 
try{
  
 

final response = await http.post(url, body: json.encode({
  'title' : crop.title,
  'otherTitle' : crop.otherTitle,
  'description': crop.description,
  'farmer': crop.farmer,
  'investor': crop.investor,
  'seedVariety': crop.seedVariety,
  'area': crop.area,
  'imageUrl' : imageUrl,
  'cropMethod' :crop.cropMethod,
  'price': crop.price,
  'quantityForSale': crop.quantityForSale,
  'quantityUnits': crop.quantityUnits,
  'expectedHarvestDate' :crop.expectedHarvestDate.toIso8601String(),
  'isFavorite': crop.isFavorite,
  'units' : crop.units,
  'salesUnits' : crop.salesUnits,
  'userId' : userId,
  'location' : crop.location,
  'forSale':1,
}),
headers: headers,
);
final dynamic newCrop = Crop(
title: crop.title, 
otherTitle: crop.otherTitle, 
description: crop.description,
expectedHarvestDate: crop.expectedHarvestDate,
seedVariety: crop.seedVariety,
cropMethod: crop.cropMethod,
price: crop.price,
area: crop.area,
units: crop.units,
salesUnits: crop.salesUnits,
userId: crop.userId,
imageUrl: crop.imageUrl,
forSale:crop.forSale,
location:crop.location,
id: json.decode(response.body)['name']
);
_items.add(newCrop);

notifyListeners();

} catch(error){
  print(error);
throw error; 

}

}

void updateCropForSale(String id, Crop newCrop) async {

  final cropId = newCrop.id;
  final cropIndex = _items.indexWhere((crop) => crop.id == id);
  if(cropIndex >= 0){
  //Firbase url
  // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
  //local Sql
   Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/V1/forSale/crops/$id';
   String picName = newCrop.userId + newCrop.title + 'forsale' ;;
   final String imageUrl = '$apiurl/images/$userId/$picName.jpg';
    final response = await http.put(url, body: json.encode({
      'id':newCrop.id,
      'title': newCrop.title,
      'otherTitle': newCrop.otherTitle,
      'description': newCrop.description,
      'seedVariety': newCrop.seedVariety,
      'farmer' : newCrop.farmer,
      'investor' :newCrop.investor,
      'totalPlants' :newCrop.totalPlants,
      'cropMethod' :newCrop.cropMethod,
      'price' : newCrop.price,
      'area' : newCrop.area,
      'quantityForSale' : newCrop.quantityForSale,
      'quantityUnits' : newCrop.quantityUnits,
      'units' : newCrop.units,
      'salesUnits' : newCrop.salesUnits,
      'userId' : userId,
      'location' : newCrop.location,
      'expectedHarvestDate' :newCrop.expectedHarvestDate.toIso8601String(),
      'imageUrl': imageUrl,
      //'price': newCrop.price.toDouble(),

    }),
    headers: headers,
    );
    _items[cropIndex] = newCrop;
    notifyListeners();
    print(response.body);
  }else{
    print('...');

  }
}

void updateCropForSaleStatus(String title, String id,  bool status) async {

  final cropId = id;
  final cropIndex = _items.indexWhere((crop) => crop.id == id);
  if(cropIndex >= 0){
  //Firbase url
  // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
  //local Sql
   Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/V1/forSale/crops/statusUpdate/$id';
   
    final response = await http.put(url, body: json.encode({
      'id':cropId,
      'forSale': status,
      'title' : title
      //'price': newCrop.price.toDouble(),

    }),
    headers: headers,
    );
    
    print(response.body);
  }else{
    print('...');

  }
}

Future<List<Crop>> fetchCropsForInvestments(String crop) async {
   Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
   var url = '$apiurl/V1/forInvestment/crops';
  

 final response = await http.get(url, headers: headers);
// final extractedCrops = json.decode(response.body) as Map<String, dynamic>;
if(response.statusCode == 200){
  final List<dynamic> extractedCrops = json.decode(response.body);
  final List<Crop> loadedCrops = [];
 if(extractedCrops.length > 0){
  /*url = 'https://farmersfriend-4595f.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
 final favoriteResponse = await http.get(url);
 final dynamic favoriteData = json.decode(favoriteResponse.body);
 print(favoriteData);*/
 
 extractedCrops.forEach((dynamic cropData ){
   
     
   //print(favoriteData[cropId]);
loadedCrops.add(Crop(
  id: cropData['id'].toString(),
  cropId: cropData['cropId'].toString(),
  userId: cropData['userId'],
  title: cropData['title'],
  description: cropData['description'],
  seedVariety: cropData['seedVariety'],
  farmer : cropData['farmer'],
  cropMethod : cropData['cropMethod'],
  location: cropData['location'],
  area: double.parse(cropData['area'].toString()),
  units: cropData['units'],
  investmentNeeded:  double.parse(cropData['investmentNeeded'].toString()),
  expectedTotalCropCost: double.parse(cropData['expectedTotalCropCost'].toString()),
  expectedHarvestDate:DateTime.tryParse( cropData['expectedHarvestDate']).toLocal(),
  seedingDate: DateTime.tryParse(cropData['seedingDate']).toLocal(),
  otherTitle: cropData['otherTitle'],
  imageUrl: cropData['imageUrl'],

 
  ));
 
  
_cropInvestments = loadedCrops;
notifyListeners();
 });
 
} else{
  _cropInvestments = loadedCrops;
  
  
}
return loadedCrops;
}
  


}

Future <void> anounseCropforInvestment(Crop crop) async {

  //String imageUrl;

 String picName = crop.userId + crop.title + 'forInvestment' ;;
 
 //crop.imageUrl.isEmpty ? imageUrl = '$apiurl/images/$picName.jpg' : imageUrl = crop.imageUrl;
final String imageUrl = '$apiurl/images/$userId/$picName.jpg';
  final url = '$apiurl/V1/forInvestment/crops';
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId.json?$authToken';

 
try{
  
 

final response = await http.post(url, body: json.encode({
  'title' : crop.title,
  'otherTitle' : crop.otherTitle,
  'description': crop.description,
  'farmer': crop.farmer,
  'seedVariety': crop.seedVariety,
  'area': crop.area,
  'imageUrl' : imageUrl,
  'cropMethod' :crop.cropMethod,
  'expectedHarvestDate' :crop.expectedHarvestDate.toIso8601String(),
  'seedingDate' :crop.seedingDate.toIso8601String(),
  'isFavorite': crop.isFavorite,
  'units' : crop.units,
  'userId' : userId,
  'location' : crop.location,
  'investmentNeeded' : crop.investmentNeeded,
  'expectedTotalCropCost' : crop.expectedTotalCropCost,
  'cropId' : crop.cropId,
  'seekInvestment':1,
}),
headers: headers,
);
final dynamic newCrop = Crop(
title: crop.title, 
otherTitle: crop.otherTitle, 
description: crop.description,
expectedHarvestDate: crop.expectedHarvestDate,
seedingDate: crop.seedingDate,
seedVariety: crop.seedVariety,
cropMethod: crop.cropMethod,
area: crop.area,
units: crop.units,
userId: crop.userId,
imageUrl: crop.imageUrl,
seekInvestment:crop.seekInvestment,
location:crop.location,
investmentNeeded:crop.investmentNeeded,
expectedTotalCropCost:crop.expectedTotalCropCost,
cropId:crop.cropId,
id: json.decode(response.body)['name']
);
_items.add(newCrop);

notifyListeners();

} catch(error){
  print(error);
throw error; 

}

}

void updateCropforInvestment(String id, Crop newCrop) async {

  final cropId = newCrop.id;
  final cropIndex = _items.indexWhere((crop) => crop.id == id);
  if(cropIndex >= 0){
  //Firbase url
  // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
  //local Sql
   Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/V1/forInvestment/crops/$id';
   String picName = newCrop.userId + newCrop.title + 'forInvestment' ;;
   final String imageUrl = '$apiurl/images/$userId/$picName.jpg';
    final response = await http.put(url, body: json.encode({
      'id':newCrop.id,
      'title': newCrop.title,
      'otherTitle': newCrop.otherTitle,
      'description': newCrop.description,
      'seedVariety': newCrop.seedVariety,
      'farmer' : newCrop.farmer,
      'cropMethod' :newCrop.cropMethod,
      'area' : newCrop.area,
     'units' : newCrop.units,
      'investmentNeeded' : newCrop.investmentNeeded,
      'expectedTotalCropCost' : newCrop.expectedTotalCropCost,
      'userId' : userId,
      'location' : newCrop.location,
      'expectedHarvestDate' :newCrop.expectedHarvestDate.toIso8601String(),
      'seedingDate' :newCrop.seedingDate.toIso8601String(),
      'imageUrl': imageUrl,
       'cropId': cropId,
        
      //'price': newCrop.price.toDouble(),

    }),
    headers: headers,
    );
    _items[cropIndex] = newCrop;
    notifyListeners();
    print(response.body);
  }else{
    print('...');

  }
}

void updateCropForInvestmentStatus(String title, String id,  bool status) async {

  final cropId = id;
  final cropIndex = _items.indexWhere((crop) => crop.id == id);
  if(cropIndex >= 0){
  //Firbase url
  // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
  //local Sql
   Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/V1/forInvestment/crops/statusUpdate/$id';
   
    final response = await http.put(url, body: json.encode({
      'id':cropId,
      'seekInvestment': status,
      'title' : title
      //'price': newCrop.price.toDouble(),

    }),
    headers: headers,
    );
    
    print(response.body);
  }else{
    print('...');

  }
}
void updateCrop(String id, Crop newCrop) async {

  final cropId = newCrop.id;
  final cropIndex = _items.indexWhere((crop) => crop.id == id);
  if(cropIndex >= 0){
  //Firbase url
  // final url = 'https://farmersfriend-4595f.firebaseio.com/crops/$userId/$id.json?$authToken';
  //local Sql
   Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/crops/$id';
  String picName = newCrop.userId + newCrop.title + newCrop.otherTitle + newCrop.id;
   final String imageUrl = '$apiurl/images/$userId/$picName.jpg';
    final response = await http.put(url, body: json.encode({
      'id':newCrop.id,
      'title': newCrop.title,
      'otherTitle': newCrop.otherTitle,
      'description': newCrop.description,
      'seedVariety': newCrop.seedVariety,
      'farmer' : newCrop.farmer,
      'investor' :newCrop.investor,
      'totalPlants' :newCrop.totalPlants,
      'cropMethod' :newCrop.cropMethod,
      'area' : newCrop.area.toDouble(),
      'units' : newCrop.units,
      'userId' : newCrop.userId,
      'seedingDate':newCrop.seedingDate.toIso8601String(),
      'imageUrl': newCrop.imageUrl,
      'landId' : newCrop.landId,
      //'price': newCrop.price.toDouble(),

    }),
    headers: headers,
    );
    _items[cropIndex] = newCrop;
    notifyListeners();
    print(response.body);
  }else{
    print('...');

  }
}

void patchCrop(String cropId, String email, String userType) async {

  String userId = email.substring(0, email.lastIndexOf("@"));;
  String id = cropId;
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
    final url = '$apiurl/crops/$id';
  
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

void deleteCrop(String id) async {
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
_items.removeWhere((crop) => crop.id == id);
final url = '$apiurl/crops/$id';
    final response = await http.delete(url, headers: headers);
notifyListeners();
print(response.body);

} 

void deleteUserCropSale(String id) async {
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
_items.removeWhere((crop) => crop.id == id);
final url = '$apiurl/V1/forSale/crops/$id';
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

