import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../widgets/user_crop_item.dart';
import '../providers/crop.dart';
import './edit_expense_screen.dart';
import 'package:provider/provider.dart';
import 'add_expense_screen.dart';
import '../providers/fields.dart';
import '../widgets/machinery_grid.dart';
import './expenses_overview_screen.dart';
import '../providers/user_profiles.dart';
import './pesticides_overview_screen.dart';
import './crops_on_land_overview_screen.dart';
import './crop_sale_anounce_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';


class FieldDetailScreen extends StatefulWidget {

  static const routeName = '/flied-detail';

  @override
  _FieldDetailScreenState createState() => _FieldDetailScreenState();
}

class _FieldDetailScreenState extends State<FieldDetailScreen> {

  // Unit of measurements


int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    //final crop = Provider.of<Crops>(context);
    final fieldid = ModalRoute.of(context).settings.arguments as String;
    final loadedFields = Provider.of<Fields>(context).findById(fieldid);
    /* var imageUrl = loadedCrops.imageUrl;
     dynamic img;
    if(  imageUrl.isEmpty) {
      img = imageUrl;
    }else {
      img = 0;
    } */


        return Scaffold(
          appBar: AppBar(
            title: Text(loadedFields.title),
            actions: <Widget>[
        /* IconButton(icon: Icon(Icons.add), onPressed: (){
          Navigator.of(context).pushNamed(CropSaleAnouncementScreen.routeName, arguments: {'id':loadedCrops.id, 'action':'create'});
         // print(loadedCrops.id);
        },) */

        PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return MenuItems.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice));
              }).toList();
            },
          ),
      ]
            ),
            
            
            body: new SingleChildScrollView(
                        child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
               
            loadedFields.imageUrl?.isEmpty ? 
            Image.network('https://images.unsplash.com/photo-1572827137848-4d7955eb93d6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80 750w', fit:BoxFit.cover) :
                Image.network(loadedFields.imageUrl,
                width: 600,            
                height: 240,
              fit: BoxFit.cover,
              ),
      
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                   margin: EdgeInsets.all(10),
                   child: Text('${loadedFields.title}'),
                   
                   
                 ),
                 
                 
               ),
               Stack(children: <Widget>[
                 Column(children: <Widget>[
                    RichText(
                     text: TextSpan(
                      text: 'Owner : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedFields.owner}'),
                  ],
                  ),
                  ),
                   RichText(
                     text: TextSpan(
                      text: 'Farmer : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedFields.farmer}')
                  ],
                  ),
                  ),
                  
                  RichText(
                     text: TextSpan(
                      text: 'Crop Method : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedFields.cropMethod}'),
                  ],
                  ),
                  ),

                                             

                  

                  RichText(
                     text: TextSpan(
                      text: 'ownershipType : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedFields.ownershipType}'),
                  ],
                  ),
                  ),

                 

                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[ RichText(
                     text: TextSpan(
                      text: 'Total Land Area : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedFields.area}'),
                  ],
                  ),
                  
                  ),

                  RichText(
                     text: TextSpan(
                      
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: " ${loadedFields.units}'s"),
                  ],
                  ),
                  
                  ),
                  
                  ],),

                    RichText(
                     text: TextSpan(
                      text: 'Description : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedFields.description}'),
                  ],
                  ),
                  ),

                  RichText(
                     text: TextSpan(
                      text: 'Location : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedFields.location}'),
                  ],
                  ),
                  ),
                    RichText(
                     text: TextSpan(
                      text: 'landType : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedFields.landType}'),
                  ],
                  ),
                  ),
                  
                   ]),
                 
               ])
              /*  Container(
                 child: Banner(child: Container
                 (child: Center(child: Text('Todays Market Price at Guimalkapur Market is Rs.12'),)
                 ),
                 message: "message",
                 textDirection: TextDirection.ltr,
                 location: BannerLocation.bottomEnd,
                 ),
                 ), */],
               
               ),
                 ),
               /* bottomNavigationBar: 
               
               
               BottomNavigationBar(
                 
                 currentIndex: selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: onItemTapped,
                
        // this will be set when a new tab is tapped
       items: [
         BottomNavigationBarItem(
           
           icon: new FaIcon(FontAwesome5.money_bill_alt),
           title: new Text('Expenses'),
           
         ),
        /*  BottomNavigationBarItem(
           icon: new Icon(MaterialCommunityIcons.needle),
           title: new Text('Tools'),
         ), */
         BottomNavigationBarItem(
           icon: FaIcon(FontAwesomeIcons.leaf),
           title: Text('Crops')
         ),
          /* BottomNavigationBarItem(
           
           icon: new FaIcon(FontAwesome5.money_bill_alt),
           title: new Text('My sale Anouncements'),
           
         ), */
              
       ]
    ), */

     bottomNavigationBar: BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: _buildTabsBar(context),
      
     /*  new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,), */
      
      ), 
   
    );

    
    
  }
 void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      final fieldid = ModalRoute.of(context).settings.arguments as String;
    final loadedFields = Provider.of<Fields>(context, listen: false).findById(fieldid);
      if(selectedIndex == 0){
Navigator.of(context).pushNamed(ExpensesOverviewScreen.routeName, arguments: {'id':loadedFields.id, 'type':'lands'});
      }
      if(selectedIndex == 1){
Navigator.of(context).pushNamed(CropsOnLandOverviewScreen.routeName, arguments: {'id':loadedFields.id, 'type':'lands'});
      }
      /* if(selectedIndex == 2){
        Navigator.of(context).pushNamed(CropsOnLandOverviewScreen.routeName, arguments: {'id':loadedFields.id, 'type':'fields'});
      }
      if(selectedIndex == 3){
        Navigator.of(context).pushNamed(CropsOnLandOverviewScreen.routeName, arguments: {'id':loadedFields.id, 'type':'fields'});
      }  */     
      else(dynamic error){

      };
    });
  }

  void choiceAction(String choice){

    if(choice == MenuItems.anounceSale){
      final cropid = ModalRoute.of(context).settings.arguments as String;
    final loadedCrops = Provider.of<Fields>(context, listen: false).findById(cropid);
       Navigator.of(context).pushNamed(CropSaleAnouncementScreen.routeName, arguments: {'id':loadedCrops.id, 'action':'create'});

    }
    else if(choice == MenuItems.addUser){
      
      _addUserDialog(context);

    }

    }

      Future<void> _addUserDialog(BuildContext context) {

        List<String> _userType = ['Admin']; // Option 2
   String _selectedUserType; 

     final cropid = ModalRoute.of(context).settings.arguments as String;
        
        String userId;
        String userType;
    return showDialog(
        context: context,
        builder: (BuildContext context) {

          return StatefulBuilder(
      builder: (context, setState) {

          return AlertDialog(
              title: Text("Add users to give access to this land details"),
              content: SingleChildScrollView(
                child: 
                 Column(
                  children: <Widget>[
                    Container(
            width: 500,
            child: Text('Email Id'),
            ),
                  Container(
          child:  TextFormField(
                     
                          decoration: InputDecoration(labelText: 'userEmail', 
                      /*   focusColor: Colors.blue,
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          gapPadding: 10.0,
                          
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), 
                        contentPadding: const EdgeInsets.all(20)*/
                        ), 
                        validator: (value){
                      if(value.isEmpty){
                       return 'Please provide value';
                        }
                        else {
                         return null;
                              }
                          },
                          onChanged: (value){
                              return userId = value;
                          }

                         
                    ),
                     decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
                  ),
           Container(
            width: 500,
            child: Text('User Type'),
            ),
/*            Container(
            width: 500,
           child: 
           Column(
                   
                             children: <Widget>[
                               DropdownButton(
                                 
              hint: Text('Choose User Type'), // Not necessary for Option 1
              value: _selectedUserType,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedUserType = newValue;
                  return userType = _selectedUserType;
                });
              }, */
            Container(
  padding: EdgeInsets.symmetric(horizontal: 20),
  child: FormField<String>(
    builder: (FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0))),

              child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text("Choose User Type"),
            value: _selectedUserType,
            isDense: true,
            onChanged: (dynamic newValue) {
              setState(() {
                 _selectedUserType = newValue;
                  //
              });
              return userType = _selectedUserType;
              
            },
              items: _userType.map((String userType) {
                return DropdownMenuItem<String>(
                  child: Text(userType),
                  value: userType,
                );
              }).toList(),
            ),
              ),
      );
    },),
            ),
                             ],
                           ),
                           /*  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0), */
                           
                  
                ),
              
              
                actions: <Widget>[
                  FlatButton(
                    child: Text("Add"),
                    onPressed: () async {
                      
                      final response =  await Provider.of<Fields>(context, listen: false).patchField(cropid, userId, userType);;
                     
                      Navigator.pop(context);
                   },
                  ),
                ],
              );
      },
          );
        }
        );
  }

   Widget _buildTabsBar(dynamic context) {
     final fieldId = ModalRoute.of(context).settings.arguments as String;
    final loadedFields = Provider.of<Fields>(context, listen: false).findById(fieldId);
    return Container(
      height: 70,
      color: Color.fromRGBO(21, 32, 43, 1.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
  child:Column(
  mainAxisSize: MainAxisSize.max,
         children: <Widget>[
           IconButton(icon:Icon(MaterialCommunityIcons.cash_multiple, color: Theme.of(context).accentColor,
          
          ),
          onPressed: (){
            Navigator.of(context).pushNamed(ExpensesOverviewScreen.routeName, arguments: {'id':loadedFields.id, 'type':'lands'});
      },),
          Text('Expenses',
          style: TextStyle(color: Colors.white),)
          ],
          ),),
           SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.min,
         children: <Widget>[
          IconButton(icon:Icon(MaterialCommunityIcons.barley, color: Colors.grey[100]),
          onPressed: (){
          Navigator.of(context).pushNamed(CropsOnLandOverviewScreen.routeName, arguments: {'id':loadedFields.id, 'type':'lands'});
      },),
          Text('Crops',
          style: TextStyle(color: Colors.white),),],),),
            
              
             SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.min,
         children: <Widget>[
          IconButton(icon:Icon(MaterialCommunityIcons.tractor, color: Colors.grey[100]),
          onPressed: (){
          Navigator.of(context).pushNamed(MachineryGrid.routeName, arguments: {'id':loadedFields.id, 'type':'lands', 'userId':loadedFields.userId});
      },),
          Text('Machinery',
          style: TextStyle(color: Colors.white),),],),),
          
       ],
      ),
    );
  }
}

class MenuItems{

  static const String anounceSale = 'anounce crop sale';
  static const String addUser = 'Add admin user';

  static const List<String> choices = <String>[
    //anounceSale,
    addUser

  ];

}

