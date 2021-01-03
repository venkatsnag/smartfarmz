import 'package:flutter/cupertino.dart';
import '../providers/crop.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import './apiClass.dart';

class  CropExpenseItemNew {
final String id;
final String cropId;
final String orchId;
final String landId;
final String expenseType;
final String description;
DateTime paymentDate;
final double amount;
final String workerName;
final dynamic type;
String cropIdCrop;
String cropIdOrch;
String cropIdLand;

  CropExpenseItemNew({
  @required this.id,  
  this.cropId,
  this.orchId,
  this.landId,
  @required this.expenseType, 
  @required this.description,
  @required this.workerName,
  @required this.paymentDate,
  @required this.amount,  
  this.cropIdCrop,
  this.cropIdOrch,
  this.cropIdLand,
  this.type,
   });

/*    
  factory CropExpenseItemNew.fromJson(Map<String, dynamic> expense){
    return 

       CropExpenseItemNew(

    id:expense['expenseID'],
    cropId: expense['cropId'],
    orchId: expense['orchId'],
    description: expense['description'],
    expenseType: expense['expenseType'],
    workerName: expense['workerName'],
    amount: expense['amount'],
    paymentDate: expense['paymentDate'],
    ); 
  } */

  
}



class CropExpenses with ChangeNotifier{
final apiurl = AppApi.api;

List<CropExpenseItemNew> _items = [];
 /* List<CropExpenseItem> _cropExpenses = [];  */
 String authToken;
  final String userId;

  CropExpenses(this.authToken, this.userId, this._items);

  double get totalAmount{
    var total = 0.0;

    _items.forEach((CropExpenseItemNew expenseItemNew){

      total += expenseItemNew.amount;
    },);
   
   return total;
  }

/* String get previousCrop{
    var preCropId = '';

    _items.forEach((CropExpenseItemNew expenseItemNew){

      preCropId = expenseItemNew.cropId;
    },);
   
   return preCropId;
  } */
 
List<CropExpenseItemNew> get items{

return [..._items];
}

CropExpenseItemNew findById( String id){

return _items.firstWhere((expense) => expense.id == id);
}



//@JsonSerializable(explicitToJson: true)
Future<void> fetchAndSetCropExpenses(String cropId, String type)  async{
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
  final url = '$apiurl/expenses/$type/$cropId';
   //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
    //final url = 'https://farmersfriend-4595f.firebaseio.com/albums/$authName/$name.json';
 final response = await http.get(url, headers: headers);
  
 final List<dynamic> expensesMap = jsonDecode(response.body) ;
  final List<CropExpenseItemNew> loadedExpenses = [];
  if(expensesMap.length > 0){
expensesMap.forEach((dynamic expenseData){
  loadedExpenses.add(CropExpenseItemNew(

    id:expenseData['expenseID'].toString(),
    cropId: expenseData['cropId'].toString(),
    orchId: expenseData['orchId'].toString(),
    landId: expenseData['landId'].toString(),
    description: expenseData['description'],
    expenseType: expenseData['expenseType'],
    workerName: expenseData['workerName'],
    amount: double.parse(expenseData['amount'].toString()),
    paymentDate: DateTime.parse(expenseData['paymentDate']).toLocal(),
    
    ),
    );

//print('Howdy, description ${expenseData['cropId']}!');



_items = loadedExpenses;
notifyListeners();

});
  }
  else {
  
  _items = loadedExpenses;
  
 
}

}
Future <void> addExpense(CropExpenseItemNew expense, ) async {
  
 /* final dynamic type = expense.type;
final cropId = expense.cropId;
 */
final url = '$apiurl/expenses';
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
try{
final response = await http.post(url, body: json.encode({


 'cropId' :expense.cropId,
  'landId' :expense.landId,
 'orchId' :expense.orchId,
  'expenseType' : expense.expenseType,
  'description': expense.description,
  'amount' : expense.amount,
  'workerName' : expense.workerName, 
  'paymentDate' : expense.paymentDate.toIso8601String(), 
    //'seedingDate' :crop.seedingDate,
  }),
  headers: headers,
  );
final dynamic newExpenseItems = CropExpenseItemNew(
cropId: expense.cropId,
landId: expense.landId,
orchId: expense.orchId,
expenseType: expense.expenseType,
description: expense.description,
paymentDate: expense.paymentDate, 
amount: expense.amount,
workerName: expense.workerName,  

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

void updateExpense(String id, CropExpenseItemNew newExpense, ) async {

  final expenseId = newExpense.id;
 
  
  final expenseIndex = _items.indexWhere((expense) => expense.id == id);
  if(expenseIndex >= 0){
   //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses/$expenseId.json?$authToken';
Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/expenses/$expenseId';
    final response = await http.put(url, body: json.encode({

      'id':expenseId,
      'expenseID':newExpense.id,
      'cropId':newExpense.cropId,
      'orchId':newExpense.orchId,
      'landId':newExpense.landId,
      'expenseType': newExpense.expenseType,
      'description': newExpense.description,
      'amount' : newExpense.amount,
      'workerName' :newExpense.workerName,
     'paymentDate' : newExpense.paymentDate.toIso8601String(), 
         

    }),
    headers: headers,);
    _items[expenseIndex] = newExpense;
    notifyListeners();
    print(response.body);
    
  }else{
    print('...');

  }
}

void deleteExpense(String expenseId)async {
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
_items.removeWhere((expense) => expense.id == expenseId);
final url = '$apiurl/expenses/$expenseId';
    final response = await http.delete(url, headers: headers);
notifyListeners();

}
void update(String frvalue) {
  if (frvalue == this.authToken) return;
  this.authToken = frvalue;
  // do some requests
}

}
 

