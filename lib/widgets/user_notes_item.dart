import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/add_notes_screen.dart';
import '../providers/cropNotes.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/auth.dart';

class UserNotesItem extends StatelessWidget {

    static const routeName = '/user-notes';
  final String id;
  final String subject;
  final String imageUrl;

  UserNotesItem(this.id, this.subject, this.imageUrl);

   Future<void> _refreshNotes(BuildContext context) async {
     //final userId = ModalRoute.of(context).settings.arguments;
     //if(userId != null){
await Provider.of<CropLandNotes>(context,listen: false);
     //}
  }

  @override

  
  Widget build(BuildContext context) {
    List<String> networkImages;
 var imageUrls;
     imageUrl?.isEmpty ?? true ? imageUrl : imageUrls = imageUrl.split(",") ;
     

     networkImages = imageUrls;
    //WidgetsBinding.instance.addPostFrameCallback((_) => _refreshNotes(context));

dynamic loadedNotes = Provider.of<CropLandNotes>(context,listen: false);
        Future<void> _showConfirmationDialog(String message){
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('Note will be deleted!'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(ctx).pop();
          Provider.of<CropLandNotes>(context, listen: false).deleteNote(id);
          }, 
          child: Text('Okay'))
      ],
      ),
      );

  }
     return  Consumer<Auth>
      (builder: (ctx, auth, _) => ListTile(title: auth.isAuth ?
    Text(subject)  : Text(GalleryLocalizations.of(context).login_Signup,) ,
    leading: CircleAvatar(
      backgroundImage: 
      
       imageUrl?.isEmpty ?? true ?
        NetworkImage('https://images.unsplash.com/photo-1599508704512-2f19efd1e35f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80 375w',)
      :
      NetworkImage(networkImages[0]),
    ),
    trailing: Container(
      width: 100,
      child: Row(children: <Widget>[
        IconButton(icon: Icon(Icons.edit), onPressed: (){
//changed to accomodate edit from lands
//Navigator.of(context).pushNamed(EditCropScreen.routeName, arguments: id);
Navigator.of(context).pushNamed(AddNotesScreen.routeName, arguments: {'noteId': id, 'type':'notes'});
        },
        color: Colors.black),
        IconButton(icon: Icon(Icons.delete), onPressed: (){
          const  message = 'Are you sure you want to delete this Notes?';
          _showConfirmationDialog(message);
          
        },
        color: Theme.of(context).errorColor,),
      ]),
    ),
    
    ),
      );
  }
}

