import 'package:flutter/cupertino.dart';
import '../providers/crop.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import './apiClass.dart';

class  FertiPestiItemNew {
final String id;
final String cropId;
final String orchId;
final String type;
final String description;
DateTime date;
final double amount;
String units;
final String workerName;
final String brand;
final dynamic cType;


  FertiPestiItemNew({
  @required this.id,  
  @required this.cropId,
  this.orchId,
  @required this.type, 
  @required this.description,
  @required this.workerName,
  @required this.date,
  this.cType,
  
  @required this.amount,  
  @required this.units,
  this.brand
   });

   factory FertiPestiItemNew.fromJson(Map<String, dynamic> fertilizer){
    return 

       FertiPestiItemNew(
      //id: json['id'],
      id: fertilizer['fertilizerID'],
      description: fertilizer['description'],
      cropId: fertilizer['cropId'],
      orchId: fertilizer['orchId'],
      type: fertilizer['type'],
      workerName: fertilizer['workerName'],
      amount: fertilizer['amount'],
      units: fertilizer['units'],
      date: DateTime.parse(fertilizer['date']),
    ); 
  }


  
}



class FertiPestis with ChangeNotifier{

 final apiurl = AppApi.api;

List<FertiPestiItemNew> _items = [];
 /* List<CropExpenseItem> _cropExpenses = [];  */
   String authToken;
  final String userId;

  FertiPestis(this.authToken, this.userId, this._items);

  double get totalAmount{
    var total = 0.0;

    _items.forEach((FertiPestiItemNew expenseItemNew){

      total += expenseItemNew.amount;
    },);
   
   return total;
  }


List<FertiPestiItemNew> get items{

return [..._items];
}

FertiPestiItemNew findById( String id){

return _items.firstWhere((ferti) => ferti.id == id);
}



//@JsonSerializable(explicitToJson: true)
Future<void> fetchAndSetCropFertilizers(String cropId, dynamic type)  async{
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
    //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/fertilizers.json?$authToken';
  var url = '$apiurl/fertilizers/$type/$cropId'; 
 
 final response = await http.get(url, headers: headers);
 
 final List<dynamic> fetiPestisMap = jsonDecode(response.body);
  final List<FertiPestiItemNew> loadedFertlizers = [];

if(fetiPestisMap.length > 0){
  
 
fetiPestisMap.forEach((dynamic fertiPestiData){
  loadedFertlizers.add(FertiPestiItemNew(

    id:fertiPestiData['fertilizerID'].toString(),
    cropId: fertiPestiData['cropId'].toString(),
    orchId: fertiPestiData['orchId'].toString(),
    description: fertiPestiData['description'],
    type: fertiPestiData['type'],
    workerName: fertiPestiData['workerName'],
    units: fertiPestiData['units'],
    amount: double.parse(fertiPestiData['amount'].toString()),
    brand: fertiPestiData['brand'],
   date: DateTime.parse(fertiPestiData['date']).toLocal(),
    
    ),
    );

_items = loadedFertlizers;
notifyListeners();
});
 
}

else{
  _items = loadedFertlizers;
  
  
  return Container(
    child: Text('No Data'),);
}
//print(_items);
}
Future <void> addFertilizer(FertiPestiItemNew ferti, ) async {
  
final url = '$apiurl/fertilizers';
 Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/fertilizers.json?$authToken';
try{
final response = await http.post(url, body: json.encode({


 'cropId' :ferti.cropId,
 'orchId' :ferti.orchId,
  'type' : ferti.type,
  'description': ferti.description,
  'amount' : ferti.amount,
  'units': ferti.units,
  'workerName' : ferti.workerName, 
  'brand' : ferti.brand, 
  'date' : ferti.date.toIso8601String(), 
    
  }),
   headers: headers,
   );
final dynamic newFertiItems = FertiPestiItemNew(
cropId: ferti.cropId,
orchId: ferti.orchId,
type: ferti.type,
description: ferti.description,
date: ferti.date,
amount: ferti.amount,
workerName: ferti.workerName,  
brand: ferti.brand, 
units: ferti.units,

id: json.decode(response.body)['name']
);
_items.add(newFertiItems);
print(response);

notifyListeners();

} catch(error){
  print(error);
throw error; 

}

}

void updateFertilizer(String id, FertiPestiItemNew newFerti) async {

  final  fertilizerId = newFerti.id;
  
  
  final fertiIndex = _items.indexWhere((expense) => expense.id == fertilizerId);
  if(fertiIndex >= 0){
    Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
  // var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/fertilizers/$fertiId.json?$authToken';
    
    final url = '$apiurl/fertilizers/$fertilizerId';
    final response = await http.put(url, body: json.encode({
     
      'fertilizerID':fertilizerId,
      'cropId':newFerti.cropId,
      'orchId':newFerti.orchId,
      'type': newFerti.type,
      'description': newFerti.description,
      'amount' : newFerti.amount.toDouble(),
      'units': newFerti.units,
      'workerName' :newFerti.workerName,
      'brand' :newFerti.brand,
      'date' : newFerti.date.toIso8601String(), 
       
         

    }),
    headers: headers,);
    _items[fertiIndex] = newFerti;
    notifyListeners();
    print(response.body);
  }else{
    print('...');

  }
}

void deleteFertilizer(String fertilizerId)async {
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
_items.removeWhere((ferti) => ferti.id == fertilizerId);
final url = '$apiurl/fertilizers/$fertilizerId';
    final response = await http.delete(url, headers: headers,);

notifyListeners();

}

void update(String frvalue) {
  if (frvalue == this.authToken) return;
  this.authToken = frvalue;
  // do some requests
}

}
 

