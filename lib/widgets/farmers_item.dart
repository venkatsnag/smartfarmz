import 'package:flutter/material.dart';

import '../screens/farmer_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';

import '../providers/auth.dart';
import 'package:rating_bar/rating_bar.dart';
import '../providers/apiClass.dart';

class FarmerItem extends StatelessWidget {

 final apiurl = AppApi.api;
 
  //Map<String, String> headers = {'Authorization': 'Bearer $authToken'};

  FarmerItem(String id, String title, String imageUrl, String userType);
   
  /* final String id;
    final String imageUrl;
    final String title;

  CropItem(this.id, this.title, this.imageUrl); */


  
  @override
  Widget build(BuildContext context) {
    double rating = 3.5;
    int starCount = 6;
 const radius = 2;
    final farmer = Provider.of<UsersItem>(context);
    
    final authData = Provider.of<Auth>(context, listen: false);
    return 
   Card(
      margin: EdgeInsets.all(5),
     color: Colors.white,
    elevation: 5,
    shape: Border(right: BorderSide(color: Colors.lightGreen, width: 10)),
    shadowColor: Colors.grey,
    child: InkWell(
  onTap: () {
          Navigator.of(context).pushNamed(FarmerDetailScreen.routeName, 
          arguments: farmer.id,
        
          );
        },
 child: 
         Row(
          children: [
           
    
  
          new Container(
            width: 150,
            height: 150,
                padding: const EdgeInsets.all(8.0),
                child: farmer?.userImageUrl?.isEmpty ?? true ?
        Image.network('$apiurl/images/folder/Indian_farmer.png') :
    Image.network(farmer.userImageUrl, fit:BoxFit.cover,
    ),), 
            new Container(
              width: 165,
             
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                    RichText(
                     text: TextSpan(
                      text: 'Name : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: farmer.userFirstname),
                  ],
                  ),
                  ),
                  farmer.state != null ?
            RichText(
                     text: TextSpan(
                      text: 'State : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: farmer.state),
                  ],
                  ),
                  ) :  Text('NA',
          style: TextStyle(color: Colors.black),                 
          ),
                   farmer.userVillage != null ?
                     RichText(
                     text: TextSpan(
                      text: 'Village : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: farmer.userVillage),
                  ],
                  ),
                  ) :  Text('NA',
          style: TextStyle(color: Colors.black),                 
          ),

          
          
           farmer.userType == 'Buyer' ?
              RichText(
                     text: TextSpan(
                      text: 'Will buy : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      farmer.userCrops != null ?
                  TextSpan(text: farmer.userCrops) : TextSpan(text: 'NA') 
                  ],
                  ),
                  ) : 
                  RichText(
                     text: TextSpan(
                      text: 'Grows : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      farmer.userCrops != null ?
                  TextSpan(text: farmer.userCrops) : TextSpan(text: 'NA') 
                  ],
                  ),
                  )
                  
                 
                 /* farmer.userLastname != null ?  Text(farmer.userLastname,
                      style: TextStyle(color: Colors.black.withOpacity(0.8))) : 'NA' , */
                      /* new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Farmer\'s Average Rating'),
         
                     ] ),  */
                    /*    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        
          RatingBar.readOnly(
    initialRating: 3.5,
    isHalfAllowed: true,
    halfFilledIcon: Icons.star_half,
    filledIcon: Icons.star,
    emptyIcon: Icons.star_border,
    filledColor: Colors.amberAccent,
    halfFilledColor: Colors.amberAccent, 
    size: 25,
  ),
  
                     ] ),   */
                  //Text(farmer.userLastname),
                ],
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        )
        );
   
  }


 
}

