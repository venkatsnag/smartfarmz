import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/crops_grid.dart';
import '../l10n/gallery_localizations.dart';
import './edit_crop_screen.dart';
import '../providers/crops.dart';
import '../providers/auth.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../providers/apiClass.dart';



/* enum FilterOptions{

  Favorites,
  All,

} */
class CropsOverviewScreen extends StatefulWidget {
  static const routeName = '/crops-overview';
  @override
  _CropsOverviewScreenState createState() => _CropsOverviewScreenState();
}

class _CropsOverviewScreenState extends State<CropsOverviewScreen> {

  

   final apiurl = AppApi.api;

  var _showOnlyFavorites = false;
var _isInit = true;
var _isLoading = false;
  @override
  void initState() {
     _refreshCrops(context);

    super.initState();
  }

/*   Future<void> _cropAssociatedWithLands(BuildContext context) async {
   final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic landId = routes['id'];
  final dynamic type = routes['type'];
  await Provider.of<Crops>(context).fetchAndFetchCropWithLand(landId, type);

} */
/* void showNotification() async {
const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        //priority: Priority.high,
        showWhen: false);
const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
await flutterLocalNotificationsPlugin.show(
    0, 'plain title', 'plain body', platformChannelSpecifics,
    payload: 'item x');
    await flutterLocalNotificationsPlugin.cancelAll();
      } */
  @override
  void didChangeDependencies()  {

 
    super.didChangeDependencies();
  }

   Future<void> _refreshCrops(BuildContext context) async {
     //final userId = ModalRoute.of(context).settings.arguments;
     //if(userId != null){
  await Provider.of<Crops>(context,listen: false).fetchCrops(true);
     //}
  }



  
  @override
  Widget build(BuildContext context) {
    //Call refresh crops after loggin in.
   //WidgetsBinding.instance.addPostFrameCallback((_) => _refreshCrops(context));
    final authData = Provider.of<Auth>(context, listen: false);

    // These delegates make sure that the localization data for the proper language is loaded
      
    //return Scaffold(
     return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(
        title: auth.isAuth ? Text(GalleryLocalizations.of(context).myCropTitle,) 
        : Text(GalleryLocalizations.of(context).login_Signup,) ,
        
      ),
     //drawer: AppDrwaer(),
      body: Container( child: 
          auth.isAuth ? CropsGrid(_showOnlyFavorites) : 
      
       Banner()
       
      ,
      
       
       
      
      ),
      
    floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: new Visibility( 
        visible: authData.userType == 'Farmer' || authData.userType == 'Hobby/DYIFarmer' ? true : false,
       child: auth.isAuth ?
       FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {
 Navigator.of(context).pushNamed(EditCropScreen.routeName, arguments: {'id': null, 'type':'crops'});
         // print(loadedCrops.id);

      },) : FloatingActionButton(onPressed: (){},),
      ),
     bottomNavigationBar: BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: 
      authData.userType == 'Farmer' || authData.userType == 'Hobby/DYIFarmer' ?
      _buildTabsBar(context) : null,
      
     /*  new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,), */
      
      ), 
      
      ),
      
      );

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
            Navigator.pushNamed(context, '/main_home_screen');
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
             Navigator.pushNamed(context, '/user-crops-screen');
          },),
          Text('Edit Crops',
          style: TextStyle(color: Colors.white),),],),),
          
       ],
      ),
    );
  }
}
     
class Banner extends StatefulWidget {
  const Banner();

  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<Banner> {
  
  var _showMultipleActions = true;
  var _displayBanner = true;
  var _showLeading = true;

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

  @override
  Widget build(BuildContext context) {
    
    return MaterialBanner(
      content: Text(GalleryLocalizations.of(context).noCropText),
      leading: _showLeading
          ? CircleAvatar(
              child: Icon(Icons.bookmark),
             
            )
          : null,
      actions: [
        FlatButton(
          child: Text("Go to Land Registration page"),
          onPressed: () {
            setState(() {
              _displayBanner = false;
              SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, '/login');
              });
            });
            
          },
        ),
         FlatButton(
            child: Text(GalleryLocalizations.of(context).dismiss),
            onPressed: () {
               setState(() {
                _displayBanner = false;
              });
              Navigator.pushReplacementNamed(context, '/main_home_screen');
            },
          ),
      ],
      
    );

    
  }

  
}


