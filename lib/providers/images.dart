import 'package:flutter/cupertino.dart';
import '../providers/crop.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import './apiClass.dart';

class  ImagesItem with ChangeNotifier {
final String id;
String refId;
String imageUrl;


  ImagesItem({
  @required this.id,  
  this.refId,
  this.imageUrl,

  
   });



  
}



class Images with ChangeNotifier{
final apiurl = AppApi.api;
List<ImagesItem> _items = [];
 /* List<CropExpenseItem> _cropExpenses = [];  */
 String authToken;
  final String userId;

  Images(this.authToken, this.userId, this._items);

  

 
List<ImagesItem> get items{

return [..._items];
}

ImagesItem findById( String id){

return _items.firstWhere((image) => image.id == id);
}



//@JsonSerializable(explicitToJson: true)
Future<void> getImageByRefId(String refId)  async{
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
  final url = '$apiurl/V1/images/reference/$refId';
   final response = await http.get(url, headers: headers);
  
 final List<dynamic> imagesMap = jsonDecode(response.body) ;
  final List<ImagesItem> loadedImages = [];
  if(imagesMap.length > 0){
imagesMap.forEach((dynamic imageData){
  loadedImages.add(ImagesItem(

    id:imageData['id'].toString(),
    refId: imageData['refId'],
    imageUrl: imageData['type'],
    
    
    
    ),
    );

//print('Howdy, description ${expenseData['cropId']}!');



_items = loadedImages;
notifyListeners();

});
  }
  else {
  
  _items = loadedImages;
  
 
}

}
Future <void> addImages(ImagesItem image, ) async {
  
 /* final dynamic type = expense.type;
final cropId = expense.cropId;
 */
final url = '$apiurl/V1/images';
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses.json?$authToken';
try{
final response = await http.post(url, body: json.encode({


 
  'refId' :image.refId,
   'imageUrl': image.imageUrl,
   
  
  }),
  headers: headers,
  );
final dynamic newImagesItem = ImagesItem(

refId: image.refId,
imageUrl: image.imageUrl,
 

id: json.decode(response.body)['name']
);
_items.add(newImagesItem);
print(response);

notifyListeners();

} catch(error){
  print(error);
throw error; 

}

}

Future <void> updateImages(String id, String newImage, ) async {

  
 
  

   //var url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/expenses/$expenseId.json?$authToken';
Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
    final url = '$apiurl/V1/images/$id';
    final response = await http.patch(url, body: json.encode({

      'refId':id,
      
      'imageUrl':newImage,
    
         

    }),
    headers: headers,);
    //_items[imageIndex] = newImage;
    notifyListeners();
    print(response.body);
    
  
}

void deleteImages(String id)async {
  Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//_items.removeWhere((image) => machinery.id == machineryId);
final url = '$apiurl/V1/images/$id';
    final response = await http.delete(url, headers: headers);
notifyListeners();

}
void update(String frvalue) {
  if (frvalue == this.authToken) return;
  this.authToken = frvalue;
  // do some requests
}

}
 

