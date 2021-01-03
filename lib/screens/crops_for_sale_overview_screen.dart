import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/crop_for_sale_grid.dart';
import '../l10n/gallery_localizations.dart';
import './edit_crop_screen.dart';
import '../providers/crops.dart';
import '../providers/auth.dart';
import '../providers/user_profiles.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


enum FilterOptions{

  Favorites,
  All,

}

  class User {
      final String userType;
      final String userId;
      final String firstName;
      final String lastName;

      User({this.userType, this.userId, this.firstName, this.lastName });

      factory User.fromJson(Map<String, dynamic> parsedJson) {
        return new User(
            userType: parsedJson['userType'] ?? "",
            userId: parsedJson['userId'] ?? "",
            firstName: parsedJson['firstName'] ?? "",
            lastName: parsedJson['lastName'] ?? "");
      }

    
    }

class CropsForSaleOverviewScreen extends StatefulWidget {

  static const routeName = '/crops-for-sale-overview';
  @override
  _CropsForSaleOverviewScreenState createState() => _CropsForSaleOverviewScreenState();
}

class _CropsForSaleOverviewScreenState extends State<CropsForSaleOverviewScreen> {

var _showOnlyFavorites = false;
var _isInit = true;
  @override
  void initState() {
    _loadUserData();
     _refreshCrops(context);
    super.initState();
  }

  void _loadUserData()async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map user = jsonDecode(prefs.getString('userData'));
  dynamic userDat = User.fromJson(user);

     setState(() {
          dynamic userDat = User.fromJson(user);
    });

  }

  @override
  void didChangeDependencies() {
 /*  if(_isInit){
Provider.of<Crops>(context).fetchCrops();
  }
  _isInit = false;
    super.didChangeDependencies(); */
  }

   Future<void> _refreshCrops(BuildContext context) async {
     //final userId = ModalRoute.of(context).settings.arguments;
     //if(userId != null){
await Provider.of<Crops>(context,listen: false).fetchCropsForSale();
     //}
  }

@override
Widget build(BuildContext context) {
//dynamic userTpe = userDat['userDat'];
  WidgetsBinding.instance.addPostFrameCallback((_) => _refreshCrops(context));
  return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(
        title: auth.isAuth ? Text(GalleryLocalizations.of(context).allCropsForSale,) 
        : Text(GalleryLocalizations.of(context).login_Signup,) ,
       
      ),
     //drawer: AppDrwaer(),
      body: Container( child: 
          auth.isAuth ? 
          
        CropsForSaleGrid()
      
      : 
      
       Banner()     
      ,
      
       
       
      
      ),
      

      
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
              Navigator.pushReplacementNamed(context, '/guest_home_screen');
            },
          ),
      ],
      
    );

    
  }

  
}