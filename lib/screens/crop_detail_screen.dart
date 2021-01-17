import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../widgets/user_crop_item.dart';
import '../providers/crop.dart';
import './edit_expense_screen.dart';
import 'package:provider/provider.dart';
import 'add_expense_screen.dart';
import '../providers/crops.dart';
import './expenses_overview_screen.dart';
import './harvest_overview_screen.dart';
import '../providers/user_profiles.dart';
import './pesticides_overview_screen.dart';
import './sales_overview_screen.dart';
import './crop_sale_anounce_screen.dart';
import './crop_investment_anounce_screen.dart';
import '../widgets/crop_notes_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:share/share.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import '../providers/auth.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


class CropDetailScreen extends StatefulWidget {

  static const routeName = '/crop-detail';

  @override
  _CropDetailScreenState createState() => _CropDetailScreenState();
}

class _CropDetailScreenState extends State<CropDetailScreen> {

  // Unit of measurements


int selectedIndex = 0;

  void _shareImage() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/wisecrab.png');
      await WcFlutterShare.share(
          sharePopupTitle: 'share',
          fileName: 'share.png',
          mimeType: 'image/png',
          bytesOfFile: bytes.buffer.asUint8List());
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> networkImages;
    var imageUrls;
    final authData = Provider.of<Auth>(context, listen: false);
    final cropid = ModalRoute.of(context).settings.arguments as String;
    final loadedCrops = Provider.of<Crops>(context).findById(cropid);
    loadedCrops?.imageUrl?.isEmpty ?? true ? loadedCrops.imageUrl : imageUrls = loadedCrops.imageUrl.split(",") ;
    networkImages = imageUrls;
    
    /* var imageUrl = loadedCrops.imageUrl;
     dynamic img;
    if(  imageUrl.isEmpty) {
      img = imageUrl;
    }else {
      img = 0;
    } */


        return Scaffold(
          appBar: AppBar(
            title: Text(loadedCrops.title),
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
            
            
            body: 
            new SingleChildScrollView(
                        child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
Container(
              width:  500,
              height: 350,
    child:
    loadedCrops?.imageUrl?.isEmpty ?? true ?
            Image.network('https://images.unsplash.com/photo-1572827137848-4d7955eb93d6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80 750w', fit:BoxFit.cover) :
             
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
                   child: Text('${loadedCrops.title}'),
                   
                   
                 ),
                 
                 
               ),
               Stack(children: <Widget>[
                 Column(children: <Widget>[
                    RichText(
                     text: TextSpan(
                      text: 'Seed Variety : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.seedVariety}'),
                  ],
                  ),
                  ),
                   RichText(
                     text: TextSpan(
                      text: 'Farmer : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.farmer}')
                  ],
                  ),
                  ),
                  
                  RichText(
                     text: TextSpan(
                      text: 'Crop Method : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.cropMethod}'),
                  ],
                  ),
                  ),

                                             

                  

                  RichText(
                     text: TextSpan(
                      text: 'Investor : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.investor}'),
                  ],
                  ),
                  ),

                 

                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[ RichText(
                     text: TextSpan(
                      text: 'Total crop Area : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.area}'),
                  ],
                  ),
                  
                  ),

                  RichText(
                     text: TextSpan(
                      
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: " ${loadedCrops.units}'s"),
                  ],
                  ),
                  
                  ),
                  
                  ],),

                    RichText(
                     text: TextSpan(
                      text: 'Description : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.description}'),
                  ],
                  ),
                  ),

                  RichText(
                     text: TextSpan(
                      text: 'Seeding Date : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.seedingDate}'),
                  ],
                  ),
                  ),
                    RichText(
                     text: TextSpan(
                      text: 'Price : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.expectedHarvestDate}'),
                  ],
                  ),
                  ),
                  
                   ]),
                 
               ])

      ])),
   
           
                
                 bottomNavigationBar: BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: _buildTabsBar(context),
      
     
      
      ), 
          persistentFooterButtons: [
        
      ],
    );

    
    
  }
 void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      final cropid = ModalRoute.of(context).settings.arguments as String;
    final loadedCrops = Provider.of<Crops>(context, listen: false).findById(cropid);
      if(selectedIndex == 0){
Navigator.of(context).pushNamed(ExpensesOverviewScreen.routeName, arguments: {'id':loadedCrops.id, 'type':'crops'});
      }
      if(selectedIndex == 1){
Navigator.of(context).pushNamed(PesticidesOverviewScreen.routeName, arguments: {'id':loadedCrops.id, 'type':'crops'});
      }
      if(selectedIndex == 2){
        Navigator.of(context).pushNamed(SalesOverviewScreen.routeName, arguments: {'id':loadedCrops.id, 'type':'crops'});
      }
      if(selectedIndex == 3){
        Navigator.of(context).pushNamed(HarvestOverviewScreen.routeName, arguments: {'id':loadedCrops.id, 'type':'crops'});
      } 
      if(selectedIndex == 4){
        Navigator.of(context).pushNamed(HarvestOverviewScreen.routeName, arguments: {'id':loadedCrops.id, 'type':'crops'});
      }      
      else(dynamic error){

      };
    });
  }

  void choiceAction(String choice){

    if(choice == MenuItems.anounceSale){
      final cropid = ModalRoute.of(context).settings.arguments as String;
    final loadedCrops = Provider.of<Crops>(context, listen: false).findById(cropid);
       Navigator.of(context).pushNamed(CropSaleAnouncementScreen.routeName, arguments: {'id':loadedCrops.id, 'action':'create'});

    }

     else if(choice == MenuItems.seekInvestment){
      
      final cropid = ModalRoute.of(context).settings.arguments as String;
    final loadedCrops = Provider.of<Crops>(context, listen: false).findById(cropid);
       Navigator.of(context).pushNamed(CropInvestmentSeekAnouncementScreen.routeName, arguments: {'id':loadedCrops.id, 'action':'create'});

    }
    else if(choice == MenuItems.addUser){
      
      _addUserDialog(context);

    }

    


    }

      Future<void> _addUserDialog(BuildContext context) {

        List<String> _userType = ['Admin', 'Supervisor', 'Investor', 'Farmer']; // Option 2
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
              title: Text("Add users to give access to this crop details"),
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
                      if(value.isEmpty || !value.contains('@')){
                       return 'Invalid email! Please provide value';
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
                         
                           
                  
                ),
              
              
              
                actions: <Widget>[
                  FlatButton(
                    child: Text("Add"),
                    onPressed: () {
                      
                      Provider.of<Crops>(context, listen: false).addCropsByUser(cropid, userId, userType);
   
                      ;
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
     final cropid = ModalRoute.of(context).settings.arguments as String;
    final loadedCrops = Provider.of<Crops>(context, listen: false).findById(cropid);
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
          onPressed: ()async {
           await  Navigator.of(context).pushNamed(ExpensesOverviewScreen.routeName, arguments: {'id':loadedCrops.id, 'type':'crops'});
      },),
          Text('Expenses',
          style: TextStyle(color: Colors.white),)
          ],
          ),),
           SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.min,
         children: <Widget>[
          IconButton(icon:Icon(MaterialCommunityIcons.flask_empty_outline, color: Colors.grey[100]),
          onPressed: (){
          Navigator.of(context).pushNamed(PesticidesOverviewScreen.routeName, arguments: {'id':loadedCrops.id, 'type':'crops'});
      },),
          Text('Pesticides',
          style: TextStyle(color: Colors.white),),],),),
            
             SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.min,
         children: <Widget>[
          IconButton(icon:Icon(MaterialCommunityIcons.sale, color: Colors.grey[100]),
          onPressed: (){
         Navigator.of(context).pushNamed(SalesOverviewScreen.routeName, arguments: {'id':loadedCrops.id, 'type':'crops'});
      },),
          Text('Sales',
          style: TextStyle(color: Colors.white),),],),),
             
             SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.min,
         children: <Widget>[
          IconButton(icon:Icon(MaterialCommunityIcons.basket_fill, color: Colors.grey[100]),
          onPressed: (){
          Navigator.of(context).pushNamed(HarvestOverviewScreen.routeName, arguments: {'id':loadedCrops.id, 'type':'crops'});
      },),
          Text('Harvest',
          style: TextStyle(color: Colors.white),),],),),
          SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.min,
         children: <Widget>[
          IconButton(icon:Icon(MaterialCommunityIcons.book_open, color: Colors.grey[100]),
          onPressed: (){
          Navigator.of(context).pushNamed(CropNotesList.routeName, 
          arguments: {'id':loadedCrops.id, 'type':'crops', 'title':loadedCrops.title, 'userId':loadedCrops.userId});
      },),
          Text('Notes',
          style: TextStyle(color: Colors.white),),],),),
          
       ],
      ),
    );
  }
}

class MenuItems{

  static const String anounceSale = 'anounce crop sale';
  static const String seekInvestment = 'Seek investment for this crop';
  static const String addUser = 'Give access to this crop';

  static const List<String> choices = <String>[
    anounceSale,
    addUser,
    seekInvestment

  ];

}



