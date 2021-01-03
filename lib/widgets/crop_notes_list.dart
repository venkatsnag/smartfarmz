import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';
import '../providers/crop.dart';
import './crop_item.dart';
import 'package:provider/provider.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/cropNotes.dart'  show CropLandNotes;
import './crop_notes_item.dart';
import '../screens/add_notes_screen.dart';
import '../screens/add_expense_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/user_notes_item.dart';
import '../screens/user_notes_screen.dart';
import '../providers/auth.dart';

import 'dart:ui';

/* enum BannerAction {
  reset,
  showMultipleActions,
  showLeading,
} */

class CropNotesList extends StatefulWidget {
  
static const routeName = '/crop-land-notes';
 
  @override

  _CropNotesListState createState() => _CropNotesListState();
}

class _CropNotesListState extends State<CropNotesList> {
  




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



      await Provider.of<CropLandNotes>(context, listen: false).getNotes(cropId, type);
      
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
  
  await Provider.of<CropLandNotes>(context, listen: false).getNotes(cropId, type);

  
}


  //FarmersGrid(this.showFavs);

  final noCropText = Text('No Crops Registered! Register crop');

  @override
  Widget build(BuildContext context) {

      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshNotes(context));
final authData = Provider.of<Auth>(context, listen: false);
  final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];
  final dynamic title = routes['title'];
   final dynamic userId = routes['userId'];

  Map<String, String> args = {'id': '$cropId', 'type':'$type', 'title':'$title', 'userId':'$userId'};

final notesData = Provider.of<CropLandNotes>(context, listen: false);


   
 final notes =  notesData.items;
    //final farmers = farmersData.items;
 return Scaffold(
    appBar: 
	AppBar(title: type == 'lands' ? new Text(GalleryLocalizations.of(context).landNotesTitle, textAlign: TextAlign.center,) :  
  new Text(GalleryLocalizations.of(context).cropNotesTitle, textAlign: TextAlign.center,),

  ),
  
	//drawer: AppDrwaer(),
  
      body: RefreshIndicator(
        onRefresh: () => _refreshNotes(context),
        
        child: Padding(
          padding: EdgeInsets.all(10),
          
        child:
      ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: notes.length,

        itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 8.0, bottom: 16.0),
                  child: InkWell(
                    
                    child: Container(
                      
                    width: 100,
                      height:150,
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            //borderRadius: widget.iconImageBorderRadius,
                            child:  ChangeNotifierProvider.value(
                              
           value: notes[index],
                    child: NotesItem(
              notes[index].id, 
              notes[index].date.toIso8601String(), 
              notes[index].notes,
              
           ),
         ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
      ),),),
      
        floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: 
    authData.userType == 'Farmer' ?
    FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {
 Navigator.of(context).pushNamed(AddNotesScreen.routeName, arguments: args);
  _refreshNotes(context);
         // print(loadedCrops.id);

      },)  : null,
    bottomNavigationBar: 
    authData.userType == 'Farmer' ?
    BottomAppBar(
      
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: _buildTabsBar(context),
    ) : null,
      
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
          Navigator.of(context).pushNamed(UserNotesScreen.routeName, 
         );
      },),
          Text('Edit Notes',
          style: TextStyle(color: Colors.white),),],),),
          
       ],
      ),
    );
  }
    
  }

 


/* class Banner extends StatefulWidget {
  const Banner();

  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<Banner> {
  
  var _showMultipleActions = true;
  var _displayBanner = true;
  var _showLeading = true; */

/*   void handleDemoAction(BannerAction action) {
    setState(() {
      switch (action) {
        case BannerAction.reset:
          _displayBanner = true;
          
          _showLeading = true;
          break;
       
        case BannerAction.showLeading:
          _showLeading = !_showLeading;
          break;
      }
    });
  } */

  /* @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MaterialBanner(
      content: Text(GalleryLocalizations.of(context).bannerDemoText),
      leading: _showLeading
          ? CircleAvatar(
              child: Icon(Icons.account_circle, color: colorScheme.onPrimary),
              backgroundColor: colorScheme.primary,
            )
          : null,
      actions: [
        FlatButton(
          child: Text(GalleryLocalizations.of(context).signIn),
          onPressed: () {
            setState(() {
              _displayBanner = false;
            });
            Navigator.pushNamed(context, '/login');
          },
        ),
         FlatButton(
            child: Text(GalleryLocalizations.of(context).dismiss),
            onPressed: () {
               setState(() {
                _displayBanner = false;
              });
              Navigator.pushNamed(context, '/guest_home_screen');
            },
          ),
      ],
      backgroundColor: colorScheme.background,
    );

    
  } */
