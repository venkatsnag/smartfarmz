import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_field_screen.dart';
import '../providers/fields.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/auth.dart';

class UserFieldItem extends StatelessWidget {

   
  final String id;
  final String title;
  final String imageUrl;

  UserFieldItem(this.id, this.title, this.imageUrl);

     Future<void> _refreshCrops(BuildContext context) async {
     //final userId = ModalRoute.of(context).settings.arguments;
     //if(userId != null){
await Provider.of<Fields>(context,listen: false).fetchfields(true);
     //}
  }

  @override

  
  Widget build(BuildContext context) {

WidgetsBinding.instance.addPostFrameCallback((_) => _refreshCrops(context));
        Future<void> _showConfirmationDialog(String message){
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('Field will be deleted!'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(ctx).pop();
          Provider.of<Fields>(context, listen: false).deleteLand(id);
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
Navigator.of(context).pushNamed(EditFieldScreen.routeName, arguments: {'id': id, 'type':'lands'});
        },
        color: Colors.black),
        IconButton(icon: Icon(Icons.delete), onPressed: (){
          const  message = 'Are you sure you want to delete Land?';
          _showConfirmationDialog(message);
          
        },
        color: Theme.of(context).errorColor,),
      ]),
    ),
    
    ),
      );
  }
}

