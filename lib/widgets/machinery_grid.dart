import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';
import '../providers/crop.dart';
import './crop_item.dart';
import 'package:provider/provider.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/machinery.dart'  show Machinery;
import './crop_notes_item.dart';
import '../screens/add_machinery_screen.dart';
import '../screens/add_expense_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/machinery_item.dart';
import '../screens/user_machinery_screen.dart';

import 'dart:ui';

/* enum BannerAction {
  reset,
  showMultipleActions,
  showLeading,
} */

class MachineryGrid extends StatefulWidget {
  
static const routeName = '/machinery-grid';
 
  @override

  _MachineryGridState createState() => _MachineryGridState();
}

class _MachineryGridState extends State<MachineryGrid> {
  




  var _isLoading = false;
  @override
  
  void initState() {
  Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       _isLoading = true;
      });
      final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];
   final dynamic title = routes['title'];
   final dynamic userId = routes['userId'];



      await Provider.of<Machinery>(context, listen: false).getMachinery(cropId, type);
      
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  } 

Future<void> _refreshNotes(BuildContext context) async {
  
  final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
   final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];
  final dynamic title = routes['title'];
   final dynamic userId = routes['userId'];
  
  await Provider.of<Machinery>(context, listen: false).getMachinery(cropId, type);

  
}


  //FarmersGrid(this.showFavs);

  final noCropText = Text('No Machines Registered! Register Machines');

  @override
  Widget build(BuildContext context) {

      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshNotes(context));

  final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];
  final dynamic title = routes['title'];
   final dynamic userId = routes['userId'];

  Map<String, String> args = {'id': '$cropId', 'type':'$type', 'title':'$title', 'userId':'$userId'};

final machineryData = Provider.of<Machinery>(context, listen: false);


   
 final machinery =  machineryData.items;
    //final farmers = farmersData.items;
 return Scaffold(
    appBar: 
	AppBar(title: type == 'lands' ? new Text(GalleryLocalizations.of(context).landMachineryTitle, textAlign: TextAlign.center,) :  
  new Text(GalleryLocalizations.of(context).cropMachineryTitle, textAlign: TextAlign.center,),

  ),
  
	//drawer: AppDrwaer(),
  
      body: RefreshIndicator(
        onRefresh: () => _refreshNotes(context),
        
        child: Padding(
          padding: EdgeInsets.all(10),
          
        child:
      GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: machinery.length,

        itemBuilder: (BuildContext context, int index)  =>  ChangeNotifierProvider.value(
                              
           value: machinery[index],
                    child: MachineryItem(
              machinery[index].id, 
              machinery[index].type, 
              machinery[index].model,
              
           ),
         ),
         
                          
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
      ),
      ),
      ),
      
        floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {
 Navigator.of(context).pushNamed(AddMachineryScreen.routeName, arguments: args);
  _refreshNotes(context);
         // print(loadedCrops.id);

      },),
    bottomNavigationBar: BottomAppBar(
      
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: _buildTabsBar(context),
    ),
      
      );
              /* 
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: farmers[i],
          child: FarmerItem(
            farmers[i].id,
            farmers[i].userFirstname,
            farmers[i].userFirstname,
            farmers[i].userType,
          ),
        ),
       
      ); */
     
    
/*      if (farmersData.userId != null) {
      return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: farmers.length,
        itemBuilder: (ctx, i) {
    return new Card(
      child: new GridTile(
        footer: new Text(farmers[i].id),
        child: new Text(farmers[i].userFirstname), //just for testing, will fill with image later
      ),
    );
  }, */
       /*  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10, */
        
     
    }
    
  Widget _buildTabsBar(dynamic context) {
    return Container(
      height: 70,
      color: Color.fromRGBO(21, 32, 43, 1.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.max,
         children: <Widget>[
           IconButton(icon:Icon(MaterialIcons.home, color: Theme.of(context).accentColor,
          
          ),
          onPressed: (){
            Navigator.pushNamed(context, '/farmer_home_screen');
          },),
          Text('Home',
          style: TextStyle(color: Colors.white),)
          ],
          ),),
           SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.min,
         children: <Widget>[
          IconButton(icon:Icon(MaterialIcons.edit, color: Colors.grey[100]),
          onPressed: (){
          Navigator.of(context).pushNamed(UserMachineryScreen.routeName, 
         );
      },),
          Text('Edit Machinery',
          style: TextStyle(color: Colors.white),),],),),
          
       ],
      ),
    );
  }
    
  }

 
