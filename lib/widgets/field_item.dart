import 'package:flutter/material.dart';

import '../screens/field_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/fields.dart';

import '../providers/auth.dart';

class FieldItem extends StatelessWidget {

 
 
  //Map<String, String> headers = {'Authorization': 'Bearer $authToken'};

  FieldItem(String id, String title, String imageUrl);
   
  /* final String id;
    final String imageUrl;
    final String title;

  CropItem(this.id, this.title, this.imageUrl); */
  
  @override
  Widget build(BuildContext context) {
    final field = Provider.of<Field>(context);
    
    final authData = Provider.of<Auth>(context, listen: false);
    return GridTile(
      child: GestureDetector
      (
        onTap: (){
          Navigator.of(context).pushNamed(FieldDetailScreen.routeName, 
          arguments: field.id,
        
          );
        },
        child: 
        field.imageUrl?.isEmpty ?
        Image.network('https://images.unsplash.com/photo-1534940519139-f860fb3c6e38?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=747&q=80 747w', fit:BoxFit.cover)
      :
    Image.network(field.imageUrl, fit:BoxFit.cover,
  
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
      title: Text(field.title,
      textAlign: TextAlign.center,
      
      ),
     
      ),
     );
  }
}

