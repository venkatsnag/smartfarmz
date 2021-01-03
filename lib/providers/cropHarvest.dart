import 'package:flutter/cupertino.dart';
import '../providers/crop.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import './apiClass.dart';

class  CropHarvestItemNew {
final String id;
final String cropId;
final String description;
final String totalOutput;
String units;
final String supervisorName;
final String totalWorkers;
DateTime harvestDate;
String cropIdCrop;
String cropIdOrch;
String cropIdLand;

  CropHarvestItemNew({
  @required this.id,  
  this.cropId,
  @required this.totalOutput, 
  this.description,
  @required this.supervisorName,
  @required this.harvestDate,
  this.units,
  this.totalWorkers,
  this.cropIdCrop,
  this.cropIdOrch,
  this.cropIdLand,
  
   });



  
}



class CropHarvest with ChangeNotifier{


final apiurl = AppApi.api;
List<CropHarvestItemNew> _items = [];
 /* List<CropExpenseItem> _cropExpenses = [];  */
 String authToken;
  final String userId;

  CropHarvest(this.authToken, this.userId, this._items);

/*   double get totalAmount{
    var total = 0.0;

    _items.forEach((CropHarvestItemNew expenseItemNew){

      total += expenseItemNew.amount;
    },);
   
   return total;
  } */

/* String get previousCrop{
    var preCropId = '';

    _items.forEach((CropExpenseItemNew expenseItemNew){

      preCropId = expenseItemNew.cropId;
    },);
   
   return preCropId;
  } */
 
List<CropHarvestItemNew> get items{

return [..._items];
}

CropHarvestItemNew findById( String id){

return _items.firstWhere((harvest) => harvest.id == id);
}



//@JsonSerializable(explicitToJson: true)
Future<void> fetchAndSetCropHarvest(String cropId, String type)  async{
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
  final url = '$apiurl/harvest/$type/$cropId';
   //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
    //final url = 'https://farmersfriend-4595f.firebaseio.com/albums/$authName/$name.json';
 final response = await http.get(url, headers: headers);
  
 final List<dynamic> harvestMap = jsonDecode(response.body) ;
  final List<CropHarvestItemNew> loadedHarvest = [];
  if(harvestMap.length > 0){
harvestMap.forEach((dynamic harvestData){
  loadedHarvest.add(CropHarvestItemNew(

    id:harvestData['harvestID'].toString(),
    cropId: harvestData['cropId'].toString(),
    description: harvestData['description'],
    totalOutput: harvestData['totalOutput'],
    units: harvestData['units'],
    supervisorName: harvestData['supervisorName'],
    totalWorkers: harvestData['totalWorkers'],
    harvestDate: DateTime.parse(harvestData['harvestDate']).toLocal(),
    
    ),
    );

//print('Howdy, description ${expenseData['cropId']}!');



_items = loadedHarvest;
notifyListeners();

});
  }
  else {
  
  _items = loadedHarvest;
  
 
}

}
Future <void> addHarvest(CropHarvestItemNew harvest, ) async {
  
 /* final dynamic type = expense.type;
final cropId = expense.cropId;
 */
final url = '$apiurl/harvest';
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
try{
final response = await http.post(url, body: json.encode({


 'cropId' :harvest.cropId,
 'description': harvest.description,
 'totalOutput' :harvest.totalOutput,
 'units' :harvest.units,
 'supervisorName' :harvest.supervisorName,
 'totalWorkers' :harvest.totalWorkers,
 'harvestDate' : harvest.harvestDate.toIso8601String(), 
    //'seedingDate' :crop.seedingDate,
  }),
  headers: headers,
  );
final dynamic newHarvestItems = CropHarvestItemNew(
cropId: harvest.cropId,
description: harvest.description,
totalOutput: harvest.totalOutput,
units: harvest.units,
supervisorName: harvest.supervisorName,
totalWorkers: harvest.totalWorkers,
harvestDate: harvest.harvestDate, 

id: json.decode(response.body)['name']
);
_items.add(newHarvestItems);
print(response);

notifyListeners();

} catch(error){
  print(error);
throw error; 

}

}

void updateHarvest(String id, CropHarvestItemNew newHarvest, ) async {

  final harvestId = newHarvest.id;
 
  
  final harvestIndex = _items.indexWhere((harvest) => harvest.id == id);
  if(harvestIndex >= 0){
   //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses/$expenseId.json?$authToken';
Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/harvest/$harvestId';
    final response = await http.patch(url, body: json.encode({

     // 'id':harvestId,
      'harvestID':newHarvest.id,
      'cropId':newHarvest.cropId,
      'totalOutput': newHarvest.totalOutput,
      'description': newHarvest.description,
      'units' : newHarvest.units,
      'supervisorName' :newHarvest.supervisorName,
       'totalWorkers' :newHarvest.totalWorkers,
     'harvestDate' : newHarvest.harvestDate.toIso8601String(), 
         

    }),
    headers: headers,);
    _items[harvestIndex] = newHarvest;
    notifyListeners();
    print(response.body);
    
  }else{
    print('...');

  }
}

void deleteHarvest(String harvestId)async {
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
_items.removeWhere((harvest) => harvest.id == harvestId);
final url = '$apiurl/harvest/$harvestId';
    final response = await http.delete(url, headers: headers);
notifyListeners();

}
void update(String frvalue) {
  if (frvalue == this.authToken) return;
  this.authToken = frvalue;
  // do some requests
}

}
 

