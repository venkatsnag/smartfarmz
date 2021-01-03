import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/farmers_grid.dart';
import '../l10n/gallery_localizations.dart';
import './edit_crop_screen.dart';
import '../providers/users.dart';
import '../providers/auth.dart';
import 'package:flutter/scheduler.dart';

enum FilterOptions{

  Favorites,
  All,

}

class FarmersOverviewScreen extends StatefulWidget {

  static const routeName = '/all-farmers-overview-old';
  @override
  _FarmersOverviewScreenState createState() => _FarmersOverviewScreenState();
}

class _FarmersOverviewScreenState extends State<FarmersOverviewScreen> {
String userT;
var _showOnlyFavorites = false;
var _isInit = true;
  @override
  void initState() {
     
    super.initState();
  }

  @override
  void didChangeDependencies() {
 /*  if(_isInit){
Provider.of<Crops>(context).fetchCrops();
  }
  _isInit = false;
    super.didChangeDependencies(); */
  }

   Future<void> _refreshUsers(BuildContext context) async {
     //final userId = ModalRoute.of(context).settings.arguments;
     //if(userId != null){
      userT == 'Farmer' ?
await Provider.of<Users>(context,listen: false).getUsersByType('Buyer'):
await Provider.of<Users>(context,listen: false).getUsersByType('Farmer');
     //}
  }


@override
Widget build(BuildContext context) {

  WidgetsBinding.instance.addPostFrameCallback((_) => _refreshUsers(context));
   final dynamic userData = Provider.of<Auth>(context, listen: false);
   String userType = '${userData.userType}';
   userT = userType;

  return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(
        title:  userType == 'Buyer' || userType == 'Investor'?? 
        auth.isAuth ? 
        Text(GalleryLocalizations.of(context).allFarmers,) :
        Text(GalleryLocalizations.of(context).allBuyers,)
       // : Text(GalleryLocalizations.of(context).login_Signup,) ,
        //title: auth.isAuth ? Text(AppLocalizations.of(context).translate('crop_title'),) : 
       // Text(AppLocalizations.of(context).translate('login_Signup'),),
        /* actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){

              setState(() {
                if(selectedValue == FilterOptions.Favorites){

              _showOnlyFavorites = true;

             }
             else{
               
              _showOnlyFavorites = false;
             } 
              });
            
            },
            //icon: Icon(Icons.more_vert,), 
            itemBuilder: (_) => [
            PopupMenuItem(child: Text('Only Favories'), value: FilterOptions.Favorites,),
            PopupMenuItem(
              child: Text('Show All'), 
              value: FilterOptions.All),
          ],
          ),
        /*  Consumer<Cart>(builder: (_, cart, ch) => Badge(child: ch,
         
         value: cart.itemCount.toString(),
         ),
         child: IconButton(icon: 
         Icon(Icons.shopping_cart,),
         onPressed: (){
           Navigator.of(context).pushNamed(CartScreen.routeName);
         },
         ),
         ) */
         
        ], */
      ),
     //drawer: AppDrwaer(),
      body: Container( child: 
          auth.isAuth ? FarmersGrid() : 
      
       Banner()
       
      ,
      
        //CropsOverviewScreen() : 
       /*  FutureBuilder(
          future: auth.tryAutoLogin(), 
          builder: (ctx, authResultSnapshot) => 
          authResultSnapshot.connectionState == 
          ConnectionState.waiting ? 
          SplashScreen() : 
          AuthCard(),
          //AuthCard(),
          //FacebookLogin(),
          ), */ 
       
      
      ),
      
/*     floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: new Visibility( 
        visible: true,
       child: auth.isAuth ?
       FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {
 Navigator.of(context).pushNamed(EditCropScreen.routeName);
         // print(loadedCrops.id);

      },) : FloatingActionButton(onPressed: (){},),
      ),
     bottomNavigationBar: BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: _buildTabsBar(context),
      
     /*  new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,), */
      
      ),  */
      
      ),
      
      );

  }

/*   Widget _buildTabsBar(dynamic context) {
    return Container(
      height: 60,
      color: Color.fromRGBO(21, 32, 43, 1.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
          IconButton(icon:Icon(MaterialIcons.home, color: Theme.of(context).accentColor,
          
          ),
          onPressed: (){
            Navigator.pushNamed(context, '/farmer_home_screen');
          },),
          IconButton(icon:Icon(MaterialIcons.edit, color: Colors.grey[100]),
          onPressed: (){
             Navigator.pushNamed(context, '/user-crops');
          },),
          
       ],
      ),
    );
  } */
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