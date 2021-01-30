import 'package:flutter/material.dart';
import '../providers/auth.dart';
import '../l10n/gallery_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import './machinery_rental_anounce_screen.dart';
import './crops_for_sale_overview_screen_user.dart';
import './machinery_forSaleRental_overview_screen.dart';
import '../widgets/machinery_forSaleRental_grid.dart';
import 'dart:ui';
import '../providers/apiClass.dart';
import '../providers/user_profiles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MySalesViews extends StatefulWidget {
  static const routeName = '/my-sales-views';
  @override
  _MySalesViewsState createState() => _MySalesViewsState();
}

class _MySalesViewsState extends State<MySalesViews> {
  final apiurl = AppApi.api;
  @override
  Widget build(BuildContext context) {
    final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
 final dynamic type = routes['type'];
  
  return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(
        
        title: Text(GalleryLocalizations.of(context).mySaleAndRentalAnouncement,) 
         ,
       
      ),
     //drawer: AppDrwaer(),
      body: 
          GridView.count(
          primary: false,
          padding: const EdgeInsets.all(8),
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          crossAxisCount: 2,
          children: [ 
            GridTile(
      
      child: GestureDetector
      (
        onTap: (){ 
          Navigator.of(context).pushNamed(CropsForSaleOverviewScreenUser.routeName, );
        },
        child: Image.network(
		"$apiurl/images/folder/crops.jpg",
	fit:BoxFit.cover,),
      ),
      footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
      backgroundColor: Colors.black54,
       title: Text('My Crop Sales',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white)
      ),)
            ),),

            GridTile(
      
      child: GestureDetector
      (
        onTap: (){ 
           Navigator.of(context).pushNamed(MachineryForSaleRentalOverviewScreen.routeName,arguments: {'type':'sale', 'viewer':'user'});
        },
        child: Image.network(
		"$apiurl/images/folder/Tractor.jpg",
	fit:BoxFit.contain),
      ),
      footer: 
      Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
      backgroundColor: Colors.black87,
       title: Text('My Machinery Sales',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white)
      ),)
            ),),
  /*   GridTile(
      
      child: GestureDetector
      (
        onTap: (){ 
           Navigator.of(context).pushNamed(MachineryForSaleRentalOverviewScreen.routeName,arguments: {type:'rental'});
        },
        child: Image.network(
		'https://images.unsplash.com/photo-1599508704512-2f19efd1e35f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80 375w'
	,fit:BoxFit.cover,),
      ),
      footer: GridTileBar(
      backgroundColor: Colors.black54)
            ), */
   GridTile(
      
      child: GestureDetector
      (
        onTap: (){ 
           Navigator.of(context).pushNamed(MachineryForSaleRentalOverviewScreen.routeName, arguments: {'type':'rental', 'viewer':'user'});
        },
        child: Image.network(
		"$apiurl/images/folder/farm_tools_vector.jpg",
	fit:BoxFit.contain),
      ),
      footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child:GridTileBar(
      backgroundColor: Colors.black87,
       title: Text('My Machinery Rentals',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white)
      ),)
            ),),
            
          ],),
      
      
     floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: new Visibility( 
        visible: false,
       child: auth.userType == 'Farmer' || auth.userType == 'Hobby/DYIFarmer' ?
       FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {
 Navigator.of(context).pushNamed(MachinerySaleAnouncementScreen.routeName, arguments: {'id': null, 'action': 'create', 'type':type});
         // print(loadedCrops.id);

      },) : null,
      ),
     bottomNavigationBar: BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: auth.userType == 'Farmer' || auth.userType == 'Hobby/DYIFarmer' ?_buildTabsBar(context) : null,
      
     /*  new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,), */
      
      ),  
     
      
      ),
      
      );

  }

Widget _buildTabsBar(dynamic context) {
   final loadedUser = Provider.of<UserProfiles>(context, listen: false);

     
   Future<void> _showLogoffDialog(String message){
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('You have been sucessfully Logged Off'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(ctx).pushReplacementNamed('/login');}, 
          child: Text('Okay'))
      ],
      ),
      );

  }
    return  Consumer<Auth>
      (builder: (ctx, auth, _) => Container(
      height: 70,
      color: Color.fromRGBO(21, 32, 43, 1.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.max,
         children: <Widget>[
         IconButton(icon:FaIcon(MaterialIcons.home, color: Theme.of(context).accentColor,
          
          ),
          onPressed: (){
           Navigator.pushNamed(context, '/main_home_screen');
          },), 
          Text('Home',
          style: TextStyle(color: Colors.white),)
          ],
          ),),

      
 auth.isAuth ?
          SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.min,
         children: <Widget>[
          IconButton(icon:FaIcon(FontAwesomeIcons.userAlt, color: Colors.grey[100]),
          onPressed: (){
             Navigator.pushNamed(context, '/user-profile-screen', arguments: loadedUser.userId);
          },),
           Text('My Profile',
          style: TextStyle(color: Colors.white),)
          ],
          ),) :
        SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.max,
         children: <Widget>[

          IconButton(icon:FaIcon(FontAwesomeIcons.userShield, color: Colors.grey[100]),
          onPressed: (){
             Navigator.pushNamed(context, '/login');
          },), Text('Login',
          style: TextStyle(color: Colors.white),)
          ],
          ),)  ,
                auth.isAuth ?
     SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.max,
         children: <Widget>[

       IconButton(icon:Icon(Icons.exit_to_app_rounded, color: Colors.grey[100]),
          onPressed: (){
              Navigator.of(context).pop();
             //Navigator.of(context).pushReplacementNamed('/');
             //Navigator.of(context).pushReplacementNamed(UserSelfProfileScreen.routeName);
             Provider.of<Auth>(context, listen: false).logout();
const  message = 'Logged out';
_showLogoffDialog(message);
           },), Text('Logout',
          style: TextStyle(color: Colors.white),)
          ],
          ),) : SizedBox(),
          
       ],
      ),
    ),);
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
      content: Text(GalleryLocalizations.of(context).bannerSignIn),
      leading: _showLeading
          ? CircleAvatar(
              child: Icon(Icons.account_circle),
             
            )
          : null,
      actions: [
        FlatButton(
          child: Text(GalleryLocalizations.of(context).signIn),
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