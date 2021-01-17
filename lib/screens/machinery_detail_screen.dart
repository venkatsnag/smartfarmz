import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../widgets/user_crop_item.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';
import '../providers/machinery.dart';
import '../providers/user_rating.dart';
import 'package:rating_bar/rating_bar.dart';
import '../providers/user_rating.dart' as userRating;
import 'package:flutter_swiper/flutter_swiper.dart';
import '../screens/machinery_rental_anounce_screen.dart';
import '../providers/auth.dart';
class MachineryDetailScreen extends StatefulWidget {

  static const routeName = '/machinery-detail';

  @override
  _MachineryDetailScreenState createState() => _MachineryDetailScreenState();
}

class _MachineryDetailScreenState extends State<MachineryDetailScreen> {

  var _isLoading = false;
  @override
  

int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> networkImages;
    var imageUrls;
    final authData = Provider.of<Auth>(context, listen: false);
    final id = ModalRoute.of(context).settings.arguments as String;
    final loadedMachinery = Provider.of<Machinery>(context).findById(id);
loadedMachinery?.imageUrl?.isEmpty ?? true ? loadedMachinery.imageUrl : imageUrls = loadedMachinery.imageUrl.split(",") ;
    networkImages = imageUrls;

    /* final ratingData = Provider.of<UserRating>(context, listen: false);
    

    var averageRating = double.parse('${ratingData.totalRating}'); */
    


        return Scaffold(
          appBar: AppBar(
            title: 
            
            RichText(
                     text: TextSpan(
                      
                      text: '${loadedMachinery.type}',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                   
                  ),
            
                      
            ),
                actions: <Widget>[
        /* IconButton(icon: Icon(Icons.add), onPressed: (){
          Navigator.of(context).pushNamed(CropSaleAnouncementScreen.routeName, arguments: {'id':loadedCrops.id, 'action':'create'});
         // print(loadedCrops.id);
        },) */
authData.userType == 'Farmer' ?
        PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return MenuItems.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice));
              }).toList();
            },
          ) : SizedBox(),
      ]
            
            ),
            
            
            body: new SingleChildScrollView(
              
              physics: ScrollPhysics(),
              child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            Container(
              width:  500,
              height: 350,
    child:   
            loadedMachinery?.imageUrl?.isEmpty ?? true ?
             Image.network('https://images.unsplash.com/photo-1599508704512-2f19efd1e35f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80 375w', width: 600,            
                height: 260,
              fit: BoxFit.cover,) :
                 new Swiper(
        itemBuilder: (BuildContext context,int index){
          return new Image.network(networkImages[index],fit: BoxFit.fill,);
        },
        itemCount:networkImages.length,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
      ),
   
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                   margin: EdgeInsets.all(10),
                   child:  RichText(
                     text: TextSpan(
                      
                      text: '${loadedMachinery.type}',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    
                  ),
            
                      
            ),
                   
                   
                 ),
                 
                 
               ),
               Stack(children: <Widget>[
                 Column(children: <Widget>[
                    RichText(
                     text: TextSpan(
                      text: 'Type : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedMachinery.type}'),
                  ],
                  ),
                  ),
                   RichText(
                     text: TextSpan(
                      text: 'Brand Name : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedMachinery.brand}')
                  ],
                  ),
                  ),
                  
              
                  RichText(
                     text: TextSpan(
                      
                      text: 'Model : ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: '${loadedMachinery.model}'),
                  ],
                  ),
                  
                  ),

                  RichText(
                     text: TextSpan(
                      
                      text: 'Description : ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: '${loadedMachinery.description}'),
                  ],
                  ),
                  
                  ),

                     RichText(
                     text: TextSpan(
                      
                      text: 'Supervisor : ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: '${loadedMachinery.supervisor}'),
                  ],
                  ),
                  
                  ),
           
                  ],
                  ),

                  
                  
                   ]
                   ),
                  
                     
               ],
               
               ),
               
        ),);
                    
    
  }



void choiceAction(String choice){

    if(choice == MenuItems.anounceMachinerySale){
      final refid = ModalRoute.of(context).settings.arguments as String;
    final loadedMachinery = Provider.of<Machinery>(context, listen: false).findById(refid);
       Navigator.of(context).pushNamed(MachinerySaleAnouncementScreen.routeName, arguments: {'id':loadedMachinery.id, 'action':'create', 'type':'sale'});

    }

     else if(choice == MenuItems.anounceMachineryRental){
      
      final refid = ModalRoute.of(context).settings.arguments as String;
    final loadedMachinery = Provider.of<Machinery>(context, listen: false).findById(refid);
       Navigator.of(context).pushNamed(MachinerySaleAnouncementScreen.routeName, arguments: {'id':loadedMachinery.id, 'action':'create', 'type':'rental'});

    }
   

    


    }

}

class MenuItems{

  static const String anounceMachinerySale = 'Anounce Machinery sale';
  static const String anounceMachineryRental = 'Anounce Machinery for Rent';

  static const List<String> choices = <String>[
    anounceMachinerySale,
    anounceMachineryRental
    

  ];

}

