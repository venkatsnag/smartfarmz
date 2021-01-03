import 'package:flutter/cupertino.dart';
import '../providers/crop.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import './apiclass.dart';

class  SaleItemNew {
final String id;
final String cropId;
final String orchId;
final String soldTo;
final double totalWeight;
final double saleAmount;
final String description;
final String buyer;
DateTime paymentDate;
final String sellerName;
  String units;
 final dynamic type;




  SaleItemNew({
  @required this.id,  
   this.cropId,
  this.orchId,
  @required this.soldTo, 
  @required this.totalWeight, 
  @required this.saleAmount, 
  @required this.description,
   @required this.buyer,
   @required this.paymentDate,
   @required this.sellerName,
   @required this.units,
   this.type,
           
 // @required this.paymentDate,
  
  
  
   });

   

  
}



class Sales with ChangeNotifier{

final apiurl = AppApi.api;
//final apiurl = 'http://192.168.68.100:5000';
List<SaleItemNew> _items = [];
 /* List<CropExpenseItem> _cropExpenses = [];  */
  String authToken;
  final String userId;

  Sales(this.authToken, this.userId, this._items);

  double get totalAmount{
    var total = 0.0;

    _items.forEach((SaleItemNew saleItemNew){

      total += saleItemNew.saleAmount;
    },);
   
   return total;
  }


List<SaleItemNew> get items{

return [..._items];
}

SaleItemNew findById( String id){

return _items.firstWhere((sale) => sale.id == id);
}

set Auth(dynamic Auth) {}

//@JsonSerializable(explicitToJson: true)
Future<void> fetchAndFetchSales(String cropId, dynamic type)  async{
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
   //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/sales.json?$authToken';
   final url = '$apiurl/sales/$type/$cropId';
    //final url = 'https://farmersfriend-4595f.firebaseio.com/albums/$authName/$name.json';
 final response = await http.get(url, headers: headers);
  final List<dynamic> salesMap = jsonDecode(response.body);
  final List<SaleItemNew> loadedSales = [];
//var ferti = FertiPestiItem.fromJson(fetiPestisMap);
 
 
    
//print('Howdy, ${ferti.description}!');
if(salesMap.length > 0){
   
 
salesMap.forEach((dynamic salesData){
  loadedSales.add(SaleItemNew(

    id:salesData['saleID'].toString(),
    cropId: salesData['cropId'].toString(),
     orchId: salesData['orchId'].toString(),
    description: salesData['description'],
    buyer: salesData['buyer'],
    soldTo: salesData['soldTo'],
    sellerName: salesData['sellerName'],
    saleAmount: double.parse(salesData['saleAmount'].toString()),
    totalWeight: double.parse(salesData['totalWeight'].toString()),
    units: salesData['units'],
    paymentDate: DateTime.parse(salesData['paymentDate']).toLocal(),
    
    ),
    );

//print('Howdy, description ${salesData['cropId']}!');



_items = loadedSales;
notifyListeners();
});

}
else{
  _items = loadedSales;
  
  
  return Container(
    child: Text('No Data'),);
}
} 
Future <void> addSales(SaleItemNew sale, ) async {

final url = '$apiurl/sales';
 Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/sales.json?$authToken';
try{
final response = await http.post(url, body: json.encode({


 'cropId' :sale.cropId,
 'orchId' :sale.orchId,
  'soldTo' : sale.soldTo,
  'description': sale.description,
  'buyer': sale.buyer,
  'saleAmount' : sale.saleAmount,
  'sellerName' : sale.sellerName, 
  'totalWeight' : sale.totalWeight, 
  'units' : sale.units,
  'paymentDate' : sale.paymentDate.toIso8601String(), 
    
  }),
   headers: headers,
   );
final dynamic newSalestems = SaleItemNew(
cropId: sale.cropId,
orchId: sale.orchId,
soldTo: sale.soldTo,
description: sale.description,
buyer: sale.buyer,
paymentDate: sale.paymentDate, 
saleAmount: sale.saleAmount,
sellerName: sale.sellerName,  
totalWeight: sale.totalWeight, 
units: sale.units,


id: json.decode(response.body)['name']
);
_items.add(newSalestems);
print(response);

notifyListeners();

} catch(error){
  print(error);
throw error; 

}

}

void updateSales(String id, SaleItemNew newSale) async {
  
  final saleId = newSale.id;
final newOrchId = newSale.orchId;

   
 
  final saleIndex = _items.indexWhere((sale) => sale.id == id);
  if(saleIndex >= 0){
   Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/sales/$saleId';
    final  response = await http.put(url, body: json.encode({

      'id':saleId,
      'saleID':newSale.id,
      'cropId':newSale.cropId,
      'orchId':newOrchId,
      'soldTo': newSale.soldTo,
      'description': newSale.description,
      'buyer': newSale.buyer,
      'saleAmount' : newSale.saleAmount,
      'sellerName' :newSale.sellerName,
      'totalWeight' :newSale.totalWeight,
      'units' : newSale.units,
      'paymentDate' : newSale.paymentDate.toIso8601String(), 
         
         

    }),
    headers: headers,);
    _items[saleIndex] = newSale;
    notifyListeners();
    print(response.body);
    
  }else{
    print('...');

  }
}

void deleteSale(String saleId) async {
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
_items.removeWhere((sale) => sale.id == saleId);
final url = '$apiurl/sales/$saleId';
    final response = await http.delete(url, headers: headers);
notifyListeners();
print(response.body);
}

void update(String frvalue) {
  /* if (frvalue == this.authToken) return;
  this.authToken = frvalue; */
  // do some requests
}

}
 

