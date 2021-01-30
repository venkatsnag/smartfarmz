import 'package:flutter/material.dart';

import '../screens/machinery_forSaleRental_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/machinery.dart';

import '../providers/auth.dart';

class MachineryForRentalItem extends StatelessWidget {

 
 
  //Map<String, String> headers = {'Authorization': 'Bearer $authToken'};

  MachineryForRentalItem(String id, String type, String year, String imageUrl, String salePrice, String rentPrice);
   
  /* final String id;
    final String imageUrl;
    final String title;

  CropItem(this.id, this.title, this.imageUrl); */


  
  @override
  Widget build(BuildContext context) {
    var imageUrls;
    final machinery = Provider.of<MachineryItemNew>(context);
    List<String> networkImages;
     machinery?.imageUrl?.isEmpty ?? true ? machinery.imageUrl : imageUrls = machinery.imageUrl.split(",") ;

   networkImages = imageUrls;
    
    final authData = Provider.of<Auth>(context, listen: false);
    if(machinery.forRental == 1){
      return GridTile(
      
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector
      (
        onTap: (){
          Navigator.of(context).pushNamed(MachineryForSaleRentalDetailScreen.routeName, 
          arguments: machinery.id,
        
          );
        },
        child: 
          machinery?.imageUrl?.isEmpty ?? true ?
        Image.network('https://cdn.pixabay.com/photo/2015/01/21/13/21/sale-606687_960_720.png', fit:BoxFit.cover)
      :
    Image.network(networkImages[0], fit:BoxFit.cover,
  
      ),
     ),),
     footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
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
      title: Text(machinery.type,
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

    machinery.forSale == 1 ?
     TextSpan(
      text: machinery.salePrice.toString(),
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ) : 
     TextSpan(
      text: machinery.rentPrice.toString(),
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
/* TextSpan(
      text: '\nModel: ',
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ),
    TextSpan(
      text: machinery.model,
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ), */
    TextSpan(
      text: '\nYear: ',
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ),
    TextSpan(
      text: machinery.year,
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ),
  ],
)
      ),),
     ),),);
    }
    
     else{
return Container(); 
     }
    
  }
}

