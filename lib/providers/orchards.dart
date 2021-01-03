

import 'package:flutter/material.dart';
import 'auth.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import './orchard.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Orchards with ChangeNotifier {
  //final apiurl = 'http://api.happyfarming.net:5000';
   final apiurl = 'http://192.168.39.190:5000';
// holds the orchards.
  List<Orchard> _items = [];

  // var _showFavoritesOnly = false;
  String authToken;
  final String userId;

  Orchards(this.authToken, this.userId, this._items);

//copy of the orchards
  List<Orchard> get items {
    /* /* if(_showFavoritesOnly){
    return items.where((prodItem) => prodItem.isFavorite).toList(); */
  } */
    return [..._items];
  }

  List<Orchard> get favortieItems {
    return _items.where((orchardItem) => orchardItem.isFavorite).toList();
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
  Orchard findById(String id) {
    return _items.firstWhere((orchard) => orchard.id == id);
  }

  Future<void> fetchOrchards([bool filterByUser = false]) async {
    //final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
    var url = '$apiurl/orchads/users/"$userId"';
    //var url = 'https://farmersfriend-4595f.firebaseio.com/orchards/$userId.json?$authToken';

    
      final response = await http.get(url, headers: headers);
      if(response.statusCode == 200){
      final List<dynamic> extractedOrchards = json.decode(response.body);
      final List<Orchard> loadedOrchards = [];
      if (extractedOrchards.length > 0) {
        
     /*  url =
          'https://farmersfriend-4595f.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final dynamic favoriteData = json.decode(favoriteResponse.body);
      print(favoriteData); */

      extractedOrchards.forEach((dynamic orchardData) {
        //final String picId = userId + orchardData['title'];
        //var imageUrl = '$apiurl/images/$picId.jpg';
        loadedOrchards.add(Orchard(
          id: orchardData['id'].toString(),
          title: orchardData['title'],
          otherTitle: orchardData['otherTitle'],
           farmer: orchardData['farmer'],
           investor: orchardData['investor'],
           userId: orchardData['userId'],
          description: orchardData['description'],
          area: double.parse(orchardData['area'].toString()),
          units: orchardData['units'],
          totalPlants: double.parse(orchardData['totalPlants'].toString()),
          variety: orchardData['variety'],
          plantingDate: DateTime.parse(orchardData['plantingDate']).toLocal(),
          expectedHarvestDate:
          DateTime.parse(orchardData['expectedHarvestDate']).toLocal(),
          price: double.parse(orchardData['price'].toString()),
          imageUrl: orchardData['imageUrl'],
          //isFavorite: favoriteData['prodId'],
          /* isFavorite:
              favoriteData == null ? false : favoriteData['orchardId'] ?? false, */
        ));

        _items = loadedOrchards;
        notifyListeners();
      });
      print(response.body);
    } else{
  _items = loadedOrchards;
  
  
  return Container(
    child: Text('No Data'),);

}}
  
else{
  return;
}
 
 


}

Future<void> fetchOrchardsForSale() async {
    //final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
    var url = '$apiurl/V1/forSale/orchads';
    //var url = 'https://farmersfriend-4595f.firebaseio.com/orchards/$userId.json?$authToken';

    
      final response = await http.get(url, headers: headers);
      if(response.statusCode == 200){
      final List<dynamic> extractedOrchards = json.decode(response.body);
      final List<Orchard> loadedOrchards = [];
      if (extractedOrchards.length > 0) {
        
     /*  url =
          'https://farmersfriend-4595f.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final dynamic favoriteData = json.decode(favoriteResponse.body);
      print(favoriteData); */

      extractedOrchards.forEach((dynamic orchardData) {
        //final String picId = userId + orchardData['title'];
        //var imageUrl = '$apiurl/images/$picId.jpg';
        loadedOrchards.add(Orchard(
          id: orchardData['id'].toString(),
          title: orchardData['title'],
          otherTitle: orchardData['otherTitle'],
           farmer: orchardData['farmer'],
           investor: orchardData['investor'],
           userId: orchardData['userId'],
          description: orchardData['description'],
          area: double.parse(orchardData['area'].toString()),
          units: orchardData['units'],
          totalPlants: double.parse(orchardData['totalPlants'].toString()),
          variety: orchardData['variety'],
          plantingDate: DateTime.parse(orchardData['plantingDate']).toLocal(),
          expectedHarvestDate:
          DateTime.parse(orchardData['expectedHarvestDate']).toLocal(),
          price: double.parse(orchardData['price'].toString()),
          imageUrl: orchardData['imageUrl'],
          //isFavorite: favoriteData['prodId'],
          /* isFavorite:
              favoriteData == null ? false : favoriteData['orchardId'] ?? false, */
        ));

        _items = loadedOrchards;
        notifyListeners();
      });
      print(response.body);
    } else{
  _items = loadedOrchards;
  
  
  return Container(
    child: Text('No Data'),);

}}
  
else{
  return;
}
 
 


}

  Future<void> addOrchard(Orchard orchard) async {
    final url = '$apiurl/orchads';
    Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/orchards/$userId.json?$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': orchard.title,
          'description': orchard.description,
          'otherTitle': orchard.otherTitle,
          'area': orchard.area,
          'units': orchard.units,
          'farmer': orchard.farmer,
          'investor': orchard.investor,
          'cropMethod': orchard.cropMethod,
          'totalPlants': orchard.totalPlants,
          'variety': orchard.variety,
          'expectedHarvestDate': orchard.expectedHarvestDate.toIso8601String(),
          'plantingDate': orchard.plantingDate.toIso8601String(),
          'price': orchard.price,
          'isFavorite': orchard.isFavorite,
          'userId': userId,
          'imageUrl': orchard.imageUrl,
        }),
        headers: headers,
      );
      final newOrchard = Orchard(
          title: orchard.title,
          otherTitle: orchard.otherTitle,
          description: orchard.description,
          area: orchard.area,
          farmer: orchard.farmer,
          cropMethod: orchard.cropMethod,
          units: orchard.units,
          totalPlants: orchard.totalPlants,
          variety: orchard.variety,
          plantingDate: orchard.plantingDate,
          expectedHarvestDate: orchard.expectedHarvestDate,
          price: orchard.price,
          imageUrl: orchard.imageUrl,
          userId: orchard.userId,
          id: json.decode(response.body)['name']);
      _items.add(newOrchard);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> anounseOrchardSale(Orchard orchard) async {
    final url = '$apiurl/V1/forSale/orchads';
    Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/orchards/$userId.json?$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': orchard.title,
          'description': orchard.description,
          'otherTitle': orchard.otherTitle,
          'area': orchard.area,
          'units': orchard.units,
          'salesUnits': orchard.salesUnits,
          'farmer': orchard.farmer,
          'location': orchard.location,
          'investor': orchard.investor,
          'cropMethod': orchard.cropMethod,
          'totalPlants': orchard.totalPlants,
          'variety': orchard.variety,
          'expectedHarvestDate': orchard.expectedHarvestDate.toIso8601String(),
          'plantingDate': orchard.plantingDate.toIso8601String(),
          'price': orchard.price,
          'isFavorite': orchard.isFavorite,
          'userId': userId,
          'imageUrl': orchard.imageUrl,
          'forSale':1,
        }),
        headers: headers,
      );
      final newOrchard = Orchard(
          title: orchard.title,
          otherTitle: orchard.otherTitle,
          description: orchard.description,
          area: orchard.area,
          location: orchard.location,
          farmer: orchard.farmer,
          cropMethod: orchard.cropMethod,
          units: orchard.units,
          totalPlants: orchard.totalPlants,
          salesUnits: orchard.salesUnits,
          variety: orchard.variety,
          plantingDate: orchard.plantingDate,
          expectedHarvestDate: orchard.expectedHarvestDate,
          price: orchard.price,
          imageUrl: orchard.imageUrl,
          userId: orchard.userId,
          forSale:orchard.forSale,
          id: json.decode(response.body)['name']);
      _items.add(newOrchard);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void updateOrchard(String id, Orchard newOrchard) async {
    final orchardIndex = _items.indexWhere((orchard) => orchard.id == id);
    if (orchardIndex >= 0) {
      // final url = 'https://farmersfriend-4595f.firebaseio.com/orchards/$userId/$id.json?$authToken';

       Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
      final url = '$apiurl/orchads/$id';
      final response = await http.put(
        url,
        body: json.encode({
          'id':newOrchard.id,
          'otherTitle': newOrchard.otherTitle,
          'title': newOrchard.title,
          'farmer': newOrchard.farmer,
          'investor': newOrchard.investor,
          'description': newOrchard.description,
          'area': newOrchard.area,
          'units': newOrchard.units,
          'totalPlants': newOrchard.totalPlants,
          'variety': newOrchard.variety,
          'userId' : newOrchard.userId,
          'expectedHarvestDate':  newOrchard.expectedHarvestDate.toIso8601String(),
          'plantingDate': newOrchard.plantingDate.toIso8601String(),
          'imageUrl': newOrchard.imageUrl,
          'price': newOrchard.price,
        }),
        headers: headers,
        
      );
      _items[orchardIndex] = newOrchard;
      notifyListeners();
      
    } else {
      print('...');
    }
  }

  void deleteOrchard(String id) async {
     Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    _items.removeWhere((orchard) => orchard.id == id);
    final url = '$apiurl/orchads/$id';
    final response = await http.delete(url, headers: headers);
    notifyListeners();
  }

  void update(String frvalue) {
    if (frvalue == this.authToken) return;
    this.authToken = frvalue;
    // do some requests
  }
}
