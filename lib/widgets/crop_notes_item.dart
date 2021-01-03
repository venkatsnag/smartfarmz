import 'package:flutter/material.dart';

import '../screens/notes_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';
import '../providers/cropNotes.dart';

import '../providers/auth.dart';
import 'package:rating_bar/rating_bar.dart';

class NotesItem extends StatelessWidget {

 
 
  //Map<String, String> headers = {'Authorization': 'Bearer $authToken'};

  NotesItem(String id, String title, String imageUrl);
   
  /* final String id;
    final String imageUrl;
    final String title;

  CropItem(this.id, this.title, this.imageUrl); */


  
  @override
  Widget build(BuildContext context) {
   
 const radius = 2;
    final notes = Provider.of<CropLandNotesItemNew>(context);
    
    final authData = Provider.of<Auth>(context, listen: false);
    return 
   Card(
      margin: EdgeInsets.all(5),
     color: Colors.white,
    elevation: 5,
    shape: Border(right: BorderSide(color: Colors.lightGreen, width: 10)),
    shadowColor: Colors.grey,
    child: InkWell(
  onTap: () {
          Navigator.of(context).pushNamed(NotesDetailScreen.routeName, 
          arguments: notes.id,
        
          );
        },
 child: 
         Row(
          children: [
           
    
  
          new Container(
            width: 150,
            height: 150,
                padding: const EdgeInsets.all(8.0),
                child: notes?.imageUrl?.isEmpty ?? true ?
        Image.network('https://images.unsplash.com/photo-1599508704512-2f19efd1e35f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80 375w', fit:BoxFit.cover) :
    Image.network(notes.imageUrl, fit:BoxFit.cover,
    ),), 
            new Container(
             
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notes.subject,),
                  Container(
                    width: 150,
                    child: Text(notes.notes, 
                  style: TextStyle(color: Colors.black.withOpacity(0.8))),
                  
                      ),
                      /* new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Farmer\'s Average Rating'),
         
                     ] ), 
                       new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        
          RatingBar.readOnly(
    initialRating: 3.5,
    isHalfAllowed: true,
    halfFilledIcon: Icons.star_half,
    filledIcon: Icons.star,
    emptyIcon: Icons.star_border,
    filledColor: Colors.amberAccent,
    halfFilledColor: Colors.amberAccent, 
    size: 25,
  ),
  
                     ] ),   */
                  //Text(farmer.userLastname),
                ],
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        )));
   
  }


 
}

