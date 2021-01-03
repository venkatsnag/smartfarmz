import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../widgets/user_crop_item.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';
import '../providers/cropNotes.dart';
import '../providers/user_rating.dart';
import 'package:rating_bar/rating_bar.dart';
import '../providers/user_rating.dart' as userRating;

class NotesDetailScreen extends StatefulWidget {

  static const routeName = '/notes-detail';

  @override
  _NotesDetailScreenState createState() => _NotesDetailScreenState();
}

class _NotesDetailScreenState extends State<NotesDetailScreen> {

  var _isLoading = false;
  @override
  
/*   void initState() {
  Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       _isLoading = true;
      });
    final userId = ModalRoute.of(context).settings.arguments as String;



      await Provider.of<UserRating>(context, listen: false).getRating(userId);
      
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  } */ 
int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    //final crop = Provider.of<Crops>(context);
    final id = ModalRoute.of(context).settings.arguments as String;
    final loadedNotes = Provider.of<CropLandNotes>(context).findById(id);
    /* final ratingData = Provider.of<UserRating>(context, listen: false);
    

    var averageRating = double.parse('${ratingData.totalRating}'); */
    


        return Scaffold(
          appBar: AppBar(
            title: 
            
            RichText(
                     text: TextSpan(
                      
                      text: 'Notes of '+ '${loadedNotes.subject}',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                   
                  ),
            
                      
            ),
            
            ),
            
            
            body: new SingleChildScrollView(
              
              physics: ScrollPhysics(),
              child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
               
            loadedNotes?.imageUrl?.isEmpty ?? true ?
             Image.network('https://images.unsplash.com/photo-1599508704512-2f19efd1e35f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80 375w', width: 600,            
                height: 260,
              fit: BoxFit.cover,) :
                Image.network(loadedNotes.imageUrl,
                width: 600,            
                height: 240,
              fit: BoxFit.cover,
              ),
   
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                   margin: EdgeInsets.all(10),
                   child:  RichText(
                     text: TextSpan(
                      
                      text: '${loadedNotes.subject}',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    
                  ),
            
                      
            ),
                   
                   
                 ),
                 
                 
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
    initialRating: averageRating,
    isHalfAllowed: true,
    halfFilledIcon: Icons.star_half,
    filledIcon: Icons.star,
    emptyIcon: Icons.star_border,
    filledColor: Colors.amberAccent,
    halfFilledColor: Colors.amberAccent, 
  ),
                     ] ),  */ 
               Stack(children: <Widget>[
                 Column(children: <Widget>[
                    RichText(
                     text: TextSpan(
                      text: 'Notes : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedNotes.notes}'),
                  ],
                  ),
                  ),
                   RichText(
                     text: TextSpan(
                      text: 'Recorded by : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedNotes.workerName}')
                  ],
                  ),
                  ),
                  
              
                  RichText(
                     text: TextSpan(
                      
                      text: 'Recorded date : ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: '${loadedNotes.date}'),
                  ],
                  ),
                  
                  ),
           
                  ],
                  ),

                  
                  
                   ]
                   ),
                   /* SizedBox(
                     height: 150,
                   ),
                         new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      
         
    Text('Total Review\'s'),
                     ] ),
                     ListView.builder(
                       physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
  itemCount: ratingData.items.length,
  itemBuilder: (context, i) {
    return ListTile(
          title:  RatingBar.readOnly(
    initialRating:double.parse('${ratingData.items[i].rating}'),
    isHalfAllowed: true,
    halfFilledIcon: Icons.star_half,
    filledIcon: Icons.star,
    emptyIcon: Icons.star_border,
    filledColor: Colors.amberAccent,
    halfFilledColor: Colors.amberAccent, 
  ),
          subtitle: 
          RichText(
                     text: TextSpan(
                      
                      text: '${ratingData.items[i].comments}' != 'null' ?
                      '${ratingData.items[i].comments}' : '',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                   
                  ),
                  
                  ),
          trailing: 
                  RichText(
                     text: TextSpan(
                      
                      text: 'Reviewer : ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: '${ratingData.items[i].reviewerId}'),
                  ],
                  ),
                  
                  ),
        );
      
   },
), */
                     
               ],
               
               ),
               
        ),);
                    
    
  }

}

