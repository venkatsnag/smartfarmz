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
    final crop = Provider.of<Crop>(context);
    
    final authData = Provider.of<Auth>(context, listen: false);
    return GridTile(
      child: GestureDetector
      (
        onTap: (){
          Navigator.of(context).pushNamed(CropDetailScreen.routeName, 
          arguments: crop.id,
        
          );
        },
        child: 
        crop.imageUrl?.isEmpty ?
        Image.network('https://images.unsplash.com/photo-1534940519139-f860fb3c6e38?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=747&q=80 747w', fit:BoxFit.cover)
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
      title: Text(crop.title == 'Others' ? crop.otherTitle : crop.title,
      textAlign: TextAlign.center,
      
      ),
     
      ),
      
     );
  }
}


