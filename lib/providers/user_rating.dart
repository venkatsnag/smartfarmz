import 'package:flutter/cupertino.dart';
import '../providers/crop.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import './apiClass.dart';

class  UserRatingItem{
final String id;
 String userId;
String reviewerId;
  double rating;
 String comments;




  UserRatingItem({
  @required this.id,  
  
   @required this.userId,
   @required this.reviewerId,
   @required this.rating,
   this.comments,
           
 // @required this.paymentDate,
  
  
  
   });

   

  
}



class UserRating with ChangeNotifier{

 final apiurl = AppApi.api;

List<UserRatingItem> _items = [];
 /* List<CropExpenseItem> _cropExpenses = [];  */
  String authToken;
  final String userId;

  UserRating(this.authToken, this.userId, this._items);


   double get count{
    
   var count =_items.length.toDouble();
   
   
   
   return count;
  }

  //Get Averageratings
  double get totalRating{
    var total = 0.0;
   var count =_items.length.toDouble();
   var avgRating = 0.0;

    _items.forEach((UserRatingItem userRatingItem){

      total += userRatingItem.rating;
      
    },);

avgRating = total/count;
   
   
   return avgRating;
  }

  //Get ratings

/*      double get rating{
    var rating = 0.0;
   
   _items.forEach((UserRatingItem userRatingItem){
      rating = userRatingItem.rating;
    
    },);
  
   return rating;
  } */
 
//Get comments
  /*   String get comments{
    dynamic comments;
   var count =_items.length.toDouble();
   var avgRating = 0.0;

    _items.add((UserRatingItem userRatingItem){

      comments = userRatingItem.comments;
      
    },);


   
   
   return comments;
  } */


List<UserRatingItem> get items{

return [..._items];
}

UserRatingItem findById( String id){

return _items.firstWhere((rating) => rating.id == id);
}

set Auth(dynamic Auth) {}

//@JsonSerializable(explicitToJson: true)
Future<void> getRating(String userId)  async{
Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
  
   final url = '$apiurl/users/rating/$userId';
   
 final response = await http.get(url, headers: headers);
  final List<dynamic> ratingsMap = jsonDecode(response.body);
  final List<UserRatingItem> loadedRatings = [];
//var ferti = FertiPestiItem.fromJson(fetiPestisMap);
 
 
    
//print('Howdy, ${ferti.description}!');
if(ratingsMap.length > 0){
   
 
ratingsMap.forEach((dynamic ratingData){
  loadedRatings.add(UserRatingItem(

    id:ratingData['id'].toString(),
    userId: ratingData['user_id'],
    reviewerId: ratingData['reviewer_userId'],
    comments: ratingData['comments'],
    rating: double.parse(ratingData['rating'].toString()),
   
    
    ),
    );

//print('Howdy, description ${salesData['cropId']}!');



_items = loadedRatings;
notifyListeners();
});

}
else{
  _items = [];
  
  
  return Container(
    child: Text('No Data'),);
}
} 
Future <void> addRatings(UserRatingItem userRating, ) async {

final url = '$apiurl/users/rating/$userId';
 Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer $authToken'};
//final url = 'https://farmersfriend-4595f.firebaseio.com/$type/$userId/$cropId/sales.json?$authToken';
try{
final response = await http.post(url, body: json.encode({


 'user_id' :userRating.userId,
 'reviewer_userId' :userRating.reviewerId,
  'comments' : userRating.comments,
  'rating': userRating.rating,
  
    
  }),
   headers: headers,
   );
final dynamic newRatingtems = UserRatingItem(
userId: userRating.userId,
reviewerId: userRating.reviewerId,
comments: userRating.comments,
rating: userRating.rating,



id: json.decode(response.body)['name']
);
_items.add(newRatingtems);
print(response);

notifyListeners();

} catch(error){
  print(error);
throw error; 

}

}



}
 

