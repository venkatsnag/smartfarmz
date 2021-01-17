import 'package:flutter/material.dart';

import '../screens/machinery_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';
import '../providers/machinery.dart';

import '../providers/auth.dart';
import 'package:rating_bar/rating_bar.dart';

class MachineryItem extends StatelessWidget {

 
 
  //Map<String, String> headers = {'Authorization': 'Bearer $authToken'};

  MachineryItem(String id, String type, String imageUrl);
   
  /* final String id;
    final String imageUrl;
    final String title;

  CropItem(this.id, this.title, this.imageUrl); */


  
  @override
  Widget build(BuildContext context) {
   
 const radius = 2;
    final machinery = Provider.of<MachineryItemNew>(context);
    
    final authData = Provider.of<Auth>(context, listen: false);
var imageUrls;
List<String> networkImages;
 machinery?.imageUrl?.isEmpty ?? true ? machinery.imageUrl : imageUrls = machinery.imageUrl.split(",") ;

   networkImages = imageUrls;
    return GridTile(
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child:GestureDetector
      (
        onTap: (){
          Navigator.of(context).pushNamed(MachineryDetailScreen.routeName, 
          arguments: machinery.id,
        
          );
        },
        child: 
        machinery?.imageUrl?.isEmpty ?? true ?
        Image.network('https://images.unsplash.com/photo-1599508704512-2f19efd1e35f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80 375w', fit:BoxFit.cover)
      :
    Image.network(networkImages[0], fit:BoxFit.cover,
  
      ),
     ),),
    footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
            ),
            clipBehavior: Clip.antiAlias,
            child:GridTileBar(
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
      title: Text(machinery.type,
      textAlign: TextAlign.center,
      
      ),
     
      ),),
      
     );
    /* return 
   Card(
      margin: EdgeInsets.all(5),
     color: Colors.white,
    elevation: 5,
    shape: Border(right: BorderSide(color: Colors.lightGreen, width: 10)),
    shadowColor: Colors.grey,
    child: InkWell(
  onTap: () {
          Navigator.of(context).pushNamed(MachineryDetailScreen.routeName, 
          arguments: machinery.id,
        
          );
        },
 child: 
         Row(
          children: [
           
    
  
          new Container(
            width: 150,
            height: 150,
                padding: const EdgeInsets.all(8.0),
                child: machinery?.imageUrl?.isEmpty ?? true ?
        Image.network('https://images.unsplash.com/photo-1599508704512-2f19efd1e35f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80 375w', fit:BoxFit.cover) :
    Image.network(machinery.imageUrl, fit:BoxFit.cover,
    ),), 
            new Container(
             
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(machinery.type,),
                  Container(
                    width: 150,
                    child: Text(machinery.model, 
                  style: TextStyle(color: Colors.black.withOpacity(0.8))),
                  
                      ),
                      
                ],
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        )
        ); */
   
  }


 
}

