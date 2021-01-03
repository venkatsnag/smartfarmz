import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Crop with ChangeNotifier{

final String id;
String title;
String otherTitle;
final String description;
final String farmer;
String seedVariety;
String cropMethod;
DateTime seedingDate;
DateTime expectedHarvestDate;
final String investor;
final double area;
String units;
String salesUnits;
String totalPlants;
String authToken;
final double price;
String imageUrl;
final String userId;
final String location;
bool isFavorite;
int forSale;
String farmType;
String quantityForSale;
String quantityUnits;
int landId;
int seekInvestment;
String cropId;
double investmentNeeded;
double expectedTotalCropCost;


Crop({
  
   
  @required this.id,  
  @required this.title, 
  this.totalPlants,
  this.otherTitle, 
  this.farmer,
  this.investor,
  @required this.description, 
  @required this.cropMethod,
  @required this.area,
  this.seedVariety,
 this.seedingDate,
 this. expectedHarvestDate,
  this.imageUrl,
  this.location,
   this.authToken,
  this.price,  
  @required this.units,
  this.salesUnits,
  @required this.userId,
  this.farmType,
  this.quantityForSale,
   this.quantityUnits,
  this.isFavorite = false,
  this.forSale,
  this.landId,
  this.seekInvestment,
  this.investmentNeeded,
  this.expectedTotalCropCost,
  this.cropId,
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
  final url = 'https://farmersfriend-4595f.firebaseio.com/userFavorites/$id.json?auth=$token';
  
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