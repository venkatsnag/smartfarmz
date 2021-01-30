import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/add_machinery_screen.dart';
import '../providers/machinery.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/auth.dart';

class UserMachineryItem extends StatelessWidget {

    static const routeName = '/user-machinery';
  final String id;
  final String type;
  final String imageUrl;

  UserMachineryItem(this.id, this.type, this.imageUrl);

   Future<void> _refreshMachinery(BuildContext context) async {
     //final userId = ModalRoute.of(context).settings.arguments;
     //if(userId != null){
await Provider.of<Machinery>(context,listen: false);
     //}
  }

  @override

  
  Widget build(BuildContext context) {
    List<String> networkImages;
     var imageUrls;
     imageUrl?.isEmpty ?? true ? imageUrl : imageUrls = imageUrl.split(",") ;
     

     networkImages = imageUrls;

    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshMachinery(context));

dynamic loadedNotes = Provider.of<Machinery>(context,listen: false);
String dummyImage = 'https://images.unsplash.com/photo-1599508704512-2f19efd1e35f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80 375w';
        Future<void> _showConfirmationDialog(String message){
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('Machinery will be deleted!'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(ctx).pop();
          Provider.of<Machinery>(context, listen: false).deleteMachinery(id);
          }, 
          child: Text('Okay'))
      ],
      ),
      );

  }
     return  Consumer<Auth>
      (builder: (ctx, auth, _) => ListTile(title: auth.isAuth ?
    Text(type)  : Text(GalleryLocalizations.of(context).login_Signup,) ,
    leading: CircleAvatar(
      backgroundImage: imageUrl?.isEmpty ?? true ? NetworkImage(dummyImage) : 
      NetworkImage(networkImages[0]),
    ),
    trailing: Container(
      width: 100,
      child: Row(children: <Widget>[
        IconButton(icon: Icon(Icons.edit), onPressed: (){
//changed to accomodate edit from lands
//Navigator.of(context).pushNamed(EditCropScreen.routeName, arguments: id);
Navigator.of(context).pushNamed(AddMachineryScreen.routeName, arguments: {'machineryId': id, 'type':'machinery'});
        },
        color: Colors.black),
        IconButton(icon: Icon(Icons.delete), onPressed: (){
          const  message = 'Are you sure you want to delete this Machinery?';
          _showConfirmationDialog(message);
          
        },
        color: Theme.of(context).errorColor,),
      ]),
    ),
    
    ),
      );
  }
}

