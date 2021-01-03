import 'package:flutter/cupertino.dart';
import '../providers/crop.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_table/json_table.dart';
import './apiClass.dart';

class  MarketPriceItemNew {
final String id;
//final List<MarketsItemNew> markets;
String marketName;
String cropTitle;
final double price;
DateTime priceDate;
final double quantity;
String units;
String state;
String city;



  MarketPriceItemNew({
  this.id,  
  @required this.marketName,
  //@required this.markets,
  this.cropTitle, 
  @required this.price,
   this.priceDate,
  @required this.quantity,  
  @required this.units,  
  this.state,
   this.city,
  
   });
 
}

class  MarketsItemNew {
final String id;
String marketName;
String cropTitle;
final double price;
DateTime priceDate;
final double quantity;
String units;
String state;
String city;



  MarketsItemNew({
  this.id,  
  @required this.marketName,
  this.cropTitle, 
  @required this.price,
   this.priceDate,
  @required this.quantity,  
  @required this.units,  
  this.state,
   this.city,
  
   });
 
}



class MarketPrices2 with ChangeNotifier{

final apiurl = AppApi.api;

List<MarketPriceItemNew> _items = [];
 /* List<CropExpenseItem> _cropExpenses = [];  */
  String authToken;
  final String userId;

  MarketPrices2(this.authToken, this.userId, this._items);



List<MarketPriceItemNew> get items{

return [..._items];
}

/* MarketPriceItemNew findById( String id){

return _items.firstWhere((marketPrice) => marketPrice.id == id);
} */



//@JsonSerializable(explicitToJson: true)
//Future<void> fetchAndSetMarketPrices(String cropTitle, marketName)  async{

  Future<void> fetchAndSetMarketPrices()  async{

   //var url = 'https://farmersfriend-4595f.firebaseio.com/$marketName/$cropTitle/marketPrices.json?$authToken';
   var url = 'https://farmersfriend-4595f.firebaseio.com/marketPrices/Tomato.json?$authToken';
    //final url = 'https://farmersfriend-4595f.firebaseio.com/albums/$authName/$name.json';
 final response = await http.get(url);
  //print('Items + ${items}');
  //print(response.body);
  //print(response);
//var expense = Expense.fromJson(expensesMap);
/*  
 if(response is CropExpenseItemNew){
   return ;
 } */
    
//print('Howdy, ${expense.description}!');
/* if(response.body == 'null'){
   return CropExpenses == null;
   
 } */
  Map <String, dynamic> marketPricesMap = jsonDecode(response.body);
  final List<MarketPriceItemNew> loadedMarketPrices = [];
  if(marketPricesMap != null){
marketPricesMap.forEach((mPriceId, dynamic marketPriceData){
  loadedMarketPrices.add(MarketPriceItemNew(




    //id:mPriceId,
    id: marketPriceData['id'],
    marketName: marketPriceData['marketName'],
    cropTitle: marketPriceData['cropTitle'],
    price: marketPriceData['price'],
    quantity: marketPriceData['quantity'],
    units: marketPriceData['units'],
    //priceDate: DateTime.parse(marketPriceData['priceDate']),
   
    ),
     
    );

print('Howdy, description ${marketPriceData['marketName']}!');



_items = loadedMarketPrices.toList();
notifyListeners();

});
  }
  else{
  _items = loadedMarketPrices;
  
  
  return Container(
    child: Text('No Data'),);
} 

/* Map <String, dynamic> marketPricesMap = jsonDecode(response.body);
  final List<MarketPriceItemNew> loadedMarketPrices = [];
  if(marketPricesMap != null){
marketPricesMap.forEach((mPriceId, dynamic marketPriceData){
  loadedMarketPrices.add(MarketPriceItemNew(




    //id:mPriceId,
    id: marketPriceData['id'],
    markets: (marketPriceData['prices'] as List<dynamic>).map((dynamic item) => MarketsItemNew(id: item['id'],
  price: item['price'],
  quantity: item['quantity'],
  marketName: item['marketName'],
  cropTitle: item['cropTitle'], )).toList(),
 
  ) );

print('Howdy, description ${marketPriceData['marketName']}!');



_items = loadedMarketPrices.toList();
notifyListeners();

});
  }
  else{
  _items = loadedMarketPrices;
  
  
  return Container(
    child: Text('No Data'),);
} */

}
Future <void> addMarketPrice(MarketPriceItemNew marketPrice, ) async {
  
 final marketName = marketPrice.marketName;
final cropTitle = marketPrice.cropTitle;
  
final url = '$apiurl/marketPrices';
Map<String, String> headers = {"Content-type": "application/json"};
//final url = 'https://farmersfriend-4595f.firebaseio.com/marketPrices/$cropTitle.json?$authToken';
try{
final response = await http.post(url, body: json.encode({

/*  'expenses' : expense.map((cp) =>{
    'id': cp.id,
    'amount':cp.amount,
    'description' :cp.description,
    'workerName' : cp.workerName,
    'expenseType' : cp.expenseType,
    
  }).toList(), */

 

 'marketName' :marketPrice.marketName,
  'cropTitle' : marketPrice.cropTitle,
  'price': marketPrice.price,
  'quantity' : marketPrice.quantity,
  'units' : marketPrice.units, 
  'city' : marketPrice.city, 
  'priceDate' : marketPrice.priceDate.toIso8601String(), 
    //'seedingDate' :crop.seedingDate,
  }),
  headers: headers,
  );
final dynamic newExpenseItems = MarketPriceItemNew(
marketName: marketPrice.marketName,
cropTitle: marketPrice.cropTitle,
price: marketPrice.price,
quantity: marketPrice.quantity, 
units: marketPrice.units,
city: marketPrice.city,
priceDate: marketPrice.priceDate,  

id: json.decode(response.body)['name']
);
_items.add(newExpenseItems);
print(response);

notifyListeners();

} catch(error){
  print(error);
throw error; 

}

}

void updateMarketPrice(String id, MarketPriceItemNew updateMarketPrice, ) async {
  final cropTitle = updateMarketPrice.cropTitle;
  final marketPriceId = updateMarketPrice.id;
  final marketName = updateMarketPrice.marketName;
  
  final mPriceIndex = _items.indexWhere((marketiPrice) => marketiPrice.id == id);
  if(mPriceIndex >= 0){
   var url = 'https://farmersfriend-4595f.firebaseio.com/marketPrices/$cropTitle.json?$authToken';
    await http.patch(url, body: json.encode({

      


      'marketName':updateMarketPrice.marketName,
      'cropTitle': updateMarketPrice.cropTitle,
      'price': updateMarketPrice.price,
      'quantity' : updateMarketPrice.quantity,
      'units' :updateMarketPrice.units,
      'city' :updateMarketPrice.city,
     'priceDate' : updateMarketPrice.priceDate.toIso8601String(), 
         

    }));
    _items[mPriceIndex] = updateMarketPrice;
    notifyListeners();
    dispose();
  }else{
    print('...');

  }
}

void deleteExpense(String id){
_items.removeWhere((expense) => expense.id == id);
notifyListeners();

}

void update(String frvalue) {
  if (frvalue == this.authToken) return;
  this.authToken = frvalue;
  // do some requests
}

}
 

