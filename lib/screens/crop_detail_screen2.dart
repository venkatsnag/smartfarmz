import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../widgets/user_crop_item.dart';
import '../providers/crop.dart';
import './edit_expense_screen.dart';
import 'package:provider/provider.dart';
import '../providers/crops.dart';


class CropDetailScreen extends StatelessWidget {

  static const routeName = '/crop-detail';

  /* final String title;
  CropDetailScreen(this.title); */

  
  @override
  Widget build(BuildContext context) {
    final crop = Provider.of<Crops>(context);
    final cropid = ModalRoute.of(context).settings.arguments as String;
    final loadedCrops = Provider.of<Crops>(context).findById(cropid);
    

        return Scaffold(
          appBar: AppBar(
            title: Text(loadedCrops.title),
            actions: <Widget>[
        IconButton(icon: Icon(Icons.add), onPressed: (){
          Navigator.of(context).pushNamed(EditExpenseScreen.routeName, arguments: loadedCrops.id);
          print(loadedCrops.id);
        },)
      ]
            ),
            
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.network(loadedCrops.imageUrl,
                width: 600,            
                height: 240,
              fit: BoxFit.cover,
              ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                   margin: EdgeInsets.all(10),
                   child: Text('${loadedCrops.farmer}'),
                 ),
               )],
               
               ),
               bottomNavigationBar: BottomNavigationBar(
                 
       currentIndex: 0, // this will be set when a new tab is tapped
       items: [
         BottomNavigationBarItem(
           
           icon: new Icon(Icons.money_off)           ,
           title: new Text('Expenses'),
           
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.local_drink),
           title: new Text('Pesticides'),
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.person),
           title: Text('Fertilizers')
         )
              
       ]
    ),
    );
    
  }
  
}

