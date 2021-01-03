import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_crop_screen.dart';
import '../providers/crops.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/auth.dart';

class UserCropItem extends StatelessWidget {

   
  final String id;
  final String title;
  final String imageUrl;

  UserCropItem(this.id, this.title, this.imageUrl);

 

  @override

  
  Widget build(BuildContext context) {

   

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
      backgroundImage: NetworkImage(imageUrl),
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

