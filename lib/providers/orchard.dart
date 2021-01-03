
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Orchard with ChangeNotifier{

final String id;
String title;
String otherTitle;
final String description;
final String farmer;
String variety;
String cropMethod;
DateTime plantingDate;
DateTime expectedHarvestDate;
final String investor;
final double area;
String units;
String salesUnits;
double totalPlants;
final double price;
String imageUrl;
final String userId;
bool isFavorite;
String cropIdCrop;
String cropIdOrch;
String location;
bool forSale;
final farmType = 'orchards';


Orchard({
  
  @required this.id,  
  @required this.title, 
  this.otherTitle, 
  @required this.description,  
  @required this.farmer,  
  this.cropMethod,
  @required this.area,
  @required this.units,
  this.salesUnits,
  this.investor,
  this.totalPlants,
  this.variety,
  @required this.plantingDate,
  this. expectedHarvestDate,
  this.imageUrl,
  this.price,  
  @required this.userId,  
  this.cropIdCrop,
  this.cropIdOrch,
  this.location,
  this.forSale = false,
  this.isFavorite = false,
});

void _setFavValue(bool newValue){
  isFavorite = newValue;
   notifyListeners();
}

Future<void> toggleFavoriteStatus(String token, String userId)async {

  final oldStatus = isFavorite;
  isFavorite = !isFavorite;
  notifyListeners();
  
  //final url = 'https://farmersfriend-4595f.firebaseio.com/products/$id.json?auth=$token';
  final url = 'https://farmersfriend-4595f.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
  
  try{

final response = await http.put(
  url, 
  body: json.encode({'isFavorite':isFavorite},));
print(response.statusCode);
print(response.body);
if(response.statusCode >= 400){
_setFavValue(oldStatus);
}print(response.body);
  }catch(error)
  {
  _setFavValue(oldStatus);
  }

}
  
}