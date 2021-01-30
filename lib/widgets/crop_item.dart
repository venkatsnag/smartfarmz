import 'package:flutter/material.dart';

import '../screens/crop_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/crop.dart';

import '../providers/auth.dart';

class CropItem extends StatelessWidget {

 
 
  //Map<String, String> headers = {'Authorization': 'Bearer $authToken'};

  CropItem(String id, String title, String imageUrl);
   
  /* final String id;
    final String imageUrl;
    final String title;

  CropItem(this.id, this.title, this.imageUrl); */
  
  @override
  Widget build(BuildContext context) {
    var imageUrls;
    final crop = Provider.of<Crop>(context);

    List<String> networkImages;
 crop?.imageUrl?.isEmpty ?? true ? crop.imageUrl : imageUrls = crop.imageUrl.split(",") ;

   networkImages = imageUrls;

    
    final authData = Provider.of<Auth>(context, listen: false);
    return GridTile(
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child:GestureDetector
      (
        onTap: (){
          Navigator.of(context).pushNamed(CropDetailScreen.routeName, 
          arguments: crop.id,
        
          );
        },
        child: 
        crop?.imageUrl?.isEmpty ?? true ?
        Image.network('https://images.unsplash.com/photo-1534940519139-f860fb3c6e38?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=747&q=80 747w', fit:BoxFit.cover)
      :
    Image.network(networkImages[0], fit:BoxFit.cover,
  
      ),
     ),),
    footer:Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
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
      title: Text(crop.title == 'Others' ? crop.otherTitle : crop.title,
      textAlign: TextAlign.center,
      
      ),
     
      ),
      
     ),);
  }
}


