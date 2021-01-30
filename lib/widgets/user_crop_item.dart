import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_crop_screen.dart';
import '../providers/crops.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/auth.dart';
import 'dart:convert';

class UserCropItem extends StatelessWidget {

   
  final String id;
  final String title;
  final String imageUrl;

  UserCropItem(this.id, this.title, this.imageUrl);

 

  @override

  
  Widget build(BuildContext context) {
    List<String> networkImages;
     var imageUrls;
     imageUrl?.isEmpty ?? true ? imageUrl : imageUrls = imageUrl.split(",") ;
     

     networkImages = imageUrls;

        Future<void> _showConfirmationDialog(String message){
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('Crop will be deleted!'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(ctx).pop();
          Provider.of<Crops>(context, listen: false).deleteCrop(id);
          }, 
          child: Text('Okay'))
      ],
      ),
      );

  }
     return  Consumer<Auth>
      (builder: (ctx, auth, _) => ListTile(title: auth.isAuth ?
    Text(title)  : Text(GalleryLocalizations.of(context).login_Signup,) ,
    leading: CircleAvatar(
      backgroundImage: 
      
       imageUrl?.isEmpty ?? true ?
        NetworkImage('https://images.unsplash.com/photo-1534940519139-f860fb3c6e38?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=747&q=80 747w',)
      :
      NetworkImage(networkImages[0]),
    ),
    trailing: Container(
      width: 100,
      child: Row(children: <Widget>[
        IconButton(icon: Icon(Icons.edit), onPressed: (){
//changed to accomodate edit from lands
//Navigator.of(context).pushNamed(EditCropScreen.routeName, arguments: id);
Navigator.of(context).pushNamed(EditCropScreen.routeName, arguments: {'id': id, 'type':'crops'});
        },
        color: Colors.black),
        IconButton(icon: Icon(Icons.delete), onPressed: (){
          const  message = 'Are you sure you want to delete crop?';
          _showConfirmationDialog(message);
          
        },
        color: Theme.of(context).errorColor,),
      ]),
    ),
    
    ),
      );
  }
}

