import 'package:flutter/cupertino.dart';
import '../providers/crop.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import './apiClass.dart';

class  CropLandNotesItemNew with ChangeNotifier {
final String id;
final String cropId;
String subject;
String landId;
final String notes;
String cropTitle;
String imageUrl;
DateTime date;
final String workerName;
String userId;
final dynamic type;
String cropIdCrop;
String cropIdLand;

  CropLandNotesItemNew({
  @required this.id,  
  this.cropId,
  this.subject,
  this.landId,
  this.cropTitle,
  @required this.notes,
  this.imageUrl,
  @required this.workerName,
  this.userId,
  @required this.date,
  this.cropIdCrop,
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



class CropLandNotes with ChangeNotifier{
  final apiurl = AppApi.api;
List<CropLandNotesItemNew> _items = [];
 /* List<CropExpenseItem> _cropExpenses = [];  */
 String authToken;
  final String userId;

  CropLandNotes(this.authToken, this.userId, this._items);

  

 
List<CropLandNotesItemNew> get items{

return [..._items];
}

CropLandNotesItemNew findById( String id){

return _items.firstWhere((note) => note.id == id);
}



//@JsonSerializable(explicitToJson: true)
Future<void> getNotes(String cropId, String type)  async{
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
  final url = '$apiurl/notes/$type/$cropId';
   //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
    //final url = 'https://farmersfriend-4595f.firebaseio.com/albums/$authName/$name.json';
 final response = await http.get(url, headers: headers);
  
 final List<dynamic> notesMap = jsonDecode(response.body) ;
  final List<CropLandNotesItemNew> loadedNotes = [];
  if(notesMap.length > 0){
notesMap.forEach((dynamic notesData){
  loadedNotes.add(CropLandNotesItemNew(

    id:notesData['id'].toString(),
    cropId: notesData['cropId'].toString(),
    landId: notesData['landId'].toString(),
    notes: notesData['notes'],
    subject: notesData['subject'],
    cropTitle: notesData['cropTitle'],
    imageUrl: notesData['imageUrl'],
    workerName: notesData['workerName'],
    date: DateTime.parse(notesData['date']).toLocal(),
    
    ),
    );

//print('Howdy, description ${expenseData['cropId']}!');



_items = loadedNotes;
notifyListeners();

});
  }
  else {
  
  _items = loadedNotes;
  
 
}

}
Future <void> addNote(CropLandNotesItemNew note, ) async {
  
 /* final dynamic type = expense.type;
final cropId = expense.cropId;
 */
final url = '$apiurl/notes';
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
try{
final response = await http.post(url, body: json.encode({


 'cropId' :note.cropId,
  'landId' :note.landId,
   'notes': note.notes,
   'subject': note.subject,
  'cropTitle': note.cropTitle,
  'workerName': note.workerName,  
  'imageUrl' : note.imageUrl, 
  'date' : note.date.toIso8601String(), 
    //'seedingDate' :crop.seedingDate,
  }),
  headers: headers,
  );
final dynamic newNoteItem = CropLandNotesItemNew(
cropId: note.cropId,
landId: note.landId,
notes: note.notes,
subject: note.subject,
date: note.date, 
cropTitle: note.cropTitle, 
imageUrl: note.imageUrl, 
workerName: note.workerName,  

id: json.decode(response.body)['name']
);
_items.add(newNoteItem);
print(response);

notifyListeners();

} catch(error){
  print(error);
throw error; 

}

}

void updateNote(String id, CropLandNotesItemNew newNote, ) async {

  final noteId = newNote.id;
 
  
  final noteIndex = _items.indexWhere((note) => note.id == id);
  if(noteIndex >= 0){
   //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses/$expenseId.json?$authToken';
Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/notes/$noteId';
    final response = await http.patch(url, body: json.encode({

      'id':noteId,
      'cropId':newNote.cropId,
      'landId':newNote.landId,
      'notes': newNote.notes,
      'cropTitle': newNote.cropTitle,
      'subject': newNote.subject,
      'imageUrl': newNote.imageUrl,
      'workerName' :newNote.workerName,
     'date' : newNote.date.toIso8601String(), 
         

    }),
    headers: headers,);
    _items[noteIndex] = newNote;
    notifyListeners();
    print(response.body);
    
  }else{
    print('...');

  }
}

void deleteNote(String noteId)async {
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
_items.removeWhere((note) => note.id == noteId);
final url = '$apiurl/notes/$noteId';
    final response = await http.delete(url, headers: headers);
notifyListeners();

}
void update(String frvalue) {
  if (frvalue == this.authToken) return;
  this.authToken = frvalue;
  // do some requests
}

}
 

