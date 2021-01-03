import 'package:flutter/cupertino.dart';
import '../providers/crop.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import './apiClass.dart';

class  MachineryItemNew with ChangeNotifier {
final String id;
String landId;
final String type;
String brand;
String model;
String imageUrl;

String description;
final String supervisor;
String userId;
String cropIdCrop;
String cropIdLand;

  MachineryItemNew({
  @required this.id,  
  this.type,
  this.brand,
  this.landId,
  this.model,
  this.description,
  this.imageUrl,
  this.supervisor,
  this.userId,
    this.cropIdCrop,
  this.cropIdLand,
  
   });



  
}



class Machinery with ChangeNotifier{
final apiurl = AppApi.api;
List<MachineryItemNew> _items = [];
 /* List<CropExpenseItem> _cropExpenses = [];  */
 String authToken;
  final String userId;

  Machinery(this.authToken, this.userId, this._items);

  

 
List<MachineryItemNew> get items{

return [..._items];
}

MachineryItemNew findById( String id){

return _items.firstWhere((machinery) => machinery.id == id);
}



//@JsonSerializable(explicitToJson: true)
Future<void> getMachinery(String cropId, String type)  async{
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
  final url = '$apiurl/machinery/$type/$cropId';
   final response = await http.get(url, headers: headers);
  
 final List<dynamic> machineryMap = jsonDecode(response.body) ;
  final List<MachineryItemNew> loadedMachinery = [];
  if(machineryMap.length > 0){
machineryMap.forEach((dynamic machineryData){
  loadedMachinery.add(MachineryItemNew(

    id:machineryData['id'].toString(),
    landId: machineryData['landId'].toString(),
    type: machineryData['type'],
    brand: machineryData['brand'],
    model: machineryData['model'],
    imageUrl: machineryData['imageUrl'],
    description: machineryData['description'],
    supervisor: machineryData['supervisor'],
    
    
    ),
    );

//print('Howdy, description ${expenseData['cropId']}!');



_items = loadedMachinery;
notifyListeners();

});
  }
  else {
  
  _items = loadedMachinery;
  
 
}

}
Future <void> addMachinery(MachineryItemNew machinery, ) async {
  
 /* final dynamic type = expense.type;
final cropId = expense.cropId;
 */
final url = '$apiurl/machinery';
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
try{
final response = await http.post(url, body: json.encode({


 
  'landId' :machinery.landId,
   'type': machinery.type,
   'brand': machinery.brand,
    'model': machinery.model,  
  'imageUrl' : machinery.imageUrl, 
  'description': machinery.description,
  'supervisor' : machinery.supervisor, 
    //'seedingDate' :crop.seedingDate,
  }),
  headers: headers,
  );
final dynamic newMachineryItem = MachineryItemNew(

landId: machinery.landId,
type: machinery.type,
brand: machinery.brand,
model: machinery.model, 
description: machinery.description, 
imageUrl: machinery.imageUrl, 
supervisor: machinery.supervisor,  

id: json.decode(response.body)['name']
);
_items.add(newMachineryItem);
print(response);

notifyListeners();

} catch(error){
  print(error);
throw error; 

}

}

void updateMachinery(String id, MachineryItemNew newMachinery, ) async {

  final machineryId = newMachinery.id;
 
  
  final machineryIndex = _items.indexWhere((machinery) => machinery.id == id);
  if(machineryIndex >= 0){
   //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses/$expenseId.json?$authToken';
Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/machinery/$machineryId';
    final response = await http.patch(url, body: json.encode({

      'id':machineryId,
      
      'landId':newMachinery.landId,
      'type': newMachinery.type,
      'brand': newMachinery.brand,
      'model': newMachinery.model,
      'imageUrl': newMachinery.imageUrl,
      'description' :newMachinery.description,
      'supervisor' :newMachinery.supervisor,
    
         

    }),
    headers: headers,);
    _items[machineryIndex] = newMachinery;
    notifyListeners();
    print(response.body);
    
  }else{
    print('...');

  }
}

void deleteMachinery(String machineryId)async {
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
_items.removeWhere((machinery) => machinery.id == machineryId);
final url = '$apiurl/machinery/$machineryId';
    final response = await http.delete(url, headers: headers);
notifyListeners();

}
void update(String frvalue) {
  if (frvalue == this.authToken) return;
  this.authToken = frvalue;
  // do some requests
}

}
 

