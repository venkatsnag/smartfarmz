import 'package:flutter/material.dart';

import '../screens/crop_for_sale_detail_screen_user.dart';
import 'package:provider/provider.dart';
import '../providers/crop.dart';

import '../providers/auth.dart';

class CropsForSaleItemUser extends StatelessWidget {

 
 
  //Map<String, String> headers = {'Authorization': 'Bearer $authToken'};

  CropsForSaleItemUser(String id, String title, String imageUrl, String price);
   
  /* final String id;
    final String imageUrl;
    final String title;

  CropItem(this.id, this.title, this.imageUrl); */


  
  @override
  Widget build(BuildContext context) {
    final crop = Provider.of<Crop>(context);
    
    final authData = Provider.of<Auth>(context, listen: false);
    return GridTile(
      
      child: GestureDetector
      (
        onTap: (){
          Navigator.of(context).pushNamed(CropForSaleDetailScreenUser.routeName, 
          arguments: crop.id,
        
          );
        },
        child: 
        crop.imageUrl.isEmpty ?
        Image.network('https://cdn.pixabay.com/photo/2015/01/21/13/21/sale-606687_960_720.png', fit:BoxFit.cover)
      :
    Image.network(crop.imageUrl, fit:BoxFit.cover,
  
      ),
     ),
     footer: GridTileBar(
      backgroundColor: Colors.black54,
      
      /* leading: Consumer<Crop>(
              builder: (ctx, crop, _) => IconButton(icon: 
        Icon(crop.isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: 
        (){
          crop.toggleFavoriteStatus(
          authData.token, 
        authData.userId);}),
      ), */
      leading: Text('₹', textScaleFactor: 1.5, 
      style: TextStyle(color: Colors.white),),
      title: Text(crop.title,
      textAlign: TextAlign.center,
      
      ),
      subtitle:  Flexible(child:RichText(
         text: TextSpan(
  children: <TextSpan>[
    // Stroked text as border.
/*     Text(
      crop.price.toString(),
      style: TextStyle(
        fontSize: 40,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..color = Colors.blue[700],
      ),
    ), */
    // Solid text as fill.
    /* TextSpan(
      text: 'Rs:- ',
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ), */
     TextSpan(
      text: crop.price.toString(),
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ),
    TextSpan(
      text: '   ',
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ),
    /*  TextSpan(
      text: '/ ',
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ), */
    /*  TextSpan(
      text: crop.salesUnits,
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ), */
TextSpan(
      text: 'Available Qty: ',
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ),
    TextSpan(
      text: crop.quantityForSale,
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ),
  ],
)
      ),),
     ),); 
  }
}

