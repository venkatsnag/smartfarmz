import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/machinery_rental_anounce_screen.dart';
import '../providers/machinery.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/auth.dart';

class UserMachineryForSaleRentalItem extends StatelessWidget {

   
  final String id;
  final String type;
  final String forSale;
  final String forRental;
    final String imageUrl;

  UserMachineryForSaleRentalItem(this.id, this.type, this.forSale, this.forRental, this.imageUrl);

  @override
  Widget build(BuildContext context) {
  List<String> networkImages;
     var imageUrls;
     imageUrl?.isEmpty ?? true ? imageUrl : imageUrls = imageUrl.split(",") ;
     

     networkImages = imageUrls;

Future<void> _showConfirmationDialog(String message){
  String refType;
  forSale == '1' ? refType = 'sale' : refType = 'rental';
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('Machinery for Sale/Rental will be deleted!'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(ctx).pop();
          Provider.of<Machinery>(context, listen: false).deleteMachineryForSaleRental(id);
          }, 
          child: Text('Okay'))
      ],
      ),
      );

  }

     
     return  Consumer<Auth>
      (builder: (ctx, auth, _) => ListTile(title: auth.isAuth ?
    Text(type) : Text(GalleryLocalizations.of(context).login_Signup,) ,
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
        Navigator.of(context).pushNamed(MachinerySaleAnouncementScreen.routeName, arguments: {'id': id, 'action':'update'});
        },
        color: Colors.black),
        IconButton(icon: Icon(Icons.delete), onPressed: (){

            const  message = 'Are you sure you want to delete machinery sale/Rental?';
          _showConfirmationDialog(message);
         
        },
        color: Theme.of(context).errorColor,),
      ]),
    ),
    
    ),
      );
  }
}

